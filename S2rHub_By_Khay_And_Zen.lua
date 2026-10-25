-- S2rHub By Khay And Zen | Instant TP
-- Pick a pet (icon + value), press Steal: taken and delivered with the Instant TP logic.
-- Go: Semi TP (portal by touch, the player stays frozen at the first drop) or Go: Run.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- Stop a previous instance before registering new state and diagnostics.
local globalEnv = nil
pcall(function() globalEnv = getgenv() end)
if globalEnv and type(globalEnv.S2rHubUnload) == "function" then
    pcall(globalEnv.S2rHubUnload)
end


------------------------------------------------------------------ settings (same values as the hub)
local CFG = {
	SpeedCap = 1.15, -- never above 115% of the walk speed
	HopRatio = 1.515, -- hop distance = walk speed * ratio (a distance, not a speed)
	HopMin = 40,
	HopGap = 0.06, -- seconds between two hops (learned: grows after a pull-back, shrinks after a clean hop)
	HopGapMin = 0.06,
	HopGapMax = 0.2,
	HopRetries = 6,
	HopLift = 42, -- height of the hops above the start
	LandOffset = 14, -- landing spot in front of the line
	LandSettle = 0.08,
	DropDelay = 0.05,
	GrabInterval = 0.03,
	RegrabFar = 40, -- egg further than this: teleport onto it, otherwise run to it
	Height = 70, -- the safe-zone run starts above the base and comes down (same as the hub)
	ClimbShare = 0.5,
	CarryRatio = 0.9,
	EasyRatio = 1.3,
}

------------------------------------------------------------------ game handles
local function safeRequire(getter)
	local ok, result = pcall(function()
		return require(getter())
	end)
	return ok and result or nil
end

local networkingFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")
local EggState = safeRequire(function() return ReplicatedStorage.Client.EggState end)
local Assets = safeRequire(function() return ReplicatedStorage.Data.Assets end)
local Mutations = safeRequire(function() return ReplicatedStorage.Shared.Modules.Mutations end)

local function remote(name)
	return networkingFolder:FindFirstChild(name)
end

local function root()
	local character = localPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

-- "Humanoid Swap" (the hub's default shield, always on in the hub): the character runs on a copy of its humanoid,
-- the original is kept out of the character while we steal. Same code path as the hub.
local shield = { Original = nil, Clone = nil, Links = {}, Connection = nil, Added = nil }

local function walkSpeed()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local speed = humanoid and humanoid.WalkSpeed or 16
	if shield.Original and shield.Original.Health > 0 then
		speed = math.min(speed, shield.Original.WalkSpeed)
	end
	local ok, result = pcall(function()
		local stat = localPlayer:FindFirstChild("leaderstats")
		stat = stat and stat:FindFirstChild("Speed")
		local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
		return stat and util.SpeedPowerToWalkSpeed(stat.Value) or nil
	end)
	if ok and type(result) == "number" and result > 0 then
		speed = math.min(speed, result)
	end
	return speed
end

local function shieldControls(humanoid)
	pcall(function()
		local scripts = localPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if type(controls) == "table" then
				controls.humanoid = humanoid
			end
		end
	end)
end

local function shieldAnimate(character)
	local animate = character and character:FindFirstChild("Animate")
	if animate and animate:IsA("LocalScript") then
		task.spawn(function()
			animate.Enabled = false
			task.wait()
			animate.Enabled = true
		end)
	end
end

local function shieldUnlink()
	for _, link in ipairs(shield.Links) do
		pcall(function()
			link:Disconnect()
		end)
	end
	table.clear(shield.Links)
end

local groundedStates = {
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.RunningNoPhysics] = true,
	[Enum.HumanoidStateType.Landed] = true,
}

local function grounded(humanoid)
	if not humanoid or humanoid.Health <= 0 or humanoid.FloorMaterial == Enum.Material.Air then
		return false
	end
	return groundedStates[humanoid:GetState()] == true
end

local function shieldSwap()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	if shield.Clone and shield.Clone.Parent == character then
		return
	end
	if not grounded(humanoid) then
		return
	end

	local clone = humanoid:Clone()
	humanoid.Parent = nil
	clone.Parent = character
	workspace.CurrentCamera.CameraSubject = clone
	shieldControls(clone)
	shieldAnimate(character)
	shield.Original = humanoid
	shield.Clone = clone

	table.insert(shield.Links, humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if clone.Parent ~= nil then
			clone.WalkSpeed = humanoid.WalkSpeed
		end
	end))

	local animator = humanoid:FindFirstChildOfClass("Animator")
	local animator2 = clone:FindFirstChildOfClass("Animator")
	if animator and animator2 then
		table.insert(shield.Links, animator.AnimationPlayed:Connect(function(played)
			local animation = played.Animation
			if not animation or clone.Parent == nil then
				return
			end
			local ok, track = pcall(function()
				return animator2:LoadAnimation(animation)
			end)
			if not ok or not track then
				return
			end
			pcall(function()
				track.Priority = played.Priority
				track.Looped = played.Looped
				track:Play(0.05, math.max(played.WeightTarget, 0.01), played.Speed)
			end)
			local stopped
			stopped = played.Stopped:Connect(function()
				stopped:Disconnect()
				pcall(function()
					track:Stop(0.1)
				end)
			end)
		end))
	end

	table.insert(shield.Links, clone.Died:Connect(function()
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		local current = localPlayer.Character
		if current and humanoid.Parent == nil then
			humanoid.Parent = current
			workspace.CurrentCamera.CameraSubject = humanoid
			shieldControls(humanoid)
		end
		pcall(function()
			clone:Destroy()
		end)
		humanoid.Health = 0
	end))
end

local function shieldUndo()
	shieldUnlink()
	local character = localPlayer.Character
	local original, clone = shield.Original, shield.Clone
	shield.Original, shield.Clone = nil, nil
	if original and clone and character and original.Parent == nil and clone.Parent == character then
		original.Parent = character
		workspace.CurrentCamera.CameraSubject = original
		shieldControls(original)
		pcall(function()
			clone:Destroy()
		end)
		shieldAnimate(character)
	end
end

local function shieldStart()
	shieldSwap()
	local n = 0
	shield.Connection = RunService.Heartbeat:Connect(function(dt)
		n += dt
		local character = localPlayer.Character
		local missing = not (shield.Clone and character and shield.Clone.Parent == character)
		if (missing and 0.25 or 3) <= n then
			n = 0
			shieldSwap()
		end
	end)
	shield.Added = localPlayer.CharacterAdded:Connect(function(character)
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			task.wait(1)
			if shield.Connection and localPlayer.Character == character then
				shieldSwap()
			end
		end)
	end)
end

local function shieldStop()
	if shield.Connection then
		shield.Connection:Disconnect()
		shield.Connection = nil
	end
	if shield.Added then
		shield.Added:Disconnect()
		shield.Added = nil
	end
	shieldUndo()
end

------------------------------------------------------------------ carry / delivery state
local alive = true
local state = { Carrying = false, Uid = nil, Delivered = 0, Busy = false, Cancel = false, Mult = 1, PulledAt = 0, HeldSeen = 0, GuessedDrop = false }

if type(EggState) == "table" and type(EggState.CarryChanged) == "table" and type(EggState.CarryChanged.Connect) == "function" then
	EggState.CarryChanged:Connect(function(arg)
		local carrying = type(arg) == "table" and arg.IsCarrying == true
		if carrying and arg.GuardDisabled == true then
			carrying = false
		end
		state.GuessedDrop = false
		if carrying then
			state.HeldSeen = os.clock()
		end
		if carrying and type(arg.Uid) == "string" then
			state.Uid = arg.Uid
			local mult = tonumber(arg.SpeedMultiplier)
			if mult and mult > 0 then
				state.Mult = mult
			end
		end
		state.Carrying = carrying
	end)
end

pcall(function()
	remote("RE/EggWorld/FieldEggRedeemVerdict").OnClientEvent:Connect(function()
		state.Delivered = os.clock()
	end)
end)

-- the server pulling us back ("Relocate") is noted so the hop is simply repeated
pcall(function()
	remote("RE/RigSync/Refresh").OnClientEvent:Connect(function(arg)
		if type(arg) == "table" and arg.Action == "Relocate" then
			state.PulledAt = os.clock()
		end
	end)
end)

local function takeEgg(uid)
	if type(uid) == "string" and type(EggState) == "table" and type(EggState.CarryFieldEgg) == "function" then
		pcall(EggState.CarryFieldEgg, uid)
	end
end

local function dropEgg()
	if type(EggState) == "table" and type(EggState.DropFieldEgg) == "function" then
		pcall(EggState.DropFieldEgg, "PlayerRequest")
	end
end

-- the prompt of the egg itself (nearest egg prompt to the egg's position), never one of another egg
local function promptNear(position, radius)
	local best, bestDistance = nil, radius
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
			local prompt = child:FindFirstChild("CarryAreaEgg")
			if prompt and prompt:IsA("ProximityPrompt") then
				local distance = (child.Position - position).Magnitude
				if distance < bestDistance then
					best, bestDistance = prompt, distance
				end
			end
		end
	end
	return best
end

-- the carried egg is welded to the character: used to catch a missed carry signal (same check as the hub)
local function heldByMe(uid)
	local character = localPlayer.Character
	if type(uid) ~= "string" or not character then
		return false
	end
	local egg = workspace:FindFirstChild(uid)
	if not egg then
		return false
	end
	for _, d in ipairs(egg:GetDescendants()) do
		if d:IsA("WeldConstraint") or d:IsA("JointInstance") then
			local ok, a, b = pcall(function()
				return d.Part0, d.Part1
			end)
			if ok and ((a and a:IsDescendantOf(character)) or (b and b:IsDescendantOf(character))) then
				return true
			end
		end
	end
	return false
end

task.spawn(function()
	while alive do
		task.wait(0.2)
		if not state.Carrying then
			if state.GuessedDrop and heldByMe(state.Uid) then
				state.GuessedDrop, state.Carrying, state.HeldSeen = false, true, os.clock()
			end
		elseif heldByMe(state.Uid) then
			state.HeldSeen = os.clock()
		elseif os.clock() - state.HeldSeen > 0.8 then
			state.Carrying, state.GuessedDrop = false, true
		end
	end
end)

local function snapshot()
	local list = {}
	local ok, result = pcall(function()
		return remote("RF/EggWorld/AskFieldEggSnapshot"):InvokeServer()
	end)
	local records = ok and type(result) == "table" and result.Records or nil
	if type(records) ~= "table" then
		return list
	end
	for _, record in pairs(records) do
		if type(record) == "table" and type(record.Uid) == "string" and (record.State == "Slot" or record.State == "Dropped") and typeof(record.BottomCFrame) == "CFrame" then
			list[#list + 1] = record
		end
	end
	return list
end

local function eggPosition(uid)
	for _, record in ipairs(snapshot()) do
		if record.Uid == uid then
			return record.BottomCFrame.Position
		end
	end
	return nil
end

------------------------------------------------------------------ egg info for the list (icon, name, value)
local function describe(record)
	local directory = type(Assets) == "table" and Assets.Directory or nil
	local entry = type(directory) == "table" and directory[tostring(record.AssetCategory)] or nil
	local info = { Uid = record.Uid, Category = tostring(record.AssetCategory), Name = tostring(record.AssetCategory), Icon = "", Rarity = 0, Value = 0 }

	if type(entry) == "table" then
		info.Name = tostring(entry.DisplayName or record.AssetCategory)
		local icon = entry.Icon
		if icon ~= nil and tostring(icon) ~= "" then
			icon = tostring(icon)
			info.Icon = tonumber(icon) and ("rbxassetid://" .. icon) or icon
		end
		if type(entry.Rarity) == "table" then
			info.Rarity = tonumber(entry.Rarity.RarityNumber or entry.Rarity.Rank) or 0
		end

		local scale = tonumber(record.AssetScale) or 1
		local factor = scale > 5 and (scale / 5) ^ 1.2 * 19.637875755794113 or scale ^ 1.85
		local mutation = 1
		if type(Mutations) == "table" and type(Mutations.EarningsFor) == "function" then
			local okM, resM = pcall(Mutations.EarningsFor, type(record.Mutations) == "table" and record.Mutations or {})
			if okM and type(resM) == "number" then
				mutation = resM
			end
		end
		info.Value = (tonumber(entry.EarningRate) or 0) * factor * mutation
	end

	return info
end

local function money(value)
	local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
	for _, u in ipairs(units) do
		if value >= u[1] then
			return string.format("$%.2f%s/s", value / u[1], u[2])
		end
	end
	return string.format("$%d/s", math.floor(value + 0.5))
end

------------------------------------------------------------------ Instant TP logic
local status = function(text) end

local semi = { Frozen = false, Home = nil, Kind = nil, AtDrop = false, SlowRun = false, Fails = 0, ResetDone = false, Rotate = nil, ExitPath = nil, Log = {} }
local goMethod = "Semi TP"

local function slog(msg)
	local r = root()
	local list = semi.Log
	list[#list + 1] = string.format("%.1f %s | y=%s", os.clock() % 1000, msg, r and string.format("%.0f", r.Position.Y) or "nil")
	if #list > 300 then
		table.remove(list, 1)
	end
end

pcall(function()
	getgenv().S2rHubSemiReport = function()
		return table.concat(semi.Log, "\n")
	end
end)

local function frozenCamera()
	local camera = workspace.CurrentCamera
	if not camera then
		return function() end
	end
	local oldType = camera.CameraType
	local frame = camera.CFrame
	pcall(function()
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = frame
	end)
	return function()
		pcall(function()
			camera.CameraType = oldType
		end)
	end
end

-- FPS dip: 50 / 40 (never below 40), the pause between two switches is 200 ms while the ping is 200 ms or less,
-- otherwise it follows the ping (read once, when the dip starts). Only during the delivery.
local userFps = 240
pcall(function()
	if typeof(getfpscap) == "function" then
		local cap = tonumber(getfpscap())
		if cap and (cap == 0 or cap >= 60) then
			userFps = cap
		end
	end
end)

local function restoreFps()
	if typeof(setfpscap) == "function" then
		pcall(setfpscap, math.clamp(math.floor(userFps), 0, 1000))
	end
end

local function dipInterval()
	local ping = 0
	local ok, value = pcall(function()
		return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok then
		ping = tonumber(value) or 0
	end
	if ping <= 200 then
		return 0.2
	end
	return math.clamp(ping / 1000, 0.2, 1)
end

local fpsGen = 0
local function fpsOn()
	if typeof(setfpscap) ~= "function" then
		return
	end
	fpsGen += 1
	local mine = fpsGen
	task.spawn(function()
		local high = true
		local step = dipInterval()
		local started = os.clock()
		while fpsGen == mine and os.clock() - started < 60 do
			pcall(setfpscap, high and 50 or 40)
			high = not high
			task.wait(step)
		end
		if fpsGen == mine then
			restoreFps()
		end
	end)
end

local function fpsOff()
	fpsGen += 1
	restoreFps()
end

-- a still copy of the player stays where the egg was taken during the flight; removed on arrival
local stealClone = nil
local function dropClone()
	local copy = stealClone
	stealClone = nil
	if copy then
		pcall(function()
			copy:Destroy()
		end)
	end
end

local function postClone()
	dropClone()
	local character = localPlayer.Character
	if not character then
		return
	end
	local was = character.Archivable
	character.Archivable = true
	local copy = character:Clone()
	character.Archivable = was
	if copy then
		for _, d in ipairs(copy:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("Animator") or d:IsA("AnimationController") or d:IsA("Sound") then
				pcall(function()
					d:Destroy()
				end)
			elseif d:IsA("Humanoid") then
				pcall(function()
					d.PlatformStand = true
					d.AutoRotate = false
					d.WalkSpeed = 0
					d.JumpPower = 0
					d.JumpHeight = 0
					d.BreakJointsOnDeath = false
					d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					d.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				end)
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
			end
		end
		copy.Name = "Clone"
		copy.Parent = workspace
		stealClone = copy
	end
end

------------------------------------------------------------------ Semi TP: frozen view (the player stays still while the body works)
local viewState = nil

local function randomName()
	return string.format("%08x", math.random(0, 2147483647))
end

local function cloneModel(model, parent)
	local map = {}
	for _, d in ipairs(model:GetDescendants()) do
		map[d] = d.Archivable
		pcall(function()
			d.Archivable = true
		end)
	end
	local was = model.Archivable
	model.Archivable = true
	local ok, result = pcall(function()
		return model:Clone()
	end)
	model.Archivable = was
	for inst, value in pairs(map) do
		pcall(function()
			inst.Archivable = value
		end)
	end
	if not ok or not result then
		return nil
	end
	result.Name = randomName()
	for _, d in ipairs(result:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("ForceField") or d:IsA("JointInstance") or d:IsA("Constraint") or d:IsA("WeldConstraint") or d:IsA("BodyMover") or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") then
			pcall(function()
				d:Destroy()
			end)
		elseif d:IsA("BasePart") then
			d.Anchored = true
			d.CanCollide = false
			d.CanQuery = false
			d.CanTouch = false
		elseif d:IsA("Humanoid") then
			d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			d.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		end
	end
	result.Parent = parent
	return result
end

local promptSaved = nil
local function hidePrompts(hide)
	pcall(function()
		local service = game:GetService("ProximityPromptService")
		if hide then
			promptSaved = promptSaved or { guis = {}, max = nil }
			if promptSaved.max == nil then
				local okMax, current = pcall(function()
					return service.MaxPromptsVisible
				end)
				if okMax then
					promptSaved.max = current
				end
			end
			pcall(function()
				service.MaxPromptsVisible = 0
			end)
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			if playerGui then
				for _, promptGui in ipairs(playerGui:GetChildren()) do
					local guiName = string.lower(promptGui.Name)
					if promptGui:IsA("ScreenGui") and promptGui.Enabled and not string.find(guiName, "s2rhub", 1, true)
						and (string.find(guiName, "prompt", 1, true) or string.find(guiName, "interact", 1, true)) then
						promptGui.Enabled = false
						promptSaved.guis[#promptSaved.guis + 1] = promptGui
					end
				end
			end
		elseif promptSaved then
			local saved = promptSaved
			promptSaved = nil
			for _, promptGui in ipairs(saved.guis) do
				pcall(function()
					promptGui.Enabled = true
				end)
			end
			if saved.max ~= nil then
				pcall(function()
					service.MaxPromptsVisible = saved.max
				end)
			end
		end
	end)
end

local sinkName = nil
local touchSaved = nil
local function sinkInput(on)
	pcall(function()
		local cas = game:GetService("ContextActionService")
		if on then
			if sinkName then
				return
			end
			sinkName = "S2rHubFreeze" .. tostring(math.random(100000, 999999))
			cas:BindActionAtPriority(sinkName, function()
				return Enum.ContextActionResult.Sink
			end, false, 3000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Down,
				Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Space, Enum.KeyCode.Thumbstick1, Enum.KeyCode.ButtonA)
		elseif sinkName then
			local name = sinkName
			sinkName = nil
			cas:UnbindAction(name)
		end
	end)
	pcall(function()
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		local touch = playerGui and playerGui:FindFirstChild("TouchGui")
		if on then
			if touch and touch:IsA("ScreenGui") and not touchSaved then
				touchSaved = { Gui = touch, Enabled = touch.Enabled }
				touch.Enabled = false
			end
		elseif touchSaved then
			local saved = touchSaved
			touchSaved = nil
			saved.Gui.Enabled = saved.Enabled
		end
	end)
end

local function viewControls(on)
	hidePrompts(not on)
	sinkInput(not on)
	pcall(function()
		local scripts = localPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if on then
				controls:Enable()
			else
				controls:Disable()
			end
		end
	end)
end

local function releaseView()
	local view = viewState
	if not view then
		return
	end
	viewState = nil
	semi.Frozen = false
	viewControls(true)
	if view.BindName then
		pcall(function()
			RunService:UnbindFromRenderStep(view.BindName)
		end)
	end
	if view.Link then
		pcall(function()
			view.Link:Disconnect()
		end)
	end
	if view.Beat then
		pcall(function()
			view.Beat:Disconnect()
		end)
	end
	for _, part in ipairs(view.Hidden) do
		pcall(function()
			part.LocalTransparencyModifier = 0
		end)
	end
	for _, extra in ipairs(view.Extras) do
		pcall(function()
			extra.Inst.Enabled = extra.Prev
		end)
	end
	pcall(function()
		view.Camera.CameraType = view.CameraType
	end)
	for _, copy in ipairs(view.Copies) do
		pcall(function()
			copy:Destroy()
		end)
	end
end

local function freezeView(character, offset, cameraCFrame)
	local camera = workspace.CurrentCamera
	if viewState or not character or not camera then
		return false
	end
	offset = offset or Vector3.zero
	local view = { Camera = camera, CameraType = camera.CameraType, CameraCFrame = cameraCFrame or camera.CFrame, Copies = {}, Hidden = {}, Extras = {} }
	viewState = view
	task.delay(120, function()
		if viewState == view then
			releaseView()
		end
	end)

	local hiddenSet, extraSet = {}, {}
	for _, d in ipairs(character:GetDescendants()) do
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
			hiddenSet[d] = true
			view.Hidden[#view.Hidden + 1] = d
		end
	end
	local lastScan = os.clock()

	local function scanExtras()
		for _, d in ipairs(character:GetDescendants()) do
			if not extraSet[d] and (d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
				or d:IsA("Highlight") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") or d:IsA("Light")) then
				extraSet[d] = true
				local okEnabled, enabledValue = pcall(function()
					return d.Enabled
				end)
				view.Extras[#view.Extras + 1] = { Inst = d, Prev = okEnabled and enabledValue or false }
			end
		end
	end
	pcall(scanExtras)

	local function tick()
		if os.clock() - lastScan > 0.25 then
			lastScan = os.clock()
			if view.Semi then
				hidePrompts(true)
			end
			pcall(function()
				for _, d in ipairs(character:GetDescendants()) do
					if not hiddenSet[d] and (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture")) then
						hiddenSet[d] = true
						view.Hidden[#view.Hidden + 1] = d
					end
				end
				for _, copy in ipairs(view.Copies) do
					if copy.Parent ~= camera then
						copy.Parent = camera
					end
				end
				scanExtras()
			end)
		end
		for _, part in ipairs(view.Hidden) do
			pcall(function()
				part.LocalTransparencyModifier = 1
			end)
		end
		for _, extra in ipairs(view.Extras) do
			pcall(function()
				if extra.Inst.Enabled then
					extra.Inst.Enabled = false
				end
			end)
		end
		pcall(function()
			local live = workspace.CurrentCamera
			if live and live ~= camera then
				camera = live
				view.Camera = live
			end
			if camera.CameraType ~= Enum.CameraType.Scriptable then
				camera.CameraType = Enum.CameraType.Scriptable
			end
			camera.CFrame = view.CameraCFrame
		end)
	end

	tick()
	view.BindName = randomName()
	if not pcall(function()
		RunService:BindToRenderStep(view.BindName, Enum.RenderPriority.Last.Value + 1, tick)
	end) then
		view.BindName = nil
		view.Link = RunService.RenderStepped:Connect(tick)
	end
	view.Beat = RunService.Heartbeat:Connect(tick)

	local ok, copy = pcall(cloneModel, character, camera)
	if ok and copy then
		if offset.Magnitude > 0.01 then
			for _, d in ipairs(copy:GetDescendants()) do
				if d:IsA("BasePart") then
					pcall(function()
						d.CFrame = d.CFrame + offset
					end)
				end
			end
		end
		view.Copies[#view.Copies + 1] = copy
	end

	view.Semi = true
	viewControls(false)
	semi.Frozen = true
	return true
end

-- Auto Steal cancelled while frozen: the body first goes back to where the copy waits, then camera and controls return
local function releaseBackHome(home)
	local frozen = viewState
	if not frozen then
		return
	end
	if typeof(home) ~= "Vector3" then
		releaseView()
		return
	end
	local started = os.clock()
	while os.clock() - started < 7 and viewState == frozen do
		local r = root()
		if not r or r.Position.Y < 5000 then
			break
		end
		RunService.Heartbeat:Wait()
	end
	for _ = 1, 10 do
		if viewState ~= frozen then
			return
		end
		local r = root()
		if r then
			pcall(function()
				r.CFrame = CFrame.new(home) * r.CFrame.Rotation
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		RunService.Heartbeat:Wait()
	end
	if viewState == frozen then
		releaseView()
	end
end

local function swapped()
	local character = localPlayer.Character
	return shield.Clone ~= nil and character ~= nil and shield.Clone.Parent == character
end

------------------------------------------------------------------ map helpers
local function lineInfo()
	local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	world = world and world:FindFirstChild("Areas")
	world = world and world:FindFirstChild("SeparationLine")
	local ok = world and world:IsA("BasePart")
	return ok and world.Position.X or 552.2, ok and world.Position.Y or 67.67
end

local function homePoint()
	for _, def in ipairs({
		{ { "GearGiver_Slap", "Podium" }, Vector3.new(-16.415, 21.072, -6.106) },
		{ { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
		{ { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
	}) do
		local node = workspace
		for _, name in ipairs(def[1]) do
			node = node and node:FindFirstChild(name) or nil
		end
		if node and node:IsA("BasePart") then
			return node.CFrame:PointToWorldSpace(def[2])
		end
	end
	return Vector3.new(528.7, 70.57, -364.11)
end

local function place(position)
	local r = root()
	if not r then
		return
	end
	pcall(function()
		r.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0)
		r.AssemblyLinearVelocity = Vector3.zero
		r.AssemblyAngularVelocity = Vector3.zero
	end)
end

-- portals / arenas / teleporters are walked around (same list as the hub)
local dangerCache, dangerAt = {}, 0
local function dangers()
	if os.clock() - dangerAt < 5 then
		return dangerCache
	end
	dangerAt = os.clock()
	local list = {}
	local function add(inst)
		local ok, cf, size = pcall(function()
			if inst:IsA("Model") then
				return inst:GetBoundingBox()
			elseif inst:IsA("BasePart") then
				return inst.CFrame, inst.Size
			end
		end)
		if ok and cf and size then
			local half = Vector3.new(math.abs(size.X), 0, math.abs(size.Z)) * 0.5
			local rot = (cf - cf.Position):VectorToWorldSpace(half)
			local rx = math.max(math.abs(rot.X), half.X, half.Z)
			local rz = math.max(math.abs(rot.Z), half.X, half.Z)
			list[#list + 1] = { MinX = cf.Position.X - rx, MaxX = cf.Position.X + rx, MinZ = cf.Position.Z - rz, MaxZ = cf.Position.Z + rz }
		end
	end
	local function bad(name)
		if name == "ScrambleLocalVisuals" or name == "DrScrambleEvent" then
			return false
		end
		name = string.lower(name)
		return string.find(name, "portal", 1, true) or string.find(name, "teleport", 1, true) or string.find(name, "mech", 1, true) or string.find(name, "arena", 1, true) or string.find(name, "scramble", 1, true)
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if (child:IsA("Model") or child:IsA("BasePart") or child:IsA("Folder")) and bad(child.Name) then
			if child:IsA("Folder") then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			else
				add(child)
			end
		end
	end
	local build = workspace:FindFirstChild("World")
	build = build and build:FindFirstChild("Build")
	if build then
		for _, child in ipairs(build:GetChildren()) do
			if bad(child.Name) then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			end
		end
	end
	dangerCache = list
	return list
end

-- if the straight line crosses a danger zone, aim at the corner of it instead
local function avoid(from, to)
	for _, d in ipairs(dangers()) do
		local x0, x1, z0, z1 = d.MinX - 12, d.MaxX + 12, d.MinZ - 12, d.MaxZ + 12
		local inside = from.X >= x0 and from.X <= x1 and from.Z >= z0 and from.Z <= z1
		if not inside then
			local t0, t1, hit = 0, 1, true
			for _, axis in ipairs({ { from.X, to.X - from.X, x0, x1 }, { from.Z, to.Z - from.Z, z0, z1 } }) do
				local pos, delta, lo, hi = axis[1], axis[2], axis[3], axis[4]
				if math.abs(delta) < 1e-6 then
					if pos < lo or pos > hi then
						hit = false
					end
				else
					local ta, tb = (lo - pos) / delta, (hi - pos) / delta
					if ta > tb then
						ta, tb = tb, ta
					end
					t0, t1 = math.max(t0, ta), math.min(t1, tb)
					if t0 > t1 then
						hit = false
					end
				end
			end
			if hit then
				local zLow, zHigh = z0 - 2, z1 + 2
				local z = math.abs(from.Z - zLow) <= math.abs(from.Z - zHigh) and zLow or zHigh
				if z < -440 or z > -290 then
					z = z == zLow and zHigh or zLow
				end
				local x = math.abs(from.X - x0) <= math.abs(from.X - x1) and x0 or x1
				if math.abs(from.Z - z) < 3 then
					x = math.abs(to.X - x0) <= math.abs(to.X - x1) and x0 or x1
				end
				return Vector3.new(x, to.Y, z)
			end
		end
	end
	return to
end

-- current position of an egg lying in the world (cheap), with the snapshot as fallback
local function eggNow(uid, cache)
	local node = workspace:FindFirstChild(uid)
	local slots = workspace:FindFirstChild("AreaEggSlotsClient")
	node = node or (slots and slots:FindFirstChild(uid))
	if node then
		local ok, pos = pcall(function()
			return node:GetPivot().Position
		end)
		if ok and pos then
			cache.Pos, cache.At = pos, os.clock()
			return pos
		end
	end
	if os.clock() - cache.At >= 0.5 then
		cache.At = os.clock()
		cache.Pos = eggPosition(uid) or cache.Pos
	end
	return cache.Pos
end

-- go to the egg: straight on the ground at 115% of the walk speed (never faster), or, after the Semi TP exit, in the air
-- at the given ratio with a cruise height above the egg. From the base side it first walks out to the safe-zone point.
local function runToEgg(uid, egg, opts)
	opts = opts or {}
	local ratio = math.min(opts.Ratio or CFG.SpeedCap, CFG.SpeedCap)
	local height = opts.Height or 0
	local lineX = lineInfo()
	local home = homePoint()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		if character:FindFirstChildWhichIsA("Tool") then
			pcall(function()
				humanoid:UnequipTools()
			end)
		end
	end

	local r = root()
	if not r then
		return false
	end
	local stage = "field"
	if not opts.Field and r.Position.X < lineX - 2 and Vector3.new(r.Position.X - home.X, 0, r.Position.Z - home.Z).Magnitude > 20 then
		stage = "safe"
	end

	local runY = egg.Y + 3
	local function snapToHeight(target)
		local at = root()
		local current = localPlayer.Character
		if not at or not current or math.abs(at.Position.Y - target) < 1 or math.abs(at.Position.Y - target) > 90 then
			return false
		end
		pcall(function()
			current:PivotTo(CFrame.new(Vector3.new(at.Position.X, target, at.Position.Z)) * at.CFrame.Rotation)
			at.AssemblyLinearVelocity = Vector3.new(at.AssemblyLinearVelocity.X, 0, at.AssemblyLinearVelocity.Z)
		end)
		return true
	end
	if stage == "field" and height > 0.5 then
		snapToHeight(runY + height)
	end

	local started, lastCheck, lastPos, lastTake = os.clock(), os.clock(), r.Position, 0
	while os.clock() - started < 120 and not state.Cancel do
		r = root()
		if not r then
			return false
		end
		local flatEgg = Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z)
		if stage == "field" and flatEgg.Magnitude <= 2.5 and (height <= 0.5 or r.Position.Y - runY < 4) then
			break
		end
		local target = egg
		if stage == "safe" then
			if Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude <= 6 then
				stage = "field"
				if height > 0.5 then
					snapToHeight(runY + height)
				end
			else
				target = home
			end
		end

		local waypoint = avoid(r.Position, target)
		local flat = Vector3.new(waypoint.X - r.Position.X, 0, waypoint.Z - r.Position.Z)
		local unit = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
		local speed = math.max(walkSpeed() * ratio, 8)
		if height > 0.5 and stage == "field" then
			local wantY = flatEgg.Magnitude <= 3 and runY or runY + height
			if (flatEgg.Magnitude <= 3 and snapToHeight(runY)) or (math.abs(wantY - r.Position.Y) > 2 and snapToHeight(wantY)) then
				RunService.Heartbeat:Wait()
				continue
			end
			local vy = math.clamp((wantY - r.Position.Y) / 0.12, -speed * 0.5, speed * 0.5)
			local horizontal = unit * math.min(math.sqrt(math.max(speed * speed - vy * vy, 0)), flat.Magnitude / 0.05)
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.new(horizontal.X, vy, horizontal.Z)
			end)
		else
			local v = unit * math.min(speed, flat.Magnitude / 0.05)
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.new(v.X, r.AssemblyLinearVelocity.Y, v.Z)
				if humanoid and unit.Magnitude > 0 then
					humanoid:Move(unit, false)
				end
			end)
		end

		-- stuck on something: jump
		if os.clock() - lastCheck >= 1.5 then
			if (r.Position - lastPos).Magnitude < 3 and humanoid and flatEgg.Magnitude > 15 then
				pcall(function()
					humanoid.Jump = true
				end)
			end
			lastPos, lastCheck = r.Position, os.clock()
		end

		-- close enough for the prompt: ask for the egg while arriving
		if stage == "field" and flatEgg.Magnitude <= 9 and os.clock() - lastTake > 0.1 then
			lastTake = os.clock()
			takeEgg(uid)
		end
		RunService.Heartbeat:Wait()
	end

	r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			if humanoid then
				humanoid:Move(Vector3.zero, false)
			end
		end)
	end
	return state.Carrying or (r ~= nil and Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z).Magnitude <= 6)
end

-- take the egg that lies next to us (also used to take it back after the drop): follow it, fire its prompt and send the request
local function grab(uid, timeout)
	local cache = { At = 0 }
	local waited, since = 0, 1
	while not state.Carrying and waited < timeout and not state.Cancel do
		local r = root()
		local egg = eggNow(uid, cache)
		local dt = math.max(RunService.Heartbeat:Wait(), 1 / 240)
		waited += dt
		since += dt
		if r and egg then
			local delta = egg - r.Position
			if delta.Magnitude > 2 then
				local pace = math.max(walkSpeed() * CFG.SpeedCap, 16)
				local v = delta / math.max(0.08, dt)
				if v.Magnitude > pace then
					v = v.Unit * pace
				end
				pcall(function()
					r.AssemblyLinearVelocity = v + Vector3.new(0, workspace.Gravity * dt * 0.5, 0)
					r.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			if since >= CFG.GrabInterval then
				since = 0
				local prompt = promptNear(egg - Vector3.new(0, 3, 0), 10)
				if prompt and typeof(fireproximityprompt) == "function" then
					pcall(function()
						prompt.HoldDuration = 0
					end)
					pcall(fireproximityprompt, prompt)
				end
				task.spawn(takeEgg, uid)
			end
		elseif since >= CFG.GrabInterval then
			since = 0
			task.spawn(takeEgg, uid)
		end
	end
	local r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.zero
		end)
	end
	return state.Carrying and state.Uid == uid
end

local function regrab(uid)
	if state.Carrying then
		return true
	end
	local r = root()
	local egg = eggNow(uid, { At = 0 })
	if r and egg and Vector3.new(r.Position.X - egg.X, 0, r.Position.Z - egg.Z).Magnitude > CFG.RegrabFar then
		status("The egg fell far behind, teleporting onto it")
		place(egg + Vector3.new(0, 3, 0))
	else
		status("The egg fell close, taking it back")
	end
	return grab(uid, 3)
end

local function groundY(position, fallback)
	local y = fallback
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { localPlayer.Character }
		params.IgnoreWater = true
		params.RespectCanCollide = true
		local hit = workspace:Raycast(position + Vector3.new(0, 60, 0), Vector3.new(0, -140, 0), params)
		if hit and hit.Material ~= Enum.Material.Water and math.abs(hit.Position.Y - fallback) < 40 then
			y = hit.Position.Y + 3.5
		end
	end)
	return y
end

-- safe zone: same route as the Normal mode: checkpoint 7 studs past the line, then the base.
-- Speed = the hub's carry plan (never above 115% of the walk speed), the run starts above the base and comes down.
local function carrySpeed(distance)
	local ws = walkSpeed()
	if semi.SlowRun then
		return math.max(ws * 0.8 * state.Mult, 8)
	end
	local base = ws * math.min(CFG.CarryRatio, CFG.SpeedCap) * state.Mult
	local fast = base * 1.5 -- SpeedRatio
	local excess = 5.5 * base -- ExcessSeconds
	local limit = fast
	if distance and distance > excess then
		limit = math.min(fast, base * distance / (distance - excess))
	end
	return math.min(math.max(math.min(base * CFG.EasyRatio, limit), base), math.max(ws * CFG.SpeedCap, base))
end

-- Semi TP delivery: two teleports (checkpoint past the line, then the base), the egg is put down on the base
local function tpHome(lineX, laneZ, started)
	local home = homePoint()
	local steps = { Vector3.new(lineX - 7, home.Y, laneZ), home }
	status("Safe zone: teleporting")
	for _, target in ipairs(steps) do
		local tries = 0
		while state.Carrying and state.Delivered < started and not state.Cancel and tries < 3 do
			tries += 1
			local pulledBefore = state.PulledAt
			local held = 0
			while held < math.max(CFG.HopGap, 0.1) do
				place(target)
				held += RunService.Heartbeat:Wait()
			end
			local check = root()
			local pulled = state.PulledAt > pulledBefore or (check ~= nil and Vector3.new(check.Position.X - target.X, 0, check.Position.Z - target.Z).Magnitude > 10)
			if not pulled then
				break
			end
		end
	end
	local waited = 0
	while state.Carrying and state.Delivered < started and not state.Cancel and waited < 1 do
		waited += RunService.Heartbeat:Wait()
	end
	if state.Carrying and state.Delivered < started and not state.Cancel then
		local at = root()
		if at and Vector3.new(at.Position.X - home.X, 0, at.Position.Z - home.Z).Magnitude > 6 then
			place(home)
			RunService.Heartbeat:Wait()
		end
		status("Safe zone: dropping the egg on the base")
		dropEgg()
		local confirm = 0
		while state.Delivered < started and confirm < 1 and not state.Cancel do
			confirm += RunService.Heartbeat:Wait()
		end
	end
	return state.Delivered >= started
end

local function runHome(lineX, laneZ)
	local started = os.clock()
	local home = homePoint()
	local checkpoint = lineX - 7
	local height = semi.SlowRun and 0 or CFG.Height
	local share = math.clamp(CFG.ClimbShare, 0.1, 0.9)
	local descent = height * math.sqrt(1 - share * share) / share
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
	end

	-- rise above the base first (no horizontal move), like the hub
	local r = root()
	if r and character and height > 0.5 and home.Y + height - 2 > r.Position.Y then
		pcall(function()
			character:PivotTo(CFrame.new(Vector3.new(r.Position.X, home.Y + height, r.Position.Z)) * r.CFrame.Rotation)
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	-- the speed is planned once, at the start, from the distance still to go (the hub does the same)
	local start = root()
	local speed = carrySpeed(start and (Vector3.new(start.Position.X - home.X, 0, start.Position.Z - home.Z).Magnitude + math.max(0, height) * 2) or nil)

	local last = os.clock()
	local timeout = 0
	status("Safe zone")
	while state.Carrying and state.Delivered < started and not state.Cancel and timeout < 25 do
		r = root()
		if not r then
			return false
		end
		local now = os.clock()
		local dt = math.max(now - last, 1 / 240)
		last = now
		timeout += dt

		local toHome = r.Position.X <= checkpoint + 2
		local target = toHome and home or Vector3.new(checkpoint, home.Y, laneZ)
		if toHome and Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude < 2 then
			break
		end
		local aim = avoid(r.Position, target)
		local flat = Vector3.new(aim.X - r.Position.X, 0, aim.Z - r.Position.Z)
		local remaining = toHome and 0 or math.max(0, r.Position.X - checkpoint)
		local wantY = home.Y + height
		if toHome or remaining <= descent then
			wantY = home.Y + height * math.clamp(remaining / math.max(descent, 1), 0, 1)
		end
		local vy = math.clamp((wantY - r.Position.Y) / 0.12, -speed * share, speed * share)
		local horizontal = math.sqrt(math.max(speed * speed - vy * vy, 0))
		local v = flat.Magnitude > 0.01 and flat.Unit * math.min(horizontal, flat.Magnitude / 0.05) or Vector3.zero
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
		end)
		RunService.Heartbeat:Wait()
	end

	if humanoid then
		pcall(function()
			humanoid:Move(Vector3.zero, false)
		end)
	end

	local settle = 0
	while settle < 2 and state.Delivered < started and state.Carrying and not state.Cancel do
		settle += RunService.Heartbeat:Wait()
	end
	-- still in the hands at home: put it down so the base takes it
	if state.Carrying and state.Delivered < started and not state.Cancel then
		task.wait(0.2)
		dropEgg()
		local waited = 0
		while state.Delivered < started and waited < 1 do
			waited += RunService.Heartbeat:Wait()
		end
	end
	return state.Delivered >= started
end

local function instantTP(uid)
	local started = os.clock()
	local lineX, lineY = lineInfo()
	local r = root()
	if not r then
		return false
	end
	local laneZ = math.clamp(r.Position.Z, -425, -300)
	local hopZ = math.clamp(r.Position.Z, -425, -300)
	local semiFrozen = viewState ~= nil
	local landing = Vector3.new(lineX + CFG.LandOffset, lineY + 3.35, laneZ)
	local semiOnly = semiFrozen and semi.Kind ~= "decoy"
	local semiEnd = semiFrozen or semi.SlowRun == true

	-- hops towards the line; a pull-back repeats the same hop with a longer pause (the pause is learned)
	local hopStep = math.max(walkSpeed() * CFG.HopRatio * (semiOnly and 0.85 or 1), CFG.HopMin)
	local hopY = r.Position.Y + CFG.HopLift
	local x = r.Position.X
	local retries = 0
	local shrinks = 0
	local releaseCamera = semiFrozen and function() end or frozenCamera()
	state.ReleaseCamera = releaseCamera
	if not semiFrozen then
		pcall(postClone)
	end
	fpsOn()

	while x - hopStep > landing.X and not state.Cancel do
		if not state.Carrying then
			-- the server let go of the egg on the way: take it back right away
			if not regrab(uid) then
				break
			end
			local current = root()
			if current then
				x = math.min(x, current.Position.X)
			end
			continue
		end

		local nextX = x - hopStep
		status(string.format("Instant TP: hopping home, X %d", math.floor(nextX)))
		local pulledBefore = state.PulledAt
		local held = 0
		while held < CFG.HopGap do
			place(Vector3.new(nextX, hopY, hopZ))
			held += RunService.Heartbeat:Wait()
		end

		local check = root()
		local pulled = state.PulledAt > pulledBefore or (check ~= nil and (check.Position.X - nextX > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and state.Carrying and not state.Cancel then
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.02)
			if retries > CFG.HopRetries then
				if shrinks >= 2 then
					break
				end
				shrinks += 1
				retries = 0
				hopStep = math.max(hopStep * 0.6, CFG.HopMin * 0.5)
				CFG.HopGap = CFG.HopGapMax
				status(string.format("Instant TP: pulled back too often, shorter hops (%d/2)", shrinks))
			end
			status(string.format("Instant TP: pulled back, retry %d/%d", retries, CFG.HopRetries))
			local settle = 0
			while settle < 0.12 and not state.Cancel do
				place(Vector3.new(x, hopY, hopZ))
				settle += RunService.Heartbeat:Wait()
			end
		else
			x = nextX
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
		end
	end

	-- landing in front of the line
	status("Instant TP: landing next to the line")
	landing = Vector3.new(landing.X, groundY(landing, landing.Y), landing.Z)
	local function onSpot()
		local current = root()
		return current ~= nil and current.Position.X <= landing.X + 12 and math.abs(current.Position.Y - landing.Y) <= 10
	end
	local function land()
		local current = root()
		-- never jump backwards: if we are already on the landing spot, stay
		if current and current.Position.X <= landing.X + 1 and math.abs(current.Position.Y - landing.Y) <= 10 then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
			end)
			return
		end
		place(landing)
	end
	land()
	for attempt = 1, 5 do
		local settle = 0
		while settle < CFG.LandSettle and not state.Cancel do
			settle += RunService.Heartbeat:Wait()
		end
		if state.Carrying and not onSpot() then
			status("Instant TP: landing retry " .. attempt)
			land()
		else
			break
		end
	end
	dropClone()

	-- drop at the line (only when we really stand on the spot, and only once the server confirmed it), take it back
	if state.Carrying and not state.Cancel then
		local delay = 0
		while delay < CFG.DropDelay do
			delay += RunService.Heartbeat:Wait()
		end
		if state.Carrying and not state.Cancel and not onSpot() then
			land()
			local settle = 0
			while settle < CFG.LandSettle and not state.Cancel do
				settle += RunService.Heartbeat:Wait()
			end
		end
		if not state.Carrying or state.Cancel then
			-- nothing to drop
		elseif not onSpot() then
			status("Instant TP: not on the drop spot, going home with the egg")
		else
			status("Instant TP: dropping the egg")
			if semiFrozen then
				local at = root()
				if at then
					slog(string.format("Instant TP: the clown drops the egg at x=%.0f z=%.0f (line %+.0f)", at.Position.X, at.Position.Z, at.Position.X - lineX))
				end
			end
			for _ = 1, 3 do
				dropEgg()
				local waited = 0
				while state.Carrying and waited < 0.8 and not state.Cancel do
					waited += RunService.Heartbeat:Wait()
				end
				if not state.Carrying or state.Cancel then
					break
				end
				status("Instant TP: the drop was not confirmed, trying again")
				if not onSpot() then
					land()
				end
			end
			local current = root()
			if current then
				pcall(function()
					current.AssemblyLinearVelocity = Vector3.zero
					current.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			-- egg is down: let go of the camera and the copy, then take it back
			releaseCamera()
			if semiFrozen and semi.AtDrop == true then
				releaseView()
			end
			dropClone()
			status("Instant TP: taking the egg back")
			local tookBack = grab(uid, 3) or regrab(uid)
			for _ = 1, 3 do
				if tookBack or state.Cancel then
					break
				end
				status("Instant TP: the egg is not in the hands yet, trying again")
				tookBack = regrab(uid) or grab(uid, 2)
			end
			if not tookBack then
				fpsOff()
				status("Could not take the egg back")
				return false
			end
			dropClone()
		end
	end
	releaseCamera()

	-- safe zone: Semi TP ends with teleports (never a run unless both fail), the rest keeps the run
	local ok = false
	local function goHome()
		if semiEnd then
			for round = 1, 2 do
				if tpHome(lineX, laneZ, started) then
					return true
				end
				if not state.Carrying or state.Cancel then
					return state.Delivered >= started
				end
				status(string.format("Instant TP: teleport home again (%d/2)", round))
			end
		end
		return runHome(lineX, laneZ)
	end
	if state.Carrying then
		ok = goHome()
	end
	local again = 0
	while not ok and state.Delivered < started and not state.Cancel and again < 2 do
		again += 1
		status(string.format("Instant TP: not delivered yet, going home again (%d/2)", again))
		if not state.Carrying and not regrab(uid) then
			break
		end
		local current = root()
		if current and current.Position.X > lineX + 8 then
			place(Vector3.new(lineX + 8, math.max(current.Position.Y, lineY + 3.35), current.Position.Z))
			RunService.Heartbeat:Wait()
		end
		ok = goHome()
	end
	fpsOff()
	return ok or state.Delivered >= started
end

-- after a failed Semi TP: the body goes back to the front of the base by itself (hops like the delivery)
local function returnFront()
	local reached = false
	pcall(function()
		local waited = 0
		while root() and root().Position.Y > 5000 and waited < 8 and not state.Cancel do
			waited += RunService.Heartbeat:Wait()
		end
		local r = root()
		if not r or state.Cancel then
			return
		end
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
		local lineX = lineInfo()
		local home = homePoint()
		local hopZ = math.clamp(r.Position.Z, -425, -300)
		local frontX = lineX - 7
		local hopStep = math.max(walkSpeed() * CFG.HopRatio * 0.85, CFG.HopMin)
		local hopY = r.Position.Y + CFG.HopLift
		local x = r.Position.X
		local gap = CFG.HopGap
		local retries, shrinks = 0, 0
		status("Going back to the front")
		while x - frontX > hopStep and not state.Cancel do
			local nextX = x - hopStep
			local pulledBefore = state.PulledAt
			local held = 0
			while held < gap and not state.Cancel do
				place(Vector3.new(nextX, hopY, hopZ))
				held += RunService.Heartbeat:Wait()
			end
			local check = root()
			local pulled = state.PulledAt > pulledBefore or (check ~= nil and check.Position.X - nextX > 10)
			if pulled then
				retries += 1
				gap = math.min(CFG.HopGapMax, gap + 0.02)
				if retries > CFG.HopRetries then
					if shrinks >= 2 then
						break
					end
					shrinks += 1
					retries = 0
					hopStep = math.max(hopStep * 0.6, CFG.HopMin * 0.5)
				end
				local settle = 0
				while settle < 0.12 and not state.Cancel do
					place(Vector3.new(x, hopY, hopZ))
					settle += RunService.Heartbeat:Wait()
				end
			else
				x = nextX
			end
		end
		if state.Cancel then
			return
		end
		for _, target in ipairs({ Vector3.new(frontX, home.Y, hopZ), home }) do
			local held = 0
			while held < math.max(gap, 0.1) and not state.Cancel do
				place(target)
				held += RunService.Heartbeat:Wait()
			end
		end
		local settle = 0
		while settle < 0.4 and not state.Cancel do
			settle += RunService.Heartbeat:Wait()
		end
		local at = root()
		reached = at ~= nil and Vector3.new(at.Position.X - home.X, 0, at.Position.Z - home.Z).Magnitude <= 20
	end)
	return reached
end

------------------------------------------------------------------ Semi TP: portal by touch (the only route, no alternative)
-- Returns true plus { Arrived, Ratio, Decoy } or false plus the reason. The player stays frozen (copy + camera) while the body works.
local function semiGo(uid, egg)
	local startRoot = root()
	local build = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	build = build and build:FindFirstChild("Build")
	local portalNode = build and build:FindFirstChild("FuseBiomeLanePortals")
	if not portalNode or not startRoot then
		return false, portalNode and "Semi TP: no character yet" or "Semi TP: portal not there"
	end
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local startCF = startRoot.CFrame
	local cache = { At = 0, Pos = egg }
	local function eggPos()
		return eggNow(uid, cache) or egg
	end
	local function eggPart()
		local node = workspace:FindFirstChild(uid)
		local slots = workspace:FindFirstChild("AreaEggSlotsClient")
		node = node or (slots and slots:FindFirstChild(uid))
		if not node then
			return nil
		end
		if node:IsA("BasePart") then
			return node
		end
		return node:FindFirstChild("Hitbox", true) or node:FindFirstChildWhichIsA("BasePart", true)
	end

	local camera = workspace.CurrentCamera
	local camOffset = camera and (camera.CFrame.Position - startRoot.Position) or Vector3.new(0, 8, 14)
	local camRot = camera and camera.CFrame.Rotation or CFrame.new()

	semi.Kind, semi.AtDrop, semi.Home = nil, false, nil
	slog(string.format("Semi TP from %.0f,%.0f,%.0f to the egg %.0f,%.0f,%.0f", startRoot.Position.X, startRoot.Position.Y, startRoot.Position.Z, egg.X, egg.Y, egg.Z))

	if Vector3.new(egg.X - startRoot.Position.X, 0, egg.Z - startRoot.Position.Z).Magnitude <= 60 then
		-- egg next to us: no portal. The copy waits at home, the body runs to the egg and brings it back.
		semi.Kind = "decoy"
		semi.AtDrop = true
		local spotAt = homePoint()
		local okFreeze = freezeView(character, spotAt - startRoot.Position, CFrame.new(spotAt + camOffset) * camRot)
		semi.Home = okFreeze and spotAt or nil
		slog("egg close: decoy at home, frozen=" .. tostring(okFreeze))
		return true, { Decoy = true }
	end

	-- the player waits at the first drop: line + 22, on the lane of the base
	local lineX, lineY = lineInfo()
	local laneZ = math.clamp(homePoint().Z, -425, -300)
	local land = Vector3.new(lineX + 22, lineY + 3.35, laneZ)
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character }
		params.IgnoreWater = false
		local hit = workspace:Raycast(Vector3.new(land.X, land.Y + 60, laneZ), Vector3.new(0, -140, 0), params)
		if hit and hit.Material ~= Enum.Material.Water and math.abs(hit.Position.Y - land.Y) < 40 then
			land = Vector3.new(land.X, hit.Position.Y + 3.5, laneZ)
		end
	end)
	semi.Kind = "semi"
	semi.AtDrop = true
	local okFreeze = freezeView(character, land - startRoot.Position, CFrame.new(land + camOffset) * camRot)
	if not okFreeze then
		releaseView()
		okFreeze = freezeView(character, land - startRoot.Position, CFrame.new(land + camOffset) * camRot)
	end
	semi.Home = okFreeze and land or nil
	slog("player frozen at the first drop = " .. tostring(okFreeze))

	for _ = 1, 3 do
		RunService.Heartbeat:Wait()
	end
	local shieldSince = os.clock()
	while not swapped() and os.clock() - shieldSince < 5 and not state.Cancel do
		pcall(function()
			local r0 = root()
			if r0 then
				r0.AssemblyLinearVelocity = Vector3.zero
			end
			if humanoid then
				humanoid:Move(Vector3.zero, false)
			end
		end)
		RunService.Heartbeat:Wait()
	end
	slog(string.format("shield=%s after %.2f s", tostring(swapped()), os.clock() - shieldSince))
	pcall(function()
		local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			semi.Rotate = { Hum = hum, Old = hum.AutoRotate }
			hum.AutoRotate = false
		end
	end)

	local stableRot = startRoot.CFrame.Rotation
	pcall(function()
		local flat = Vector3.new(egg.X - startRoot.Position.X, 0, egg.Z - startRoot.Position.Z)
		if flat.Magnitude > 1 then
			stableRot = CFrame.lookAt(Vector3.zero, flat).Rotation
		end
	end)
	local function placeAt(p)
		local r = root()
		if r then
			pcall(function()
				r.CFrame = CFrame.new(p) * stableRot
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end
	local function inBiome()
		local r = root()
		return r ~= nil and r.Position.Y > 5000
	end
	local function jumpNow()
		local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			pcall(function()
				hum.Jump = true
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end
	local function holdPause(t)
		local w = 0
		while w < t and not state.Cancel do
			w += RunService.Heartbeat:Wait()
		end
	end

	local groundSkip, groundSkipAt = nil, 0
	local function groundAt(pos, from)
		local found = nil
		pcall(function()
			if not groundSkip or os.clock() - groundSkipAt > 1 then
				groundSkip = { stealClone }
				groundSkipAt = os.clock()
				local slots = workspace:FindFirstChild("AreaEggSlotsClient")
				if slots then
					groundSkip[#groundSkip + 1] = slots
				end
				for _, child in ipairs(workspace:GetChildren()) do
					if child:IsA("Model") and #child.Name == 32 and child:FindFirstChild("Hitbox") then
						groundSkip[#groundSkip + 1] = child
					end
				end
			end
			local list = { localPlayer.Character }
			for _, v in ipairs(groundSkip) do
				list[#list + 1] = v
			end
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = list
			params.IgnoreWater = true
			pcall(function()
				params.RespectCanCollide = true
			end)
			local origin = Vector3.new(pos.X, from, pos.Z)
			for _ = 1, 4 do
				local hit = workspace:Raycast(origin, Vector3.new(0, -400, 0), params)
				if not hit then
					break
				end
				if hit.Material ~= Enum.Material.Water and hit.Instance.CanCollide and hit.Instance.Transparency < 0.95 then
					found = hit.Position
					break
				end
				origin = hit.Position - Vector3.new(0, 0.05, 0)
			end
		end)
		return found
	end
	local function standHeight()
		local h = 3
		pcall(function()
			local character2 = localPlayer.Character
			local r = root()
			local hum = character2 and character2:FindFirstChildOfClass("Humanoid")
			if character2 and r then
				local box, boxSize = character2:GetBoundingBox()
				local value = r.Position.Y - (box.Position.Y - boxSize.Y / 2)
				if value > 1 and value < 12 then
					h = value
				end
				if hum and hum.HipHeight > 0.2 then
					local exact = hum.HipHeight + r.Size.Y / 2
					if exact > 1 and exact < 12 then
						h = exact
					end
				end
			end
		end)
		return h + 0.05
	end
	local approachDir = nil
	pcall(function()
		local flat = Vector3.new(startRoot.Position.X - egg.X, 0, startRoot.Position.Z - egg.Z)
		if flat.Magnitude > 1 then
			approachDir = flat.Unit
		end
	end)
	local function landFor(at)
		local dir = approachDir or Vector3.new(-1, 0, 0)
		local stand = 2.5
		pcall(function()
			local part = eggPart()
			if part and part.CanCollide then
				stand = math.clamp(math.sqrt(part.Size.X ^ 2 + part.Size.Z ^ 2) / 2 + 2.2, 2.5, 7)
			end
		end)
		local base = Vector3.new(at.X + dir.X * stand, at.Y + 3, at.Z + dir.Z * stand)
		local hit = groundAt(base, at.Y + 6)
		if hit and math.abs(hit.Y - at.Y) < 12 then
			return Vector3.new(base.X, hit.Y + standHeight(), base.Z)
		end
		hit = groundAt(base, at.Y + 40)
		if hit and math.abs(hit.Y - at.Y) < 40 then
			return Vector3.new(base.X, hit.Y + standHeight(), base.Z)
		end
		return base
	end

	-- the biome has no usable exit by itself: wait for the game's automatic return, then look for an exit, then step back
	local function zoneRoots()
		local out = {}
		local base = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
		base = base and base:FindFirstChild("Build")
		for _, name in ipairs({ "FuseBiomeZone", "EnchantedTreeInterior" }) do
			local node = base and base:FindFirstChild(name)
			if node then
				out[#out + 1] = node
			end
		end
		return out
	end
	local function zoneExits()
		local list, all = {}, {}
		for _, zone in ipairs(zoneRoots()) do
			for _, d in ipairs(zone:GetDescendants()) do
				all[#all + 1] = d
			end
		end
		local good = { "exit", "leave", "return", "back", "home", "portal", "gate", "door", "out", "teleport", "warp", "spawn", "lobby", "world", "main" }
		local bad = { "fusion", "shrine", "pad", "place", "sell", "buy", "shop", "lion", "whale" }
		local function score(inst, extra)
			local label = string.lower(inst.Name .. " " .. (inst.Parent and inst.Parent.Name or "") .. " " .. (extra or ""))
			for _, w in ipairs(bad) do
				if string.find(label, w, 1, true) then
					return 0
				end
			end
			for _, w in ipairs(good) do
				if string.find(label, w, 1, true) then
					return 1
				end
			end
			return 0
		end
		pcall(function()
			for _, d in ipairs(all) do
				if d:IsA("ProximityPrompt") and score(d, d.ActionText .. " " .. d.ObjectText) > 0 then
					list[#list + 1] = d
				elseif d:IsA("BasePart") and d.Size.Magnitude < 250 and score(d) > 0 then
					list[#list + 1] = d
				end
				if #list >= 16 then
					break
				end
			end
		end)
		return list
	end
	local function leaveByExits()
		local list = zoneExits()
		local function posOf(c)
			if c:IsA("ProximityPrompt") then
				local part = c.Parent
				local reach = math.max(3, math.min(c.MaxActivationDistance - 1.5, 8))
				if part and part:IsA("BasePart") then
					return part.Position, reach
				end
				if part and part:IsA("Attachment") then
					return part.WorldPosition, reach
				end
				return nil, 0
			end
			return c.Position, 1.5
		end
		local tried = {}
		local deadline = os.clock() + 16
		while os.clock() < deadline and not state.Cancel do
			if not inBiome() then
				return true
			end
			local r0 = root()
			if not r0 then
				break
			end
			local best, bestD, bestReach, bestPos
			for _, c in ipairs(list) do
				if not tried[c] and c.Parent then
					local tp, rc = posOf(c)
					if tp then
						local d = (tp - r0.Position).Magnitude
						if semi.ExitPath and c:GetFullName() == semi.ExitPath then
							d = d - 1e6
						end
						if not bestD or d < bestD then
							best, bestD, bestReach, bestPos = c, d, rc, tp
						end
					end
				end
			end
			if not best then
				break
			end
			tried[best] = true
			slog("walking to " .. best.Name)
			bestD = math.max(bestD, 0)
			local speed = math.max(walkSpeed() * 1.1, walkSpeed() * 1.8, 22)
			local legEnd = os.clock() + math.min(bestD / speed + 1.5, 7)
			local lastJump = 0
			while os.clock() < legEnd and os.clock() < deadline and not state.Cancel do
				if not inBiome() then
					pcall(function()
						semi.ExitPath = best:GetFullName()
					end)
					slog("out through " .. best.Name)
					return true
				end
				local r = root()
				local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
				if not r or not hum then
					break
				end
				local flat = Vector3.new(bestPos.X - r.Position.X, 0, bestPos.Z - r.Position.Z)
				local dist = (r.Position - bestPos).Magnitude
				if best:IsA("ProximityPrompt") and dist <= bestReach + 1 then
					if typeof(fireproximityprompt) == "function" then
						pcall(fireproximityprompt, best)
					end
					local w = 0
					while w < 1.2 and inBiome() and not state.Cancel do
						w += RunService.Heartbeat:Wait()
					end
					break
				end
				pcall(function()
					hum:MoveTo(bestPos)
					if flat.Magnitude > 2 then
						local dir = flat.Unit
						r.AssemblyLinearVelocity = Vector3.new(dir.X * speed, r.AssemblyLinearVelocity.Y, dir.Z * speed)
					end
				end)
				if os.clock() - lastJump > 0.7 and (dist < 14 or (r.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude < 1) then
					lastJump = os.clock()
					jumpNow()
				end
				RunService.Heartbeat:Wait()
			end
		end
		return not inBiome()
	end
	local function walkOut()
		status("Semi TP: waiting for the return")
		local t0 = os.clock()
		while inBiome() and os.clock() - t0 < 5.5 and not state.Cancel do
			RunService.Heartbeat:Wait()
		end
		if not inBiome() then
			return true
		end
		leaveByExits()
		if not inBiome() then
			return true
		end
		local arrival = root() and root().Position or nil
		local backDirs = {}
		do
			local r = root()
			if r then
				local look = r.CFrame.LookVector
				local flat = Vector3.new(look.X, 0, look.Z)
				if flat.Magnitude > 0.1 then
					backDirs[#backDirs + 1] = -flat.Unit
					backDirs[#backDirs + 1] = flat.Unit
				end
			end
			backDirs[#backDirs + 1] = Vector3.new(-1, 0, 0)
		end
		local stepsDone = 0
		for _, dir in ipairs(backDirs) do
			for _ = 1, 2 do
				if not inBiome() or state.Cancel then
					break
				end
				local r = root()
				if r and arrival then
					local origin = r.Position
					local moveEnd = os.clock() + 0.45
					while inBiome() and os.clock() < moveEnd and not state.Cancel do
						pcall(function()
							r.AssemblyLinearVelocity = Vector3.new(dir.X * 110, 0, dir.Z * 110)
						end)
						RunService.Heartbeat:Wait()
						if (r.Position - origin).Magnitude >= 30 or r.Position.Y < arrival.Y - 6 then
							break
						end
					end
					pcall(function()
						r.AssemblyLinearVelocity = Vector3.zero
					end)
				end
				stepsDone += 1
				task.wait(0.15)
			end
			if not inBiome() then
				break
			end
			if arrival and root() then
				placeAt(arrival)
			end
		end
		slog("went back " .. stepsDone .. " times, inBiome=" .. tostring(inBiome()))
		local t1 = os.clock()
		while inBiome() and os.clock() - t1 < 8 and not state.Cancel do
			RunService.Heartbeat:Wait()
		end
		return not inBiome()
	end

	local function touchRoute()
		local zone = zoneRoots()[1]
		local portalPart = portalNode:FindFirstChildWhichIsA("BasePart") or portalNode:FindFirstChildWhichIsA("BasePart", true)
		local exitPart = zone and zone.Name == "FuseBiomeZone" and zone:FindFirstChild("ExitPart", true) or nil
		if not (portalPart and exitPart and exitPart:IsA("BasePart")) then
			slog("touch route: portal part=" .. tostring(portalPart ~= nil) .. " ExitPart=" .. tostring(exitPart ~= nil) .. ", the touch route cannot run")
			return false
		end
		local raceUntil = tonumber(workspace:GetAttribute("RaceRallyJoinEndsAt")) or 0
		local racePortal = raceUntil > workspace:GetServerTimeNow() and workspace:FindFirstChild("RaceRallyPortal", true) or nil
		local racePart = racePortal and (racePortal:IsA("BasePart") and racePortal or racePortal:FindFirstChild("Hitbox", true))
		if racePart and (racePart.Position - eggPos()).Magnitude < 100 then
			slog("touch route: the egg is next to the open race portal, the touch route cannot run")
			return false
		end
		local ping = 0.1
		pcall(function()
			ping = localPlayer:GetNetworkPing()
		end)
		ping = math.clamp(ping, 0, 1)
		local function touch(r, part)
			pcall(function()
				firetouchinterest(r, part, 0)
				firetouchinterest(r, part, 1)
			end)
		end
		local function carriedNow()
			return state.Carrying and state.Uid == uid
		end
		local r0 = root()
		if r0 and r0.Anchored then
			status("Semi TP: getting off the treadmill first")
			local askDoff = remote("RF/Treadmill/AskDoff")
			for _ = 1, 3 do
				if not r0.Anchored or state.Cancel then
					break
				end
				if askDoff and askDoff:IsA("RemoteFunction") then
					pcall(askDoff.InvokeServer, askDoff)
				end
				holdPause(0.5 + ping)
				r0 = root() or r0
			end
		end
		status("Semi TP: touch route, jumping to the egg")
		local at = landFor(eggPos())
		local heldSince
		local limit = os.clock() + 3
		while os.clock() < limit and not state.Cancel do
			local r = root()
			if not r then
				return false
			end
			if (r.Position - at).Magnitude > 15 then
				placeAt(at)
				heldSince = nil
			else
				heldSince = heldSince or os.clock()
				if os.clock() - heldSince > 0.15 then
					break
				end
			end
			RunService.Heartbeat:Wait()
		end
		holdPause(0.05)
		local transitioned = false
		local transLink
		pcall(function()
			local ev = remote("RE/FuseBiome/PortalTransition")
			if ev and ev:IsA("RemoteEvent") then
				transLink = ev.OnClientEvent:Connect(function()
					transitioned = true
				end)
			end
		end)
		local t0 = os.clock()
		local inZone = false
		status("Semi TP: touching the portal from the egg")
		while os.clock() - t0 < 4 and not state.Cancel do
			local r = root()
			if not r then
				break
			end
			if r.Position.Y > 10000 then
				inZone = true
				break
			end
			if not transitioned and (r.Position - at).Magnitude > 15 then
				placeAt(at)
			end
			touch(r, portalPart)
			holdPause(0.1)
		end
		if transLink then
			pcall(function()
				transLink:Disconnect()
			end)
		end
		if not inZone then
			slog("touch route: the portal did not take after 4 s")
			local back = root()
			if back then
				pcall(function()
					back.CFrame = startCF
					back.AssemblyLinearVelocity = Vector3.zero
					back.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			return false
		end
		slog(string.format("touch route: in the biome after %.2f s", os.clock() - t0))
		status("Semi TP: touching the exit of the biome")
		local exitStart = os.clock()
		local exited = false
		while os.clock() - exitStart < 8 and not state.Cancel do
			local r = root()
			if not r then
				return false
			end
			if r.Position.Y <= 10000 then
				exited = true
				break
			end
			touch(r, exitPart)
			holdPause(0.1)
		end
		if not exited then
			slog("touch route: no way out by touch, waiting for the game to bring us back")
			walkOut()
			exited = not inBiome()
		end
		if not exited then
			return false
		end
		slog(string.format("touch route: out of the biome after %.2f s", os.clock() - exitStart))
		holdPause(0.3 + math.min(1, ping * 5))
		local r = root()
		if not r then
			return false
		end
		local away = (r.Position - eggPos()).Magnitude
		if away > 60 then
			slog(string.format("touch route: the exit landed %.0f studs from the egg", away))
			return "far"
		end
		for _ = 1, 6 do
			if carriedNow() or state.Cancel then
				break
			end
			grab(uid, 0.4)
		end
		slog("touch route: on the egg, carrying=" .. tostring(carriedNow()))
		return carriedNow() and "near" or "far"
	end

	status("Semi TP: clown to the portal")
	local touchWon = nil
	if type(firetouchinterest) ~= "function" then
		slog("firetouchinterest is not available: the portal touch cannot run")
	end
	for tryNo = 1, 4 do
		if type(firetouchinterest) ~= "function" or state.Cancel then
			break
		end
		touchWon = touchRoute()
		if touchWon then
			break
		end
		slog("portal touch try " .. tryNo .. " did not work")
		task.wait(0.25)
	end
	slog(touchWon and ("portal touch: done " .. tostring(touchWon)) or "portal touch: NOT done")

	if not touchWon then
		releaseView()
		local r = root()
		if r then
			pcall(function()
				r.CFrame = startCF
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		task.wait(0.2)
		return false, "Semi TP: the portal touch did not work"
	end
	if touchWon == "near" then
		return true, { Arrived = true }
	end
	status("Semi TP: out of the portal, going to the egg at 110%")
	return true, { Ratio = 1.1 }
end

local worldResetTime, lastResetCheck = 0, 0
task.spawn(function()
	while alive do
		task.wait(1)
		if state.Busy then
			local now = os.clock()
			if now - lastResetCheck >= 1 then
				lastResetCheck = now
				local okClock, clock = pcall(function()
					return game:GetService("Lighting").ClockTime
				end)
				local wt = okClock and tonumber(clock) or 0
				if wt < 0.5 and worldResetTime > 0 and os.clock() - worldResetTime > 60 then
					worldResetTime = 0
					state.Cancel = true
					status("World reset detected")
				elseif wt >= 0.5 then
					worldResetTime = now
				end
			end
		end
	end
end)

local function stealAndDeliver(uid)
	if state.Busy then
		return
	end
	state.Busy = true
	state.Cancel = false
	worldResetTime, lastResetCheck = 0, 0
	task.spawn(function()
		local semiTrip = goMethod == "Semi TP"
		local delivered = false
		local failReason = nil
		local ok, err = pcall(function()
			status("Looking for the egg")
			local egg = eggPosition(uid)
			if not egg then
				status("That egg is gone")
				return
			end
			if state.Carrying and state.Uid ~= uid then
				dropEgg()
				local waited = 0
				while state.Carrying and waited < 1 do
					waited += RunService.Heartbeat:Wait()
				end
			end
			status("Going to the egg")
			local reached
			if semiTrip then
				local okSemi, info = semiGo(uid, egg)
				if not okSemi then
					failReason = info
					status("Could not reach the egg")
					return
				end
				semi.SlowRun = true
				local current = eggNow(uid, { At = 0, Pos = egg }) or egg
				if info.Arrived then
					reached = true
				elseif info.Decoy then
					reached = runToEgg(uid, current, { Field = true, Ratio = 1 })
				else
					reached = runToEgg(uid, current, { Field = true, Ratio = info.Ratio or 1.1, Height = 50 })
				end
			else
				reached = runToEgg(uid, egg)
			end
			if not reached then
				failReason = failReason or "could not reach the egg"
				status("Could not reach the egg")
				return
			end
			status("Taking the egg")
			if not grab(uid, 4) then
				failReason = "the egg would not come free"
				status("The egg would not come free")
				return
			end
			delivered = instantTP(uid)
			if not delivered then
				failReason = "delivery failed"
			end
			status(delivered and "Delivered" or "Delivery failed")
		end)
		fpsOff()
		dropClone()
		if state.ReleaseCamera then
			pcall(state.ReleaseCamera)
			state.ReleaseCamera = nil
		end
		semi.SlowRun = false
		semi.AtDrop = false
		if viewState then
			if state.Cancel and semi.Home then
				releaseBackHome(semi.Home)
			else
				releaseView()
			end
		end
		semi.Kind, semi.Home = nil, nil
		if semi.Rotate then
			local info = semi.Rotate
			semi.Rotate = nil
			pcall(function()
				info.Hum.AutoRotate = info.Old
			end)
		end
		if not ok then
			failReason = failReason or tostring(err)
			status("Error: " .. tostring(err))
		end
		slog("delivery " .. (delivered and "DONE" or "NOT done") .. ", " .. tostring(failReason or ""))

		-- Semi TP failed: the body goes back to the front by itself, and if that is not enough the player gets an instruction
		if semiTrip then
			if delivered then
				semi.Fails, semi.ResetDone = 0, false
			elseif not state.Cancel then
				semi.Fails += 1
				local untilAt = os.clock() + 1.5
				while os.clock() < untilAt and not state.Cancel do
					RunService.Heartbeat:Wait()
				end
				local why = tostring(failReason or "unknown")
				if string.find(why, "portal not there", 1, true) then
					status("Semi TP: no portal now. Set Go to Run")
				elseif not semi.ResetDone then
					semi.ResetDone = true
					status("Semi TP failed, going back to the front")
					returnFront()
				else
					status("Semi TP failed again. Press Steal again")
				end
			end
		end
		state.Busy = false
	end)
end

------------------------------------------------------------------ UI: S2rHub By Khay And Zen / Violet Obsidian
-- Presentation only. All egg selection, travel, teleport and delivery routines above are retained.
local THEME = {
    BG = Color3.fromRGB(10, 9, 19),
    PANEL = Color3.fromRGB(18, 16, 31),
    RAISED = Color3.fromRGB(25, 21, 43),
    ROW = Color3.fromRGB(22, 19, 37),
    HOVER = Color3.fromRGB(34, 26, 56),
    SELECTED = Color3.fromRGB(49, 29, 83),
    OUTLINE = Color3.fromRGB(69, 56, 105),
    PURPLE = Color3.fromRGB(151, 93, 255),
    GLOW = Color3.fromRGB(192, 154, 255),
    WHITE = Color3.fromRGB(250, 248, 255),
    MUTED = Color3.fromRGB(169, 160, 194),
    SOFT = Color3.fromRGB(120, 107, 151),
}
local RARITY_COLORS = {
    Color3.fromRGB(208, 201, 224), Color3.fromRGB(119, 222, 154), Color3.fromRGB(116, 175, 255),
    Color3.fromRGB(194, 135, 255), Color3.fromRGB(255, 190, 100), Color3.fromRGB(255, 124, 139),
    Color3.fromRGB(255, 131, 206), Color3.fromRGB(102, 232, 229),
}

local function parentGui()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and typeof(result) == "Instance" then
            return result
        end
    end
    return CoreGui
end

local function make(class, properties)
    local obj = Instance.new(class)
    for key, value in pairs(properties or {}) do
        obj[key] = value
    end
    return obj
end

local function corner(parent, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius or 9), Parent = parent })
end

local function outline(parent, color, thickness, transparency)
    return make("UIStroke", {
        Parent = parent, Color = color or THEME.OUTLINE, Thickness = thickness or 1,
        Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function txt(parent, properties)
    properties.BackgroundTransparency = 1
    properties.TextColor3 = properties.TextColor3 or THEME.WHITE
    properties.Parent = parent
    return make("TextLabel", properties)
end

local function button(parent, label, position, size, primary)
    local b = make("TextButton", {
        Parent = parent, Size = size, Position = position, Text = label,
        Font = Enum.Font.GothamBold, TextSize = primary and 13 or 11,
        TextColor3 = THEME.WHITE, BackgroundColor3 = primary and THEME.PURPLE or THEME.RAISED,
        BorderSizePixel = 0, AutoButtonColor = true,
    })
    corner(b, 10)
    outline(b, primary and THEME.GLOW or THEME.OUTLINE, 1, primary and 0.3 or 0.25)
    if primary then
        make("UIGradient", {
            Parent = b, Rotation = 12,
            Color = ColorSequence.new(THEME.PURPLE, Color3.fromRGB(105, 57, 208)),
        })
    end
    return b
end

local host = parentGui()
local env = globalEnv
-- Remove the previous window (also supports first-time migration from the original standalone GUI).
for _, name in ipairs({ "S2rHubByKhayAndZen", "ys" .. "lemEgg" }) do
    local previous = host:FindFirstChild(name)
    if previous then
        previous:Destroy()
    end
end

local gui = make("ScreenGui", {
    Name = "S2rHubByKhayAndZen", Parent = host,
    ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
})

local W, H, HEADER = 342, 472, 68
local window = make("Frame", {
    Parent = gui, Size = UDim2.fromOffset(W, H), AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = THEME.BG, BorderSizePixel = 0,
})
corner(window, 16)
outline(window, THEME.PURPLE, 1.5, 0.25)
local uiScale = make("UIScale", { Parent = window, Scale = 1 })

local viewportConnection = nil
local function fitScreen()
    local cam = workspace.CurrentCamera
    local view = cam and cam.ViewportSize or Vector2.new(800, 600)
    uiScale.Scale = math.clamp(math.min((view.X - 22) / W, (view.Y - 50) / H), 0.55, 1)
end
fitScreen()
if workspace.CurrentCamera then
    viewportConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScreen)
end

local header = make("Frame", {
    Parent = window, Size = UDim2.new(1, -2, 0, HEADER), Position = UDim2.fromOffset(1, 1),
    BackgroundColor3 = THEME.PANEL, BorderSizePixel = 0,
})
corner(header, 15)
make("UIGradient", { Parent = header, Rotation = 0, Color = ColorSequence.new(THEME.RAISED, THEME.PANEL) })

local emblem = make("Frame", {
    Parent = header, Size = UDim2.fromOffset(33, 33), Position = UDim2.fromOffset(13, 13),
    BackgroundColor3 = THEME.PURPLE, BorderSizePixel = 0,
})
corner(emblem, 9)
make("UIGradient", {
    Parent = emblem, Rotation = 45,
    Color = ColorSequence.new(THEME.GLOW, Color3.fromRGB(107, 59, 206)),
})
txt(emblem, {
    Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamBlack, TextSize = 13,
    Text = "S2", TextColor3 = THEME.WHITE, TextXAlignment = Enum.TextXAlignment.Center,
})
txt(header, {
    Size = UDim2.new(1, -133, 0, 19), Position = UDim2.fromOffset(55, 11),
    Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd, Text = "S2rHub By Khay And Zen",
})
txt(header, {
    Size = UDim2.new(1, -128, 0, 16), Position = UDim2.fromOffset(55, 32),
    Font = Enum.Font.GothamMedium, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    Text = "INSTANT TP  /  EGG FINDER", TextColor3 = THEME.MUTED,
})
make("Frame", {
    Parent = header, Position = UDim2.new(0, 12, 1, -4), Size = UDim2.new(1, -24, 0, 1),
    BackgroundColor3 = THEME.OUTLINE, BorderSizePixel = 0,
})

local function titleButton(glyph, rightOffset)
    local b = make("TextButton", {
        Parent = header, Size = UDim2.fromOffset(25, 25), Position = UDim2.new(1, rightOffset, 0, 16),
        BackgroundColor3 = THEME.ROW, BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, TextSize = 13, Text = glyph, TextColor3 = THEME.MUTED,
        AutoButtonColor = true,
    })
    corner(b, 7)
    outline(b, THEME.OUTLINE, 1, 0.5)
    return b
end
local minimize = titleButton("−", -63)
local close = titleButton("×", -33)

local body = make("Frame", {
    Parent = window, Size = UDim2.new(1, -24, 1, -(HEADER + 16)),
    Position = UDim2.fromOffset(12, HEADER + 6), BackgroundTransparency = 1,
})
txt(body, {
    Size = UDim2.fromOffset(180, 24), Position = UDim2.fromOffset(2, 0),
    Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    Text = "AVAILABLE EGGS", TextColor3 = THEME.GLOW,
})
local countLabel = txt(body, {
    Size = UDim2.new(0, 100, 0, 24), Position = UDim2.new(1, -101, 0, 0),
    Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
    Text = "0 FOUND", TextColor3 = THEME.MUTED,
})

local list = make("ScrollingFrame", {
    Parent = body, Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 1, -172),
    BackgroundColor3 = THEME.PANEL, BorderSizePixel = 0,
    ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 3,
    ScrollBarImageColor3 = THEME.PURPLE, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
corner(list, 12)
outline(list, THEME.OUTLINE, 1, 0.45)
make("UIListLayout", {
    Parent = list, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder,
})
make("UIPadding", {
    Parent = list, PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7),
    PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 10),
})

local statusPanel = make("Frame", {
    Parent = body, Position = UDim2.new(0, 0, 1, -136), Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = THEME.PANEL, BorderSizePixel = 0,
})
corner(statusPanel, 9)
outline(statusPanel, THEME.OUTLINE, 1, 0.7)
local dot = make("Frame", {
    Parent = statusPanel, Size = UDim2.fromOffset(7, 7), Position = UDim2.fromOffset(12, 13),
    BackgroundColor3 = THEME.PURPLE, BorderSizePixel = 0,
})
corner(dot, 7)
local statusLabel = txt(statusPanel, {
    Size = UDim2.new(1, -34, 1, -4), Position = UDim2.fromOffset(27, 2),
    Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = THEME.MUTED,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true, Text = "Pick a pet",
})

local PUBLIC = {
    ["Pick a pet"] = true, ["Looking for the egg"] = true, ["Going to the egg"] = true,
    ["Taking the egg"] = true, ["Delivered"] = true, ["Delivery failed"] = true,
    ["That egg is gone"] = true, ["Could not reach the egg"] = true,
    ["The egg would not come free"] = true, ["Cancelling"] = true,
    ["Going back to the front"] = true, ["World reset detected"] = true,
    ["Semi TP failed, going back to the front"] = true,
    ["Semi TP failed again. Press Steal again"] = true,
    ["Semi TP: no portal now. Set Go to Run"] = true,
}
status = function(message)
    if not gui.Parent then return end
    message = tostring(message)
    if PUBLIC[message] or string.sub(message, 1, 9) == "Selected:" then
        statusLabel.Text = message
    elseif string.sub(message, 1, 5) == "Error" then
        statusLabel.Text = "Something went wrong"
    elseif state.Busy then
        statusLabel.Text = "Delivering"
    end
end

local goButton = button(body, "GO MODE  :  SEMI TP", UDim2.new(0, 0, 1, -92), UDim2.new(1, 0, 0, 34), false)
local refreshButton = button(body, "REFRESH", UDim2.new(0, 0, 1, -48), UDim2.new(0.37, -4, 0, 45), false)
local stealButton = button(body, "STEAL EGG", UDim2.new(0.37, 4, 1, -48), UDim2.new(0.63, -4, 0, 45), true)

goButton.MouseButton1Click:Connect(function()
    if state.Busy then return end
    goMethod = goMethod == "Semi TP" and "Run" or "Semi TP"
    goButton.Text = goMethod == "Semi TP" and "GO MODE  :  SEMI TP" or "GO MODE  :  RUN"
end)

local selectedUid = nil
local rows = {}
local function setSelected(uid)
    selectedUid = uid
    for rowUid, row in pairs(rows) do
        local selected = rowUid == uid
        row.Frame.BackgroundColor3 = selected and THEME.SELECTED or THEME.ROW
        row.Stroke.Color = selected and THEME.PURPLE or THEME.OUTLINE
        row.Stroke.Transparency = selected and 0 or 0.6
        row.Stroke.Thickness = selected and 1.5 or 1
        row.Accent.Visible = selected
    end
end

local function rebuild()
    if not gui.Parent then return end
    for _, row in pairs(rows) do
        row.Frame:Destroy()
    end
    table.clear(rows)

    local infos = {}
    for _, record in ipairs(snapshot()) do
        infos[#infos + 1] = describe(record)
    end
    table.sort(infos, function(a, b)
        return a.Value > b.Value
    end)
    countLabel.Text = string.format("%d FOUND", #infos)

    local stillSelected = false
    for index, info in ipairs(infos) do
        if info.Uid == selectedUid then stillSelected = true end
        local frame = make("TextButton", {
            Parent = list, LayoutOrder = index, Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = THEME.ROW, BorderSizePixel = 0, Text = "", AutoButtonColor = true,
        })
        corner(frame, 9)
        local rowStroke = outline(frame, THEME.OUTLINE, 1, 0.6)
        local accent = make("Frame", {
            Parent = frame, Visible = false, Position = UDim2.fromOffset(0, 10),
            Size = UDim2.fromOffset(3, 26), BackgroundColor3 = THEME.PURPLE, BorderSizePixel = 0,
        })
        corner(accent, 2)
        make("ImageLabel", {
            Parent = frame, Size = UDim2.fromOffset(31, 31), Position = UDim2.fromOffset(9, 7),
            BackgroundTransparency = 1, Image = info.Icon or "", ScaleType = Enum.ScaleType.Fit,
        })
        txt(frame, {
            Size = UDim2.new(1, -53, 0, 19), Position = UDim2.fromOffset(49, 5),
            Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            Text = info.Name,
            TextColor3 = RARITY_COLORS[math.clamp(info.Rarity, 1, #RARITY_COLORS)] or THEME.WHITE,
        })
        txt(frame, {
            Size = UDim2.new(1, -53, 0, 16), Position = UDim2.fromOffset(49, 25),
            Font = Enum.Font.GothamMedium, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left, Text = money(info.Value),
            TextColor3 = THEME.MUTED,
        })
        rows[info.Uid] = { Frame = frame, Stroke = rowStroke, Accent = accent }
        frame.MouseButton1Click:Connect(function()
            setSelected(info.Uid)
            status("Selected: " .. info.Name)
        end)
        frame.MouseEnter:Connect(function()
            if selectedUid ~= info.Uid then
                frame.BackgroundColor3 = THEME.HOVER
            end
        end)
        frame.MouseLeave:Connect(function()
            if selectedUid ~= info.Uid then
                frame.BackgroundColor3 = THEME.ROW
            end
        end)
    end

    setSelected(stillSelected and selectedUid or nil)
    if #infos == 0 then status("Pick a pet") end
end

refreshButton.MouseButton1Click:Connect(function()
    if not state.Busy then rebuild() end
end)
stealButton.MouseButton1Click:Connect(function()
    if state.Busy then
        state.Cancel = true
        status("Cancelling")
        return
    end
    if not selectedUid then
        status("Pick a pet")
        return
    end
    stealAndDeliver(selectedUid)
end)

task.spawn(function()
    local wasBusy = nil
    while alive and gui.Parent do
        if wasBusy ~= state.Busy then
            wasBusy = state.Busy
            stealButton.Text = state.Busy and "CANCEL" or "STEAL EGG"
        end
        task.wait(0.2)
    end
end)

-- Header drag works with either touch or mouse; the action buttons stay clickable.
local dragConnection = nil
do
    local dragging, startPos, startInput = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Position.X > header.AbsolutePosition.X + header.AbsoluteSize.X - 75 * uiScale.Scale then
                return
            end
            dragging, startPos, startInput = true, window.Position, input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragConnection = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    minimize.Text = minimized and "+" or "−"
    window.Size = minimized and UDim2.fromOffset(W, HEADER + 4) or UDim2.fromOffset(W, H)
end)

local didShutdown = false
local function shutdown()
    if didShutdown then return end
    didShutdown = true
    state.Cancel = true
    alive = false
    fpsOff()
    dropClone()
    if state.ReleaseCamera then
        pcall(state.ReleaseCamera)
        state.ReleaseCamera = nil
    end
    releaseView()
    shieldStop()
    if viewportConnection then viewportConnection:Disconnect() end
    if dragConnection then dragConnection:Disconnect() end
    if env then
        if env.S2rHubUnload == shutdown then env.S2rHubUnload = nil end
        env.S2rHubSemiReport = nil
    end
    if gui.Parent then gui:Destroy() end
end
if env then env.S2rHubUnload = shutdown end
close.MouseButton1Click:Connect(shutdown)
gui.AncestryChanged:Connect(function(_, newParent)
    if not newParent then shutdown() end
end)

rebuild()
task.spawn(function()
    while alive and gui.Parent do
        task.wait(4)
        if not state.Busy and body.Visible then rebuild() end
    end
end)

shieldStart()
