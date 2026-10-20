local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)
		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end
	return function()
		local r = table.pack(f(s, c))
		if r[1] == nil then
			return false
		end
		c = r[1]
		return true, table.unpack(r, 1, r.n)
	end
end
local CFrame_ = CFrame
local cFrameNew = CFrame_ and CFrame_.new
local lookAt = CFrame_ and CFrame_.lookAt
local Angles = CFrame_ and CFrame_.Angles
local fromMatrix = CFrame_ and CFrame_.fromMatrix
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local v14, genv, v16, __S2rHubTweenRuntimeGeneration, t1, v19, v20, v21, v22, v23
local v24, v25, v26, v27, v28, v29, v30, v31, v32, v33
do
	local Workspace = game:GetService("Workspace")
	v14 = function()
		return Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
	end
	genv = getgenv and getgenv() or _G
	if type(genv.__S2rHubShutdown) == "function" then
		pcall(genv.__S2rHubShutdown)
	end
	local t2 = {}
	genv.__S2rHubSession = t2
	v16 = function()
		return genv.__S2rHubSession == t2
	end
	genv.__S2rHubIdentityGetter = genv.getthreadidentity or genv.get_thread_identity or genv.getidentity or genv.getthreadcontext or genv.get_thread_context
	genv.__S2rHubIdentitySetter = genv.setthreadidentity or genv.set_thread_identity or genv.setidentity or genv.setthreadcontext or genv.set_thread_context
	local __S2rHubIdentitySetter = genv.__S2rHubIdentitySetter
	if type(__S2rHubIdentitySetter) == "function" then
		pcall(__S2rHubIdentitySetter, 8)
		genv.__S2rHubUICapabilityIdentity = 8
	end
	if not (rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap")) and type(setfpscap) == "function" then
	end
	genv.__S2rHubSetCapFps = function(p1)
		local v37 = math.clamp(math.floor(tonumber(p1) or 240), 1, 999)
		local setfpscap_ = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or type(setfpscap) == "function" and setfpscap
		if type(setfpscap_) == "function" then
			return pcall(setfpscap_, v37)
		end
		return false
	end
	if type(genv.__S2rHubTweenRuntimeCleanup) == "function" then
		pcall(genv.__S2rHubTweenRuntimeCleanup)
	end
	if type(genv.__S2rHubEggRuntimeCleanup) == "function" then
		pcall(genv.__S2rHubEggRuntimeCleanup)
	end
	if type(genv.__S2rHubAntiGuardCleanup) == "function" then
		pcall(genv.__S2rHubAntiGuardCleanup)
	end
	genv.__S2rHubTweenRuntimeGeneration = (genv.__S2rHubTweenRuntimeGeneration or 0) + 1
	__S2rHubTweenRuntimeGeneration = genv.__S2rHubTweenRuntimeGeneration
	t1 = {
		KEY = "__S2rHubStealAnEggMovementSpoof",
		VERSION = 436,
		INTEGRITY_KEY = "__S2rHubStealAnEggIntegritySpoof",
		SIGNAL = "ClientCharacter: GetDebugSnapshot",
		HEADROOM = 1.35,
		CLAMP = 0.15,
		PADDING = 24,
		MULTIPLIER = 10,
		MIN_INPUT = 20,
		MAX_INPUT = 100,
		DEF_INPUT = 60,
		MIN_SPEED = 200,
		MAX_SPEED = 1000,
		DEF_SPEED = 600,
		FIELDS = {
			"LastObservedSample",
			"LastSample",
			"LastGoodSample",
			"LastGameplayTrustedSample",
			"LastValidatedSample",
			"LastValidatedGroundedSample",
			"LastConfirmedGroundSample",
			"CandidateGroundedSample"
		}
	}
	local KEY = t1.KEY
	local VERSION = t1.VERSION
	local INTEGRITY_KEY = t1.INTEGRITY_KEY
	local SIGNAL = t1.SIGNAL
	local HEADROOM = t1.HEADROOM
	local CLAMP = t1.CLAMP
	local PADDING = t1.PADDING
	local MIN_SPEED = t1.MIN_SPEED
	local MAX_SPEED = t1.MAX_SPEED
	local DEF_SPEED = t1.DEF_SPEED
	local FIELDS = t1.FIELDS
	local n1 = 60
	game:GetService("RunService").Heartbeat:Connect(function(dt)
		if dt and dt > 0 then
			n1 = n1 * 0.9 + 1 / dt * 0.1
		end
	end)
	v19 = function()
		return n1
	end
	local u51
	local v52 = tostring(math.random(100000, 999999))
	local connection
	local connection2
	local t3 = {}
	local u56
	v20 = nil
	local function v57()
		for _, child in ipairs(Workspace:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "__S2rHubHoverPad" and child ~= u51 then
				pcall(child.Destroy, child)
			end
		end
	end
	v21 = function(p2)
		if not u51 or not u51.Parent then
			return false
		end
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if not HumanoidRootPart or not Humanoid then
			return false
		end
		local v63 = typeof(p2) == "Vector3" and p2
		v63 = v63 or HumanoidRootPart.Position
		u51.CFrame = cFrameNew(v63.X, v63.Y - (Humanoid.RigType == Enum.HumanoidRigType.R15 and HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5) or HumanoidRootPart.Size.Y * 0.5 + 2) - 0.5 - 0.05, v63.Z)
		return true
	end
	v22 = function()
		if not u51 or not u51.Parent or u51:GetAttribute("S2rHubRuntimeOwner") ~= v52 then
			v57()
			if u51 and u51.Parent then
				pcall(u51.Destroy, u51)
			end
			local Part = Instance.new("Part")
			Part.Name = "__S2rHubHoverPad"
			Part:SetAttribute("S2rHubRuntimeOwner", v52)
			Part.Anchored = true
			Part.CanCollide = true
			Part.CanQuery = true
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Transparency = 1
			Part.Material = Enum.Material.SmoothPlastic
			Part.Size = Vector3.new(8, 1, 8)
			u51 = Part
			Part.Parent = Workspace
		end
		v21()
		if not connection then
			local function v65()
				if not v21() then
					v22()
				end
			end
			connection = RunService.PreSimulation:Connect(v65)
		end
		if not connection2 then
			connection2 = RunService.PostSimulation:Connect(function()
				v21()
			end)
		end
	end
	v23 = function()
		if connection then
			pcall(connection.Disconnect, connection)
			connection = nil
		end
		if connection2 then
			pcall(connection2.Disconnect, connection2)
			connection2 = nil
		end
		if u51 then
			pcall(u51.Destroy, u51)
			u51 = nil
		end
		v57()
	end
	v23()
	v24 = function()
		u56 = nil
	end
	v25 = function(p3, p4)
		if p3 and typeof(p4) == "CFrame" then
			u56 = {
				Character = LocalPlayer.Character,
				RootPart = p3,
				CFrame = p4
			}
		end
	end
	local function v66()
		local v67 = u56
		if type(v67) == "table" then
			if typeof(v67.CFrame) == "CFrame" then
				if LocalPlayer.Character == v67.Character then
					if v67.RootPart and v67.RootPart.Parent then
						v22()
						v67.RootPart.AssemblyLinearVelocity = Vector3.zero
						v67.RootPart.AssemblyAngularVelocity = Vector3.zero
						v21(v67.CFrame.Position)
						v67.RootPart.CFrame = v67.CFrame
						v21(v67.CFrame.Position)
						return true
					end
				end
				u56 = nil
				return false
			end
		end
		return false
	end
	local function v68()
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character
		HumanoidRootPart = HumanoidRootPart and Character:FindFirstChild("HumanoidRootPart")
		for _, v in pairs(t3) do
			if type(v) == "table" then
				v.cancelled = true
			end
		end
		table.clear(t3)
		if HumanoidRootPart then
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end
		v24()
		v23()
	end
	genv.__S2rHubTweenRuntimeCleanup = function()
		for _, v in pairs(t3) do
			if type(v) == "table" then
				v.cancelled = true
			end
		end
		table.clear(t3)
		v24()
		v23()
	end
	v26 = function()
		return getgenv and getgenv() or _G
	end
	local function v75()
		local v76 = v26()
		local v77 = v76[KEY]
		if type(v77) ~= "table" or v77.Version ~= VERSION then
			if type(v77) == "table" then
				v77.Enabled = false
			end
			v77 = {
				Version = VERSION,
				Installed = false,
				Enabled = false,
				Mode = "StateBaseline",
				Humanoid = nil,
				RootPart = nil,
				WalkSpeed = DEF_SPEED
			}
			v76[KEY] = v77
		end
		return v77
	end
	v27 = function(p5, p6)
		local v78 = v75()
		if not v78 then
			return false
		end
		local Humanoid = p5 and p5:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = p5 and p5:FindFirstChild("HumanoidRootPart")
		v78.Humanoid = Humanoid
		v78.RootPart = HumanoidRootPart
		v78.WalkSpeed = math.clamp(tonumber(p6) or DEF_SPEED, MIN_SPEED, MAX_SPEED * HEADROOM)
		v78.Enabled = false
		return Humanoid ~= nil and HumanoidRootPart ~= nil
	end
	local function v81()
		local v82 = v26()[KEY]
		if type(v82) == "table" then
			v82.Enabled = false
			v82.Humanoid = nil
			v82.RootPart = nil
		end
	end
	local function v83(p7, p8, p9)
		local u84
		if type(getcallbackvalue) == "function" and type(debug) == "table" and type(debug.getupvalue) == "function" then
			local Signal = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Signal")
			if Signal then
				local ok, result = pcall(require, Signal)
				if ok and type(result) == "table" and type(result.Invoked) == "function" then
					local ok2, result2 = pcall(result.Invoked, SIGNAL)
					if ok2 and result2 then
						local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")
						if ok3 and type(result3) == "function" then
							local ok4, result4 = pcall(debug.getinfo, result3)
							if ok4 then
								local function v94(p10, p11, p12)
									if u84 or type(p10) ~= "table" or p11 > 3 or p12[p10] then
										return
									end
									p12[p10] = true
									if rawget(p10, "Player") == p7 and rawget(p10, "Character") == p7.Character then
										if rawget(p10, "Humanoid") == p8 and rawget(p10, "RootPart") == p9 and type(rawget(p10, "SampleHistory")) == "table" and type(rawget(p10, "Evidence")) == "table" then
											u84 = p10
											return
										end
									end
									local n2 = 0
									for _, v in pairs(p10) do
										n2 += 1
										if n2 > 128 then
											break
										end
										if type(v) == "table" then
											v94(v, p11 + 1, p12)
										end
									end
								end
								local n3 = 1
								local nups = result4.nups or 0
								for i = n3, nups do
									local ok5, result5 = pcall(debug.getupvalue, result3, i)
									if not ok5 or type(result5) ~= "table" then
										continue
									end
									v94(result5, 0, {})
									if u84 then
										break
									end
								end
							end
						end
					end
				end
			end
		end
		if not u84 and type(getgc) == "function" then
			local ok, result = pcall(getgc, true)
			if ok and type(result) == "table" then
				for _, v in ipairs(result) do
					if type(v) == "table" and rawget(v, "Player") == p7 and rawget(v, "Character") == p7.Character and rawget(v, "Humanoid") == p8 and rawget(v, "RootPart") == p9 and type(rawget(v, "SampleHistory")) == "table" and type(rawget(v, "Evidence")) == "table" then
						u84 = v
						break
					end
				end
			end
		end
		return u84
	end
	local t4 = {
		busy = false,
		nextAt = 0,
		misses = 0,
		found = nil
	}
	local function v108(p13, p14, p15)
		local found = t4.found
		if type(found) == "table" and rawget(found, "Player") == p13 then
			if rawget(found, "Character") == p13.Character and rawget(found, "Humanoid") == p14 and rawget(found, "RootPart") == p15 then
				return found
			end
		end
		if t4.busy or os.clock() < t4.nextAt then
			return nil
		end
		t4.busy = true
		task.spawn(function()
			task.wait()
			local ok, result = pcall(v83, p13, p14, p15)
			local v112 = ok and result or nil
			t4.found = v112
			t4.misses = v112 and 0 or t4.misses + 1
			t4.nextAt = os.clock() + (v112 and 0.2 or t4.misses >= 5 and 10 or 1)
			t4.busy = false
		end)
		return nil
	end
	v28 = function(p16, p17, p18)
		if type(p16) ~= "table" then
			return false
		end
		local value = rawget(p16, "RootPart")
		local CFrame_2 = value and value.Parent and value.CFrame or nil
		local Position = CFrame_2 and CFrame_2.Position or nil
		local vector3 = typeof(p18) == "Vector3" and p18 or Vector3.zero
		local function v117(p19)
			if type(p19) == "table" then
				rawset(p19, "WalkSpeed", p17)
				if CFrame_2 then
					rawset(p19, "CFrame", CFrame_2)
					rawset(p19, "Position", Position)
					rawset(p19, "LinearVelocity", vector3)
					rawset(p19, "AngularVelocity", Vector3.zero)
				end
			end
		end
		for _, v in ipairs(FIELDS) do
			v117(rawget(p16, v))
		end
		local pairs_ = pairs
		local v121 = rawget(p16, "SampleHistory") or {}
		for _, v in pairs_(v121) do
			v117(v)
		end
		local pairs_2 = pairs
		local v125 = rawget(p16, "SafeGroundCheckpoints") or {}
		for _, v in pairs_2(v125) do
			v117(v)
		end
		local value2 = rawget(p16, "Evidence")
		if type(value2) == "table" then
			value2.Speed = 0
			value2.Teleport = 0
			value2.Flight = 0
		end
		local value3 = rawget(p16, "ImpulseContext")
		if type(value3) == "table" then
			local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, p17)
			local v131 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), CLAMP)
			value3.MaxHorizontalSpeed = maxHorizontalSpeed
			if Position then
				value3.OriginPosition = Position
			end
			value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * v131 + PADDING * 2)
			v117(value3.PreMovementSafeSample)
		end
		if rawget(p16, "CorrectionContext") == nil then
			rawset(p16, "FirstSuspiciousAt", nil)
			if rawget(p16, "ThreatLevel") == "Observing" then
				rawset(p16, "ThreatLevel", "Trusted")
			end
		end
		return true
	end
	local function v132()
		local v133 = v26()
		local v134 = v133[INTEGRITY_KEY]
		if type(v134) ~= "table" then
			v134 = {}
			v133[INTEGRITY_KEY] = v134
		end
		return v134
	end
	v29 = function(p20, p21, p22)
		return type(p20) == "table" and rawget(p20, "Player") == LocalPlayer and rawget(p20, "Character") == LocalPlayer.Character and rawget(p20, "Humanoid") == p21 and rawget(p20, "RootPart") == p22
	end
	v30 = function(p23, p24, p25)
		return v29(p23, p24, p25)
	end
	v31 = function(p26, p27, p28)
		local v135 = v132()
		local State = v135.State
		if not v29(State, p26, p27) then
			local now = os.clock()
			if now < (v135.NextSearchAt or 0) then
				return false
			end
			v135.NextSearchAt = now + 0.2
			State = v108(LocalPlayer, p26, p27)
		end
		if not State then
			return false
		end
		if not v30(State, p26, p27) then
			v135.Enabled = false
			v135.Humanoid = p26
			v135.RootPart = p27
			v135.State = State
			return false
		end
		v135.NextSearchAt = 0
		v135.Enabled = true
		v135.Humanoid = p26
		v135.RootPart = p27
		v135.State = State
		v135.WalkSpeed = math.clamp(p28 * HEADROOM, MIN_SPEED, MAX_SPEED * HEADROOM)
		v135.TravelVelocity = Vector3.zero
		v28(State, v135.WalkSpeed, v135.TravelVelocity)
		return true
	end
	v32 = function(p29, p30, p31, p32)
		local v138 = v26()[INTEGRITY_KEY]
		if type(v138) == "table" and v138.Enabled and v138.Humanoid == p29 and v138.RootPart == p30 then
			if v30(v138.State, p29, p30) then
				v138.WalkSpeed = math.clamp(p31 * HEADROOM, MIN_SPEED, MAX_SPEED * HEADROOM)
				if typeof(p32) == "Vector3" then
					v138.TravelVelocity = p32
				elseif typeof(v138.TravelVelocity) ~= "Vector3" then
					v138.TravelVelocity = Vector3.zero
				end
				return v28(v138.State, v138.WalkSpeed, v138.TravelVelocity)
			end
		end
		return false
	end
	local function v139(p33)
		local v140 = v26()[INTEGRITY_KEY]
		if type(v140) ~= "table" then
			return
		end
		if p33 == nil or v140.Humanoid == p33 then
			v140.Enabled = false
			v140.Humanoid = nil
			v140.RootPart = nil
			v140.State = nil
			v140.TravelVelocity = nil
			v140.NextSearchAt = 0
		end
	end
	local connection3
	v33 = function()
		if connection3 then
			return
		end
		connection3 = RunService.PreSimulation:Connect(function()
			if genv.__S2rHubTweenRuntimeGeneration ~= __S2rHubTweenRuntimeGeneration then
				local v142 = connection3
				connection3 = nil
				if v142 then
					pcall(v142.Disconnect, v142)
				end
				return
			end
			local Character = LocalPlayer.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not Character or not HumanoidRootPart or not Humanoid then
				return
			end
			local v146 = v20()
			v27(Character, v146 * HEADROOM)
			if not v32(Humanoid, HumanoidRootPart, v146) then
				v31(Humanoid, HumanoidRootPart, v146)
			end
			v66()
		end)
	end
	local function v147()
		if connection3 then
			pcall(connection3.Disconnect, connection3)
			connection3 = nil
		end
		v81()
		v139()
	end
	genv.__S2rHubTweenRuntimeCleanup = function()
		v68()
		v147()
	end
end
RunService.Heartbeat:Connect(function()
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end
	local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
	if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 400 or math.abs(AssemblyLinearVelocity.Y) > 400 then
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(math.clamp(AssemblyLinearVelocity.X, -100, 100), math.clamp(AssemblyLinearVelocity.Y, -100, 100), math.clamp(AssemblyLinearVelocity.Z, -100, 100))
	end
end)
pcall(function()
	local queue_on_teleport_ = queue_on_teleport or queueonteleport
	queue_on_teleport_ = queue_on_teleport_ or syn and syn.queue_on_teleport
	if queue_on_teleport_ then
		pcall(queue_on_teleport_, "")
	end
end)
do
	pcall(function()
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	end)
end
do
	local connection
	local connection2
	local function v154(p34)
		if not p34 then
			return
		end
		local Humanoid = p34:WaitForChild("Humanoid", 5) or p34:FindFirstChildOfClass("Humanoid")
		if not p34:WaitForChild("HumanoidRootPart", 5) then
			p34:FindFirstChild("HumanoidRootPart")
		end
		if not Humanoid then
			return
		end
		local health = math.max(Humanoid.MaxHealth, 100)
		local u157 = false
		local n4 = 0
		local function v159()
			if u157 or not Humanoid.Parent then
				return
			end
			local now = os.clock()
			if now - n4 < 0.1 then
				if Humanoid.Health > 0 then
					if Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
						return
					end
				end
			end
			n4 = now
			u157 = true
			pcall(function()
				Humanoid.BreakJointsOnDeath = false
				Humanoid.RequiresNeck = false
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				if Humanoid.Health <= 0 then
					Humanoid.Health = health
				end
				if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			u157 = false
		end
		v159()
		if connection then
			pcall(connection.Disconnect, connection)
		end
		if connection2 then
			pcall(connection2.Disconnect, connection2)
		end
		connection = Humanoid.HealthChanged:Connect(function(health2)
			if health2 <= 0 or health2 < health then
				v159()
			end
		end)
		connection2 = RunService.Heartbeat:Connect(v159)
	end
	task.spawn(function()
		v154(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
	end)
	LocalPlayer.CharacterAdded:Connect(function(character)
		v154(character)
	end)
end
local s2rHubConfig = {
	AutoSteal = false,
	HelpFriend = false,
	ScrambleTradeInTrade = false,
	ScrambleTradeInReroll = false,
	ScrambleTradeInBanners = {},
	ScrambleBossAuto = false,
	StealMode = "Fly",
	FlyAerial = false,
	StealHoldSeconds = 5,
	StealAreas = { "None" },
	StealRarities = { "None" },
	StealNamesFilter = { "None" },
	StealMinValue = 0,
	StealMutations = { "None" },
	StealMinWeight = 0,
	StealPriority = "Rarity",
	AutoFavorite = false,
	FavMode = "Rarity",
	FavRarities = { "None" },
	FavSpecies = { "None" },
	AutoEquipBest = false,
	AutoClaimOffline = false,
	AutoBaseUpgrade = false,
	AutoClaimAlmanac = false,
	AutoFusePets = false,
	ScrambleFarmDrones = false,
	ScrambleLostParts = false,
	ScrambleCollectSamples = false,
	ScrambleAutoVault = false,
	ScrambleAutoBuy = false,
	ScrambleAreas = {},
	ScrambleDroneTypes = {},
	ScrambleBuyList = {},
	ButterflyAutoNet = false,
	ButterflyAutoCatch = false,
	ButterflyEsp = false,
	ButterflyTiers = {},
	ButterflyAutoTrade = false,
	ButterflyTradeRecipe = "All",
	ButterflyCatchMode = "Tween",
	ButterflyAutoCraft = false,
	Noclip = false,
	BottingMode = false,
	AntiCutscene = false,
	FuseSelectedOnly = false,
	FuseRarities = { "None" },
	FuseSpecies = { "None" },
	EspDetails = {
		"Name",
		"Rarity",
		"Value"
	},
	BackpackRateEsp = false,
	AntiAFK = true,
	AutoReconnect = true,
	AutoExecute = false,
	AutoPlace = false,
	PlaceRarities = { "None" },
	AutoHatch = false,
	SellAll = false,
	AutoSell = false,
	SellNames = { "None" },
	SellRarities = { "None" },
	AutoSellEgg = false,
	SellEggRarities = { "None" },
	WebhookEnabled = false,
	WebhookURL = "",
	TweenSpeedMultiplier = 60,
	AutoTreadmillIdle = false,
	AutoTreadmillUpgrade = false,
	AntiTreadmill = false,
	HopNoMatch = false,
	PrivateServerMax = "2",
	PrivateServerAuto = false,
	HopCooldown = 5,
	AutoIndex = false,
	AntiHitGuard = false,
	FlyForCapture = false,
	AutoStealCapture = false,
	InstantGrab = false,
	InfiniteJump = false,
	WalkSpeedMultiplier = 1,
	AntiGuardKnockback = true,
	GodMode = true,
	EggPredictUI = false,
	EggESP = false,
	StealPlayers = false,
	StealPlayerRarities = { "None" },
	StealPlayerMinValue = 0,
	StealPlayerTarget = "Any Player",
	WebhookRarities = { "None" },
	WebhookMinValue = 0
}
local EggState = require(game:GetService("ReplicatedStorage").Client.EggState)
EggState.GetAreaEggSnapshot = EggState.ReadFieldEggs
EggState.GetAreaEggRecord = EggState.ReadFieldEgg
EggState.RequestAreaEggSnapshot = EggState.SyncFieldEggs
EggState.RequestCarryAreaEgg = EggState.CarryFieldEgg
EggState.RequestDropHeldAreaEgg = EggState.DropFieldEgg
EggState.AreaEggCarryStateChanged = EggState.CarryChanged
EggState.AreaEggClaimed = EggState.FieldClaimed
EggState.AreaEggUpdated = EggState.FieldShifted
EggState.AreaEggRemoved = EggState.FieldGone
EggState.GetOwnerRuntimeRecords = EggState.ReadOwnerEggs
EggState.RequestEquipTool = EggState.WearEggTool
EggState.RequestPlaceEgg = EggState.PlantEgg
EggState.RequestHatchEgg = EggState.BeginHatch
EggState.RequestCompleteHatchEgg = EggState.FinishHatch
EggState.RequestRuntimeSnapshot = EggState.SyncOwnedEggs
EggState.RuntimeOwnerUpdated = EggState.OwnerRefreshed
EggState.RuntimeOwnerCleared = EggState.OwnerCleared
local PlotState = require(game:GetService("ReplicatedStorage").Client.PlotState)
PlotState.GetMySlot = PlotState.ResolveLocalSlot
PlotState.GetPlotsFolder = PlotState.ResolveFolder
PlotState.IsWorldPositionWithinLocalPlotBounds = PlotState.ContainsLocalPoint
PlotState.GetPlotData = PlotState.ResolvePlot
local AreaEggResetWall = require(game:GetService("ReplicatedStorage").Client.AreaEggResetWall)
AreaEggResetWall.IsClosed = AreaEggResetWall.IsSealed
v20 = function()
	if genv.__S2rHubAdminBoost == true then
		return 4000
	end
	return math.clamp(math.floor((tonumber(s2rHubConfig.TweenSpeedMultiplier) or t1.DEF_INPUT) + 0.5), t1.MIN_INPUT, t1.MAX_INPUT) * t1.MULTIPLIER
end
s2rHubConfig.applyStealValueInput = function(p35, p36)
	local lower = string.lower
	local tostring_ = tostring
	local v167 = lower(tostring_(p36 or "")):gsub("[%s,]", "")
	if v167 == "" then
		p35.StealMinValue = 0
		return true
	end
	local v168, v169 = string.match(v167, "^([%d]+%.?[%d]*)([kmb]?)$")
	local v170 = tonumber(v168)
	if not v170 then
		return false
	end
	local n5 = 1
	if v169 == "k" then
		n5 = 1000
	elseif v169 == "m" then
		n5 = 1000000
	elseif v169 == "b" then
		n5 = 1e9
	end
	p35.StealMinValue = v170 * n5
	return true
end
s2rHubConfig.getAreaEggValue = function(p37, p38)
	if not p37._assetGenerationUtil then
		p37._assetGenerationUtil = require(game:GetService("ReplicatedStorage").Shared.Util.AssetEarnings)
	end
	return p37._assetGenerationUtil.MutationOnlyRatePerSecond({
		Category = p38.AssetCategory,
		Scale = p38.AssetScale or 1,
		Mutations = p38.Mutations or {},
		BaseMutation = p38.BaseMutation,
		EyeColor = p38.AssetEyeColor,
		ColorSeed = p38.AssetColorSeed,
		ColorIndex = p38.AssetColorIndex,
		Gender = p38.Gender,
		Personality = p38.Personality or "Normal",
		HasBeenFirstPlaced = p38.HasBeenFirstPlaced == true
	})
end
local function v172(p39)
	local max = math.max
	local StealPriorityUntil = s2rHubConfig.StealPriorityUntil or 0
	s2rHubConfig.StealPriorityUntil = max(StealPriorityUntil, os.clock() + (p39 or 5))
end
local AreaEggCycle
local AreaEggResetWall2
pcall(function()
	AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
	AreaEggResetWall2 = require(ReplicatedStorage.Client.AreaEggResetWall)
end)
local function v177()
	if AreaEggCycle then
		if type(AreaEggCycle.IsNightPhase) == "function" then
			local ok, result = pcall(AreaEggCycle.IsNightPhase, workspace:GetServerTimeNow())
			if ok then
				if result == true then
					return true
				end
			end
		end
	end
	if AreaEggResetWall2 then
		if type(AreaEggResetWall2.IsSealed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsSealed)
			if ok and result == true then
				return true
			end
		end
		if type(AreaEggResetWall2.IsClosed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsClosed)
			if ok and result == true then
				return true
			end
		end
	end
	return false
end
do
	local n6 = 0
	local u185 = false
	local function v186()
		if v177() then
			return false
		end
		local now = os.clock()
		if now - n6 < 0.35 then
			return u185
		end
		n6 = now
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local v189 = require(ReplicatedStorage2.Client.EggState).GetAreaEggSnapshot()
		local Directory = require(ReplicatedStorage2.Data.Assets).Directory
		local pairs_ = pairs
		local Records = v189 and v189.Records or {}
		for _, Record in pairs_(Records) do
			if Record.State ~= "Slot" and Record.State ~= "Dropped" or not Record.BottomCFrame then
				continue
			end
			local v195 = Directory[Record.AssetCategory]
			local Rarity = v195 and v195.Rarity
			local DisplayName = Rarity and (Rarity.DisplayName or Rarity._id)
			if DisplayName ~= "Eternal" and DisplayName ~= "Divine" then
				continue
			end
			u185 = true
			return true
		end
		u185 = false
		return false
	end
end
local function v198()
	if s2rHubConfig.IsStealing then
		return false
	end
	local __S2rHubDronesWantCharacter = genv.__S2rHubDronesWantCharacter
	if __S2rHubDronesWantCharacter and __S2rHubDronesWantCharacter() then
		return false
	end
	if s2rHubConfig.IsPlacing == true then
		return false
	end
	if s2rHubConfig.AutoSteal then
		return os.clock() >= (s2rHubConfig.StealPriorityUntil or 0)
	end
	return true
end
do
	local function v200(p40)
		pcall(function()
			if typeof(writefile) ~= "function" then
				return
			end
			local s1 = ""
			if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("S2rHub_Disconnect_Log.txt") then
				s1 = readfile("S2rHub_Disconnect_Log.txt") or ""
			end
			local t5 = {}
			for match in s1:gmatch("[^\r\n]+") do
				table.insert(t5, match)
			end
			local v204 = "] " .. p40
			table.insert(t5, "[" .. os.date("%Y-%m-%d %H:%M:%S") .. v204)
			while #t5 > 50 do
				table.remove(t5, 1)
			end
			writefile("S2rHub_Disconnect_Log.txt", table.concat(t5, "\n"))
		end)
	end
end
local function v205(p41)
	if not p41 or type(p41.GetValue) ~= "function" then
		return nil
	end
	local ok, result = pcall(function()
		return p41:GetValue()
	end)
	if not ok then
		return nil
	end
	if type(result) ~= "table" then
		if type(result) == "string" then
			return { result }
		end
		return nil
	end
	local t6 = {}
	for k, v in pairs(result) do
		if type(k) == "number" then
			table.insert(t6, v)
		elseif type(k) == "string" and v == true then
			table.insert(t6, k)
		end
	end
	return t6
end
local function v211(p42, p43, p44, p45)
	if s2rHubConfig.SellAll then
		return true
	end
	if type(p44) ~= "table" or type(p45) ~= "table" then
		return false
	end
	local v212 = false
	if not (#p44 == 0 or table.find(p44, "None")) then
		if table.find(p44, "All") then
			v212 = true
		else
			v212 = table.find(p44, p42) ~= nil
		end
	end
	local v213 = false
	if #p45 ~= 0 and not table.find(p45, "None") then
		if table.find(p45, "All") then
			v213 = true
		else
			v213 = table.find(p45, p43) ~= nil
		end
	end
	return v212 or v213
end
local function v214(p46, p47)
	if type(p47) ~= "table" then
		return false
	end
	if #p47 ~= 0 then
		if not table.find(p47, "None") then
			if table.find(p47, "All") then
				return true
			end
			return table.find(p47, p46) ~= nil
		end
	end
	return false
end
local function v215(p48)
	local HumanoidRootPart = p48 and p48:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		HumanoidRootPart:SetAttribute("KillPartIgnore", true)
	end
end
local vector3 = Vector3.new(544.76, 71.5, -416.48)
local t7 = {
	CarryRetry = 0.25,
	CarryTimeout = 2,
	EarlyCarryDistance = 8,
	SafeStable = 0.35,
	ReturnValidation = 0.08,
	NextTarget = 0.05,
	SafeHandoff = 0.15
}
local t8 = {
	GUARD_MARGIN = 1.25,
	GUARD_FALLBACK = 222,
	maxGuardWalkSpeed = nil,
	floorNotifiedFor = -1,
	capNotifiedFor = -1
}
local function v220()
	if not t8.maxGuardWalkSpeed then
		local ok, result = pcall(function()
			return require(game:GetService("ReplicatedStorage").Data.Guards).GetHighestWalkSpeed()
		end)
		t8.maxGuardWalkSpeed = ok and type(result) == "number" and result > 0 and result or t8.GUARD_FALLBACK
		warn(string.format("[GuardEscape] Guard tercepat %d stud/detik -> lantai kabur %d stud/detik", t8.maxGuardWalkSpeed, t8.maxGuardWalkSpeed * t8.GUARD_MARGIN))
	end
	return t8.maxGuardWalkSpeed * t8.GUARD_MARGIN
end
local function v223(p49)
	local tweenSpeedMultiplier = math.clamp(math.floor((tonumber(p49) or t1.DEF_INPUT) + 0.5), t1.MIN_INPUT, t1.MAX_INPUT)
	if math.abs((s2rHubConfig.TweenSpeedMultiplier or 0) - tweenSpeedMultiplier) <= 0.001 then
		return
	end
	s2rHubConfig.TweenSpeedMultiplier = tweenSpeedMultiplier
end
local function v225(p50, p51, p52, p53)
	local v226 = os.clock() + p52
	local now
	local n7 = 0
	local n8 = 0.1
	pcall(function()
		n8 = LocalPlayer:GetNetworkPing()
	end)
	local v230 = math.clamp(n8 * 2 + 0.2, 0.4, 1)
	while true do
		if not (os.clock() < v226) then
			return false
		end
		if p53 and p53() then
			break
		end
		p50.AssemblyLinearVelocity = Vector3.zero
		p50.AssemblyAngularVelocity = Vector3.zero
		RunService.Heartbeat:Wait()
		if not ((p50.Parent and (p50.Position - p51.Position).Magnitude or math.huge) <= 1.5) then
			now = nil
			n7 = 0
			continue
		end
		p50.CFrame = p51
		now = now or os.clock()
		n7 += 1
		if not (n7 >= 3) or not (v230 <= os.clock() - now) then
			continue
		end
		return true
	end
	return false
end
local t9 = {}
local function v232(p54, p55, p56, p57, p58, p59, p60)
	if not p54 or not p55 or typeof(p56) ~= "CFrame" then
		return false
	end
	if p57 and p57() then
		return false
	end
	local v233 = t9[p54]
	if v233 then
		v233.cancelled = true
		t9[p54] = nil
	end
	local Parent = p54.Parent
	if not Parent then
		return false
	end
	v24()
	v215(Parent)
	v33()
	local CurrentCamera = workspace.CurrentCamera
	if CurrentCamera and CurrentCamera.CameraSubject ~= p55 then
		pcall(function()
			CurrentCamera.CameraSubject = p55
		end)
	end
	local AutoRotate = p55.AutoRotate
	p55.AutoRotate = false
	local v237 = p60 and math.max(p54.Position.Y, p56.Position.Y + 5, vector3.Y + 5) or nil
	local v238 = v237 and cFrameNew(p56.Position.X, v237, p56.Position.Z) * p56.Rotation or p56
	local v239 = math.clamp(v20(), t1.MIN_SPEED, genv.__S2rHubAdminBoost == true and 3000 or t1.MAX_SPEED)
	v27(Parent, v239 * t1.HEADROOM)
	local t10 = {
		cancelled = false
	}
	t9[p54] = t10
	v22()
	local now
	local v242
	local n9 = 0
	local v244 = v237 and (math.abs(p54.Position.Y - v237) > 0.35 and "takeoff" or "cruise") or nil
	local Magnitude = (v238.Position - p54.Position).Magnitude
	local v246 = os.clock() + math.max(Magnitude / v239, 0.08) * 3 + 8
	local v247 = false
	local v248 = false
	while not t10.cancelled and (not p57 or not p57()) and p54.Parent and not (v246 <= os.clock()) do
		local v249 = math.max(math.min(RunService.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
		local v250 = math.clamp(v20(), t1.MIN_SPEED, genv.__S2rHubAdminBoost == true and 3000 or t1.MAX_SPEED)
		v27(Parent, v250 * t1.HEADROOM)
		local v251 = v26()[t1.INTEGRITY_KEY]
		local State = type(v251) == "table" and v251.State or nil
		if v30(State, p55, p54) then
			local Position = p54.Position
			local v254 = v238.Position - Position
			local Magnitude2 = v254.Magnitude
			local vector32 = Vector3.new(v254.X, 0, v254.Z)
			if v237 and v244 == "takeoff" and math.abs(Position.Y - v237) <= 0.35 then
				v244 = "cruise"
			end
			local v257 = (v237 and v244 == "takeoff" and Vector3.new(Position.X, v237, Position.Z) or v238.Position) - Position
			local Magnitude3 = v257.Magnitude
			local Magnitude4 = v237 and vector32.Magnitude or Magnitude2
			if v242 and v242 + 2 < Magnitude4 then
				n9 = os.clock() + 0.5
			end
			v242 = Magnitude4
			local v260 = (os.clock() < n9 and math.max(t1.MIN_SPEED, v250 * 0.45) or v250) * v249
			if p59 and not v248 and Magnitude2 <= t7.EarlyCarryDistance then
				v248 = true
				task.spawn(p59)
			end
			local vector33 = Vector3.new(p54.CFrame.LookVector.X, 0, p54.CFrame.LookVector.Z)
			local Unit = vector32.Magnitude > 0.001 and vector32.Unit or vector33.Magnitude > 0.001 and vector33.Unit or Vector3.new(0, 0, -1)
			if (not v237 or v244 == "cruise") and Magnitude2 <= math.max(v260, 0.05) then
				if Magnitude2 > 0.5 then
					now = nil
				end
				v21(v238.Position)
				p54.CFrame = lookAt(v238.Position, v238.Position + Unit)
				p54.AssemblyLinearVelocity = Vector3.zero
				p54.AssemblyAngularVelocity = Vector3.zero
				v21(v238.Position)
				v32(p55, p54, v250, Vector3.zero)
				now = now or os.clock()
				if os.clock() - now >= 0.4 then
					v247 = true
					break
				end
			else
				now = nil
				if Magnitude3 <= 0.001 then
					p54.AssemblyLinearVelocity = Vector3.zero
					p54.AssemblyAngularVelocity = Vector3.zero
					v21(Position)
				else
					local v263 = Position + v257.Unit * math.min(v260, Magnitude3)
					local v264 = (v263 - Position) / v249
					v21(v263)
					p54.CFrame = lookAt(v263, v263 + Unit)
					p54.AssemblyLinearVelocity = Vector3.zero
					v21(v263)
					if not v32(p55, p54, v250, v264) then
						v31(p55, p54, v250)
						v32(p55, p54, v250, v264)
					end
				end
			end
		else
			v242 = nil
			now = nil
			p54.AssemblyLinearVelocity = Vector3.zero
			p54.AssemblyAngularVelocity = Vector3.zero
			v21(p54.Position)
			if v29(State, p55, p54) then
				v28(State, v250 * t1.HEADROOM, Vector3.zero)
			else
				v31(p55, p54, v250)
			end
		end
	end
	if p55.Parent and AutoRotate ~= nil then
		p55.AutoRotate = AutoRotate
	end
	p54.AssemblyLinearVelocity = Vector3.zero
	p54.AssemblyAngularVelocity = Vector3.zero
	if v247 and p58 then
		v25(p54, v238)
	else
		v23()
	end
	local v265 = v247 and not t10.cancelled
	return v265
end
local function v266(p61, p62, p63, p64)
	return v232(p61, p62, p63, p64, false, nil, true)
end
local function v267(p65, p66)
	if p65 then
		if typeof(p66) == "CFrame" then
			if not pcall(function()
				p65.AssemblyLinearVelocity = Vector3.zero
				p65.AssemblyAngularVelocity = Vector3.zero
				p65.CFrame = p66
				p65.AssemblyLinearVelocity = Vector3.zero
				p65.AssemblyAngularVelocity = Vector3.zero
			end) then
				return false
			end
			v21(p66.Position)
			local Parent = p65.Parent
			local Humanoid = Parent and Parent:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				local v270 = math.clamp(v20(), t1.MIN_SPEED, genv.__S2rHubAdminBoost == true and 3000 or t1.MAX_SPEED)
				v27(Parent, v270 * t1.HEADROOM)
				if not v32(Humanoid, p65, v270, Vector3.zero) then
					v31(Humanoid, p65, v270)
					v32(Humanoid, p65, v270, Vector3.zero)
				end
			end
			return true
		end
	end
	return false
end
getgenv().S2rHubConfig = s2rHubConfig
local function v271(p67)
	if p67 and p67.Name == "PlayerTrap" then
		pcall(function()
			p67:Destroy()
		end)
	end
end
task.spawn(function()
	local function v272(p68)
		if not p68 then
			return
		end
		local v273, v274, v275 = ipairs(p68:GetChildren())
		local v276 = geniter(v273, v274, v275)
		local v277 = table.pack(v276())
		if v277[1] then
			local v278 = v277[3]
			while true do
				v271(v278)
				local v279 = table.pack(v276())
				if v279[1] then
					v278 = v279[3]
				else
					break
				end
			end
		end
		p68.ChildAdded:Connect(function(child)
			v271(child)
		end)
	end
	local Transient = workspace:FindFirstChild("Transient")
	if Transient then
		v272(Transient)
	end
	local __DEBRIS = workspace:FindFirstChild("__DEBRIS")
	if __DEBRIS then
		v272(__DEBRIS)
	end
	workspace.ChildAdded:Connect(function(child)
		if child.Name == "Transient" or child.Name == "__DEBRIS" then
			v272(child)
		elseif child.Name == "PlayerTrap" then
			v271(child)
			return
		elseif child.Name:lower():find("trap") then
			v271(child)
		end
	end)
	task.spawn(function()
		while v16() do
			for _, v in ipairs({
				workspace:FindFirstChild("Transient"),
				workspace:FindFirstChild("__DEBRIS")
			}) do
				if v then
					for _, child in ipairs(v:GetChildren()) do
						v271(child)
					end
				end
			end
			task.wait(1.5)
		end
	end)
end)
local u286
local function v287()
	local ok, result = pcall(function()
		return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskRenderSnapshot:InvokeServer()
	end)
	if ok then
		if type(result) == "table" then
			return table.find(result, LocalPlayer.UserId) ~= nil
		end
	end
	return nil
end
local function v290()
	local ok, result, result2 = pcall(function()
		return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskDoff:InvokeServer()
	end)
	if not ok then
		return false, tostring(result)
	end
	if result ~= true then
		return false, tostring(result2)
	end
	return true
end
local function v294()
	local ok, result = pcall(function()
		local PlotState2 = require(ReplicatedStorage.Client.PlotState)
		local v298 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
		local v299 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
		local v300 = v299 and v298
		v300 = v300 and v299:FindFirstChild(tostring(v298))
		local TreadmillBottom = v300 and v300:FindFirstChild("TreadmillBottom")
		if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
			return nil
		end
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if HumanoidRootPart and Humanoid then
			return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + (Humanoid.RigType == Enum.HumanoidRigType.R15 and HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5) or HumanoidRootPart.Size.Y * 0.5 + 2) + 0.05, 0)
		end
		return nil
	end)
	local v305 = ok and result or nil
	return v305
end
local t11 = {
	HoldSeconds = 0.3,
	ConfirmStableSeconds = 0.3,
	ConfirmTimeout = 2.5,
	PollSeconds = 0.05,
	ArrivalSettle = 0.5,
	DecoyName = "__S2rHubTweenTreadmillDecoy",
	destroyTrail = function(p69)
		if typeof(p69) == "Instance" then
			if p69:IsA("Trail") then
				pcall(p69.Destroy, p69)
			end
		end
	end,
	destroyStealPopup = function(p70)
		if s2rHubConfig.IsStealing then
			if typeof(p70) == "Instance" and (p70.Name == "SpeedGainPopup" or p70.Name == "PlusOne") then
				pcall(p70.Destroy, p70)
			end
		end
	end
}
t11.purgeStealPopups = function()
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not PlayerGui then
		return
	end
	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		t11.destroyStealPopup(descendant)
	end
end
t11.guiConnection = LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(descendant)
	t11.destroyStealPopup(descendant)
end)
t11.removeDecoy = function()
	if t11.cameraConnection then
		pcall(t11.cameraConnection.Disconnect, t11.cameraConnection)
		t11.cameraConnection = nil
	end
	if t11.characterConnection then
		pcall(t11.characterConnection.Disconnect, t11.characterConnection)
		t11.characterConnection = nil
	end
	local pairs_ = pairs
	local transparency = t11.transparency or {}
	for k, v in pairs_(transparency) do
		if typeof(k) == "Instance" and k.Parent then
			pcall(function()
				k.LocalTransparencyModifier = v
			end)
		end
	end
	t11.transparency = nil
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local CurrentCamera = workspace.CurrentCamera
	if CurrentCamera then
		pcall(function()
			CurrentCamera.CameraSubject = Humanoid or t11.cameraSubject
		end)
	end
	t11.cameraSubject = nil
	if t11.decoy then
		pcall(t11.decoy.Destroy, t11.decoy)
	end
	t11.decoy = nil
end
t11.spawnDecoy = function(p71)
	t11.removeDecoy()
	local Character = LocalPlayer.Character
	if not Character then
		return false
	end
	local Archivable = Character.Archivable
	Character.Archivable = true
	local ok, decoy = pcall(Character.Clone, Character)
	Character.Archivable = Archivable
	if not ok or not decoy or typeof(decoy) ~= "Instance" then
		return false
	end
	decoy.Name = t11.DecoyName
	for _, descendant in ipairs(decoy:GetDescendants()) do
		if not descendant:IsA("Script") then
			if not descendant:IsA("LocalScript") and not descendant:IsA("BillboardGui") and not descendant:IsA("Sound") and not descendant:IsA("Trail") then
				if not descendant:IsA("BasePart") then
					continue
				end
				descendant.LocalTransparencyModifier = 0
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanQuery = false
				descendant.CanTouch = false
				continue
			end
		end
		pcall(descendant.Destroy, descendant)
	end
	local Humanoid = decoy:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		decoy:Destroy()
		return false
	end
	pcall(function()
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	end)
	decoy.Parent = workspace
	decoy:PivotTo(p71)
	t11.decoy = decoy
	local transparency = setmetatable({}, {
		__mode = "k"
	})
	local function v325(p72)
		if not p72 or not p72:IsA("BasePart") or not p72:IsDescendantOf(Character) then
			return
		end
		if transparency[p72] == nil then
			transparency[p72] = p72.LocalTransparencyModifier
		end
		p72.LocalTransparencyModifier = 1
	end
	for _, descendant in ipairs(Character:GetDescendants()) do
		v325(descendant)
		t11.destroyTrail(descendant)
	end
	t11.transparency = transparency
	t11.characterConnection = Character.DescendantAdded:Connect(function(descendant)
		if t11.decoy == decoy then
			pcall(v325, descendant)
			t11.destroyTrail(descendant)
		end
	end)
	local CurrentCamera = workspace.CurrentCamera
	if CurrentCamera then
		t11.cameraSubject = CurrentCamera.CameraSubject
		CurrentCamera.CameraSubject = Humanoid
	end
	t11.cameraConnection = RunService.RenderStepped:Connect(function()
		if t11.decoy == decoy then
			if decoy.Parent and Humanoid.Parent then
				for k in pairs(transparency) do
					if k.Parent and k.LocalTransparencyModifier ~= 1 then
						k.LocalTransparencyModifier = 1
					end
				end
				local CurrentCamera2 = workspace.CurrentCamera
				if CurrentCamera2 and CurrentCamera2.CameraSubject ~= Humanoid then
					CurrentCamera2.CameraSubject = Humanoid
				end
				return
			end
		end
	end)
	return true
end
t11.requestEquip = function()
	local ok, result, result2 = pcall(function()
		return require(ReplicatedStorage.Shared.Remotes).Treadmill.AskWearStill:InvokeServer()
	end)
	if ok then
		if result ~= false then
			return true
		end
	end
	local v334 = false
	local tostring_ = tostring
	local v336 = result2 or result
	return v334, tostring_(v336)
end
t11.prepare = function(p73, p74)
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if HumanoidRootPart then
		if Humanoid and typeof(p73) == "CFrame" then
			local function v340()
				return p74 ~= nil and p74()
			end
			local function v341()
				local Character2 = LocalPlayer.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart2 then
					v267(HumanoidRootPart2, p73)
					task.wait(0.1)
				end
				t11.removeDecoy()
			end
			t11.purgeStealPopups()
			v24()
			v23()
			if not t11.spawnDecoy(p73) then
				return false
			end
			local v344 = v294()
			if not v344 or v340() or not v267(HumanoidRootPart, v344) then
				v290()
				v341()
				return false
			end
			task.wait(t11.ArrivalSettle)
			if v340() then
				v290()
				v341()
				return false
			end
			if not t11.requestEquip() then
				v290()
				v341()
				return false
			end
			local v345 = os.clock() + t11.ConfirmTimeout
			local v346 = false
			local now
			while not v340() do
				if not (os.clock() < v345) then
					break
				end
				if v287() == true then
					now = now or os.clock()
					if not (t11.ConfirmStableSeconds <= os.clock() - now) then
						task.wait(t11.PollSeconds)
						continue
					end
					v346 = true
					break
				end
				now = nil
				task.wait(t11.PollSeconds)
			end
			if not v346 or v340() then
				v290()
				v341()
				return false
			end
			local v348 = os.clock() + t11.HoldSeconds
			while not v340() and os.clock() < v348 do
				task.wait(t11.PollSeconds)
			end
			local v349 = os.clock() + t11.ConfirmTimeout
			local v350 = false
			while not v340() and os.clock() < v349 do
				v290()
				task.wait(t11.PollSeconds)
				if v287() == false then
					u286 = nil
					v350 = true
					break
				end
			end
			v341()
			local v351 = v350 and not v340()
			return v351
		end
	end
	return false
end
t11.previousCleanup = genv.__S2rHubTweenRuntimeCleanup
genv.__S2rHubTweenRuntimeCleanup = function()
	v290()
	t11.removeDecoy()
	if t11.guiConnection then
		pcall(t11.guiConnection.Disconnect, t11.guiConnection)
		t11.guiConnection = nil
	end
	if type(t11.previousCleanup) == "function" then
		t11.previousCleanup()
	end
end
LocalPlayer.CharacterRemoving:Connect(function()
	t11.removeDecoy()
end)
do
	if type(genv.__S2rHubCosmeticSuppressCleanup) == "function" then
		pcall(genv.__S2rHubCosmeticSuppressCleanup)
	end
	local t12 = {}
	local function v353(child)
		if child then
			if child.Name == "DropHeldEgg" then
				if not child:IsA("ScreenGui") then
					if not child:IsA("LayerCollector") then
						return
					end
				end
				pcall(function()
					child.Enabled = false
				end)
				table.insert(t12, child:GetPropertyChangedSignal("Enabled"):Connect(function()
					if child.Enabled then
						pcall(function()
							child.Enabled = false
						end)
					end
				end))
				return
			end
		end
	end
	local function v354()
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if PlayerGui then
			for _, child in ipairs(PlayerGui:GetChildren()) do
				v353(child)
			end
			table.insert(t12, PlayerGui.ChildAdded:Connect(v353))
			return
		end
	end
	v354()
	table.insert(t12, LocalPlayer.CharacterAdded:Connect(function()
		task.defer(v354)
	end))
	pcall(function()
		local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)
		if type(GuardPresentationComponent) == "table" then
			genv.__S2rHubGuardPresentOrig = genv.__S2rHubGuardPresentOrig or {
				PlayWake = GuardPresentationComponent.PlayWake,
				PlayHit = GuardPresentationComponent.PlayHit,
				PlayAfterWake = GuardPresentationComponent.PlayAfterWake,
				ScheduleAfterWake = GuardPresentationComponent.ScheduleAfterWake
			}
			local function playWake()
			end
			GuardPresentationComponent.PlayWake = playWake
			GuardPresentationComponent.PlayHit = function()
				return 0
			end
			GuardPresentationComponent.PlayAfterWake = playWake
			GuardPresentationComponent.ScheduleAfterWake = playWake
		end
	end)
	genv.__S2rHubCosmeticSuppressCleanup = function()
		for _, v in ipairs(t12) do
			pcall(function()
				v:Disconnect()
			end)
		end
		table.clear(t12)
		local __S2rHubGuardPresentOrig = genv.__S2rHubGuardPresentOrig
		if type(__S2rHubGuardPresentOrig) == "table" then
			pcall(function()
				local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)
				for k, v in pairs(__S2rHubGuardPresentOrig) do
					GuardPresentationComponent[k] = v
				end
			end)
		end
	end
end
do
	if type(genv.__S2rHubStealDeclutterCleanup) == "function" then
		pcall(genv.__S2rHubStealDeclutterCleanup)
	end
	local t13 = {
		{
			name = "ProximityPrompts",
			restore = true
		},
		{
			name = "AreaGui",
			restore = false
		}
	}
	local u367 = false
	local t14 = {}
	local function v369(p75)
		return p75 and (p75:IsA("ScreenGui") or p75:IsA("LayerCollector"))
	end
	local function v370(p76)
		if not v369(p76) then
			return
		end
		pcall(function()
			p76.Enabled = false
		end)
		table.insert(t14, p76:GetPropertyChangedSignal("Enabled"):Connect(function()
			if u367 then
				if p76.Enabled then
					pcall(function()
						p76.Enabled = false
					end)
				end
			end
		end))
	end
	local function v371(p77)
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if not PlayerGui then
			return
		end
		for _, v in ipairs(t13) do
			local VName = PlayerGui:FindFirstChild(v.name)
			if VName then
				p77(VName, v)
			end
		end
	end
	local function v376()
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if not PlayerGui then
			return
		end
		v371(function(p78)
			v370(p78)
		end)
		table.insert(t14, PlayerGui.ChildAdded:Connect(function(child)
			if not u367 then
				return
			end
			for _, v in ipairs(t13) do
				if child.Name == v.name then
					v370(child)
					break
				end
			end
		end))
	end
	local function v380()
		for _, v in ipairs(t14) do
			pcall(function()
				v:Disconnect()
			end)
		end
		table.clear(t14)
		v371(function(p79, p80)
			pcall(function()
				p79.Enabled = p80.restore
			end)
		end)
	end
	genv.__S2rHubSetStealDeclutter = function(p81)
		local v383 = p81 == true
		if v383 == u367 then
			return
		end
		u367 = v383
		if v383 then
			v376()
		else
			v380()
		end
	end
	genv.__S2rHubStealDeclutterCleanup = function()
		u367 = false
		v380()
	end
end
do
	local function v384()
		local v385 = v287()
		if v385 == false then
			u286 = nil
			return true
		end
		if v385 == nil and u286 == nil then
			return true
		end
		u286 = u286 or "server"
		local v386, v387 = v290()
		if not v386 then
			warn("[Treadmill] Gagal minta lepas dari treadmill sebelum steal:", v387)
			return false
		end
		local v388 = os.clock() + 1.5
		while u286 ~= nil and os.clock() < v388 do
			task.wait(0.05)
			if not s2rHubConfig.AutoSteal then
				return false
			end
			if v287() == false then
				u286 = nil
				break
			end
		end
		if u286 ~= nil then
			warn("[Treadmill] Lepas treadmill gak kekonfirmasi dalam 1.5s, steal dilanjut apa adanya.")
			return false
		end
		task.wait(0.12)
		return true
	end
end
if type(genv.__S2rHubDecomBoostCleanup) == "function" then
	pcall(genv.__S2rHubDecomBoostCleanup)
end
local t15, v390, v391
do
	local t16 = {}
	local u393 = false
	genv.__S2rHubDecomBoostCleanup = function()
		for _, v in ipairs(t16) do
			pcall(function()
				v:Disconnect()
			end)
		end
		table.clear(t16)
		u393 = false
	end
	local function v396()
		local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")
		if not ClientRenderedAssets then
			return
		end
		for _, child in ipairs(ClientRenderedAssets:GetChildren()) do
			pcall(function()
				child.Parent = nil
			end)
		end
	end
	local function v400(p82)
		return string.sub(p82.Name, 1, #tostring(LocalPlayer.UserId) + 1) == tostring(LocalPlayer.UserId) .. "_"
	end
	local function v401()
		for _, child in ipairs(workspace:GetChildren()) do
			if child.Name == "PlacedEggRenders" then
				for _, child2 in ipairs(child:GetChildren()) do
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") then
							if not v400(child2) then
								child2.Parent = nil
							end
						end
					end)
				end
			end
		end
	end
	local function v406()
		for _, v in ipairs({
			"Transient",
			"__DEBRIS"
		}) do
			local v409 = workspace:FindFirstChild(v)
			if v409 then
				for _, child in ipairs(v409:GetChildren()) do
					if child.Name ~= "PlayerTrap" then
						if not child.Name:lower():find("trap") then
							continue
						end
					end
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end
	local function v412(p83)
		if not p83:FindFirstAncestor("S2rHubVisualBack") then
			if not p83:FindFirstAncestor("S2rHubVisualRemote") then
				local Tool = p83:FindFirstAncestorWhichIsA("Tool")
				return Tool ~= nil and Tool:GetAttribute("S2rHubVisual") ~= nil
			end
		end
		return true
	end
	t15 = {
		effects = {},
		parts = {},
		decals = {},
		snapshot = nil
	}
	local t17 = {
		PlusOne = true,
		SpeedGainPopup = true,
		SellPayout = true,
		SyncedIncomeCash = true
	}
	local t18 = {
		PlayerPlotSign = true,
		CanUpgrade = true,
		AlertGui = true,
		OfflineMoneyClaimBillboard = true
	}
	local function v416(descendant)
		pcall(function()
			if v412(descendant) then
				return
			end
			if t17[descendant.Name] then
				descendant:Destroy()
				return
			end
			if descendant:IsA("BillboardGui") and t18[descendant.Name] then
				if descendant.Enabled then
					t15.effects[descendant] = true
				end
				descendant.Enabled = false
				return
			end
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Sparkles") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("PostEffect") then
				if descendant.Enabled then
					t15.effects[descendant] = true
				end
				descendant.Enabled = false
			end
		end)
	end
	local function v417()
		if u393 then
			return
		end
		u393 = true
		table.insert(t16, game.DescendantAdded:Connect(v416))
		table.insert(t16, workspace.ChildAdded:Connect(function(child)
			if child.Name == "ClientRenderedAssets" then
				v396()
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						child2.Parent = nil
					end)
				end))
			elseif child.Name == "PlacedEggRenders" then
				v401()
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") and not v400(child2) then
							child2.Parent = nil
						end
					end)
				end))
			elseif child.Name == "__DEBRIS" or child.Name == "Transient" then
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					if child2.Name == "PlayerTrap" then
						pcall(function()
							child2:Destroy()
						end)
						return
					elseif child2.Name:lower():find("trap") then
						pcall(function()
							child2:Destroy()
						end)
					end
				end))
			end
		end))
		local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")
		if ClientRenderedAssets then
			table.insert(t16, ClientRenderedAssets.ChildAdded:Connect(function(child)
				pcall(function()
					child.Parent = nil
				end)
			end))
		end
		for _, child in ipairs(workspace:GetChildren()) do
			if child.Name == "PlacedEggRenders" then
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") then
							if not v400(child2) then
								child2.Parent = nil
							end
						end
					end)
				end))
			end
		end
	end
	local u421 = false
	v390 = function()
		if u421 then
			return
		end
		u421 = true
		local Lighting = game:GetService("Lighting")
		if not t15.snapshot then
			local t19 = {}
			pcall(function()
				t19.quality = settings().Rendering.QualityLevel
				t19.throttle = settings().Physics.PhysicsEnvironmentalThrottle
				t19.technology = Lighting.Technology
				t19.shadows = Lighting.GlobalShadows
				t19.fogEnd = Lighting.FogEnd
				t19.brightness = Lighting.Brightness
				t19.ambient = Lighting.Ambient
				t19.outdoorAmbient = Lighting.OutdoorAmbient
			end)
			local Terrain = workspace:FindFirstChildOfClass("Terrain")
			if Terrain then
				pcall(function()
					t19.terrain = {
						WaterWaveSize = Terrain.WaterWaveSize,
						WaterWaveSpeed = Terrain.WaterWaveSpeed,
						WaterReflectance = Terrain.WaterReflectance,
						WaterTransparency = Terrain.WaterTransparency,
						Decoration = Terrain.Decoration
					}
				end)
				pcall(function()
					local Clouds = Terrain:FindFirstChildOfClass("Clouds")
					if Clouds then
						t19.cloudsEnabled = Clouds.Enabled
					end
				end)
			end
			pcall(function()
				local Preferences = ReplicatedStorage.Shared:FindFirstChild("Preferences")
				if Preferences then
					local module = require(Preferences)
					t19.prefs = {
						HideOtherPets = module.IsOn("HideOtherPets"),
						DisableVideos = module.IsOn("DisableVideos")
					}
				end
			end)
			if t19.quality == Enum.QualityLevel.Level01 then
				t19.quality = Enum.QualityLevel.Automatic
			end
			t15.snapshot = genv.__S2rHubDecomSnapshot or t19
			genv.__S2rHubDecomSnapshot = t15.snapshot
		end
		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
			Lighting.Technology = Enum.Technology.Compatibility
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		end)
		local now = os.clock()
		for _, v in ipairs({
			workspace,
			Lighting
		}) do
			for _, descendant in ipairs(v:GetDescendants()) do
				if not v412(descendant) then
					if descendant:IsA("BasePart") then
						pcall(function()
							if not t15.parts[descendant] then
								t15.parts[descendant] = {
									descendant.Material,
									descendant.CastShadow,
									descendant:IsA("MeshPart") and descendant.RenderFidelity or nil
								}
							end
							descendant.Material = Enum.Material.SmoothPlastic
							descendant.CastShadow = false
							if descendant:IsA("MeshPart") then
								descendant.RenderFidelity = Enum.RenderFidelity.Performance
							end
						end)
					else
						if descendant:IsA("Decal") then
							pcall(function()
								if descendant.Texture ~= "" and not t15.decals[descendant] then
									t15.decals[descendant] = descendant.Texture
								end
								descendant.Texture = ""
							end)
							if os.clock() - now > 0.004 then
								task.wait()
								now = os.clock()
							end
							continue
						end
						if descendant:IsA("Texture") then
							pcall(function()
								if descendant.Texture ~= "" and not t15.decals[descendant] then
									t15.decals[descendant] = descendant.Texture
								end
								descendant.Texture = ""
							end)
						else
							v416(descendant)
						end
					end
					if os.clock() - now > 0.004 then
						task.wait()
						now = os.clock()
					end
				end
			end
		end
		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		if Terrain then
			pcall(function()
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Terrain.Decoration = false
				local Clouds = Terrain:FindFirstChildOfClass("Clouds")
				if Clouds then
					Clouds.Enabled = false
				end
			end)
		end
		pcall(function()
			local Shared = ReplicatedStorage.Shared
			local Preferences = Shared:FindFirstChild("Preferences")
			if Preferences then
				local module = require(Preferences)
				module.Set("HideOtherPets", true)
				module.Set("DisableVideos", true)
			else
				local SettingsCmds = require(Shared.SettingsCmds)
				SettingsCmds.Write("HideOtherPets", true)
				SettingsCmds.Write("DisableVideos", true)
			end
		end)
		v396()
		v401()
		v406()
		v417()
		u421 = false
	end
	t15.revert = function()
		for _, v in ipairs(t16) do
			pcall(function()
				v:Disconnect()
			end)
		end
		table.clear(t16)
		u393 = false
		local snapshot = t15.snapshot
		local Lighting = game:GetService("Lighting")
		if snapshot then
			pcall(function()
				settings().Rendering.QualityLevel = snapshot.quality or Enum.QualityLevel.Automatic
			end)
			pcall(function()
				settings().Physics.PhysicsEnvironmentalThrottle = snapshot.throttle
			end)
			pcall(function()
				Lighting.Technology = snapshot.technology
				Lighting.GlobalShadows = snapshot.shadows
				Lighting.FogEnd = snapshot.fogEnd
				Lighting.Brightness = snapshot.brightness
				Lighting.Ambient = snapshot.ambient
				Lighting.OutdoorAmbient = snapshot.outdoorAmbient
			end)
			local Terrain = workspace:FindFirstChildOfClass("Terrain")
			if Terrain and snapshot.terrain then
				for k, v in pairs(snapshot.terrain) do
					pcall(function()
						Terrain[k] = v
					end)
				end
				if snapshot.cloudsEnabled ~= nil then
					pcall(function()
						local Clouds = Terrain:FindFirstChildOfClass("Clouds")
						if Clouds then
							Clouds.Enabled = snapshot.cloudsEnabled
						end
					end)
				end
			end
			if snapshot.prefs then
				pcall(function()
					local Preferences = require(ReplicatedStorage.Shared.Preferences)
					for k, pref in pairs(snapshot.prefs) do
						Preferences.Set(k, pref)
					end
				end)
			end
		end
		local n10 = 0
		for k, part in pairs(t15.parts) do
			if k.Parent then
				pcall(function()
					k.Material = part[1]
					k.CastShadow = part[2]
					if part[3] ~= nil and k:IsA("MeshPart") then
						k.RenderFidelity = part[3]
					end
				end)
			end
			n10 += 1
			if n10 % 400 == 0 then
				task.wait()
			end
		end
		for k, decal in pairs(t15.decals) do
			if k.Parent then
				pcall(function()
					k.Texture = decal
				end)
			end
		end
		for k in pairs(t15.effects) do
			if k.Parent then
				pcall(function()
					k.Enabled = true
				end)
			end
		end
		t15.parts = {}
		t15.decals = {}
		t15.effects = {}
		t15.snapshot = nil
	end
	genv.__S2rHubDecomBoostUndo = t15
	local u456 = false
	local function v457(p84)
		if not p84 or not p84:IsA("Model") then
			return
		end
		local match = p84.Name:match("^(%d+)_")
		local v459 = match and tonumber(match)
		if not v459 or v459 == LocalPlayer.UserId then
			return
		end
		for _, descendant in ipairs(p84:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Transparency = 1
				descendant.CanCollide = false
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 1
			elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
				descendant.Enabled = false
			elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
				descendant.Enabled = false
			end
		end
	end
	local function v462()
		if s2rHubConfig._fpsEggsReady then
			return true
		end
		local u463 = false
		local ok, result = pcall(function()
			local v466 = require(game:GetService("ReplicatedStorage").Shared.Eggs.PlacedEggRenderer).GetRenderFolder()
			if not v466 then
				return
			end
			local children = v466:GetChildren()
			for _, child in ipairs(children) do
				v457(child)
			end
			v466.ChildAdded:Connect(function(child)
				task.defer(v457, child)
			end)
			u463 = true
		end)
		if not ok then
			warn("[FPSBoost] Gagal hide egg pemain lain:", result)
			return false
		end
		return u463
	end
	local function v470(p85)
		if not p85 then
			return
		end
		pcall(function()
			p85.Parent = nil
		end)
	end
	local function v471()
		if s2rHubConfig._fpsPetsReady then
			return true
		end
		local IsOn
		local ok, result = pcall(function()
			local Shared = game:GetService("ReplicatedStorage").Shared
			local Preferences = Shared:FindFirstChild("Preferences")
			if Preferences then
				local module = require(Preferences)
				module.Set("HideOtherPets", true)
				IsOn = module.IsOn
			else
				local SettingsCmds = require(Shared.SettingsCmds)
				SettingsCmds.Write("HideOtherPets", true)
				IsOn = SettingsCmds.Allows
			end
		end)
		local v479 = false
		if ok and IsOn then
			local ok2, result2 = pcall(IsOn, "HideOtherPets")
			v479 = ok2 and result2 == true
		end
		if ok then
			if v479 then
				local u482 = false
				local ok2, result2 = pcall(function()
					local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets") or workspace:WaitForChild("ClientRenderedAssets", 10)
					if not ClientRenderedAssets then
						return
					end
					local children = ClientRenderedAssets:GetChildren()
					for _, child in ipairs(children) do
						v470(child)
					end
					ClientRenderedAssets.ChildAdded:Connect(function(child)
						task.defer(v470, child)
					end)
					u482 = true
				end)
				if not ok2 then
					warn("[FPSBoost] Gagal hide pet (manual):", result2)
					return false
				end
				return u482
			end
		end
		warn("[FPSBoost] Gagal set HideOtherPets bawaan game:", result or "setting belum aktif")
		return false
	end
	local function v489()
		if type(genv.__S2rHubSetCapFps) == "function" then
			pcall(genv.__S2rHubSetCapFps, 240)
		end
		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)
		local function v490()
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
		end
		pcall(v490)
		pcall(function()
			require(game:GetService("ReplicatedStorage").Client.LightingsController):SetModifier("FPSBoost", function(p86)
				local v491 = table.clone(p86)
				v491.Bloom = nil
				v491.ColorCorrection = nil
				v491.SunRays = nil
				v491.DepthOfField = nil
				v491.Blur = nil
				v491.Clouds = nil
				v491.Atmosphere = nil
				v491.ShadowSoftness = 1
				return v491
			end, 100, 0)
		end)
		pcall(function()
			local Lighting = game:GetService("Lighting")
			Lighting.GlobalShadows = false
			Lighting.Technology = Enum.Technology.Compatibility
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 2
		end)
		pcall(function()
			local Terrain = workspace:FindFirstChildOfClass("Terrain")
			if Terrain then
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Terrain.Decoration = false
			end
		end)
		pcall(function()
			local __DEBRIS = workspace:FindFirstChild("__DEBRIS")
			if __DEBRIS then
				for _, child in ipairs(__DEBRIS:GetChildren()) do
					if child.Name == "PlayerTrap" then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end
		end)
	end
	local color3 = Color3.fromRGB(120, 120, 120)
	local function v498(p87)
		if not p87 or not p87:IsA("BasePart") then
			return
		end
		p87.Material = Enum.Material.SmoothPlastic
		p87.Color = color3
		p87.CastShadow = false
	end
	local function v499(p88)
		if p88:IsA("ParticleEmitter") then
			p88.Enabled = false
			p88.Rate = 0
			pcall(function()
				p88:Clear()
			end)
		elseif p88:IsA("Trail") or p88:IsA("Beam") or p88:IsA("Smoke") or p88:IsA("Fire") or p88:IsA("Sparkles") or p88:IsA("PostEffect") or p88:IsA("Light") or p88:IsA("Highlight") or p88:IsA("Clouds") then
			p88.Enabled = false
		elseif p88:IsA("Atmosphere") then
			p88.Density = 0
			p88.Haze = 0
			p88.Glare = 0
		elseif p88:IsA("Explosion") then
			pcall(function()
				p88.Visible = false
			end)
		end
	end
	local function v500()
		if s2rHubConfig._fpsWorldReady then
			return true
		end
		local u501 = false
		local t20 = {}
		local ok, result = pcall(function()
			local function v505(p89)
				if v412(p89) then
					return
				end
				v498(p89)
				v499(p89)
			end
			local t21 = {
				workspace,
				game:GetService("Lighting")
			}
			for _, v in ipairs(t21) do
				table.insert(t20, v.DescendantAdded:Connect(function(descendant)
					task.defer(v505, descendant)
				end))
			end
			local t22 = {}
			for _, v in ipairs(t21) do
				for _, child in ipairs(v:GetChildren()) do
					table.insert(t22, child)
				end
			end
			local n11 = 0
			while #t22 > 0 do
				local v515 = table.remove(t22)
				v505(v515)
				for _, child in ipairs(v515:GetChildren()) do
					table.insert(t22, child)
				end
				n11 += 1
				if n11 >= 250 and #t22 > 0 then
					n11 = 0
					RunService.Heartbeat:Wait()
				end
			end
			u501 = true
		end)
		if ok then
			return u501
		end
		for _, v in ipairs(t20) do
			v:Disconnect()
		end
		warn("[FPSBoost] Gagal flatten material workspace:", result)
		return false
	end
	local function v520()
		if s2rHubConfig._fpsAreasReady then
			return true
		end
		local v521 = v14()
		local Areas = v521 and v521:FindFirstChild("Areas")
		local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
		local Build = v521 and v521:FindFirstChild("Build")
		if not GuardAreas or not Build then
			return false
		end
		for _, child in ipairs(GuardAreas:GetChildren()) do
			local RequiredSpeedSign = child:FindFirstChild("RequiredSpeedSign")
			if RequiredSpeedSign then
				pcall(function()
					RequiredSpeedSign:Destroy()
				end)
			end
		end
		local MainMap = Build:FindFirstChild("MainMap")
		local Bases = MainMap and MainMap:FindFirstChild("Bases")
		local function v530(p90)
			if Bases and p90:IsDescendantOf(Bases) then
				return p90.Size.Y <= 5 and not string.find(string.upper(p90.Name), "WALL", 1, true)
			end
			local Parent = p90
			while true do
				if not Parent or Parent == Build then
					return false
				end
				if not string.find(string.upper(Parent.Name), "BOTTOM", 1, true) then
					Parent = Parent.Parent
					continue
				end
				break
			end
			return true
		end
		local t23 = {
			"ENCHANTED",
			"FUSEBIOME",
			"WISP",
			"BUTTERFLY",
			"MARKERS",
			"PORTAL",
			"TRIGGER"
		}
		local function v533(p91)
			if p91:FindFirstChildOfClass("TouchTransmitter") or p91:FindFirstChildWhichIsA("ProximityPrompt", true) then
				return true
			end
			local Parent = p91
			while true do
				if not Parent then
					return false
				end
				if Parent == Build then
					return false
				end
				local v535 = string.upper(Parent.Name)
				for _, v in ipairs(t23) do
					if string.find(v535, v, 1, true) then
						return true
					end
				end
				Parent = Parent.Parent
			end
		end
		local function v538(p92)
			if not p92:IsA("BasePart") then
				return
			end
			if v533(p92) then
				return
			end
			if v530(p92) then
				v498(p92)
			else
				pcall(function()
					p92:Destroy()
				end)
			end
		end
		local connection = Build.DescendantAdded:Connect(function(descendant)
			task.defer(v538, descendant)
		end)
		local n12 = 0
		local fpsAreaDeleted = 0
		for _, descendant in ipairs(Build:GetDescendants()) do
			local v544 = descendant.Parent ~= nil
			v538(descendant)
			if v544 and descendant.Parent == nil then
				fpsAreaDeleted += 1
			end
			n12 += 1
			if n12 >= 250 then
				n12 = 0
				RunService.Heartbeat:Wait()
			end
		end
		s2rHubConfig._fpsAreaListener = connection
		s2rHubConfig._fpsAreaDeleted = fpsAreaDeleted
		s2rHubConfig._fpsAreasReady = true
		return true
	end
	local function v545()
		if s2rHubConfig._fpsPlotsReady then
			return true
		end
		local u546 = false
		local ok, result = pcall(function()
			local PlotState2 = require(game:GetService("ReplicatedStorage").Client.PlotState)
			if PlotState2.GetMySlot() == nil then
				warn("[FPSBoost] Slot plot kita belum ke-resolve, skip delete plot dulu (biar aman).")
				return
			end
			local function v550(p93)
				local v551 = PlotState2.GetMySlot()
				return v551 ~= nil and p93.Name == tostring(v551)
			end
			local Plots = PlotState2.GetPlotsFolder() or workspace:WaitForChild("Plots", 10)
			if not Plots then
				warn("[FPSBoost] workspace.Plots gak ketemu sama sekali.")
				return
			end
			local children = Plots:GetChildren()
			local n13 = 0
			for _, child in ipairs(children) do
				if not v550(child) and pcall(function()
					child:Destroy()
				end) then
					n13 += 1
				end
			end
			Plots.ChildAdded:Connect(function(child)
				task.defer(function()
					if child.Parent then
						if not v550(child) then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end)
			end)
			u546 = true
		end)
		if ok then
			return u546
		end
		warn("[FPSBoost] Gagal delete plot pemain lain:", result)
		return false
	end
	local function v557()
		if s2rHubConfig._fpsTreadmillsReady then
			return true
		end
		local u558 = false
		local ok, result = pcall(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
			local v563
			local Modules = ReplicatedStorage2.Client:FindFirstChild("Modules") or ReplicatedStorage2.Client:WaitForChild("Modules", 10)
			local RuntimeInstanceRegistry = Modules and (Modules:FindFirstChild("RuntimeInstanceRegistry") or Modules:WaitForChild("RuntimeInstanceRegistry", 10))
			if RuntimeInstanceRegistry then
				local ok, result = pcall(require, RuntimeInstanceRegistry)
				if ok then
					v563 = result
				end
			end
			local __ClientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders") or workspace:WaitForChild("__ClientTreadmillRenders", 10)
			if not __ClientTreadmillRenders then
				return
			end
			local function v569()
				local v570 = PlotState2.GetMySlot()
				if v570 == nil then
					return nil
				end
				local v571 = __ClientTreadmillRenders:FindFirstChild("TreadmillRender_" .. tostring(v570))
				if v571 then
					return v571
				end
				local Peek = v563 and (v563.Peek or v563.Get)
				if not Peek then
					return nil
				end
				local ok, result = pcall(Peek, "TreadmillPlotRender", tostring(v570))
				if ok then
					return result
				end
				return nil
			end
			local function v575(p94)
				local v576 = v569()
				if v576 and p94 == v576 then
					return true
				end
				local ok, result = pcall(function()
					return p94:GetPivot().Position
				end)
				if not ok then
					return true
				end
				local ok2, result2 = pcall(PlotState2.IsWorldPositionWithinLocalPlotBounds, result)
				local v581 = ok2 and result2
				return v581
			end
			local children = __ClientTreadmillRenders:GetChildren()
			local n14 = 0
			for _, child in ipairs(children) do
				if child:IsA("Model") and not v575(child) and pcall(function()
					child:Destroy()
				end) then
					n14 += 1
				end
			end
			__ClientTreadmillRenders.ChildAdded:Connect(function(child)
				task.defer(function()
					if child.Parent and child:IsA("Model") and not v575(child) then
						pcall(function()
							child:Destroy()
						end)
					end
				end)
			end)
			u558 = true
		end)
		if ok then
			return u558
		end
		warn("[FPSBoost] Gagal delete treadmill pemain lain:", result)
		return false
	end
	v391 = function()
		if u456 or s2rHubConfig._fpsBoostApplying then
			return
		end
		s2rHubConfig._fpsBoostApplying = true
		local ok, result = pcall(function()
			v489()
			s2rHubConfig._fpsPlotsReady = v545() == true
			s2rHubConfig._fpsTreadmillsReady = v557() == true
			s2rHubConfig._fpsAreasReady = v520() == true
			s2rHubConfig._fpsWorldReady = v500() == true
			s2rHubConfig._fpsPetsReady = v471() == true
			s2rHubConfig._fpsEggsReady = v462() == true
			u456 = s2rHubConfig._fpsEggsReady and s2rHubConfig._fpsPetsReady and s2rHubConfig._fpsWorldReady and s2rHubConfig._fpsPlotsReady and s2rHubConfig._fpsTreadmillsReady and s2rHubConfig._fpsAreasReady
		end)
		s2rHubConfig._fpsBoostApplying = nil
		if not ok then
			warn("[FPSBoost] Gagal menerapkan FPS Boost:", result)
		end
	end
end
local function v588(p95, p96, p97)
	local u589 = true
	pcall(function()
		local filterDescendantsInstances = { p97 }
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local v592 = p95
		for i = 1, 8 do
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			local v594 = p96 - v592
			if v594.Magnitude < 1 then
				break
			end
			local hit = workspace:Raycast(v592, v594, raycastParams)
			if not hit then
				break
			end
			if not hit.Instance.CanCollide then
				table.insert(filterDescendantsInstances, hit.Instance)
				v592 = hit.Position + v594.Unit * 0.1
				continue
			end
			u589 = false
			break
		end
	end)
	return u589
end
local t24 = {}
local ProximityPromptService = game:GetService("ProximityPromptService")
local t25 = {
	TITLES = {
		auto_steal = "Auto Steal",
		mech_boss = "Mech Boss",
		butterfly = "Butterfly Bloom",
		auto_place = "Auto Place",
		treadmill = "Treadmill"
	},
	ORDER = {
		"auto_steal",
		"mech_boss",
		"butterfly",
		"auto_place",
		"treadmill"
	}
}
do
	local function v599(p98)
		if p98 == "auto_steal" then
			local __S2rHubStealWantsCharacter = genv.__S2rHubStealWantsCharacter
			return __S2rHubStealWantsCharacter ~= nil and __S2rHubStealWantsCharacter() == true
		end
		if p98 ~= "mech_boss" then
			if p98 == "butterfly" then
				local __S2rHubButterflyRuntime = genv.__S2rHubButterflyRuntime
				return __S2rHubButterflyRuntime ~= nil and __S2rHubButterflyRuntime.wantsCharacter == true
			end
			if p98 == "auto_place" then
				return s2rHubConfig.IsPlacing == true
			end
			return false
		end
		if LocalPlayer:GetAttribute("InScrambleArena") == true then
			return true
		end
		if s2rHubConfig.ScrambleBossAuto ~= true then
			return false
		end
		local ScrambleArena = workspace:FindFirstChild("ScrambleArena")
		local v603 = workspace:FindFirstChild("ScrambleArenaPortal") ~= nil
		if not v603 then
			v603 = ScrambleArena ~= nil
			if v603 then
				v603 = tostring(ScrambleArena:GetAttribute("Phase") or "") ~= ""
			end
			v603 = v603 and ScrambleArena:GetAttribute("Phase") ~= "Defeated"
		end
		return v603
	end
	local function v604(p99)
		if p99 == "auto_steal" then
			local __S2rHubEggRuntime = genv.__S2rHubEggRuntime
			return __S2rHubEggRuntime ~= nil and __S2rHubEggRuntime.enabled == true and (__S2rHubEggRuntime.running == true or __S2rHubEggRuntime.carry ~= nil and __S2rHubEggRuntime.carry.active == true)
		end
		if p99 == "mech_boss" then
			return LocalPlayer:GetAttribute("InScrambleArena") == true
		end
		if p99 ~= "butterfly" then
			if p99 == "auto_place" then
				return s2rHubConfig.IsPlacing == true
			end
			return false
		end
		local __S2rHubButterflyRuntime = genv.__S2rHubButterflyRuntime
		return __S2rHubButterflyRuntime ~= nil and __S2rHubButterflyRuntime.active == true
	end
	t25.blocker = function(p100)
		if p100 ~= "mech_boss" and LocalPlayer:GetAttribute("InScrambleArena") == true then
			return "mech_boss"
		end
		for _, v in ipairs(t25.ORDER) do
			if v == p100 then
				return nil
			end
			if v599(v) then
				return v
			end
		end
		return nil
	end
	t25.holder = function(p101)
		for _, v in ipairs(t25.ORDER) do
			if v ~= p101 and v ~= "treadmill" then
				if v604(v) then
					return v
				end
			end
		end
		return nil
	end
end
local v611, v612, v613, v614, v615
do
	local function v616()
		local t26 = {}
		t26.__index = t26
		local t27 = {
			auto_place = true,
			auto_fuse = true,
			equip_best = true
		}
		local t28 = {
			auto_steal = 100,
			auto_hatch = 80,
			auto_place = 70,
			auto_fuse = 50,
			equip_best = 40,
			rewards = 20
		}
		local function v620(p102)
			local t29 = {}
			for k, v in pairs(p102) do
				t29[k] = v
			end
			return t29
		end
		t26.new = function()
			local obj = setmetatable({}, t26)
			obj.destroyed = false
			obj.active = nil
			obj.background = nil
			obj.reservations = {}
			obj.listeners = {}
			obj.backgroundListeners = {}
			obj.serial = 0
			return obj
		end
		t26._snapshot = function(p103)
			local active = p103.active
			return {
				busy = active ~= nil,
				operation = active and active.owner or nil,
				priority = active and active.priority or 0,
				reservedCount = active and #active.uids or 0,
				reservations = v620(p103.reservations)
			}
		end
		t26._emit = function(p104)
			local v626 = p104:_snapshot()
			for k in pairs(p104.listeners) do
				local ok, result = pcall(k, v626)
				if not ok then
					warn("[StealAnEgg] Coordinator listener failed:", result)
				end
			end
		end
		t26._emitBackground = function(p105)
			local background = p105.background
			local t30 = {
				busy = background ~= nil
			}
			local owner = background and background.owner
			t30.operation = owner or nil
			for k in pairs(p105.backgroundListeners) do
				local ok, result = pcall(k, t30)
				if not ok then
					warn("[StealAnEgg] Background coordinator listener failed:", result)
				end
			end
		end
		t26.subscribe = function(p106, p107)
			p106.listeners[p107] = true
			pcall(p107, p106:_snapshot())
			local function v636()
				p106.listeners[p107] = nil
			end
			return v636
		end
		t26.subscribeBackground = function(p108, p109)
			p108.backgroundListeners[p109] = true
			pcall(p109, {
				busy = p108.background ~= nil,
				operation = p108.background and p108.background.owner or nil
			})
			local function v637()
				p108.backgroundListeners[p109] = nil
			end
			return v637
		end
		t26.getSnapshot = function(p110)
			return p110:_snapshot()
		end
		t26.isBackgroundBusy = function(p111)
			return p111.background ~= nil
		end
		t26.isReserved = function(p112, p113, p114)
			local v638 = p112.reservations[p113]
			return v638 ~= nil and v638 ~= p114
		end
		t26.tryAcquire = function(p115, p116, p117, p118)
			if p115.destroyed then
				return nil, "Coordinator destroyed"
			end
			if type(p116) ~= "string" or p116 == "" then
				return nil, "Invalid operation owner"
			end
			if p115.active then
				return nil, "Busy: " .. p115.active.owner
			end
			if p115.background and t27[p116] then
				return nil, "Busy: background " .. p115.background.owner
			end
			local t31 = {}
			local t32 = {}
			local ipairs_ = ipairs
			local v642 = type(p117) == "table" and p117 or {}
			for _, v in ipairs_(v642) do
				if type(v) == "string" and v ~= "" and not t32[v] then
					if p115:isReserved(v, p116) then
						return nil, "UID reserved by " .. tostring(p115.reservations[v])
					end
					t32[v] = true
					table.insert(t31, v)
				end
			end
			p115.serial += 1
			local active = {
				id = p115.serial,
				lane = "foreground",
				owner = p116,
				priority = tonumber(p118) or t28[p116] or 0,
				uids = t31,
				released = false
			}
			p115.active = active
			for _, v in ipairs(t31) do
				p115.reservations[v] = p116
			end
			p115:_emit()
			return active
		end
		t26.tryAcquireBackground = function(p119, p120, p121)
			if p119.destroyed then
				return nil, "Coordinator destroyed"
			end
			if type(p120) ~= "string" or p120 == "" then
				return nil, "Invalid operation owner"
			end
			if p119.background then
				return nil, "Background busy: " .. p119.background.owner
			end
			if p119.active and t27[p119.active.owner] then
				return nil, "Foreground tool busy: " .. p119.active.owner
			end
			local t33 = {}
			local t34 = {}
			local ipairs_ = ipairs
			local v651 = type(p121) == "table" and p121 or {}
			for _, v in ipairs_(v651) do
				if type(v) == "string" and v ~= "" and not t34[v] then
					if p119:isReserved(v, p120) then
						return nil, "UID reserved by " .. tostring(p119.reservations[v])
					end
					t34[v] = true
					table.insert(t33, v)
				end
			end
			p119.serial += 1
			local background = {
				id = p119.serial,
				lane = "background",
				owner = p120,
				priority = 0,
				uids = t33,
				released = false
			}
			p119.background = background
			for _, v in ipairs(t33) do
				p119.reservations[v] = p120
			end
			p119:_emitBackground()
			return background
		end
		t26.release = function(p122, p123)
			if type(p123) ~= "table" or p123.released then
				return false
			end
			p123.released = true
			local ipairs_ = ipairs
			local uids = p123.uids or {}
			for _, uid in ipairs_(uids) do
				if p122.reservations[uid] == p123.owner then
					p122.reservations[uid] = nil
				end
			end
			local v661 = p122.active == p123
			if v661 then
				p122.active = nil
			elseif p122.background == p123 then
				p122.background = nil
				p122:_emitBackground()
			end
			if v661 then
				p122:_emit()
			end
			return true
		end
		t26.destroy = function(p124)
			if p124.destroyed then
				return
			end
			p124.destroyed = true
			if p124.active then
				p124:release(p124.active)
			end
			if p124.background then
				p124:release(p124.background)
			end
			table.clear(p124.reservations)
			table.clear(p124.listeners)
			table.clear(p124.backgroundListeners)
		end
		return t26
	end
	local v662 = v616()
	local function v663()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Areas = require(ReplicatedStorage2.Data.Areas)
		local Assets = require(ReplicatedStorage2.Data.Assets)
		local Guards = require(ReplicatedStorage2.Data.Guards)
		local Mutations = require(ReplicatedStorage2.Shared.Modules.Mutations)
		local t35 = {
			Common = 1,
			Uncommon = 2,
			Rare = 3,
			Epic = 4,
			Legendary = 5,
			Mythic = 6,
			Cosmic = 7,
			Secret = 8,
			Eternal = 9,
			Divine = 10
		}
		local function v670(p125)
			local t36 = {}
			local t37 = {}
			for _, v in ipairs(p125) do
				if type(v) == "string" and v ~= "" and not t36[v] then
					t36[v] = true
					table.insert(t37, v)
				end
			end
			table.sort(t37)
			return t37
		end
		return {
			rarityRank = function(p126)
				return t35[p126] or 0
			end,
			getRarities = function()
				local t38 = {}
				for k in pairs(Assets.ByRarity) do
					table.insert(t38, k)
				end
				table.sort(t38, function(p127, p128)
					local v677 = t35[p127] or 99
					local v678 = t35[p128] or 99
					if v677 == v678 then
						return tostring(p127) < tostring(p128)
					end
					return v677 < v678
				end)
				return t38
			end,
			getNames = function()
				local t39 = {}
				for _, v in pairs(Assets.Directory) do
					table.insert(t39, v.DisplayName or v._id)
				end
				return v670(t39)
			end,
			getAreas = function()
				local t40 = {}
				for k, v in pairs(Areas.Directory) do
					if type(k) == "string" and type(v) == "table" and type(v.DropTable) == "table" then
						table.insert(t40, k)
					end
				end
				table.sort(t40, function(p129, p130)
					local v685 = Guards.Directory[p129]
					local v686 = Guards.Directory[p130]
					local WalkSpeed = v685 and v685.WalkSpeed or math.huge
					local WalkSpeed2 = v686 and v686.WalkSpeed
					WalkSpeed2 = WalkSpeed2 or math.huge
					if WalkSpeed == WalkSpeed2 then
						return p129 < p130
					end
					return WalkSpeed < WalkSpeed2
				end)
				return t40
			end,
			getMutations = function()
				local t41 = {}
				local v690 = Mutations.Ids()
				local pairs_ = pairs
				local v692 = type(v690) == "table" and v690 or {}
				for k in pairs_(v692) do
					if type(k) == "string" and k ~= Mutations.NO_MUTATION then
						local ok, result = pcall(Mutations.LabelOf, k)
						table.insert(t41, ok and type(result) == "string" and result ~= "" and result or k)
					end
				end
				return v670(t41)
			end,
			resolveMutationId = function(p131)
				if type(p131) ~= "string" then
					return nil
				end
				if Mutations.IdSet[p131] then
					return p131
				end
				for k in pairs(Mutations.Ids()) do
					if k ~= Mutations.NO_MUTATION and Mutations.LabelOf(k) == p131 then
						return k
					end
				end
				return nil
			end,
			resolve = function(p132)
				local v697 = p132 and Assets.Directory[p132.AssetCategory]
				local Rarity = v697 and v697.Rarity
				local DisplayName = Rarity and (Rarity.DisplayName or Rarity._id) or "Unknown"
				return {
					name = v697 and (v697.DisplayName or v697._id) or p132 and p132.AssetCategory or "Unknown",
					category = p132 and p132.AssetCategory or "Unknown",
					rarity = DisplayName,
					rarityRank = t35[DisplayName] or 0,
					rarityColor = Rarity and Rarity.Color or nil,
					icon = v697 and type(v697.Icon) == "string" and v697.Icon or nil
				}
			end
		}
	end
	v611 = v663()
	local function v700(p133)
		if not p133 then
			return nil
		end
		for _, descendant in ipairs(p133:GetDescendants()) do
			if not descendant:IsA("ModuleScript") or not (descendant.Name == "Limits" and descendant.Parent) then
				continue
			end
			if not descendant.Parent:FindFirstChild("Surface") then
				continue
			end
			if descendant.Parent:FindFirstChild("Runtime") then
				return descendant
			end
		end
		return nil
	end
	local v703 = v700(LocalPlayer:FindFirstChildOfClass("PlayerScripts")) or v700(game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"))
	local function v704()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local RunService2 = game:GetService("RunService")
		local LocalPlayer2 = Players2.LocalPlayer
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local EggWorld = Remotes.EggWorld
		local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
		local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)
		local AreaEggResetWall3 = require(ReplicatedStorage2.Client.AreaEggResetWall)
		local SpeedPowerProjection = require(ReplicatedStorage2.Client.SpeedPowerProjection)
		local TreadmillUtil = require(ReplicatedStorage2.Shared.Util.TreadmillUtil)
		local EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
		local AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
		local Save = require(ReplicatedStorage2.Shared.Save)
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
		local function v721()
			return genv.__S2rHubAdminBoost == true and 3000 or 1000
		end
		local t42 = {
			Divine = true,
			Eternal = true
		}
		local t43 = {
			"LastObservedSample",
			"LastSample",
			"LastGoodSample",
			"LastGameplayTrustedSample",
			"LastValidatedSample",
			"LastValidatedGroundedSample",
			"LastConfirmedGroundSample",
			"CandidateGroundedSample"
		}
		local vector32 = Vector3.new(544.76, 71.5, -416.48)
		local t44 = {
			-364.3,
			-367.21,
			-371.12,
			-375.65
		}
		cFrameNew(599.8, 113.5, -325)
		Vector3.new(599.8, 70, -325)
		local cFrame = cFrameNew(616.749, 71.667, -395.585)
		local t45 = {
			Script = true,
			LocalScript = true,
			BillboardGui = true,
			Sound = true
		}
		local t46 = {}
		t46.__index = t46
		local Stats = game:GetService("Stats")
		local function v730(p134, p135)
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			if HumanoidRootPart then
				pcall(function()
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			local n15 = 0
			pcall(function()
				n15 = Stats.Network.ServerStats.Ping:GetValue()
			end)
			task.wait(math.max(0.3, n15 * 2.5 / 1000))
			local t47 = {
				Uid = p134
			}
			if p135 ~= nil then
				t47.FirstAreaSlotKey = p135
			end
			local response, v735 = EggWorld.AskFieldEggCarry:InvokeServer(t47)
			local v736 = response == true
			local v737 = typeof(v735) == "string" and v735 or nil
			return v736, v737
		end
		local function v738(p136, p137, p138)
			local connection = p136:Connect(p137)
			table.insert(p138, connection)
			return connection
		end
		local function v740(p139)
			for _, v in ipairs(p139) do
				pcall(v.Disconnect, v)
			end
			table.clear(p139)
		end
		local function v743(p140, p141)
			local ipairs_ = ipairs
			local v745 = p140 or {}
			for _, v in ipairs_(v745) do
				if v == p141 then
					return true
				end
			end
			return false
		end
		local v748
		local function v749(p142, p143)
			if type(p142) ~= "function" or type(debug) ~= "table" or type(debug.getconstants) ~= "function" then
				return false
			end
			local ok, result = pcall(debug.getconstants, p142)
			if not ok or type(result) ~= "table" then
				return false
			end
			local t48 = {}
			for _, v in ipairs(result) do
				if type(v) == "string" then
					t48[v] = true
				end
			end
			for _, v in ipairs(p143) do
				if not t48[v] then
					return false
				end
			end
			return true
		end
		local function v757(p144)
			if type(p144) ~= "function" or type(debug) ~= "table" or type(debug.info) ~= "function" then
				return ""
			end
			local ok, result = pcall(debug.info, p144, "s")
			return ok and tostring(result) or ""
		end
		local function v760(p145)
			local HumanoidRootPart = p145 and p145:FindFirstChild("HumanoidRootPart")
			if HumanoidRootPart then
				HumanoidRootPart:SetAttribute("KillPartIgnore", true)
			end
		end
		local function v762(p146)
			local Humanoid = p146 and p146:FindFirstChildOfClass("Humanoid")
			if not Humanoid or not Humanoid.Parent then
				return false
			end
			pcall(function()
				Humanoid.BreakJointsOnDeath = false
			end)
			local clone = Humanoid:Clone()
			Humanoid:Destroy()
			clone.Parent = p146
			local CurrentCamera = workspace.CurrentCamera
			if CurrentCamera then
				CurrentCamera.CameraSubject = clone
			end
			local Animate = p146:FindFirstChild("Animate")
			if Animate then
				local clone2 = Animate:Clone()
				Animate:Destroy()
				clone2.Parent = p146
			end
			pcall(function()
				clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				clone:ChangeState(Enum.HumanoidStateType.Running)
			end)
			return true
		end
		local function v768(p147)
			if p147._healthPinner then
				pcall(p147._healthPinner.Disconnect, p147._healthPinner)
				p147._healthPinner = nil
			end
			if p147._healthChangedConnection then
				pcall(p147._healthChangedConnection.Disconnect, p147._healthChangedConnection)
				p147._healthChangedConnection = nil
			end
		end
		local function v769(p148, p149)
			v768(p148)
			local Humanoid = p149 and p149:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = p149 and p149:FindFirstChild("HumanoidRootPart")
			if not Humanoid then
				return false
			end
			local health = math.max(Humanoid.MaxHealth, 100)
			local u773 = false
			local n16 = 0
			local function v775()
				if u773 or p148.destroyed or LocalPlayer2.Character ~= p149 or not Humanoid.Parent then
					return
				end
				local now = os.clock()
				if now - n16 < 0.1 and Humanoid.Health > 0 and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
					return
				end
				n16 = now
				u773 = true
				pcall(function()
					Humanoid.BreakJointsOnDeath = false
					Humanoid.RequiresNeck = false
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					if Humanoid.Health <= 0 then
						Humanoid.Health = health
					end
					if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
						Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
					if HumanoidRootPart and HumanoidRootPart.Parent == p149 and HumanoidRootPart.Anchored then
						HumanoidRootPart.Anchored = false
					end
				end)
				u773 = false
			end
			v775()
			p148._healthChangedConnection = Humanoid.HealthChanged:Connect(function(health2)
				if health2 <= 0 or health2 < health then
					v775()
				end
			end)
			p148._healthPinner = RunService2.Heartbeat:Connect(v775)
			return true
		end
		local function v777(p150)
			local Humanoid = p150 and p150:FindFirstChildOfClass("Humanoid")
			if not Humanoid then
				return
			end
			pcall(function()
				Humanoid.BreakJointsOnDeath = false
				Humanoid.RequiresNeck = false
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			end)
		end
		local function v779(p151)
			local Humanoid = p151 and p151:FindFirstChildOfClass("Humanoid")
			if not Humanoid then
				return
			end
			pcall(function()
				if Humanoid.Health <= 0 then
					Humanoid.Health = math.max(Humanoid.MaxHealth, 1)
				end
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				Humanoid.BreakJointsOnDeath = true
				Humanoid.RequiresNeck = true
			end)
		end
		local function v781()
			return getgenv and getgenv() or _G
		end
		local function v782()
			if type(getconnections) ~= "function" or type(debug) ~= "table" or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
				return false
			end
			local ok, result = pcall(getconnections, LocalPlayer2.Idled)
			if not (ok and type(result) == "table") then
				return false
			end
			for _, v in ipairs(result) do
				local Function = v.Function
				if type(Function) == "function" and type(v.Disable) == "function" then
					local ok2, result2 = pcall(debug.info, Function, "s")
					local ok3, result3 = pcall(debug.getupvalue, Function, 1)
					if not ok2 or not (type(result2) == "string" and result2:sub(-27) == ".PlayerScripts.Game.AntiAFK" and ok3) then
						continue
					end
					if type(result3) == "number" then
						return (pcall(v.Disable, v))
					end
				end
			end
			return false
		end
		local function v792()
			local v793 = v781()
			local __S2rHubStealAnEggMovementSpoof = v793.__S2rHubStealAnEggMovementSpoof
			if type(__S2rHubStealAnEggMovementSpoof) ~= "table" or __S2rHubStealAnEggMovementSpoof.Version ~= 436 then
				if type(__S2rHubStealAnEggMovementSpoof) == "table" then
					__S2rHubStealAnEggMovementSpoof.Enabled = false
				end
				__S2rHubStealAnEggMovementSpoof = {
					Version = 436,
					Installed = false,
					Enabled = false,
					Mode = "StateBaseline",
					Humanoid = nil,
					RootPart = nil,
					WalkSpeed = 600
				}
				v793.__S2rHubStealAnEggMovementSpoof = __S2rHubStealAnEggMovementSpoof
			end
			return __S2rHubStealAnEggMovementSpoof
		end
		local function v795(p152, p153)
			local v796 = v792()
			if not v796 then
				return false
			end
			local Humanoid = p152 and p152:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = p152 and p152:FindFirstChild("HumanoidRootPart")
			v796.Humanoid = Humanoid
			v796.RootPart = HumanoidRootPart
			v796.WalkSpeed = math.clamp(tonumber(p153) or 600, 200, 1350)
			v796.Enabled = false
			return Humanoid ~= nil and HumanoidRootPart ~= nil
		end
		local function v799()
			local __S2rHubStealAnEggMovementSpoof = v781().__S2rHubStealAnEggMovementSpoof
			if type(__S2rHubStealAnEggMovementSpoof) == "table" then
				__S2rHubStealAnEggMovementSpoof.Enabled = false
				__S2rHubStealAnEggMovementSpoof.Humanoid = nil
				__S2rHubStealAnEggMovementSpoof.RootPart = nil
			end
		end
		local function v801(p154, p155, p156)
			local u802
			if type(getcallbackvalue) == "function" then
				if type(debug) == "table" and type(debug.getupvalue) == "function" then
					local Signal = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Signal")
					if Signal then
						local ok, result = pcall(require, Signal)
						if ok and type(result) == "table" and type(result.Invoked) == "function" then
							local ok2, result2 = pcall(result.Invoked, "ClientCharacter: GetDebugSnapshot")
							if ok2 and result2 then
								local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")
								if ok3 and type(result3) == "function" then
									local ok4, result4 = pcall(debug.getinfo, result3)
									if ok4 then
										local function v812(p157, p158, p159)
											if u802 or type(p157) ~= "table" or p158 > 3 or p159[p157] then
												return
											end
											p159[p157] = true
											if rawget(p157, "Player") == p154 and rawget(p157, "Character") == p154.Character and rawget(p157, "Humanoid") == p155 and rawget(p157, "RootPart") == p156 and type(rawget(p157, "SampleHistory")) == "table" and type(rawget(p157, "Evidence")) == "table" then
												u802 = p157
												return
											end
											local n17 = 0
											for _, v in pairs(p157) do
												n17 += 1
												if n17 > 128 then
													break
												end
												if type(v) == "table" then
													v812(v, p158 + 1, p159)
												end
											end
										end
										local n18 = 1
										local nups = result4.nups or 0
										for i = n18, nups do
											local ok5, result5 = pcall(debug.getupvalue, result3, i)
											if not ok5 or type(result5) ~= "table" then
												continue
											end
											v812(result5, 0, {})
											if u802 then
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if not u802 and type(getgc) == "function" then
				local ok, result = pcall(getgc, true)
				if ok and type(result) == "table" then
					for _, v in ipairs(result) do
						if type(v) == "table" and rawget(v, "Player") == p154 and rawget(v, "Character") == p154.Character and rawget(v, "Humanoid") == p155 and rawget(v, "RootPart") == p156 and type(rawget(v, "SampleHistory")) == "table" and type(rawget(v, "Evidence")) == "table" then
							u802 = v
							break
						end
					end
				end
			end
			return u802
		end
		local t49 = {
			busy = false,
			nextAt = 0,
			misses = 0,
			found = nil
		}
		local function v826(p160, p161, p162)
			local found = t49.found
			if type(found) == "table" and rawget(found, "Player") == p160 and rawget(found, "Character") == p160.Character and rawget(found, "Humanoid") == p161 and rawget(found, "RootPart") == p162 then
				return found
			end
			if t49.busy or os.clock() < t49.nextAt then
				return nil
			end
			t49.busy = true
			task.spawn(function()
				task.wait()
				local ok, result = pcall(v801, p160, p161, p162)
				local v830 = ok and result or nil
				t49.found = v830
				t49.misses = v830 and 0 or t49.misses + 1
				t49.nextAt = os.clock() + (v830 and 0.2 or t49.misses >= 5 and 10 or 1)
				t49.busy = false
			end)
			return nil
		end
		local function v831(p163, p164, p165)
			if type(p163) ~= "table" then
				return false
			end
			local value = rawget(p163, "RootPart")
			local CFrame_2 = value and value.Parent and value.CFrame
			CFrame_2 = CFrame_2 or nil
			local Position = CFrame_2 and CFrame_2.Position or nil
			local vector33 = typeof(p165) == "Vector3" and p165 or Vector3.zero
			local function v836(p166)
				if type(p166) == "table" then
					rawset(p166, "WalkSpeed", p164)
					if CFrame_2 then
						rawset(p166, "CFrame", CFrame_2)
						rawset(p166, "Position", Position)
						rawset(p166, "LinearVelocity", vector33)
						rawset(p166, "AngularVelocity", Vector3.zero)
					end
				end
			end
			for _, v in ipairs(t43) do
				v836(rawget(p163, v))
			end
			local pairs_ = pairs
			local v840 = rawget(p163, "SampleHistory") or {}
			for _, v in pairs_(v840) do
				v836(v)
			end
			local pairs_2 = pairs
			local v844 = rawget(p163, "SafeGroundCheckpoints") or {}
			for _, v in pairs_2(v844) do
				v836(v)
			end
			local value2 = rawget(p163, "Evidence")
			if type(value2) == "table" then
				value2.Speed = 0
				value2.Teleport = 0
				value2.Flight = 0
			end
			local value3 = rawget(p163, "ImpulseContext")
			if type(value3) == "table" then
				local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, p164)
				local v850 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), 0.15)
				value3.MaxHorizontalSpeed = maxHorizontalSpeed
				if Position then
					value3.OriginPosition = Position
				end
				value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * v850 + 48)
				v836(value3.PreMovementSafeSample)
			end
			if rawget(p163, "CorrectionContext") == nil then
				rawset(p163, "FirstSuspiciousAt", nil)
				if rawget(p163, "ThreatLevel") == "Observing" then
					rawset(p163, "ThreatLevel", "Trusted")
				end
			end
			return true
		end
		local function v851()
			local v852 = v781()
			local __S2rHubStealAnEggIntegritySpoof = v852.__S2rHubStealAnEggIntegritySpoof
			if type(__S2rHubStealAnEggIntegritySpoof) ~= "table" then
				__S2rHubStealAnEggIntegritySpoof = {}
				v852.__S2rHubStealAnEggIntegritySpoof = __S2rHubStealAnEggIntegritySpoof
			end
			return __S2rHubStealAnEggIntegritySpoof
		end
		local function v854(p167, p168, p169)
			return type(p167) == "table" and rawget(p167, "Player") == LocalPlayer2 and rawget(p167, "Character") == LocalPlayer2.Character and rawget(p167, "Humanoid") == p168 and rawget(p167, "RootPart") == p169
		end
		local function v855(p170, p171, p172)
			return v854(p170, p171, p172)
		end
		local function v856(p173, p174, p175)
			local v857 = v851()
			local State = v857.State
			if not v854(State, p173, p174) then
				local now = os.clock()
				if now < (v857.NextSearchAt or 0) then
					return false
				end
				v857.NextSearchAt = now + 0.2
				State = v826(LocalPlayer2, p173, p174)
			end
			if not State then
				return false
			end
			if not v855(State, p173, p174) then
				v857.Enabled = false
				v857.Humanoid = p173
				v857.RootPart = p174
				v857.State = State
				return false
			end
			v857.NextSearchAt = 0
			v857.Enabled = true
			v857.Humanoid = p173
			v857.RootPart = p174
			v857.State = State
			v857.WalkSpeed = math.clamp(p175 * 1.35, 200, 1350)
			v857.TravelVelocity = Vector3.zero
			v831(State, v857.WalkSpeed, v857.TravelVelocity)
			return true
		end
		local function v860(p176, p177, p178, p179)
			local __S2rHubStealAnEggIntegritySpoof = v781().__S2rHubStealAnEggIntegritySpoof
			if type(__S2rHubStealAnEggIntegritySpoof) ~= "table" or not __S2rHubStealAnEggIntegritySpoof.Enabled or __S2rHubStealAnEggIntegritySpoof.Humanoid ~= p176 or __S2rHubStealAnEggIntegritySpoof.RootPart ~= p177 or not v855(__S2rHubStealAnEggIntegritySpoof.State, p176, p177) then
				return false
			end
			__S2rHubStealAnEggIntegritySpoof.WalkSpeed = math.clamp(p178 * 1.35, 200, 1350)
			if typeof(p179) == "Vector3" then
				__S2rHubStealAnEggIntegritySpoof.TravelVelocity = p179
			elseif typeof(__S2rHubStealAnEggIntegritySpoof.TravelVelocity) ~= "Vector3" then
				__S2rHubStealAnEggIntegritySpoof.TravelVelocity = Vector3.zero
			end
			return v831(__S2rHubStealAnEggIntegritySpoof.State, __S2rHubStealAnEggIntegritySpoof.WalkSpeed, __S2rHubStealAnEggIntegritySpoof.TravelVelocity)
		end
		local function v862(p180)
			local __S2rHubStealAnEggIntegritySpoof = v781().__S2rHubStealAnEggIntegritySpoof
			if type(__S2rHubStealAnEggIntegritySpoof) ~= "table" then
				return
			end
			if p180 == nil or __S2rHubStealAnEggIntegritySpoof.Humanoid == p180 then
				__S2rHubStealAnEggIntegritySpoof.Enabled = false
				__S2rHubStealAnEggIntegritySpoof.Humanoid = nil
				__S2rHubStealAnEggIntegritySpoof.RootPart = nil
				__S2rHubStealAnEggIntegritySpoof.State = nil
				__S2rHubStealAnEggIntegritySpoof.TravelVelocity = nil
				__S2rHubStealAnEggIntegritySpoof.NextSearchAt = 0
			end
		end
		local function v864(p181, p182)
			if #p182 == 0 then
				return true
			end
			local ipairs_ = ipairs
			local Mutations = p181.Mutations or {}
			for _, Mutation in ipairs_(Mutations) do
				if v743(p182, Mutation) then
					return true
				end
			end
			return p181.BaseMutation ~= nil and v743(p182, p181.BaseMutation)
		end
		local function v869()
			local v870 = TreadmillUtil.SpeedPowerToWalkSpeed(SpeedPowerProjection.ReadProjected())
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			return math.clamp(math.min(v870, Humanoid and Humanoid.WalkSpeed or v870), 200, 1000)
		end
		t46.new = function(p183, p184, p185)
			local obj = setmetatable({}, t46)
			obj.catalog = p183
			obj.limitsModule = p184
			obj.coordinator = p185
			obj.operationToken = nil
			obj.connections = {}
			obj.listeners = {}
			obj.records = {}
			obj.enabled = false
			obj.userStealEnabled = false
			obj.skippedEggs = {}
			obj.riftWants = {}
			obj.riftOnly = false
			obj.indexObjectiveEnabled = false
			obj.wispObjective = nil
			obj.manualObjectiveEnabled = false
			obj.manualQueue = {}
			obj.manualOrder = {}
			obj.indexCache = {
				at = 0,
				set = {}
			}
			obj.running = false
			obj.safeStarting = false
			obj.movementRetryPending = false
			obj.destroyed = false
			obj.resetBlocked = AreaEggResetWall3.IsSealed()
			obj.gateOpenAt = obj.resetBlocked and math.huge or os.clock()
			obj.activeTween = nil
			obj.activeTarget = nil
			obj.claimPresentationNode = nil
			obj.claimPresentationOriginal = nil
			obj.claimPresentationSuppression = nil
			obj.carry = {
				active = false,
				uid = nil,
				generation = 0
			}
			obj.carryWorker = nil
			obj.tweenRecoveryUid = nil
			obj.planGeneration = 0
			obj.treadmillDecoy = nil
			obj.treadmillDecoyCamera = nil
			obj.treadmillDecoyCameraConnection = nil
			obj.treadmillDecoyCharacterConnection = nil
			obj.treadmillPopupConnection = nil
			obj.treadmillDecoyRealTransparency = nil
			obj.hoverPadOwnerId = string.format("%s:%0.6f", tostring(obj), os.clock())
			obj.instantPhase = nil
			obj.primerUid = nil
			obj.primerUids = {}
			obj.targetUid = nil
			obj.hitTimer = nil
			obj.guardHitBoostInstalled = false
			obj.stats = {
				status = obj.resetBlocked and "Reset wall closed" or "Ready",
				available = 0,
				matching = 0,
				lastTarget = "None",
				lastResult = "Idle"
			}
			obj.config = {
				stealMode = "Fly",
				flyAerial = false,
				flyZigzag = false,
				speed = 600,
				antiTrap = true,
				heaviestFirst = false,
				highestValueFirst = false,
				minWeightKg = 0,
				espEnabled = false,
				espRarity = true,
				espName = true,
				espKg = true,
				espMutation = true,
				espValue = true,
				espPlaced = false,
				espIcon = true,
				espMinRank = 0,
				espMinValue = 0,
				minValuePerSec = 0,
				rarityEnabled = false,
				rarities = {},
				nameEnabled = false,
				names = {},
				areaEnabled = false,
				areas = {},
				mutationEnabled = false,
				mutations = {}
			}
			obj.gameAntiAfkDisabled = v782()
			if LocalPlayer2.Character then
				v760(LocalPlayer2.Character)
				local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					pcall(function()
						Humanoid.BreakJointsOnDeath = false
						Humanoid.RequiresNeck = false
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					end)
				end
				v769(obj, LocalPlayer2.Character)
			end
			local ok, result = pcall(function()
				return require(ReplicatedStorage2.Shared.Util.EggRecords)
			end)
			obj.weightUtil = ok and type(result.WeightKgForScale) == "function" and result or nil
			local function v877(p186)
				if not p186 then
					return
				end
				v738(p186.DescendantAdded, function(p187)
					if obj.config.antiTrap then
						obj:_purgeTrap(p187)
					end
				end, obj.connections)
			end
			v877(workspace:FindFirstChild("Transient"))
			v877(workspace:FindFirstChild("__DEBRIS"))
			if obj.config.antiTrap then
				obj:_purgeTraps()
			end
			v738(workspace.ChildAdded, function(p188)
				if p188.Name == "Transient" or p188.Name == "__DEBRIS" then
					v877(p188)
					if obj.config.antiTrap then
						obj:_purgeTraps()
					end
				end
			end, obj.connections)
			obj:_replaceSnapshot(EggState2.ReadFieldEggs())
			v738(EggState2.FieldRefreshed, function(p189)
				obj:_replaceSnapshot(p189)
			end, obj.connections)
			v738(EggState2.FieldShifted, function(p190)
				obj.records[p190.Uid] = p190
				obj:_refreshCounts()
				if obj.enabled and not obj.destroyed and not obj.running and not obj.carry.active and (p190.State == AreaEggs.States.Slot or p190.State == AreaEggs.States.Dropped) and not obj._shiftWakePending then
					obj._shiftWakePending = true
					task.delay(0.25, function()
						obj._shiftWakePending = nil
						if not obj.destroyed and obj.enabled then
							if not obj.running then
								obj:_schedule()
							end
						end
					end)
				end
			end, obj.connections)
			v738(EggState2.FieldGone, function(p191)
				obj.records[p191] = nil
				if obj.activeTarget and obj.activeTarget.Uid == p191 then
					if obj.carry.active and obj.carry.uid == p191 then
						obj:_refreshCounts()
						return
					end
					obj.carryAttemptToken = nil
					obj:_clearArrivalHold(p191)
					if obj.activeTween and obj.activeTween.Cancel then
						pcall(obj.activeTween.Cancel, obj.activeTween)
					end
					local activeTarget = obj.activeTarget
					task.delay(0.65, function()
						if obj.destroyed or not obj.enabled then
							return
						end
						if obj.carry.active and obj.carry.uid == p191 then
							return
						end
						if obj.activeTarget == activeTarget and activeTarget.Uid == p191 then
							obj:_finish("Target removed — continuing")
						end
					end)
				end
				obj:_refreshCounts()
			end, obj.connections)
			v738(EggState2.ResetCountdown, function()
				obj:_closeGate("Egg reset countdown")
			end, obj.connections)
			v738(EggState2.ResetFade, function()
				obj:_closeGate("Egg reset teleport")
			end, obj.connections)
			v738(AreaEggResetWall3.Changed, function(p192)
				if p192 then
					obj:_closeGate("Reset wall closed")
				else
					obj.resetBlocked = false
					obj.gateOpenAt = os.clock()
					obj.safeStarting = false
					obj.running = false
					obj:_setStatus(obj.enabled and "Searching" or "Ready")
					obj:_schedule()
				end
			end, obj.connections)
			v738(LocalPlayer2.CharacterRemoving, function()
				obj._recalling = nil
				obj:_cleanupInstantSteal()
				obj:_hideTreadmillDecoy()
				obj._forestDropInProgress = nil
				obj._instantReturnToken = nil
				local carry = obj.carry
				carry.generation += 1
				obj:_invalidateCarryWorker()
				obj.carry.active = false
				obj.carry.uid = nil
				obj.safeStarting = false
				obj.planGeneration += 1
				obj:_cancelTween("Character resetting")
				obj:_stopMovementProtection()
			end, obj.connections)
			v738(RunService2.Heartbeat, function()
				if obj.destroyed then
					return
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then
					return
				end
				local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local WalkSpeed = Humanoid and Humanoid.WalkSpeed or 0
				local vector33 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
				local Magnitude = vector33.Magnitude
				if math.max(400, WalkSpeed * 1.5) < Magnitude or math.abs(AssemblyLinearVelocity.Y) > 400 then
					local v887 = math.max(100, WalkSpeed)
					if v887 < vector33.Magnitude then
						vector33 = vector33.Unit * v887
					end
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector33.X, math.clamp(AssemblyLinearVelocity.Y, -100, 100), vector33.Z)
				end
			end, obj.connections)
			v738(LocalPlayer2.CharacterAdded, function(p193)
				obj:_hideTreadmillDecoy()
				v760(p193)
				local Humanoid = p193:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					pcall(function()
						Humanoid.BreakJointsOnDeath = false
						Humanoid.RequiresNeck = false
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					end)
				end
				v769(obj, p193)
				task.delay(0.25, function()
					if not obj.destroyed and obj.enabled then
						obj:_startMovementProtection()
					end
				end)
				task.delay(1, function()
					if not obj.destroyed and obj.enabled and obj:_wallOpen() then
						obj:_schedule()
					end
				end)
			end, obj.connections)
			obj:_installClaimPresentationFilter()
			v738(EggState2.CarryChanged, function(p194)
				if p194.IsCarrying then
					if obj.running then
						if obj.activeTarget and p194.Uid == obj.activeTarget.Uid then
							if obj.carry.active and obj.carry.uid == p194.Uid then
								return
							end
							if obj.instantPhase == "priming" and p194.Uid == obj.primerUid then
								obj.carry.active = true
								obj.carry.uid = p194.Uid
								obj:_clearArrivalHold(p194.Uid)
								obj:_enterBaitWait()
								return
							end
							local carry = obj.carry
							carry.generation += 1
							obj:_invalidateCarryWorker()
							obj:_clearArrivalHold(p194.Uid)
							obj.claimPresentationSuppression = {
								assetCategory = obj.activeTarget.AssetCategory,
								expiresAt = os.clock() + 8
							}
							obj.carry.active = true
							obj.carry.uid = p194.Uid
							obj.carryStartTime = os.clock()
							obj.carryStartPos = obj.activeTarget and obj.activeTarget.BottomCFrame and obj.activeTarget.BottomCFrame.Position or LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer2.Character.HumanoidRootPart.Position
							if obj.tweenRecoveryUid == p194.Uid then
								obj.tweenRecoveryUid = nil
							end
							if obj.carryTimeouts then
								obj.carryTimeouts[p194.Uid] = nil
							end
							obj.stats.lastResult = "Carry confirmed"
							obj:_notify()
							obj.carryAttemptToken = nil
							if obj.activeTween and obj.activeTween.Cancel then
								pcall(obj.activeTween.Cancel, obj.activeTween)
							end
							task.defer(function()
								if not obj.destroyed and obj.enabled and obj.carry.uid == p194.Uid and obj:_hasConfirmedCarry(p194.Uid) then
									if genv.__S2rHubGodMode then
										genv.__S2rHubGodMode:stopDefend()
									end
									obj:_returnToSafe()
								end
							end)
						end
					end
					return
				end
				if obj.carry.uid ~= nil and p194.Uid ~= nil and p194.Uid ~= obj.carry.uid then
					return
				end
				local Uid = p194.Uid or obj.carry.uid
				Uid = Uid or obj.activeTarget and obj.activeTarget.Uid
				local active = obj.carry.active
				local carry = obj.carry
				carry.generation += 1
				local generation = obj.carry.generation
				obj:_invalidateCarryWorker()
				if obj.activeTween and obj.activeTween.Cancel then
					pcall(obj.activeTween.Cancel, obj.activeTween)
				end
				obj.carry.active = false
				obj.carry.uid = nil
				if genv.__S2rHubGodMode then
					genv.__S2rHubGodMode:startDefend(Uid)
				end
				if obj._captureHoldUid ~= nil and Uid == obj._captureHoldUid or obj._adminBusyUid ~= nil and Uid == obj._adminBusyUid then
					return
				end
				if obj.instantPhase == "priming" and (p194.Uid == obj.primerUid or Uid == obj.primerUid) then
					obj:_startPrimerTargetHunt()
					return
				end
				if obj._forestDropInProgress ~= nil and Uid == obj._forestDropInProgress then
					return
				end
				if not active then
					return
				end
				if not obj.running or not obj.activeTarget then
					return
				end
				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart or not obj:_isInSafeArea(HumanoidRootPart) then
					task.delay(0.03, function()
						if not obj.destroyed then
							if obj.enabled and not obj.carry.active and obj.carry.generation == generation then
								if LocalPlayer2.Character then
									local HumanoidRootPart2 = LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
									if HumanoidRootPart2 and obj:_isInSafeArea(HumanoidRootPart2) then
										obj:_reportStolen()
										obj:_finish("Safe return complete")
										return
									end
								end
								obj:_reStealDroppedEgg(Uid)
								return
							end
						end
					end)
					return
				end
				obj:_reportStolen()
				obj:_finish("Safe return complete")
			end, obj.connections)
			v738(LocalPlayer2:GetAttributeChangedSignal("RagdollEndTime"), function()
				local attribute = LocalPlayer2:GetAttribute("RagdollEndTime") or 0
				if obj.instantPhase == "priming" and workspace:GetServerTimeNow() < attribute then
					obj:_startPrimerTargetHunt()
				end
			end, obj.connections)
			v738(RunService2.Heartbeat, function()
				if obj.destroyed then
					return
				end
				local now = os.clock()
				if now - (obj._espLastTick or 0) < 0.4 then
					return
				end
				obj._espLastTick = now
				local ok2, result2 = pcall(function()
					obj:_updateEsp()
				end)
				if not ok2 then
					if now - (obj._espErrLast or 0) > 5 then
						obj._espErrLast = now
						warn("[SAE][esp] update error: " .. tostring(result2))
					end
				end
			end, obj.connections)
			obj.stats.status = obj.stats.status
			return obj
		end
		t46._installClaimPresentationFilter = function()
			return false
		end
		t46._restoreClaimPresentationFilter = function(p195)
			local claimPresentationNode = p195.claimPresentationNode
			local claimPresentationOriginal = p195.claimPresentationOriginal
			if type(claimPresentationNode) == "table" and type(claimPresentationOriginal) == "function" and rawget(claimPresentationNode, "_fn") == p195.claimPresentationWrapper then
				claimPresentationNode._fn = claimPresentationOriginal
			end
			p195.claimPresentationNode = nil
			p195.claimPresentationOriginal = nil
			p195.claimPresentationWrapper = nil
			p195.claimPresentationSuppression = nil
		end
		t46._setStatus = function(p196, p197)
			if p196.stats.status == p197 then
				return
			end
			if type(p197) == "string" and string.find(p197, "not currently trusted", 1, true) then
				p196._untrustedSeen = true
			end
			p196.stats.status = p197
			p196:_notify()
		end
		t46._notify = function(p198)
			local v902 = p198:getSnapshot()
			for k in pairs(p198.listeners) do
				local ok, result = pcall(k, v902)
				if not ok then
					warn("[StealAnEgg] UI listener failed:", result)
				end
			end
		end
		t46.onChanged = function(p199, p200)
			p199.listeners[p200] = true
			local ok, result = pcall(p200, p199:getSnapshot())
			if not ok then
				warn("[StealAnEgg] UI listener failed:", result)
			end
			local function v908()
				p199.listeners[p200] = nil
			end
			return v908
		end
		t46.getSnapshot = function(p201)
			return {
				status = p201.stats.status,
				available = p201.stats.available,
				matching = p201.stats.matching,
				lastTarget = p201.stats.lastTarget,
				lastResult = p201.stats.lastResult,
				wallClosed = p201.resetBlocked or AreaEggResetWall3.IsSealed() or os.clock() < p201.gateOpenAt,
				enabled = p201.enabled,
				running = p201.running
			}
		end
		t46._replaceSnapshot = function(p202, p203)
			table.clear(p202.records)
			local Records = p203 and (p203.Records or p203) or {}
			for k, Record in pairs(Records) do
				if type(Record) == "table" and type(Record.Uid) == "string" then
					p202.records[Record.Uid] = Record
				elseif type(k) == "string" and type(Record) == "table" then
					p202.records[k] = Record
				end
			end
			p202:_refreshCounts()
			p202:_schedule()
		end
		t46._indexWants = function(p204)
			local now = os.clock()
			local indexCache = p204.indexCache
			if indexCache then
				if now - (indexCache.at or 0) < 2 then
					return indexCache.set
				end
			end
			local t50 = {}
			pcall(function()
				local areasDirectory = p204.areasDirectory
				if not areasDirectory then
					areasDirectory = require(ReplicatedStorage2.Data.Areas).Directory
					p204.areasDirectory = areasDirectory
				end
				local v916 = (Save.Peek or Save.Get)()
				if not areasDirectory or not v916 then
					return
				end
				local Index = v916.Index or {}
				local t51 = {}
				local pairs_ = pairs
				local EggInventory = v916.EggInventory or {}
				for _, v in pairs_(EggInventory) do
					local AssetCategory = type(v) == "table" and (v.AssetCategory or v.Category) or nil
					if AssetCategory then
						t51[tostring(AssetCategory)] = true
					end
				end
				local uid = p204.carry and p204.carry.uid
				if uid then
					local v925 = p204.records[uid]
					if v925 and v925.AssetCategory then
						t51[tostring(v925.AssetCategory)] = true
					end
				end
				for _, v in pairs(areasDirectory) do
					if type(v) == "table" and type(v.DropTable) == "table" then
						for _, v2 in ipairs(v.DropTable) do
							local v930 = v2[1]
							if v930 then
								local v931 = tostring(v930)
								if not Index[v931] and not t51[v931] then
									t50[v931] = true
								end
							end
						end
					end
				end
			end)
			p204.indexCache = {
				at = now,
				set = t50
			}
			return t50
		end
		t46._isIndexObjective = function(p205, p206)
			if not p205.indexObjectiveEnabled then
				return false
			end
			if type(p206) ~= "table" then
				return false
			end
			local AssetCategory = p206.AssetCategory
			if not AssetCategory or AssetCategory == "" then
				return false
			end
			return p205:_indexWants()[tostring(AssetCategory)] == true
		end
		t46.setIndexObjective = function(p207, p208)
			local indexObjectiveEnabled = p208 == true
			if p207.indexObjectiveEnabled == indexObjectiveEnabled then
				return
			end
			p207.indexObjectiveEnabled = indexObjectiveEnabled
			p207.indexCache = {
				at = 0,
				set = {}
			}
			p207:_reconcileRunningState()
		end
		t46._isWispObjective = function(p209, p210)
			local wispObjective = p209.wispObjective
			if type(wispObjective) ~= "table" or type(p210) ~= "table" then
				return false
			end
			if wispObjective.area and p210.AreaId ~= wispObjective.area then
				return false
			end
			if wispObjective.rarity then
				local v935 = p209.catalog.resolve(p210)
				if not v935 or v935.rarity ~= wispObjective.rarity then
					return false
				end
			end
			return true
		end
		t46.setWispObjective = function(p211, p212)
			local wispObjectiveKey = type(p212) == "table"
			if wispObjectiveKey then
				wispObjectiveKey = (p212.area or "") .. "|" .. (p212.rarity or "")
			end
			wispObjectiveKey = wispObjectiveKey or nil
			if p211.wispObjectiveKey == wispObjectiveKey then
				return
			end
			p211.wispObjectiveKey = wispObjectiveKey
			p211.wispObjective = wispObjectiveKey and p212 or nil
			p211:_reconcileRunningState()
		end
		t46.indexMissingCount = function(p213)
			local n19 = 0
			for _ in pairs(p213:_indexWants()) do
				n19 += 1
			end
			return n19
		end
		t46._matchesNormalFilter = function(p214, p215)
			local v939 = p214.catalog.resolve(p215)
			local config = p214.config
			local v941, v942, minValuePerSec, minWeightKg
			if config.rarityEnabled then
				if not (#config.rarities ~= 0 and v743(config.rarities, v939.rarity)) then
					return false
				end
				if config.nameEnabled then
					if #config.names == 0 or not v743(config.names, v939.name) and not v743(config.names, v939.category) then
						return false
					end
					if config.areaEnabled then
						if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
							return false
						end
						if config.mutationEnabled then
							if not v864(p215, config.mutations) then
								return false
							end
							if (config.minWeightKg or 0) > 0 then
								v942 = p214:_resolveWeightKg(p215)
								if not v942 or v942 < config.minWeightKg then
									return false
								end
								if (config.minValuePerSec or 0) > 0 then
									v941 = v748(p215)
									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							else
								minValuePerSec = config.minValuePerSec or 0
								if minValuePerSec > 0 then
									v941 = v748(p215)
									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							end
						else
							minWeightKg = config.minWeightKg or 0
							if minWeightKg > 0 then
								v942 = p214:_resolveWeightKg(p215)
								if not v942 or v942 < config.minWeightKg then
									return false
								end
								minValuePerSec = config.minValuePerSec or 0
								if minValuePerSec > 0 then
									v941 = v748(p215)
									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							else
								minValuePerSec = config.minValuePerSec or 0
								if minValuePerSec > 0 then
									v941 = v748(p215)
									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							end
						end
					elseif config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.areaEnabled then
					if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
						return false
					end
					if config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.nameEnabled then
				if #config.names == 0 or not v743(config.names, v939.name) and not v743(config.names, v939.category) then
					return false
				end
				if config.areaEnabled then
					if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
						return false
					end
					if config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0
						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)
							if not v942 or v942 < config.minWeightKg then
								return false
							end
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0
							if minValuePerSec > 0 then
								v941 = v748(p215)
								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.areaEnabled then
				if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
					return false
				end
				if config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0
					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)
						if not v942 or v942 < config.minWeightKg then
							return false
						end
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0
						if minValuePerSec > 0 then
							v941 = v748(p215)
							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.mutationEnabled then
				if not v864(p215, config.mutations) then
					return false
				end
				minWeightKg = config.minWeightKg or 0
				if minWeightKg > 0 then
					v942 = p214:_resolveWeightKg(p215)
					if not v942 or v942 < config.minWeightKg then
						return false
					end
					minValuePerSec = config.minValuePerSec or 0
					if minValuePerSec > 0 then
						v941 = v748(p215)
						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				else
					minValuePerSec = config.minValuePerSec or 0
					if minValuePerSec > 0 then
						v941 = v748(p215)
						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				end
			else
				if (config.minWeightKg or 0) > 0 then
					v942 = p214:_resolveWeightKg(p215)
					if not v942 or v942 < config.minWeightKg then
						return false
					end
					minValuePerSec = config.minValuePerSec or 0
					if minValuePerSec > 0 then
						v941 = v748(p215)
						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				else
					if (config.minValuePerSec or 0) > 0 then
						v941 = v748(p215)
						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				end
			end
			return true
		end
		t46._matches = function(p216, p217)
			if p217.State ~= AreaEggs.States.Slot and p217.State ~= AreaEggs.States.Dropped then
				return false
			end
			if p216.riftWants[p217.AssetCategory] then
				return true
			end
			if p216.indexObjectiveEnabled and p216:_isIndexObjective(p217) then
				return true
			end
			if p216.wispObjective and p216:_isWispObjective(p217) then
				return true
			end
			if p216.userStealEnabled and not p216.riftOnly and p216:_matchesNormalFilter(p217) then
				return true
			end
			return false
		end
		t46.setScrambleWants = function(p218, p219, p220)
			local riftWants = {}
			local ipairs_ = ipairs
			local v947 = type(p219) == "table" and p219 or {}
			for _, v in ipairs_(v947) do
				if type(v) == "string" and v ~= "" then
					riftWants[v] = true
				end
			end
			local riftOnly = p220 == true
			local v951 = riftOnly ~= p218.riftOnly
			for k in pairs(riftWants) do
				if not p218.riftWants[k] then
					v951 = true
				end
			end
			for k in pairs(p218.riftWants) do
				if not riftWants[k] then
					v951 = true
				end
			end
			if not v951 then
				return
			end
			p218.riftWants = riftWants
			p218.riftOnly = riftOnly
			p218:_reconcileRunningState()
		end
		t46._refreshCounts = function(p221)
			local available = 0
			local matching = 0
			for _, record in pairs(p221.records) do
				if record.State == AreaEggs.States.Slot then
					available += 1
					if p221:_matches(record) then
						matching += 1
					end
				end
			end
			p221.stats.available = available
			p221.stats.matching = matching
			p221:_notify()
		end
		t46.hasPriorityRareEgg = function(p222)
			local Character = LocalPlayer2.Character
			Character = Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			local v959
			local v960
			local v961
			local pairs_ = pairs
			local records = p222.records or {}
			for _, record in pairs_(records) do
				if (record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped) and record.BottomCFrame and not p222:isSkippedEgg(record.Uid) and p222:_matchesNormalFilter(record) then
					local v966 = p222.catalog.resolve(record)
					if t42[v966.rarity] then
						local Magnitude = Character and (record.BottomCFrame.Position - Character.Position).Magnitude or 0
						local rarityRank = v966.rarityRank or 0
						if not v959 or v960 < rarityRank or rarityRank == v960 and Magnitude < v961 then
							v959 = record
							v960 = rarityRank
							v961 = Magnitude
						end
					end
				end
			end
			return v959 ~= nil, v959
		end
		t46.isSkippedEgg = function(p223, p224)
			if p224 ~= nil then
				if p224 == workspace:GetAttribute("Event_CaptureTheEggUid") then
					if not p223.captureObjectiveEnabled then
						return true
					end
				end
			end
			local v969 = p224 and p223.skippedEggs[p224]
			if not v969 then
				return false
			end
			if os.clock() < v969 then
				return true
			end
			p223.skippedEggs[p224] = nil
			return false
		end
		do
			t46._isCaptureEgg = function(p225, p226)
				return p226 ~= nil and p226 == workspace:GetAttribute("Event_CaptureTheEggUid")
			end
		end
		t46.setCaptureObjective = function(p227, p228)
			local v970 = p228 == true
			if p227.captureObjectiveEnabled == v970 then
				return
			end
			if v970 then
				p227._modeBeforeCapture = {
					p227.config.stealMode,
					p227.config.flyAerial,
					p227.config.flyZigzag
				}
				p227:setStealMode("Instant", false, false)
				p227.captureObjectiveEnabled = true
			else
				p227.captureObjectiveEnabled = false
				local _modeBeforeCapture = p227._modeBeforeCapture
				p227._modeBeforeCapture = nil
				if _modeBeforeCapture then
					p227:setStealMode(_modeBeforeCapture[1], _modeBeforeCapture[2], _modeBeforeCapture[3])
				end
			end
			p227:_reconcileRunningState()
		end
		t46._captureHold = function(p229, p230)
			if p229._captureHoldUid == p230 then
				return
			end
			p229._captureHoldUid = p230
			local function v972()
				local v973 = EggState2.ReadFieldEgg(p230)
				return v973 ~= nil and v973.State == AreaEggs.States.Carried and v973.CarrierUserId == LocalPlayer2.UserId
			end
			local function v974()
				return not p229.destroyed and p229.enabled and p229.captureObjectiveEnabled and v972()
			end
			task.spawn(function()
				p229:_clearArrivalHold(p230)
				p229:_hideTreadmillDecoy()
				pcall(function()
					p229:_stopHoverPad()
				end)
				p229.stats.lastResult = "Holding capture egg"
				p229:_setStatus("Holding capture egg")
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local cFrame2 = HumanoidRootPart and cFrameNew(HumanoidRootPart.Position.X, 110, HumanoidRootPart.Position.Z) * HumanoidRootPart.CFrame.Rotation
				if cFrame2 then
					p229:_glideRoot(cFrame2, function()
						return not v974()
					end)
				end
				while v974() do
					local Character2 = LocalPlayer2.Character
					local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
					if HumanoidRootPart2 and Humanoid and cFrame2 then
						pcall(function()
							HumanoidRootPart2.CFrame = cFrame2
							HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						end)
						p229:_syncHoverPad(cFrame2.Position)
						local v981 = math.clamp(p229.config.speed or 600, 200, v721())
						pcall(function()
							v795(Character2, v981 * 1.35)
							v860(Humanoid, HumanoidRootPart2, v981, Vector3.zero)
						end)
					end
					task.wait(0.1)
				end
				pcall(function()
					p229:_stopHoverPad()
				end)
				if p229._captureHoldUid == p230 then
					p229._captureHoldUid = nil
				end
				if p229.destroyed or not p229.enabled then
					return
				end
				p229:_finish(p229.captureObjectiveEnabled and "Capture egg lost — re-grabbing" or "Capture stopped")
			end)
		end
		t46._chooseTarget = function(p231)
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then
				return nil
			end
			if p231.captureObjectiveEnabled then
				local attribute = workspace:GetAttribute("Event_CaptureTheEggUid")
				local v984 = attribute and (EggState2.ReadFieldEgg(attribute) or p231.records[attribute])
				if type(v984) == "table" and v984.BottomCFrame and (v984.State == AreaEggs.States.Slot or v984.State == AreaEggs.States.Dropped) then
					return v984
				end
			end
			if p231.manualObjectiveEnabled then
				local v985 = p231:_takeManualTarget()
				if v985 then
					return v985
				end
			end
			if p231.userStealEnabled and not p231.riftOnly then
				local v986, v987 = p231:hasPriorityRareEgg()
				if v986 and v987 then
					return v987
				end
			end
			local v988
			local v989
			local v990
			local v991
			local v992
			local v993
			for _, record in pairs(p231.records) do
				if (record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped) and record.BottomCFrame and not p231:isSkippedEgg(record.Uid) then
					local Magnitude = (record.BottomCFrame.Position - HumanoidRootPart.Position).Magnitude
					if not p231.riftWants[record.AssetCategory] then
						if not p231.wispObjective or not p231:_isWispObjective(record) then
							if p231.indexObjectiveEnabled and p231:_isIndexObjective(record) and (not v990 or Magnitude < v991) then
								v990 = record
								v991 = Magnitude
							end
						elseif not v992 or Magnitude < v993 then
							v992 = record
							v993 = Magnitude
						end
					elseif not v988 or Magnitude < v989 then
						v988 = record
						v989 = Magnitude
					end
				end
			end
			if v988 or v992 or v990 then
				return v988 or v992 or v990
			end
			if p231.userStealEnabled and not p231.riftOnly then
				local v997
				local v998
				local v999
				for _, record in pairs(p231.records) do
					if record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped then
						if not p231:isSkippedEgg(record.Uid) and p231:_matchesNormalFilter(record) then
							local Magnitude = (record.BottomCFrame.Position - HumanoidRootPart.Position).Magnitude
							local v1003 = p231.catalog.resolve(record)
							local v1004
							if p231.config.highestValueFirst then
								v1004 = v748(record) or -math.huge
							elseif p231.config.heaviestFirst then
								v1004 = p231:_resolveWeightKg(record) or -math.huge
							else
								v1004 = v1003.rarityRank or 0
							end
							if not v997 or v998 < v1004 or v1004 == v998 and Magnitude < v999 then
								v997 = record
								v998 = v1004
								v999 = Magnitude
							end
						end
					end
				end
				if v997 then
					return v997
				end
			end
			return nil
		end
		t46._takeManualTarget = function(p232)
			local t52 = {}
			local manualOrder = {}
			for _, v in ipairs(p232.manualOrder) do
				local v1009 = p232.records[v]
				if v1009 and (v1009.State == AreaEggs.States.Slot or v1009.State == AreaEggs.States.Dropped) then
					manualOrder[#manualOrder + 1] = v
					t52[v] = true
				end
			end
			p232.manualOrder = manualOrder
			for k in pairs(p232.manualQueue) do
				if not t52[k] then
					p232.manualQueue[k] = nil
				end
			end
			if #manualOrder ~= 0 then
				return p232.records[manualOrder[1]]
			end
			if p232.manualObjectiveEnabled then
				p232.manualObjectiveEnabled = false
				task.defer(function()
					if not p232.destroyed then
						p232:_reconcileRunningState()
					end
				end)
			end
			return nil
		end
		t46.queueManual = function(p233, p234)
			if type(p234) ~= "table" then
				return 0
			end
			for _, v in ipairs(p234) do
				local v1013 = v
				if v1013 ~= nil and not p233.manualQueue[v1013] then
					p233.manualQueue[v1013] = true
					p233.manualOrder[#p233.manualOrder + 1] = v1013
				end
			end
			local v1014 = #p233.manualOrder
			if v1014 > 0 then
				p233.manualObjectiveEnabled = true
			end
			p233:_reconcileRunningState()
			return v1014
		end
		do
			t46.clearManual = function(p235)
				p235.manualQueue = {}
				p235.manualOrder = {}
				p235.manualObjectiveEnabled = false
				p235:_reconcileRunningState()
			end
		end
		t46.manualPending = function(p236)
			return #p236.manualOrder
		end
		t46.setTreadmillManager = function(p237, p238)
			p237.treadmillManager = p238
		end
		t46.getStealMode = function(p239)
			return p239.config.stealMode == "Fly" and "Fly" or "Instant"
		end
		do
			t46.setStealMode = function(p240, p241, p242, p243)
				local stealMode = p241 == "Fly" and "Fly" or "Instant"
				local flyAerial = stealMode == "Fly" and p242 == true
				local flyZigzag = stealMode == "Fly" and p243 == true and not flyAerial
				if p240.config.stealMode ~= stealMode or p240.config.flyAerial ~= flyAerial or p240.config.flyZigzag ~= flyZigzag then
					p240.config.stealMode = stealMode
					p240.config.flyAerial = flyAerial
					p240.config.flyZigzag = flyZigzag
					if p240.enabled then
						p240:_installGuardHitDistanceBoost()
						p240:_finish("Mode changed")
					end
				end
				return stealMode
			end
		end
		do
			local ResolveHitDistance
			t46._installGuardHitDistanceBoost = function(p244)
				if not p244.guardHitBoostInstalled then
					pcall(function()
						local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)
						if GuardChasePolicy and type(GuardChasePolicy.ResolveHitDistance) == "function" then
							ResolveHitDistance = ResolveHitDistance or GuardChasePolicy.ResolveHitDistance
							local v1020 = p244
							GuardChasePolicy.ResolveHitDistance = function(p245)
								if v1020.enabled and v1020.instantPhase == "priming" then
									return 25
								end
								if v1020.enabled or v1020._recalling then
									return -math.huge
								end
								local ok = not ResolveHitDistance
								local v1022
								if not ok then
									v1022 = ResolveHitDistance(p245)
									ok = not v1022
								end
								if ok then
									v1022 = p245 or 10
								end
								return v1022
							end
							p244.guardHitBoostInstalled = true
						end
					end)
					return
				end
			end
			t46._removeGuardHitDistanceBoost = function(p246)
				if not p246.guardHitBoostInstalled then
					return
				end
				pcall(function()
					local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)
					if GuardChasePolicy and ResolveHitDistance then
						GuardChasePolicy.ResolveHitDistance = ResolveHitDistance
						p246.guardHitBoostInstalled = false
					end
				end)
			end
		end
		t46._setInstantAnchored = function(p247, p248)
			pcall(function()
				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart then
					if HumanoidRootPart.Anchored ~= p248 then
						HumanoidRootPart.Anchored = p248
					end
				end
			end)
		end
		do
			t46._kbCancelTimer = function(p249)
				if p249.hitTimer then
					pcall(task.cancel, p249.hitTimer)
					p249.hitTimer = nil
				end
			end
		end
		t46._isPrimerEgg = function(p250, p251)
			if p251 == nil then
				return false
			end
			if p251 == p250.primerUid then
				return true
			end
			local primerUids = p250.primerUids and p250.primerUids[p251]
			if primerUids then
				if os.clock() < primerUids then
					return true
				end
			end
			if primerUids then
				p250.primerUids[p251] = nil
			end
			return false
		end
		t46._cleanupInstantSteal = function(p252)
			p252.instantPhase = nil
			p252.primerUid = nil
			p252.targetUid = nil
			p252._flyDeparting = false
			p252:_stopGuardStick()
			p252:_kbCancelTimer()
			p252:_setInstantAnchored(false)
			p252:_hideTreadmillDecoy()
		end
		t46._choosePrimerEgg = function(p253, p254)
			local v1026 = v14()
			local Areas = v1026 and v1026:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
			local Guard = Forest and Forest:FindFirstChild("Guard")
			local HumanoidRootPart = Guard and Guard:FindFirstChild("HumanoidRootPart")
			local Position = HumanoidRootPart and HumanoidRootPart.Position
			local v1033
			local v1034
			for _, record in pairs(p253.records) do
				if record.State == AreaEggs.States.Slot and record.AreaId == "Forest" and record.Uid ~= p254 and not p253:_isCaptureEgg(record.Uid) then
					local v1037 = -(Position and (record.BottomCFrame.Position - Position).Magnitude or LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") and (record.BottomCFrame.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude or math.huge) - (p253.catalog.resolve(record).rarityRank or 0) * 100
					if not v1033 or v1034 < v1037 then
						v1033 = record
						v1034 = v1037
					end
				end
			end
			return v1033
		end
		t46._stopGuardStick = function(p255)
			if p255.guardStickConnection then
				pcall(p255.guardStickConnection.Disconnect, p255.guardStickConnection)
				p255.guardStickConnection = nil
			end
		end
		t46._startGuardStick = function(p256)
			p256:_stopGuardStick()
			local function v1038()
				local v1039 = v14()
				local Areas = v1039 and v1039:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
				local Guard = Forest and Forest:FindFirstChild("Guard")
				return Guard and Guard:FindFirstChild("HumanoidRootPart")
			end
			p256.guardStickConnection = RunService2.PreSimulation:Connect(function()
				if p256.destroyed or not p256.enabled or p256.instantPhase ~= "priming" then
					p256:_stopGuardStick()
					return
				end
				local v1044 = v1038()
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				if not v1044 or not HumanoidRootPart then
					return
				end
				local Position = v1044.Position
				local v1048 = v1044.CFrame.LookVector * 2.5
				local v1049 = Vector3.new(Position.X + v1048.X, HumanoidRootPart.Position.Y, Position.Z + v1048.Z) - HumanoidRootPart.Position
				if v1049.Magnitude > 40 then
					v1049 = v1049.Unit * 40
				end
				local v1050 = HumanoidRootPart.Position + v1049
				HumanoidRootPart.CFrame = lookAt(v1050, Vector3.new(Position.X, v1050.Y, Position.Z))
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				p256:_syncHoverPad(v1050)
			end)
		end
		t46._forestGuardModel = function()
			local v1051 = v14()
			local Areas = v1051 and v1051:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
			return Forest and Forest:FindFirstChild("Guard")
		end
		t46._triggerGuardHit = function(p257)
			local v1055 = p257:_forestGuardModel()
			local HumanoidRootPart = v1055 and v1055:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then
				return
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart2 then
				return
			end
			local Position = HumanoidRootPart.Position
			local v1060 = HumanoidRootPart.CFrame.LookVector * 2.5
			local vector33 = Vector3.new(Position.X + v1060.X, HumanoidRootPart2.Position.Y, Position.Z + v1060.Z)
			p257.guardStrikeAnchor = vector33
			HumanoidRootPart2.CFrame = lookAt(vector33, Vector3.new(Position.X, vector33.Y, Position.Z))
			HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
			local Collider = v1055:FindFirstChild("Collider") or HumanoidRootPart
			if firetouchinterest then
				pcall(function()
					firetouchinterest(HumanoidRootPart2, Collider, 0)
					firetouchinterest(HumanoidRootPart2, Collider, 1)
				end)
			end
			pcall(function()
				local ForestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike
				if ForestStrike then
					ForestStrike:FireServer({
						EggUid = p257.primerUid,
						GuardCFrame = HumanoidRootPart.CFrame
					})
				end
			end)
		end
		t46._stopGuardStrike = function(p258)
			p258.guardStrikeGeneration = (p258.guardStrikeGeneration or 0) + 1
		end
		t46._knockbackLanded = function()
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				return false
			end
			if Humanoid.PlatformStand or Humanoid.Sit then
				return true
			end
			local state = Humanoid:GetState()
			if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
				return true
			end
			return HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 18
		end
		t46._settleAfterKnockback = function(p259)
			local guardStrikeAnchor = p259.guardStrikeAnchor
			local v1069 = os.clock() + 0.35
			while true do
				if not (os.clock() < v1069) or p259.destroyed then
					return
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then
					break
				end
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					pcall(function()
						Humanoid.PlatformStand = false
						Humanoid.Sit = false
						Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					end)
				end
				if guardStrikeAnchor then
					HumanoidRootPart.CFrame = cFrameNew(guardStrikeAnchor)
				end
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				p259:_syncHoverPad(guardStrikeAnchor or HumanoidRootPart.Position)
				RunService2.Heartbeat:Wait()
			end
		end
		t46._startGuardStrike = function(p260)
			p260:_stopGuardStrike()
			local guardStrikeGeneration = p260.guardStrikeGeneration
			task.spawn(function()
				local v1074 = os.clock() + 1.5
				while not p260.destroyed and p260.enabled and p260.instantPhase == "priming" and p260.guardStrikeGeneration == guardStrikeGeneration and os.clock() < v1074 do
					p260:_triggerGuardHit()
					local v1075 = os.clock() + 0.05
					local v1076 = false
					while os.clock() < v1075 do
						if p260:_knockbackLanded() then
							v1076 = true
							break
						else
							RunService2.Heartbeat:Wait()
						end
					end
					if v1076 then
						break
					end
				end
				if p260.guardStrikeGeneration == guardStrikeGeneration then
					p260:_stopGuardStick()
					p260:_settleAfterKnockback()
				end
			end)
		end
		t46._enterBaitWait = function(p261)
			p261:_setInstantAnchored(false)
			p261:_setStatus("Preparing steal")
			p261:_startGuardStick()
			p261:_startGuardStrike()
			if p261.hitTimer then
				return
			end
			p261.hitTimer = task.delay(1.8, function()
				p261.hitTimer = nil
				if p261.destroyed or not p261.enabled then
					return
				end
				if p261.instantPhase ~= "priming" then
					return
				end
				p261:_stopGuardStick()
				p261:_stopGuardStrike()
				if p261.carry.active and p261:_isPrimerEgg(p261.carry.uid) then
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
				end
				p261:_finish("Steal timed out — retrying")
			end)
		end
		local function v1077(p262, p263)
			local v1078 = tostring(p262 or ""):lower()
			local n20 = 8
			local n21 = 3.5
			if v1078:find("enchanted") then
				n20 = 18
				n21 = 12
			elseif v1078:find("light") or v1078:find("dark") then
				n20 = 16
				n21 = 10
			elseif v1078:find("titan") then
				n20 = 10
				n21 = 8
			end
			return math.max(n21, n20 * ((11 - math.clamp(p263, 1, 10)) / 6))
		end
		do
			t46._resolveSettleSeconds = function(p264, p265)
				local v1081 = math.clamp(tonumber(s2rHubConfig.StealHoldSeconds) or 5, 1, 10)
				local v1082 = p264.settleBonus and type(p265) == "table" and p264.settleBonus[p265.Uid]
				local seconds = v1082 and v1082.untilAt > os.clock() and v1082.seconds or 0
				return v1077(type(p265) == "table" and p265.AreaId, v1081) + seconds
			end
		end
		t46._startPrimerTargetHunt = function(p266)
			if p266.instantPhase ~= "priming" then
				return
			end
			p266:_stopGuardStick()
			p266:_stopGuardStrike()
			pcall(function()
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					Humanoid.PlatformStand = false
					Humanoid.Sit = false
				end
				if HumanoidRootPart then
					if p266.guardStrikeAnchor then
						HumanoidRootPart.CFrame = cFrameNew(p266.guardStrikeAnchor)
					end
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end
			end)
			p266:_kbCancelTimer()
			p266:_setInstantAnchored(false)
			p266.instantPhase = "hunting"
			p266:_clearArrivalHold()
			local carry = p266.carry
			carry.generation += 1
			p266:_invalidateCarryWorker()
			p266.carry.active = false
			p266.carry.uid = nil
			local targetUid = p266.targetUid
			p266.targetUid = nil
			if not targetUid then
				p266:_finish("No target egg")
				return
			end
			local v1089 = EggState2.ReadFieldEgg(targetUid) or p266.records[targetUid]
			if not v1089 or v1089.State ~= AreaEggs.States.Slot and v1089.State ~= AreaEggs.States.Dropped then
				p266:_finish("Target egg no longer available")
				return
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				p266:_finish("Character unavailable")
				return
			end
			p266.activeTarget = v1089
			local v1093 = p266:_resolveEggDestination(v1089, HumanoidRootPart, Humanoid)
			if not v1093 then
				p266:_finish("Target destination unavailable")
				return
			end
			if p266.config.stealMode ~= "Fly" then
				if p266.config.stealMode == "Instant" and not p266.lowFpsPrime then
					local Uid = v1089.Uid
					local function v1095()
						return p266.destroyed or not p266.enabled or p266.instantPhase ~= "hunting" or not p266.activeTarget or p266.activeTarget.Uid ~= Uid
					end
					local cFrame2 = v1093 + Vector3.new(0, 14, 0)
					p266:_setStatus("Heading to target egg")
					if not p266:_glideRoot(cFrame2, v1095) then
						if not v1095() then
							p266:_finish("Could not reach the egg — retrying")
						end
						return
					end
					task.spawn(function()
						local v1097 = p266:_resolveSettleSeconds(v1089)
						local v1098 = os.clock() + v1097
						if os.clock() < v1098 then
							local exitTo
							while not v1095() do
								p266:_setStatus(string.format("Securing target egg (%.1fs)", math.max(0, v1098 - os.clock())))
								local Character2 = LocalPlayer2.Character
								local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
								local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")
								if HumanoidRootPart2 and Humanoid2 then
									pcall(function()
										HumanoidRootPart2.CFrame = cFrame2
										HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
										HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
									end)
									p266:_syncHoverPad(cFrame2.Position)
									local v1103 = math.clamp(p266.config.speed or 600, 200, v721())
									pcall(function()
										v795(Character2, v1103 * 1.35)
										v860(Humanoid2, HumanoidRootPart2, v1103, Vector3.zero)
									end)
								end
								task.wait(0.1)
								if not (os.clock() < v1098) then
									exitTo = 1
									break
								end
							end
							if exitTo ~= 1 then
								return
							end
							if not v1095() then
								p266:_glideRoot(v1093, v1095)
								if v1095() then
									return
								end
								p266:_setArrivalHold(v1093, Uid)
								p266:_setStatus("Securing target egg")
								p266:_requestCarry(v1089, true)
								return
							end
						elseif not v1095() then
							p266:_glideRoot(v1093, v1095)
							if v1095() then
								return
							end
							p266:_setArrivalHold(v1093, Uid)
							p266:_setStatus("Securing target egg")
							p266:_requestCarry(v1089, true)
							return
						end
					end)
					return
				end
				p266:_setStatus("Heading to target egg")
				p266:_tweenRoot(v1093, function()
					if p266.instantPhase == "hunting" and p266.activeTarget and p266.activeTarget.Uid == v1089.Uid then
						p266:_requestCarry(v1089, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1089.Uid,
					flightProfile = true,
					carryTarget = v1089
				})
				return
			end
			local Uid = v1089.Uid
			local function v1105()
				return p266.destroyed or not p266.enabled or p266.instantPhase ~= "hunting" or not p266.activeTarget or p266.activeTarget.Uid ~= Uid
			end
			if p266.config.flyAerial then
				p266:_setStatus("Heading to target egg")
				p266:_startFlyGrounding()
				local v1106 = p266:_flyWalkTo(v1093, v1105, 8, 110)
				p266:_stopFlyGrounding()
				if not v1106 then
					if not v1105() then
						p266:_finish("Could not reach the egg — retrying")
					end
					return
				end
			elseif p266.config.flyZigzag then
				p266:_setStatus("Heading to target egg")
				if not p266:_walkToZigzag(v1093, v1105) then
					if not v1105() then
						p266:_finish("Zig-zag walk to target failed")
					end
					return
				end
			else
				p266:_setStatus("Heading to target egg")
				if not p266:_walkTo(v1093, v1105) then
					if not v1105() then
						p266:_finish("Walk to target failed")
					end
					return
				end
			end
			if v1105() then
				return
			end
			p266:_glideRoot(v1093, v1105, p266:_legitWalkSpeed())
			if v1105() then
				return
			end
			p266:_setArrivalHold(v1093, Uid)
			p266:_setStatus("Securing target egg")
			p266:_requestCarry(v1089, true)
		end
		do
			t46._wallOpen = function(p267)
				if p267.resetBlocked or AreaEggResetWall3.IsSealed() or os.clock() < p267.gateOpenAt then
					return false
				end
				local v1107 = v14()
				local Areas = v1107 and v1107:FindFirstChild("Areas")
				local WallStartCollision = Areas and Areas:FindFirstChild("WallStartCollision")
				if WallStartCollision and WallStartCollision:IsA("BasePart") and WallStartCollision.CanCollide then
					return false
				end
				return true
			end
		end
		t46._closeGate = function(p268, p269)
			p268.resetBlocked = true
			p268.gateOpenAt = math.huge
			p268.safeStarting = false
			if not p268.activeTween then
				p268:_cancelTween(p269)
			elseif not p268.activeTween.sharedTravel then
				p268:_cancelTween(p269)
				p268:_setStatus(p269)
				return
			end
			p268:_setStatus(p269)
		end
		t46._releaseOperation = function(p270)
			local operationToken = p270.operationToken
			p270.operationToken = nil
			if operationToken and p270.coordinator then
				p270.coordinator:release(operationToken)
			end
		end
		do
			t46._acquireOperation = function(p271)
				if p271.operationToken or not p271.coordinator then
					return true
				end
				local autoSteal, v1112 = p271.coordinator:tryAcquire("auto_steal", {})
				if not autoSteal then
					return false, v1112
				end
				p271.operationToken = autoSteal
				return true
			end
		end
		t46._cancelTween = function(p272, p273, p274)
			p272:_cleanupInstantSteal()
			p272.carryAttemptToken = nil
			p272:_clearArrivalHold()
			p272.safeStarting = false
			if p272.activeTween then
				pcall(p272.activeTween.Cancel, p272.activeTween)
				p272.activeTween = nil
			end
			if not p272.activeTween and not p272.arrivalHold then
				p272:_stopHoverPad()
			end
			if p272.running then
				p272.running = false
				p272.activeTarget = nil
				p272.stats.lastResult = p273
				p272:_notify()
			end
			if not p274 then
				p272:_releaseOperation()
			end
		end
		t46._groundYAt = function(p275, p276, p277, p278)
			local Character = p278 or LocalPlayer2.Character
			local vector33 = Vector3.new(p276, (Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position.Y or vector32.Y) + 60, p277)
			local filterDescendantsInstances = {}
			if Character then
				table.insert(filterDescendantsInstances, Character)
			end
			if p275.hoverPad then
				table.insert(filterDescendantsInstances, p275.hoverPad)
			end
			if p275.treadmillDecoy then
				table.insert(filterDescendantsInstances, p275.treadmillDecoy)
			end
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "__S2rHubHoverPad" or child.Name == "__S2rHubTreadmillDecoy" then
					table.insert(filterDescendantsInstances, child)
				end
			end
			for i = 1, 10 do
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.FilterDescendantsInstances = filterDescendantsInstances
				raycastParams.IgnoreWater = true
				local hit = workspace:Raycast(vector33, Vector3.new(0, -300, 0), raycastParams)
				if not hit then
					return nil
				end
				if hit.Instance.CanCollide then
					return hit.Position.Y
				end
				table.insert(filterDescendantsInstances, hit.Instance)
			end
			return nil
		end
		do
			t46._resolveSafeCFrame = function(p279, p280)
				if not p280 then
					return nil
				end
				local X = vector32.X
				local Z = vector32.Z
				local Y = vector32.Y
				local v1124 = p279:_groundYAt(X, Z, p280.Parent)
				if v1124 then
					Y = v1124 + 3.2
				end
				return cFrameNew(X, Y, Z) * p280.CFrame.Rotation
			end
		end
		t46._groundSnap = function(p281)
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				return false
			end
			local Position = HumanoidRootPart.Position
			local v1129 = p281:_groundYAt(Position.X, Position.Z, Character)
			if not v1129 then
				return false
			end
			local v1130 = v1129 + p281:_feetOffset(HumanoidRootPart, Humanoid)
			if not (Position.Y < v1130 - 0.25) and not (v1130 + 8 < Position.Y) then
				return false
			end
			pcall(function()
				p281:_syncHoverPad(Vector3.new(Position.X, v1130, Position.Z))
				HumanoidRootPart.CFrame = cFrameNew(Position.X, v1130, Position.Z) * HumanoidRootPart.CFrame.Rotation
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end)
			return true
		end
		do
			local function v1131(p282)
				if typeof(p282) == "Instance" and p282:IsA("Trail") then
					pcall(p282.Destroy, p282)
				end
			end
			local function v1132(p283)
				if typeof(p283) == "Instance" then
					if p283.Name == "SpeedGainPopup" or p283.Name == "PlusOne" then
						pcall(p283.Destroy, p283)
					end
				end
			end
			t46._showTreadmillDecoy = function(p284)
				if p284.treadmillDecoy and p284.treadmillDecoy.Parent then
					return true
				end
				p284:_hideTreadmillDecoy()
				local Character = LocalPlayer2.Character
				if not Character then
					return false
				end
				local Archivable = Character.Archivable
				Character.Archivable = true
				local ok, treadmillDecoy = pcall(Character.Clone, Character)
				Character.Archivable = Archivable
				if not ok or not treadmillDecoy or typeof(treadmillDecoy) ~= "Instance" then
					return false
				end
				treadmillDecoy.Name = "__S2rHubTreadmillDecoy"
				for _, descendant in ipairs(treadmillDecoy:GetDescendants()) do
					if t45[descendant.ClassName] or descendant:IsA("Trail") then
						pcall(descendant.Destroy, descendant)
					elseif descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 0
						descendant.Anchored = true
						descendant.CanCollide = false
						descendant.CanQuery = false
						descendant.CanTouch = false
					end
				end
				local HumanoidRootPart = treadmillDecoy:FindFirstChild("HumanoidRootPart")
				local Humanoid = treadmillDecoy:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart or not Humanoid then
					treadmillDecoy:Destroy()
					return false
				end
				pcall(function()
					Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				end)
				treadmillDecoy.Parent = workspace
				treadmillDecoy:PivotTo(cFrameNew(vector32))
				p284.treadmillDecoy = treadmillDecoy
				local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
				if PlayerGui then
					for _, descendant in ipairs(PlayerGui:GetDescendants()) do
						if descendant.Name == "SpeedGainPopup" or descendant.Name == "PlusOne" then
							v1132(descendant)
						end
					end
					p284.treadmillPopupConnection = PlayerGui.DescendantAdded:Connect(function(descendant)
						if p284.treadmillDecoy == treadmillDecoy then
							v1132(descendant)
						end
					end)
				end
				local treadmillDecoyRealTransparency = setmetatable({}, {
					__mode = "k"
				})
				local function v1145(p285)
					if not p285 or not p285:IsA("BasePart") or not p285:IsDescendantOf(Character) then
						return
					end
					if treadmillDecoyRealTransparency[p285] == nil then
						treadmillDecoyRealTransparency[p285] = p285.LocalTransparencyModifier
					end
					p285.LocalTransparencyModifier = 1
				end
				for _, descendant in ipairs(Character:GetDescendants()) do
					v1145(descendant)
					v1131(descendant)
				end
				p284.treadmillDecoyRealTransparency = treadmillDecoyRealTransparency
				p284.treadmillDecoyCharacterConnection = Character.DescendantAdded:Connect(function(descendant)
					if p284.treadmillDecoy == treadmillDecoy then
						pcall(v1145, descendant)
						v1131(descendant)
					end
				end)
				local CurrentCamera = workspace.CurrentCamera
				if CurrentCamera then
					p284.treadmillDecoyCamera = CurrentCamera.CameraSubject
					CurrentCamera.CameraSubject = Humanoid
				end
				p284.treadmillDecoyCameraConnection = RunService2.RenderStepped:Connect(function()
					if p284.treadmillDecoy ~= treadmillDecoy or not treadmillDecoy.Parent or not Humanoid.Parent then
						return
					end
					for k in pairs(treadmillDecoyRealTransparency) do
						if k.Parent and k.LocalTransparencyModifier ~= 1 then
							k.LocalTransparencyModifier = 1
						end
					end
					local CurrentCamera2 = workspace.CurrentCamera
					if CurrentCamera2 and CurrentCamera2.CameraSubject ~= Humanoid then
						CurrentCamera2.CameraSubject = Humanoid
					end
				end)
				return true
			end
		end
		t46._hideTreadmillDecoy = function(p286, p287)
			if p286._recalling and not p287 then
				return
			end
			if p286.treadmillDecoyCameraConnection then
				pcall(p286.treadmillDecoyCameraConnection.Disconnect, p286.treadmillDecoyCameraConnection)
				p286.treadmillDecoyCameraConnection = nil
			end
			if p286.treadmillDecoyCharacterConnection then
				pcall(p286.treadmillDecoyCharacterConnection.Disconnect, p286.treadmillDecoyCharacterConnection)
				p286.treadmillDecoyCharacterConnection = nil
			end
			if p286.treadmillPopupConnection then
				pcall(p286.treadmillPopupConnection.Disconnect, p286.treadmillPopupConnection)
				p286.treadmillPopupConnection = nil
			end
			local pairs_ = pairs
			local treadmillDecoyRealTransparency = p286.treadmillDecoyRealTransparency or {}
			for k, v in pairs_(treadmillDecoyRealTransparency) do
				if typeof(k) == "Instance" and k.Parent then
					pcall(function()
						k.LocalTransparencyModifier = v
					end)
				end
			end
			p286.treadmillDecoyRealTransparency = nil
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local CurrentCamera = workspace.CurrentCamera
			if CurrentCamera then
				pcall(function()
					CurrentCamera.CameraSubject = Humanoid or p286.treadmillDecoyCamera
				end)
			end
			p286.treadmillDecoyCamera = nil
			if p286.treadmillDecoy then
				pcall(p286.treadmillDecoy.Destroy, p286.treadmillDecoy)
			end
			p286.treadmillDecoy = nil
		end
		do
			t46._restoreTreadmillVisualAtSafe = function(p288)
				if not p288.treadmillDecoy then
					p288:_hideTreadmillDecoy()
					return true
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local v1161 = p288:_resolveSafeCFrame(HumanoidRootPart)
				if not HumanoidRootPart or not Humanoid or not v1161 then
					p288:_hideTreadmillDecoy()
					return false
				end
				local v1162 = os.clock() + 2
				local v1163
				local n22 = 0
				while not p288.destroyed and os.clock() < v1162 do
					local now = os.clock()
					if p288:_isInSafeArea(HumanoidRootPart) then
						v1163 = v1163 or now
						if now - v1163 >= 0.35 then
							p288:_hideTreadmillDecoy()
							return true
						end
					else
						v1163 = nil
						if n22 <= now then
							n22 = now + 0.1
							p288:_teleportRoot(HumanoidRootPart, Humanoid, v1161)
						end
					end
					task.wait(0.03)
				end
				p288:_hideTreadmillDecoy()
				return false
			end
		end
		t46._prepareTreadmillLaunch = function(p289, p290, p291)
			local treadmillManager = p289.treadmillManager
			if not treadmillManager or type(treadmillManager.pulseForCarry) ~= "function" then
				return false, "Preparation unavailable"
			end
			local Uid = p290 and p290.Uid
			local function v1168()
				return Uid and (EggState2.ReadFieldEgg(Uid) or p289.records[Uid]) or nil
			end
			local function v1169()
				local v1170 = v1168()
				return p289.destroyed or not p289.enabled or p289.planGeneration ~= p291 or not p289:_wallOpen() or type(v1170) ~= "table" or not p289:_matches(v1170)
			end
			local function v1171(p292)
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				return p289:_teleportRoot(HumanoidRootPart, Character and Character:FindFirstChildOfClass("Humanoid"), p292)
			end
			p289:_setStatus("Preparing carry")
			if not p289:_showTreadmillDecoy() then
				return false, "Safe-zone visual unavailable"
			end
			local v1174, v1175 = treadmillManager:pulseForCarry(v1171, v1169)
			if not v1174 then
				p289:_restoreTreadmillVisualAtSafe()
				return false, v1175
			end
			p289:_setStatus("Positioning at safe area")
			if not p289:_restoreTreadmillVisualAtSafe() then
				return false, "Safe teleport failed"
			end
			if not v1169() then
				return true, v1168()
			end
			return false, "Target changed before travel"
		end
		t46._resolveEggDestination = function(p293, p294, p295, p296)
			if type(p294) ~= "table" or typeof(p294.BottomCFrame) ~= "CFrame" then
				return nil
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = p295 or Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = p296 or Character and Character:FindFirstChildOfClass("Humanoid")
			if HumanoidRootPart and Humanoid then
				return cFrameNew(p294.BottomCFrame.Position + Vector3.new(0, p293:_feetOffset(HumanoidRootPart, Humanoid) + 0.15, 0))
			end
			return nil
		end
		local function v1179()
			local ok, result = pcall(function()
				local v1182 = v14()
				return v1182 and v1182:FindFirstChild("Areas") and v1182.Areas:FindFirstChild("EggCarryBounds")
			end)
			if ok and result then
				local Gameplay1 = result:FindFirstChild("Gameplay1")
				if Gameplay1 and Gameplay1:IsA("BasePart") then
					local v1184 = Gameplay1.Size.Z * 0.5 - 18
					if v1184 > 5 then
						return Gameplay1.Position.Z - v1184, Gameplay1.Position.Z + v1184
					end
				end
			end
			return -426, -308
		end
		t46._resolveRouteCruiseY = function(p297, p298, p299)
			if p297.config.stealMode ~= "Fly" then
				return nil
			end
			if not p298 or typeof(p299) ~= "CFrame" then
				return nil
			end
			if p299.Position.Y >= 104 then
				return nil
			end
			return 110
		end
		t46._resolveElevatedDestination = function(p300, p301, p302)
			if p301 then
				if typeof(p302) == "CFrame" then
					return p302
				end
			end
			return nil
		end
		t46._teleportRoot = function(p303, p304, p305, p306)
			if not p304 or not p305 or typeof(p306) ~= "CFrame" then
				return false
			end
			if not pcall(function()
				p304.AssemblyLinearVelocity = Vector3.zero
				p304.AssemblyAngularVelocity = Vector3.zero
				p304.CFrame = p306
				p304.AssemblyLinearVelocity = Vector3.zero
				p304.AssemblyAngularVelocity = Vector3.zero
			end) then
				return false
			end
			local v1185 = math.clamp(p303.config.speed or 600, 200, v721())
			v795(LocalPlayer2.Character, v1185 * 1.35)
			if not v860(p305, p304, v1185, Vector3.zero) then
				v856(p305, p304, v1185)
				v860(p305, p304, v1185, Vector3.zero)
			end
			return true
		end
		t46._legitWalkSpeed = function(p307)
			local u1186
			pcall(function()
				local Character = LocalPlayer2.Character
				local WalkSpeed
				if Character then
					local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
					WalkSpeed = Humanoid and Humanoid.WalkSpeed
				else
					WalkSpeed = Character
				end
				u1186 = WalkSpeed
			end)
			if type(u1186) == "number" and u1186 >= 1 and u1186 <= 400 then
				p307._legitWsCache = u1186
			end
			local _legitWsCache = p307._legitWsCache or type(u1186) == "number" and math.clamp(u1186, 1, 400) or 16
			return _legitWsCache
		end
		do
			t46._activeGlideSpeed = function(p308)
				if p308.config.stealMode == "Fly" and p308._flyDeparting then
					return p308:_legitWalkSpeed()
				end
				return 5000
			end
		end
		t46._glideRoot = function(p309, p310, p311, p312)
			if typeof(p310) ~= "CFrame" then
				return false
			end
			local v1191 = p312 or p309:_activeGlideSpeed()
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart or not Humanoid then
				return false
			end
			pcall(v760, Character)
			pcall(function()
				Humanoid.AutoRotate = false
			end)
			p309:_startHoverPad()
			local Position = p310.Position
			local function v1196(p313, p314, p315)
				local v1197 = math.clamp(p309.config.speed or 600, 200, v721())
				pcall(function()
					v795(p313, v1197 * 1.35)
					v860(p314, p315, v1197, Vector3.zero)
				end)
			end
			local v1198 = os.clock() + math.clamp((Position - HumanoidRootPart.Position).Magnitude / math.max(v1191, 1) * 1.6 + 6, 15, 120)
			while true do
				if not (os.clock() < v1198) then
					return false
				end
				if p311 and p311() then
					break
				end
				if p309.destroyed or not p309.enabled and not p309._externalDeliver then
					return false
				end
				local Character2 = LocalPlayer2.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
				Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart2 then
					return false
				end
				if not Humanoid then
					return false
				end
				local Position2 = HumanoidRootPart2.Position
				local v1202 = Position - Position2
				local Magnitude = v1202.Magnitude
				if Magnitude <= 1 then
					pcall(function()
						HumanoidRootPart2.CFrame = p310
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					end)
					p309:_syncHoverPad(Position)
					v1196(Character2, Humanoid, HumanoidRootPart2)
					return true
				end
				local v1204 = math.max(math.min(RunService2.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
				local v1205 = Position2 + v1202.Unit * math.min(v1191 * v1204, Magnitude)
				if v1204 >= 0.033333333333333333 then
					local v1206 = p309:_groundYAt(v1205.X, v1205.Z, Character2)
					if v1206 then
						local v1207 = v1206 + p309:_feetOffset(HumanoidRootPart2, Humanoid)
						if v1205.Y < v1207 then
							v1205 = Vector3.new(v1205.X, v1207, v1205.Z)
						end
					end
				end
				pcall(function()
					HumanoidRootPart2.CFrame = cFrameNew(v1205, v1205 + v1202.Unit)
					HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
				end)
				p309:_syncHoverPad(v1205)
				v1196(Character2, Humanoid, HumanoidRootPart2)
			end
			return false
		end
		t46._walkBrakeDecel = function(p316)
			if p316._brakeDecel then
				return p316._brakeDecel
			end
			local __S2rHubBrakeDecel = genv.__S2rHubBrakeDecel
			if LocalPlayer2.Character then
				local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
				if type(__S2rHubBrakeDecel) == "table" and Humanoid then
					if math.abs((__S2rHubBrakeDecel.ws or 0) - Humanoid.WalkSpeed) < 15 then
						p316._brakeDecel = __S2rHubBrakeDecel.decel
						return __S2rHubBrakeDecel.decel
					end
				end
			else
				type(__S2rHubBrakeDecel)
			end
			return 420
		end
		do
			t46._walkLeg = function(p317, p318, p319, p320, p321, p322, p323)
				local state = 1
				local v1211, v1212, v1213, v1214, v1215, v1216, v1217, n23, v1219, n24, v1221, v1222, v1223, u1224, u1225, u1226, u1227, Character, HumanoidRootPart, Humanoid, Position, vector33, Magnitude, AssemblyLinearVelocity, Magnitude2, v1236, v1237, vector34, now, v1240, v1241, Character2, v1243, Humanoid2, HumanoidRootPart2
				while true do
					if state == 1 then
						v1211 = p317
						v1212 = p318
						v1213 = p319
						v1214 = p320
						v1215 = p321
						v1216 = p322
						v1217 = p323
						n23 = 684529208
						v1219 = nil
						n24 = 602089359
						v1221 = nil
						v1222 = nil
						v1223 = function(p324, p325)
							if p324 then
								if p325 then
									pcall(function()
										p324:MoveTo(p325.Position)
									end)
								end
							end
							return false
						end
						u1224 = nil
						u1225 = nil
						u1226 = nil
						u1227 = nil
						if os.clock() < v1216 then
							state = 2
						else
							state = 40
						end
					elseif state == 2 then
						Character = LocalPlayer2.Character
						HumanoidRootPart = Character
						if HumanoidRootPart then
							state = 35
						else
							state = 3
						end
					elseif state == 3 then
						if Character then
							state = 4
						else
							state = 39
						end
					elseif state == 4 then
						Humanoid = Character:FindFirstChildOfClass("Humanoid")
						state = 5
					elseif state == 5 then
						if HumanoidRootPart and Humanoid then
							state = 6
						else
							state = 38
						end
					elseif state == 6 then
						if v1213 and v1213() then
							state = 7
						else
							state = 8
						end
					else
						if state == 7 then
							return v1223(Humanoid, HumanoidRootPart)
						end
						if state == 8 then
							if not v1211.destroyed and (v1211.enabled or v1211._externalDeliver) then
								state = 10
							else
								state = 9
							end
						else
							if state == 9 then
								return v1223(Humanoid, HumanoidRootPart)
							end
							if state == 10 then
								Position = HumanoidRootPart.Position
								vector33 = Vector3.new(v1212.X - Position.X, 0, v1212.Z - Position.Z)
								Magnitude = vector33.Magnitude
								AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
								Magnitude2 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
								if v1215 then
									state = 11
								else
									state = 13
								end
							elseif state == 11 then
								if Magnitude <= v1214 and Magnitude2 <= 20 then
									state = 12
								else
									state = 19
								end
							else
								if state == 12 then
									pcall(function()
										u1224 = 26636988
										u1225 = 319405266
										Humanoid:MoveTo(Position)
									end)
									return true
								end
								if state == 13 then
									v1236 = v1219
									if v1236 then
										state = 18
									else
										state = 14
									end
								elseif state == 14 then
									v1236 = Magnitude > 0.001
									if v1236 then
										state = 15
									else
										state = 16
									end
								elseif state == 15 then
									v1236 = vector33.Unit
									state = 16
								elseif state == 16 then
									if v1236 then
										state = 18
									else
										state = 17
									end
								elseif state == 17 then
									v1236 = Vector3.zero
									state = 18
								elseif state == 18 then
									v1219 = v1236
									if Magnitude <= v1214 or vector33:Dot(v1219) <= 0 then
										state = 37
									else
										state = 19
									end
								elseif state == 19 then
									v1237 = Magnitude > 0.001
									if v1237 then
										state = 20
									else
										state = 21
									end
								elseif state == 20 then
									v1237 = math.max(AssemblyLinearVelocity.X * vector33.X + AssemblyLinearVelocity.Z * vector33.Z, 0) / Magnitude
									state = 21
								elseif state == 21 then
									if v1237 then
										state = 23
									else
										state = 22
									end
								elseif state == 22 then
									v1237 = Magnitude2
									state = 23
								elseif state == 23 then
									if v1215 and Magnitude <= v1237 * v1237 / (2 * v1211:_walkBrakeDecel()) + v1237 * 0.06 then
										state = 24
									else
										state = 28
									end
								elseif state == 24 then
									vector34 = Position
									now = os.clock()
									if v1221 and v1222 < now and Magnitude2 > 20 then
										state = 25
									else
										state = 27
									end
								elseif state == 25 then
									v1240 = (v1221 - Magnitude2) / (now - v1222)
									if v1240 > 20 and v1240 < 5000 then
										state = 26
									else
										state = 27
									end
								elseif state == 26 then
									v1211._brakeDecel = v1211:_walkBrakeDecel() * 0.8 + v1240 * 0.93 * 0.2
									genv.__S2rHubBrakeDecel = {
										ws = Humanoid.WalkSpeed,
										decel = v1211._brakeDecel
									}
									state = 27
								elseif state == 27 then
									v1221 = Magnitude2
									v1222 = now
									state = 31
								elseif state == 28 then
									v1221 = nil
									v1241 = math.max(Humanoid.WalkSpeed * 0.5, 12)
									if v1215 and Magnitude <= v1241 then
										state = 29
									else
										state = 30
									end
								elseif state == 29 then
									vector34 = Vector3.new(v1212.X, Position.Y, v1212.Z)
									state = 31
								elseif state == 30 then
									vector34 = Position + vector33.Unit * v1241
									state = 31
								elseif state == 31 then
									pcall(function()
										u1226 = 843258489
										u1227 = 553919544
										Humanoid:MoveTo(vector34)
									end)
									if v1217 then
										state = 32
									else
										state = 33
									end
								elseif state == 32 then
									v1217()
									state = 33
								elseif state == 33 then
									RunService2.Heartbeat:Wait()
									if os.clock() < v1216 then
										state = 34
									else
										state = 40
									end
								elseif state == 34 then
									Character = LocalPlayer2.Character
									HumanoidRootPart = Character
									if HumanoidRootPart then
										state = 35
									else
										state = 36
									end
								elseif state == 35 then
									HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
									state = 36
								elseif state == 36 then
									Humanoid = Character
									if Humanoid then
										state = 4
									else
										state = 5
									end
								else
									if state == 37 then
										return true
									end
									if state == 38 then
										return false
									end
									if state == 39 then
										return false
									end
									if state == 40 then
										Character2 = LocalPlayer2.Character
										v1243 = v1223
										Humanoid2 = Character2
										if Humanoid2 then
											state = 41
										else
											state = 42
										end
									elseif state == 41 then
										Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")
										state = 42
									elseif state == 42 then
										HumanoidRootPart2 = Character2
										if HumanoidRootPart2 then
											state = 43
										else
											state = 45
										end
									elseif state == 43 then
										HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
										state = 44
									elseif state == 44 then
										return v1243(Humanoid2, HumanoidRootPart2)
									elseif state == 45 then
										return v1243(Humanoid2, HumanoidRootPart2)
									end
								end
							end
						end
					end
				end
			end
		end
		do
			t46._walkTo = function(p326, p327, p328, p329)
				if typeof(p327) ~= "CFrame" then
					return false
				end
				local v1246 = p329 or 8
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart or not Humanoid then
					return false
				end
				pcall(function()
					Humanoid.AutoRotate = true
				end)
				local Position = p327.Position
				local WalkSpeed = Humanoid.WalkSpeed
				if not WalkSpeed or WalkSpeed < 1 then
					WalkSpeed = 16
				end
				local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude
				return p326:_walkLeg(Position, p328, v1246, true, os.clock() + math.clamp(Magnitude / WalkSpeed * 2 + 8, 12, 90))
			end
		end
		t46._walkToZigzag = function(p330, p331, p332, p333)
			if typeof(p331) ~= "CFrame" then
				return false
			end
			local v1253 = p333 or 8
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				return false
			end
			pcall(function()
				Humanoid.AutoRotate = true
			end)
			local Position = p331.Position
			local WalkSpeed = Humanoid.WalkSpeed
			if not WalkSpeed or WalkSpeed < 1 then
				WalkSpeed = 16
			end
			local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude
			local v1260 = math.max(45, WalkSpeed * WalkSpeed / (2 * p330:_walkBrakeDecel()) * 2.5)
			local v1261 = os.clock() + math.clamp(Magnitude / WalkSpeed * 3 + 10, 14, 120)
			local v1262
			local v1263
			local ok, result, result2 = pcall(function()
				return v1179()
			end)
			if ok and type(result) == "number" and type(result2) == "number" then
				v1262 = math.min(result, result2)
				v1263 = math.max(result, result2)
			end
			while true do
				if not (os.clock() < v1261) then
					return false
				end
				if p332 and p332() then
					break
				end
				if p330.destroyed or not p330.enabled then
					return false
				end
				local Character2 = LocalPlayer2.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
				Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart2 or not Humanoid then
					return false
				end
				local Position2 = HumanoidRootPart2.Position
				local vector33 = Vector3.new(Position.X - Position2.X, 0, Position.Z - Position2.Z)
				local Magnitude2 = vector33.Magnitude
				if Magnitude2 <= v1260 then
					return p330:_walkLeg(Position, p332, v1253, true, v1261)
				end
				local Unit = vector33.Unit
				local vector34 = Vector3.new(-Unit.Z, 0, Unit.X)
				local v1274 = math.max(Magnitude2 - v1260 * 0.5, 4)
				local v1275 = math.min(60 + math.random() * 40, v1274)
				local v1276 = math.min(38, v1275 * 0.4)
				local v1277 = Position2 + Unit * v1275 + vector34 * ((math.random() * 2 - 1) * v1276)
				local Z = v1277.Z
				if v1262 and v1263 then
					Z = math.clamp(Z, v1262 + 2, v1263 - 2)
				end
				if p330:_walkLeg(Vector3.new(v1277.X, Position2.Y, Z), p332, 10, false, v1261) then
					continue
				end
				return false
			end
			return false
		end
		t46._flyWalkTo = function(p334, p335, p336, p337, p338)
			if typeof(p335) ~= "CFrame" then
				return false
			end
			local v1279 = p337 or 8
			local hoverPadHeightOverride = tonumber(p338) or 110
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				return false
			end
			pcall(function()
				Humanoid.AutoRotate = true
			end)
			local function v1284()
				pcall(function()
					local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
					local Animator = Humanoid2 and Humanoid2:FindFirstChildWhichIsA("Animator")
					if Animator then
						for _, v in ipairs(Animator:GetPlayingAnimationTracks()) do
							v:Stop(0)
						end
					end
				end)
			end
			local function v1289(p339)
				local Character2 = LocalPlayer2.Character
				local Animate = Character2 and Character2:FindFirstChild("Animate")
				if Animate then
					pcall(function()
						Animate.Disabled = p339
					end)
				end
			end
			v1289(true)
			v1284()
			local Position = p335.Position
			p334.hoverPadHeightOverride = hoverPadHeightOverride
			p334:_startHoverPad()
			pcall(function()
				HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position.X, hoverPadHeightOverride, HumanoidRootPart.Position.Z) * HumanoidRootPart.CFrame.Rotation
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end)
			p334:_syncHoverPad()
			local WalkSpeed = Humanoid.WalkSpeed
			if not WalkSpeed or WalkSpeed < 1 then
				WalkSpeed = 16
			end
			local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude
			local v1295 = p334:_walkLeg(Position, p336, v1279, true, os.clock() + math.clamp(Magnitude / WalkSpeed * 2 + 10, 12, 120), v1284)
			v1289(false)
			p334.hoverPadHeightOverride = nil
			if not v1295 then
				return false
			end
			if p336 and p336() then
				return false
			end
			p334:_glideRoot(p335, p336, p334:_legitWalkSpeed())
			local v1296 = p336 and p336()
			return not v1296
		end
		t46._isInSafeArea = function(p340, p341)
			if not p341 then
				return false
			end
			local v1297 = p341.Position - vector32
			return Vector2.new(v1297.X, v1297.Z).Magnitude <= 30 and math.abs(v1297.Y) <= 18
		end
		t46._isInField = function(p342, p343)
			local v1298 = v14()
			local Areas = v1298 and v1298:FindFirstChild("Areas")
			local WallStartCollision = Areas and Areas:FindFirstChild("WallStartCollision")
			if WallStartCollision and WallStartCollision:IsA("BasePart") then
				return p343.Position.X >= WallStartCollision.Position.X + 3
			end
			return true
		end
		t46._needsSafeZoneHop = function(p344, p345)
			if p344:_isInField(p345) or p344:_isInSafeArea(p345) then
				return false, nil
			end
			return true, p344:_resolveSafeCFrame(p345)
		end
		t46._invalidateCarryWorker = function(p346)
			p346.carryWorker = nil
		end
		t46._claimCarryWorker = function(p347, p348, p349)
			local generation = p347.carry.generation
			local carryWorker = p347.carryWorker
			if carryWorker then
				if carryWorker.generation == generation then
					return nil
				end
			end
			local carryWorker2 = {
				kind = p348,
				uid = p349,
				generation = generation,
				token = {}
			}
			p347.carryWorker = carryWorker2
			return carryWorker2
		end
		do
			t46._isCarryWorkerCurrent = function(p350, p351)
				return type(p351) == "table" and p350.carryWorker == p351 and p350.carry.generation == p351.generation and not p350.destroyed and (p350.enabled or p350._externalDeliver)
			end
		end
		t46._releaseCarryWorker = function(p352, p353)
			if p352.carryWorker == p353 then
				p352.carryWorker = nil
			end
		end
		t46.ownsCarryRecovery = function(p354, p355)
			if p354.destroyed or not p354.enabled then
				return false
			end
			if p354.carry.uid == p355 then
				return true
			end
			return p354.running and p354.activeTarget ~= nil and (p355 == nil or p354.activeTarget.Uid == p355)
		end
		t46.requestCarryRecovery = function(p356, p357)
			if p356.destroyed or not p356.enabled or type(p357) ~= "string" or p357 == "" then
				return false
			end
			if p356:isSkippedEgg(p357) then
				return true
			end
			if p356.tweenRecoveryUid == p357 then
				p356:_scheduleMovementRetry()
				return true
			end
			if p356.carry.active and p356.carry.uid == p357 then
				return true
			end
			local v1304 = EggState2.ReadFieldEgg(p357) or p356.records[p357]
			if type(v1304) ~= "table" or v1304.State ~= AreaEggs.States.Dropped and v1304.State ~= AreaEggs.States.Slot then
				return false
			end
			local carryWorker = p356.carryWorker
			if (not carryWorker or carryWorker.kind ~= "re-steal" or carryWorker.uid ~= p357) and (not p356.activeTween or not p356.activeTarget or p356.activeTarget.Uid ~= p357) then
				if not p356.carryAttemptToken or not p356.activeTarget or p356.activeTarget.Uid ~= p357 then
					local carry = p356.carry
					carry.generation += 1
					p356:_invalidateCarryWorker()
					p356.carryAttemptToken = nil
					p356.running = true
					p356.activeTarget = v1304
					task.defer(function()
						if not p356.destroyed and p356.enabled and not p356.carry.active then
							p356:_reStealDroppedEgg(p357)
						end
					end)
					return true
				end
			end
			return true
		end
		t46._hasConfirmedCarry = function(p358, p359)
			if not p358.carry.active then
				return false
			end
			if p359 == nil or p358.carry.uid == nil then
				return true
			end
			return p358.carry.uid == p359
		end
		t46._adoptCarryFromRecord = function(p360, p361)
			if p360.carry.active and p360.carry.uid == p361 then
				return
			end
			if p360.carryTimeouts then
				p360.carryTimeouts[p361] = nil
			end
			if p360.instantPhase == "priming" and p361 == p360.primerUid then
				p360.carry.active = true
				p360.carry.uid = p361
				return
			end
			local carry = p360.carry
			carry.generation += 1
			p360:_invalidateCarryWorker()
			p360:_clearArrivalHold(p361)
			local activeTarget = p360.activeTarget
			p360.claimPresentationSuppression = {
				assetCategory = activeTarget and activeTarget.AssetCategory,
				expiresAt = os.clock() + 8
			}
			p360.carry.active = true
			p360.carry.uid = p361
			p360.carryStartTime = os.clock()
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			p360.carryStartPos = activeTarget and activeTarget.BottomCFrame and activeTarget.BottomCFrame.Position or HumanoidRootPart and HumanoidRootPart.Position
			if p360.tweenRecoveryUid == p361 then
				p360.tweenRecoveryUid = nil
			end
			p360.stats.lastResult = "Carry confirmed"
			p360:_notify()
		end
		t46._recordShowsCarried = function(p362, p363)
			if type(p363) ~= "string" or p363 == "" then
				return false
			end
			local v1310 = EggState2.ReadFieldEgg(p363) or p362.records[p363]
			return type(v1310) == "table" and v1310.State == AreaEggs.States.Carried and v1310.CarrierUserId == LocalPlayer2.UserId
		end
		t46._recordShowsForeignCarry = function(p364, p365)
			if type(p365) ~= "string" or p365 == "" then
				return false
			end
			local v1311 = EggState2.ReadFieldEgg(p365) or p364.records[p365]
			return type(v1311) == "table" and v1311.State == AreaEggs.States.Carried and v1311.CarrierUserId ~= nil and v1311.CarrierUserId ~= LocalPlayer2.UserId
		end
		t46._resolveMovementSpeed = function(p366, p367)
			if not p367.Parent or p367.Health <= 0 then
				return nil
			end
			return math.clamp(p366.config.speed, 200, v721())
		end
		t46._isAreaSafe = function()
			return true
		end
		t46._feetOffset = function(p368, p369, p370)
			if p370.RigType == Enum.HumanoidRigType.R15 then
				return p369.Size.Y * 0.5 + math.max(p370.HipHeight, 0.5)
			end
			return p369.Size.Y * 0.5 + 2
		end
		t46.setAntiTrap = function(p371, p372)
			p371.config.antiTrap = p372 == true
			if p371.config.antiTrap then
				p371:_purgeTraps()
			end
		end
		t46._isForeignTrap = function(p373, p374)
			if p374.Name == "PlayerTrap" and p374:IsA("BasePart") then
				local attribute = p374:GetAttribute("Owner")
				return type(attribute) ~= "string" or attribute ~= LocalPlayer2.Name
			end
			return p374:IsA("Model") and p374.Name == "Trap" and p374:FindFirstChild("Hitbox") ~= nil
		end
		t46._purgeTrap = function(p375, p376)
			if p375.config.antiTrap and p376 then
				if p376.Parent then
					if p375:_isForeignTrap(p376) then
						pcall(p376.Destroy, p376)
					end
					return
				end
			end
		end
		t46._purgeTraps = function(p377)
			for _, v in ipairs({
				"Transient",
				"__DEBRIS"
			}) do
				local v1315 = workspace:FindFirstChild(v)
				if v1315 then
					for _, descendant in ipairs(v1315:GetDescendants()) do
						p377:_purgeTrap(descendant)
					end
				end
			end
		end
		do
			t46._syncHoverPad = function(p378, p379)
				local hoverPad = p378.hoverPad
				if not hoverPad or not hoverPad.Parent or hoverPad:GetAttribute("S2rHubRuntimeOwner") ~= p378.hoverPadOwnerId then
					return false
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart or not Humanoid then
					return false
				end
				local Position = typeof(p379) == "Vector3" and p379 or HumanoidRootPart.Position
				local Y = Position.Y
				if p378.hoverPadHeightOverride ~= nil and typeof(p379) ~= "Vector3" then
					Y = p378.hoverPadHeightOverride
				end
				local n25 = 8
				if p378.hoverPadHeightOverride ~= nil then
					n25 = math.max(8, Humanoid.WalkSpeed * 2 / 15)
				end
				if math.abs(hoverPad.Size.X - n25) > 0.5 then
					hoverPad.Size = Vector3.new(n25, 1, n25)
				end
				hoverPad.CFrame = cFrameNew(Position.X, Y - p378:_feetOffset(HumanoidRootPart, Humanoid) - 0.5 - 0.05, Position.Z)
				return true
			end
		end
		do
			t46._setArrivalHold = function(p380, p381, p382)
				if typeof(p381) ~= "CFrame" then
					return
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				if not Character or not HumanoidRootPart then
					return
				end
				p380.arrivalHold = {
					Character = Character,
					RootPart = HumanoidRootPart,
					CFrame = p381,
					Uid = p382
				}
			end
		end
		t46._clearArrivalHold = function(p383, p384)
			local arrivalHold = p383.arrivalHold
			if not arrivalHold or p384 == nil or arrivalHold.Uid == nil or arrivalHold.Uid == p384 then
				p383.arrivalHold = nil
			end
		end
		t46._enforceArrivalHold = function(p385)
			local arrivalHold = p385.arrivalHold
			if type(arrivalHold) ~= "table" or typeof(arrivalHold.CFrame) ~= "CFrame" then
				return false
			end
			if LocalPlayer2.Character ~= arrivalHold.Character or not arrivalHold.RootPart or not arrivalHold.RootPart.Parent then
				p385.arrivalHold = nil
				return false
			end
			p385:_startHoverPad()
			pcall(function()
				arrivalHold.RootPart.AssemblyLinearVelocity = Vector3.zero
				arrivalHold.RootPart.AssemblyAngularVelocity = Vector3.zero
				p385:_syncHoverPad(arrivalHold.CFrame.Position)
				arrivalHold.RootPart.CFrame = arrivalHold.CFrame
			end)
			p385:_syncHoverPad(arrivalHold.CFrame.Position)
			return true
		end
		t46._purgeOrphanHoverPads = function(p386)
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "__S2rHubHoverPad" and child ~= p386.hoverPad then
					pcall(child.Destroy, child)
				end
			end
		end
		t46._startHoverPad = function(p387)
			local hoverPad = p387.hoverPad
			if not hoverPad or not hoverPad.Parent or hoverPad:GetAttribute("S2rHubRuntimeOwner") ~= p387.hoverPadOwnerId then
				p387:_purgeOrphanHoverPads()
				if hoverPad and hoverPad.Parent then
					pcall(hoverPad.Destroy, hoverPad)
				end
				local Part = Instance.new("Part")
				Part.Name = "__S2rHubHoverPad"
				Part:SetAttribute("S2rHubRuntimeOwner", p387.hoverPadOwnerId)
				Part.Anchored = true
				Part.CanCollide = true
				Part.CanQuery = true
				Part.CanTouch = false
				Part.CastShadow = false
				Part.Transparency = 1
				Part.Material = Enum.Material.SmoothPlastic
				Part.Size = Vector3.new(8, 1, 8)
				p387.hoverPad = Part
				Part.Parent = workspace
			end
			p387:_syncHoverPad()
			if not p387.hoverPadConnection then
				p387.hoverPadConnection = RunService2.PreSimulation:Connect(function()
					if not p387:_syncHoverPad() then
						p387:_startHoverPad()
					end
				end)
			end
			if not p387.hoverPadPostConnection then
				p387.hoverPadPostConnection = RunService2.PostSimulation:Connect(function()
					if p387.activeTween or p387.arrivalHold then
						p387:_syncHoverPad()
					end
				end)
			end
		end
		do
			t46._stopHoverPad = function(p388)
				p388.hoverPadHeightOverride = nil
				if p388.hoverPadConnection then
					pcall(p388.hoverPadConnection.Disconnect, p388.hoverPadConnection)
					p388.hoverPadConnection = nil
				end
				if p388.hoverPadPostConnection then
					pcall(p388.hoverPadPostConnection.Disconnect, p388.hoverPadPostConnection)
					p388.hoverPadPostConnection = nil
				end
				if p388.hoverPad then
					pcall(p388.hoverPad.Destroy, p388.hoverPad)
					p388.hoverPad = nil
				end
				p388:_purgeOrphanHoverPads()
			end
		end
		do
			t46._startMovementProtection = function(p389)
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if not Character or not HumanoidRootPart or not Humanoid then
					return false
				end
				local v1336 = math.clamp(p389.config.speed or 600, 200, v721())
				p389.protectionCharacter = Character
				p389.protectionHumanoid = Humanoid
				p389.protectionRoot = HumanoidRootPart
				v795(Character, v1336 * 1.35)
				v856(Humanoid, HumanoidRootPart, v1336)
				if not p389.integritySpoofConnection then
					p389.integritySpoofConnection = RunService2.PreSimulation:Connect(function()
						local Character2 = LocalPlayer2.Character
						local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
						local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")
						if not Character2 or not HumanoidRootPart2 or not Humanoid2 then
							return
						end
						local v1340 = math.clamp(p389.config.speed or 600, 200, v721())
						p389.protectionCharacter = Character2
						p389.protectionHumanoid = Humanoid2
						p389.protectionRoot = HumanoidRootPart2
						v795(Character2, v1340 * 1.35)
						if not v860(Humanoid2, HumanoidRootPart2, v1340) then
							v856(Humanoid2, HumanoidRootPart2, v1340)
						end
						p389:_enforceArrivalHold()
					end)
				end
				if not p389.arrivalHoldConnection then
					p389.arrivalHoldConnection = RunService2.Heartbeat:Connect(function()
						p389:_enforceArrivalHold()
					end)
				end
				return true
			end
		end
		t46._startFlyGrounding = function(p390)
			p390:_stopFlyGrounding()
			local v1341 = v851()
			p390._flyGroundConn = RunService2.PreSimulation:Connect(function()
				if p390.destroyed then
					return
				end
				local State = v1341 and v1341.State
				if type(State) ~= "table" or rawget(State, "CorrectionContext") ~= nil then
					return
				end
				rawset(State, "IsSupportedNow", true)
				rawset(State, "UnsupportedStartedAt", nil)
				if rawget(State, "MovementMode") ~= "Correcting" then
					rawset(State, "MovementMode", "Grounded")
				end
				local value = rawget(State, "Evidence")
				if type(value) == "table" then
					value.Flight = 0
					value.Teleport = 0
					value.Speed = 0
				end
			end)
		end
		t46._stopFlyGrounding = function(p391)
			if p391._flyGroundConn then
				pcall(p391._flyGroundConn.Disconnect, p391._flyGroundConn)
				p391._flyGroundConn = nil
			end
		end
		t46._stopMovementProtection = function(p392)
			p392:_stopFlyGrounding()
			if p392.integritySpoofConnection then
				pcall(p392.integritySpoofConnection.Disconnect, p392.integritySpoofConnection)
				p392.integritySpoofConnection = nil
			end
			if p392.arrivalHoldConnection then
				pcall(p392.arrivalHoldConnection.Disconnect, p392.arrivalHoldConnection)
				p392.arrivalHoldConnection = nil
			end
			p392:_clearArrivalHold()
			p392:_stopHoverPad()
			v799()
			v862(p392.protectionHumanoid)
			p392.protectionCharacter = nil
			p392.protectionHumanoid = nil
			p392.protectionRoot = nil
		end
		t46.travelAndWait = function(p393, p394, p395)
			local v1344 = p395 or {}
			if p393.destroyed then
				return false
			end
			if p393.travelBusy then
				if os.clock() < (p393.travelBusyUntil or 0) then
					return false
				end
			end
			if p393.activeTween and not p393.running and (not p393.activeTween.sharedTravel or v1344.preempt == true) then
				pcall(p393.activeTween.Cancel, p393.activeTween)
				local v1345 = os.clock() + 0.5
				while p393.activeTween and os.clock() < v1345 do
					task.wait(0.05)
				end
			end
			if p393.activeTween then
				return false
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then
				return false
			end
			p393.travelBusy = true
			p393.travelBusyUntil = os.clock() + 45
			local ok, result = pcall(function()
				local u1350
				local now = os.clock()
				local v1352 = now
				local Magnitude = (p394.Position - HumanoidRootPart.Position).Magnitude
				local v1354 = now + Magnitude / math.max(tonumber(v1344.speed) or p393.config.speed or 600, 200) + 6
				p393.travelBusyUntil = v1354 + 2
				p393:_tweenRoot(p394, nil, v1344.speed, {
					silent = true,
					sharedTravel = true,
					abort = function()
						return p393.destroyed or v1344.abort ~= nil and v1344.abort()
					end,
					onDone = function(p396)
						u1350 = p396 == true
					end
				})
				while u1350 == nil do
					local now2 = os.clock()
					local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
					local Magnitude2 = HumanoidRootPart2 and (p394.Position - HumanoidRootPart2.Position).Magnitude or math.huge
					if Magnitude2 < Magnitude - 0.5 then
						Magnitude = Magnitude2
						v1352 = now2
					end
					if p393.destroyed or v1344.abort ~= nil and v1344.abort() or now2 - v1352 >= 1.5 or v1354 <= now2 then
						if p393.activeTween and p393.activeTween.Cancel then
							pcall(p393.activeTween.Cancel)
						end
						u1350 = false
						break
					else
						task.wait(0.05)
					end
				end
				return u1350
			end)
			p393.travelBusy = false
			if ok then
				return result == true
			end
			if p393.activeTween and p393.activeTween.sharedTravel and p393.activeTween.Cancel then
				pcall(p393.activeTween.Cancel)
			end
			return false
		end
		do
			t46._tweenRoot = function(p397, p398, p399, p400, p401)
				p397:_clearArrivalHold()
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local v1361 = p401 or {}
				if not HumanoidRootPart or not Humanoid then
					p397.safeStarting = false
					if not v1361.silent then
						p397:_finish("Character unavailable")
						return
					end
					if v1361.onDone then
						pcall(v1361.onDone, false)
					end
					return
				end
				local v1362 = p400 or p397:_resolveMovementSpeed(Humanoid)
				if not v1362 then
					p397.safeStarting = false
					if not v1361.silent then
						p397:_finish("Movement unavailable")
						return
					end
					if v1361.onDone then
						pcall(v1361.onDone, false)
					end
					return
				end
				local v1363 = math.clamp(v1362, 200, v721())
				p397:_startMovementProtection()
				pcall(v760, Character)
				local CurrentCamera = workspace.CurrentCamera
				if CurrentCamera and CurrentCamera.CameraSubject ~= Humanoid then
					pcall(function()
						CurrentCamera.CameraSubject = Humanoid
					end)
				end
				local AutoRotate = Humanoid.AutoRotate
				Humanoid.AutoRotate = false
				local v1366 = v1361.flightProfile == true and p397:_resolveRouteCruiseY(HumanoidRootPart, p398) or nil
				local activeTween = {
					sharedTravel = v1361.sharedTravel == true,
					routeCruiseY = v1366,
					travelPhase = v1366 and "takeoff" or nil,
					zigzag = p397.config.stealMode == "Zig-Zag",
					zigT = 0,
					zigLast = 0
				}
				p397.activeTween = activeTween
				p397:_startHoverPad()
				local u1368 = false
				local connection
				local now
				local u1371
				local n26 = 0
				local function v1373(p402)
					if u1368 then
						return
					end
					u1368 = true
					now = nil
					if Humanoid.Parent ~= nil then
						Humanoid.AutoRotate = AutoRotate
					end
					if p402 and v1361.holdAfterArrival then
						p397:_setArrivalHold(p398, v1361.holdUid)
					end
					if v1361.onDone then
						pcall(v1361.onDone, p402 == true)
					end
					if connection then
						connection:Disconnect()
						connection = nil
					end
					if p397.activeTween == activeTween then
						p397.activeTween = nil
					end
					if not p397.arrivalHold then
						p397:_stopHoverPad()
					end
					if not p397.enabled then
						p397:_stopMovementProtection()
					end
					pcall(function()
						if LocalPlayer2.Character == Character and HumanoidRootPart.Parent then
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						end
					end)
					if p402 and LocalPlayer2.Character == Character and Humanoid.Parent ~= nil and p399 then
						p399()
					end
				end
				activeTween.Cancel = function()
					v1373(false)
				end
				connection = RunService2.Heartbeat:Connect(function(dt)
					if v1361.abort and v1361.abort() then
						v1373(false)
						return
					end
					if p397.destroyed or p397.activeTween ~= activeTween then
						v1373(false)
						return
					end
					if v1361.carryTarget then
						if (activeTween.nextTargetCheck or 0) <= os.clock() then
							activeTween.nextTargetCheck = os.clock() + 0.1
							local Uid = v1361.carryTarget.Uid
							local v1375 = EggState2.ReadFieldEgg(Uid)
							local State = v1375 and v1375.State
							if State ~= AreaEggs.States.Slot and State ~= AreaEggs.States.Dropped and State ~= "GuardCarried" and (not v1375 or v1375.CarrierUserId ~= LocalPlayer2.UserId) and not p397:_hasConfirmedCarry(Uid) then
								v1373(false)
								local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
								p397:_finish(State == "Carried" and __S2rHubPlayerSteal ~= nil and __S2rHubPlayerSteal:intercept(Uid) and "Target taken - chasing the carrier" or "Target taken by someone else")
								return
							end
						end
					end
					pcall(function()
						local v1378 = math.clamp(p400 or p397.config.speed or v1363, 200, v721())
						v795(Character, v1378 * 1.35)
						local __S2rHubStealAnEggIntegritySpoof = v781().__S2rHubStealAnEggIntegritySpoof
						local State = type(__S2rHubStealAnEggIntegritySpoof) == "table" and __S2rHubStealAnEggIntegritySpoof.State or nil
						if not v855(State, Humanoid, HumanoidRootPart) then
							u1371 = nil
							now = nil
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
							p397:_syncHoverPad(HumanoidRootPart.Position)
							if v854(State, Humanoid, HumanoidRootPart) then
								v831(State, v1378 * 1.35, Vector3.zero)
							else
								v856(Humanoid, HumanoidRootPart, v1378)
							end
							return
						end
						local Position = HumanoidRootPart.Position
						local v1382 = p398.Position - Position
						local Magnitude = v1382.Magnitude
						local vector33 = Vector3.new(v1382.X, 0, v1382.Z)
						local Magnitude2 = vector33.Magnitude
						local Position2 = p398.Position
						if activeTween.routeCruiseY then
							if activeTween.travelPhase == "takeoff" then
								if activeTween.routeCruiseY - 0.5 <= Position.Y then
									activeTween.travelPhase = "cruise"
								else
									Position2 = Vector3.new(Position.X, activeTween.routeCruiseY, Position.Z)
								end
							end
							if activeTween.travelPhase == "cruise" then
								if Magnitude2 <= 4 then
									activeTween.travelPhase = "descend"
								else
									Position2 = Vector3.new(p398.Position.X, activeTween.routeCruiseY, p398.Position.Z)
								end
							end
							if activeTween.travelPhase == "descend" then
								Position2 = p398.Position
							end
						end
						local v1387 = Position2 - Position
						local Magnitude3 = v1387.Magnitude
						local routeCruiseY = activeTween.routeCruiseY and Magnitude2 or Magnitude
						if u1371 and u1371 + 2 < routeCruiseY then
							n26 = os.clock() + 0.5
						end
						u1371 = routeCruiseY
						local v1390 = os.clock() < n26 and math.max(200, v1378 * 0.45) or v1378
						if v1361.carryTarget and not activeTween.__earlyCarrySpam and Magnitude <= 30 then
							activeTween.__earlyCarrySpam = true
							local carryTarget = v1361.carryTarget
							local Uid = carryTarget.Uid
							local v1393 = AreaEggSlotIdentity.LooksLikeFirstAreaUid(Uid) and AreaEggSlotIdentity.SlotKey(carryTarget.AreaId, carryTarget.NestId) or nil
							task.spawn(function()
								while not p397.destroyed and p397.enabled and p397.activeTween == activeTween and not p397:_hasConfirmedCarry(Uid) do
									pcall(v730, Uid, v1393)
									task.wait(0.08)
								end
							end)
						end
						local v1394 = math.max(math.min(dt, 0.15), 0.0041666666666666666)
						local v1395 = v1390 * v1394
						local v1396 = vector33
						local vector34 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z)
						local Unit = v1396.Magnitude > 0.001 and v1396.Unit or vector34.Magnitude > 0.001 and vector34.Unit or Vector3.new(0, 0, -1)
						if (not activeTween.routeCruiseY or activeTween.travelPhase == "descend") and Magnitude <= math.max(v1395, 0.05) then
							if Magnitude > 0.5 then
								now = nil
							end
							p397:_syncHoverPad(p398.Position)
							HumanoidRootPart.CFrame = lookAt(p398.Position, p398.Position + Unit)
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							p397:_syncHoverPad(p398.Position)
							v860(Humanoid, HumanoidRootPart, v1378, Vector3.zero)
							now = now or os.clock()
							if os.clock() - now >= 0.4 then
								v1373(true)
							end
							return
						end
						now = nil
						if Magnitude3 <= 0.001 then
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
							p397:_syncHoverPad(Position)
							return
						end
						if not p397.hoverPad or not p397.hoverPad.Parent then
							p397:_startHoverPad()
						end
						local v1399 = math.min(v1395, Magnitude3)
						local v1400 = Position + v1387.Unit * v1399
						if v1394 >= 0.033333333333333333 and (not activeTween.routeCruiseY or activeTween.travelPhase ~= "cruise") then
							local v1401 = p397:_groundYAt(v1400.X, v1400.Z, Character)
							if v1401 then
								local v1402 = v1401 + p397:_feetOffset(HumanoidRootPart, Humanoid)
								if v1400.Y < v1402 then
									v1400 = Vector3.new(v1400.X, v1402, v1400.Z)
								end
							end
						end
						if activeTween.zigzag and (not activeTween.routeCruiseY or activeTween.travelPhase == "cruise") then
							local vector35 = Vector3.new(v1387.X, 0, v1387.Z)
							if vector35.Magnitude > 1 and Magnitude2 > 12 then
								local Unit2 = vector35.Unit
								local vector36 = Vector3.new(-Unit2.Z, 0, Unit2.X)
								local v1406 = math.min(30, Magnitude2 * 0.3)
								if Magnitude2 < 120 then
									v1406 *= Magnitude2 / 120
								end
								activeTween.zigT = (activeTween.zigT or 0) + v1399
								local zigLast = v1406 * math.sin(activeTween.zigT / 900 * 3.1415926535897931 * 2)
								local zigLast2 = activeTween.zigLast or 0
								activeTween.zigLast = zigLast
								v1400 += vector36 * (zigLast - zigLast2)
								if not activeTween.zigLaneMin then
									local v1409, v1410 = v1179()
									activeTween.zigLaneMin = v1409
									activeTween.zigLaneMax = v1410
								end
								local v1411 = math.clamp(v1400.Z, activeTween.zigLaneMin, activeTween.zigLaneMax)
								if v1411 ~= v1400.Z then
									v1400 = Vector3.new(v1400.X, v1400.Y, v1411)
								end
							else
								activeTween.zigLast = 0
							end
						end
						local v1412 = (v1400 - Position) / v1394
						p397:_syncHoverPad(v1400)
						HumanoidRootPart.CFrame = lookAt(v1400, v1400 + Unit)
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						p397:_syncHoverPad(v1400)
						if not v860(Humanoid, HumanoidRootPart, v1378, v1412) then
							v856(Humanoid, HumanoidRootPart, v1378)
							v860(Humanoid, HumanoidRootPart, v1378, v1412)
						end
					end)
				end)
			end
		end
		t46._reStealDroppedEgg = function(p403, p404)
			if type(p404) ~= "string" or p404 == "" then
				p403:_finish("Egg lost — retrying")
				return
			end
			if p403:isSkippedEgg(p404) then
				return
			end
			if p403.tweenRecoveryUid == p404 then
				p403.running = false
				p403.activeTarget = nil
				p403:_releaseOperation()
				p403:_scheduleMovementRetry()
				return
			end
			local v1413 = p403:_claimCarryWorker("re-steal", p404)
			if not v1413 then
				return
			end
			if genv.__S2rHubGodMode then
				genv.__S2rHubGodMode:startDefend(p404)
			end
			local v1414
			local v1415 = os.clock() + 5
			p403:_setStatus("Re-stealing dropped egg")
			while p403:_isCarryWorkerCurrent(v1413) and os.clock() < v1415 do
				local v1416 = EggState2.ReadFieldEgg(p404) or p403.records[p404]
				if v1416 and (v1416.State == AreaEggs.States.Dropped or v1416.State == AreaEggs.States.Slot) then
					v1414 = v1416
					break
				else
					task.wait(0.03)
				end
			end
			if not p403:_isCarryWorkerCurrent(v1413) then
				return
			end
			if not v1414 or not p403:_wallOpen() then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Egg lost — retrying")
				return
			end
			p403:_cancelTween("Re-stealing dropped egg", true)
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local v1420 = p403:_resolveEggDestination(v1414, HumanoidRootPart, Humanoid)
			local v1421 = v1420 and p403:_resolveElevatedDestination(HumanoidRootPart, v1420) or nil
			if not v1421 then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Character unavailable")
				return
			end
			p403.running = true
			p403.activeTarget = v1414
			p403:_setStatus("Bringing egg home")
			if p403:_regrabBurst(v1413, v1414.Uid, 3.5) or not p403:_isCarryWorkerCurrent(v1413) then
				return
			end
			p403:_setStatus("Re-stealing egg")
			if not p403:_teleportRoot(HumanoidRootPart, Humanoid, v1421) then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Re-steal failed — retrying")
				return
			end
			p403:_setArrivalHold(v1421, v1414.Uid)
			p403:_setStatus("Re-stealing egg")
			if p403:_isCarryWorkerCurrent(v1413) then
				p403:_requestCarry(v1414, true)
			end
		end
		do
			t46._regrabBurst = function(p405, p406, p407, p408)
				local function v1422()
					local v1423 = EggState2.ReadFieldEgg(p407)
					return v1423 ~= nil and v1423.State == AreaEggs.States.Carried and v1423.CarrierUserId == LocalPlayer2.UserId
				end
				local RagdollJoints
				pcall(function()
					RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
				end)
				local u1425 = false
				local u1426 = false
				local v1427 = os.clock() + p408
				while true do
					if not (os.clock() < v1427) or p405.destroyed or not p405.enabled and not p405._externalDeliver then
						return v1422()
					end
					if v1422() then
						break
					end
					if not p405:_isCarryWorkerCurrent(p406) then
						return v1422()
					end
					local v1428 = EggState2.ReadFieldEgg(p407)
					if not v1428 or v1428.State ~= AreaEggs.States.Dropped and v1428.State ~= AreaEggs.States.Slot then
						return false
					end
					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
					if not HumanoidRootPart or not Humanoid then
						return false
					end
					pcall(function()
						if RagdollJoints and RagdollJoints.Release then
							RagdollJoints.Release(Character)
						end
						Humanoid.PlatformStand = false
						Humanoid.Sit = false
						if Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
							Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						end
					end)
					local v1432 = p405:_resolveEggDestination(v1428, HumanoidRootPart, Humanoid)
					if v1432 then
						HumanoidRootPart.CFrame = v1432
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
						p405:_syncHoverPad(v1432.Position)
					end
					if not u1425 then
						u1425 = true
						task.spawn(function()
							pcall(function()
								EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = p407
								})
							end)
							u1425 = false
						end)
					end
					if not u1426 then
						u1426 = true
						task.spawn(function()
							pcall(EggState2.CarryFieldEgg, p407)
							u1426 = false
						end)
					end
					pcall(function()
						local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
						local v1434 = AreaEggSlotsClient and AreaEggSlotsClient:FindFirstChild(tostring(p407))
						local CarryAreaEgg = v1434 and (v1434:FindFirstChild("CarryAreaEgg", true) or v1434:FindFirstChildWhichIsA("ProximityPrompt", true))
						if CarryAreaEgg and CarryAreaEgg.Enabled and type(fireproximityprompt) == "function" then
							CarryAreaEgg.HoldDuration = 0
							CarryAreaEgg.RequiresLineOfSight = false
							fireproximityprompt(CarryAreaEgg, 0)
						end
					end)
					task.wait(0.06)
				end
				return true
			end
		end
		t46._recoverCarryConfirmationTimeout = function(p409, p410, p411)
			if p409.destroyed or not p409.enabled or p409.carryAttemptToken ~= p410 or p409:_hasConfirmedCarry(p411) then
				return false
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local v1438 = HumanoidRootPart and p409:_resolveSafeCFrame(HumanoidRootPart)
			local v1439 = v1438 and p409:_resolveElevatedDestination(HumanoidRootPart, v1438) or nil
			p409.carryTimeouts = p409.carryTimeouts or {}
			local v1440 = (p409.carryTimeouts[p411] or 0) + 1
			local v1441 = v1440 >= 2
			if v1441 then
				p409.carryTimeouts[p411] = nil
				p409.skippedEggs[p411] = os.clock() + 45
				p409.tweenRecoveryUid = nil
			else
				p409.carryTimeouts[p411] = v1440
				p409.tweenRecoveryUid = not p409:_isPrimerEgg(p411) and p411 or nil
			end
			local lastCarryReject = p409.stats.lastCarryReject
			local v1443 = p409.records[p411] or EggState2.ReadFieldEgg(p411)
			local v1444 = p409.config.stealMode == "Instant" and (p411 == p409.primerUid or type(v1443) == "table" and v1443.AreaId == "Forest")
			local carry = p409.carry
			carry.generation += 1
			p409:_invalidateCarryWorker()
			p409.carryAttemptToken = nil
			p409:_clearArrivalHold(p411)
			if p409.activeTween and p409.activeTween.Cancel then
				pcall(p409.activeTween.Cancel, p409.activeTween)
			end
			p409.activeTween = nil
			p409.running = true
			p409.activeTarget = nil
			p409.stats.lastResult = "Carry confirmation timeout"
			if HumanoidRootPart and v1439 then
				pcall(function()
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end)
				p409:_setStatus("Carry timeout - returning to safe area")
				pcall(p409._glideRoot, p409, v1439, function()
					return p409.destroyed or not p409.enabled
				end)
				if v1441 then
					p409:_setStatus(lastCarryReject and "Carry refused (" .. lastCarryReject .. ") — skipping egg" or "Carry timed out twice — skipping egg")
				else
					p409:_setStatus("Carry timeout — retrying")
				end
			else
				p409:_setStatus("Carry timeout — safe area unavailable")
			end
			p409.running = false
			p409:_releaseOperation()
			if v1444 then
				p409.running = true
			end
			task.delay(0.35, function()
				if v1444 then
					if not p409.destroyed and p409.enabled then
						p409:_setStatus("Retrying steal")
						pcall(p409._treadmillReset, p409, function()
							return p409.destroyed or not p409.enabled
						end)
					end
					p409.running = false
				end
				if not p409.destroyed and p409.enabled and p409.carryAttemptToken == nil then
					p409:_schedule()
				end
			end)
			return true
		end
		t46._requestCarry = function(p412, p413, p414)
			if not p412:_wallOpen() then
				p412:_finish("Wall closed before carry")
				return
			end
			local Uid = p413.Uid
			local carryAttemptToken = {}
			local u1448
			p412.stats.lastCarryReject = nil
			local v1449 = p412.instantPhase == "priming" and Uid == p412.primerUid and 5 or math.max(5, p412:_resolveSettleSeconds(p413) + 3)
			p412.carryAttemptToken = carryAttemptToken
			p412.stats.lastResult = "Carry requested"
			p412:_setStatus("Securing egg")
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				pcall(Humanoid.UnequipTools, Humanoid)
			end
			if p412.coordinator then
				local v1452 = os.clock() + 0.35
				while p412.coordinator:isBackgroundBusy() and not p412.destroyed and p412.enabled and p412.carryAttemptToken == carryAttemptToken and os.clock() < v1452 do
					task.wait(0.02)
				end
				if Humanoid and Humanoid.Parent then
					pcall(Humanoid.UnequipTools, Humanoid)
				end
			end
			task.spawn(function()
				while not p412.destroyed and p412.enabled and p412.running and p412.carryAttemptToken == carryAttemptToken and p412.activeTarget and p412.activeTarget.Uid == Uid do
					if not p412:_hasConfirmedCarry(Uid) and p412:_recordShowsCarried(Uid) then
						p412:_adoptCarryFromRecord(Uid)
					end
					if p412:_hasConfirmedCarry(Uid) then
						if not p412:_recordShowsCarried(Uid) then
							p412:_setStatus("Confirming carry record")
							task.wait(0.25)
							continue
						end
						p412:_clearArrivalHold(Uid)
						p412.carryAttemptToken = nil
						if p412.activeTween then
							pcall(p412.activeTween.Cancel, p412.activeTween)
							p412.activeTween = nil
						end
						if p412.instantPhase == "priming" and Uid == p412.primerUid then
							p412.carry.active = true
							p412.carry.uid = Uid
							p412.stats.lastResult = "Preparing steal"
							p412:_enterBaitWait()
							return
						end
						p412.carry.active = true
						p412.carry.uid = Uid
						p412.stats.lastResult = "Carry confirmed"
						p412:_setStatus("Carry confirmed")
						task.defer(function()
							if not p412.destroyed and p412.enabled and p412:_hasConfirmedCarry(Uid) then
								p412:_returnToSafe()
							end
						end)
						return
					end
					if u1448 and u1448 <= os.clock() then
						p412:_recoverCarryConfirmationTimeout(carryAttemptToken, Uid)
						return
					end
					if not p412:_wallOpen() then
						p412:_finish("Wall closed before carry")
						return
					end
					local v1453 = EggState2.ReadFieldEgg(Uid) or p412.records[Uid]
					if not v1453 then
						p412:_finish("Target unavailable")
						return
					end
					if v1453.State == AreaEggs.States.Carried then
						if v1453.CarrierUserId == LocalPlayer2.UserId then
							p412:_setStatus("Confirming carry state")
							task.wait(0.25)
							continue
						end
						p412:_finish("Egg carried by another player")
						return
					end
					if v1453.State ~= AreaEggs.States.Slot and v1453.State ~= AreaEggs.States.Dropped then
						p412:_finish("Target changed")
						return
					end
					local Character2 = LocalPlayer2.Character
					local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")
					if not HumanoidRootPart then
						p412:_finish("Character unavailable")
						return
					end
					local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")
					if not Humanoid2 then
						p412:_finish("Character unavailable")
						return
					end
					local v1457 = p412:_resolveEggDestination(v1453, HumanoidRootPart, Humanoid2)
					local v1458 = v1457 and p412:_resolveElevatedDestination(HumanoidRootPart, v1457) or nil
					if not v1458 then
						p412:_finish("Character unavailable")
						return
					end
					if (HumanoidRootPart.Position - v1458.Position).Magnitude > 10 then
						if not p414 then
							p412:_setStatus("Re-approaching egg")
							local u1459 = false
							p412:_tweenRoot(v1457, function()
								u1459 = true
								if p412.carryAttemptToken == carryAttemptToken and not p412:_hasConfirmedCarry(Uid) then
									p412:_setStatus("Securing egg")
								end
							end, nil, {
								holdAfterArrival = true,
								holdUid = Uid,
								flightProfile = true
							})
							while not p412.destroyed and p412.enabled and p412.carryAttemptToken == carryAttemptToken and not p412:_hasConfirmedCarry(Uid) and not u1459 do
								task.wait(0.25)
							end
							continue
						end
						p412:_setStatus("Re-stealing egg")
						if not p412:_teleportRoot(HumanoidRootPart, Humanoid2, v1458) then
							p412:_finish("Re-steal failed — retrying")
							return
						end
						p412:_setArrivalHold(v1458, Uid)
						p412:_setStatus("Re-stealing egg")
					end
					local ok, result, lastCarryReject = pcall(v730, v1453.Uid, AreaEggSlotIdentity.LooksLikeFirstAreaUid(v1453.Uid) and AreaEggSlotIdentity.SlotKey(v1453.AreaId, v1453.NestId) or nil)
					if not ok then
						lastCarryReject = tostring(result)
					elseif result == true then
						lastCarryReject = nil
					end
					if lastCarryReject then
						p412.stats.lastCarryReject = lastCarryReject
						if lastCarryReject ~= p412._lastCarryRejectLogged then
							p412._lastCarryRejectLogged = lastCarryReject
							warn("[S2rHub Steal] carry refused: " .. lastCarryReject)
						end
					end
					u1448 = u1448 or os.clock() + v1449
					p412.stats.lastResult = "Carry requested"
					p412:_setStatus(lastCarryReject and "Waiting for carry · " .. lastCarryReject or "Waiting for carry confirmation")
					task.wait(0.25)
				end
			end)
		end
		t46._burstHold = function(p415, p416, p417)
			if typeof(p416) ~= "CFrame" then
				return false
			end
			local Position = p416.Position
			local function v1464()
				local Character = LocalPlayer2.Character
				return Character and Character:FindFirstChild("HumanoidRootPart")
			end
			local function v1466(p418)
				p418.CFrame = p416
				p418.AssemblyLinearVelocity = Vector3.zero
				p418.AssemblyAngularVelocity = Vector3.zero
			end
			local v1467 = os.clock() + 0.7
			while true do
				if os.clock() < v1467 then
					if p417 and p417() then
						break
					end
					local v1468 = v1464()
					if not v1468 or not v1468.Parent then
						return false
					end
					pcall(v1466, v1468)
					RunService2.Heartbeat:Wait()
					continue
				end
				local v1469 = os.clock() + 3
				local now
				while true do
					if not (os.clock() < v1469) then
						local v1471 = v1464()
						local v1472 = v1471 ~= nil and (v1471.Position - Position).Magnitude <= 6
						return v1472
					end
					if p417 and p417() then
						break
					end
					local v1473 = v1464()
					if not v1473 or not v1473.Parent then
						return false
					end
					if (v1473.Position - Position).Magnitude > 6 then
						now = nil
					elseif not now then
						now = os.clock()
					elseif os.clock() - now >= 0.45 then
						return true
					end
					pcall(v1466, v1473)
					RunService2.Heartbeat:Wait()
				end
				return false
			end
			return false
		end
		t46._isStealPrompt = function(p419, p420)
			if typeof(p420) ~= "Instance" then
				return false
			end
			if p420.Name == "EnchantedTreePrompt" then
				return true
			end
			local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
			if AreaEggSlotsClient and p420:IsDescendantOf(AreaEggSlotsClient) then
				return true
			end
			if p420:FindFirstAncestor("FuseBiomeLanePortals") or p420:FindFirstAncestor("FuseBiomeZone") then
				return true
			end
			return false
		end
		t46._installPromptFilter = function(p421)
			if p421._promptFilter or type(getconnections) ~= "function" then
				return
			end
			local promptFilter = {
				muted = {},
				forwarders = {}
			}
			p421._promptFilter = promptFilter
			local function v1476()
				return not p421.destroyed and (p421.enabled or p421._externalDeliver or p421._recalling or p421._treeFxMuted ~= nil)
			end
			for _, v in ipairs({
				ProximityPromptService.PromptShown,
				ProximityPromptService.PromptHidden
			}) do
				local ok, result = pcall(getconnections, v)
				local ipairs_ = ipairs
				local v1482 = ok and type(result) == "table" and result or {}
				for _, v2 in ipairs_(v1482) do
					local Function = v2.Function
					local v1486 = false
					local result2
					if type(Function) == "function" then
						v1486, result2 = pcall(debug.info, Function, "s")
					end
					if v1486 then
						if tostring(result2):find("ProximityPromptScriptController", 1, true) and type(v2.Disable) == "function" and pcall(v2.Disable, v2) then
							table.insert(promptFilter.muted, v2)
							table.insert(promptFilter.forwarders, v:Connect(function(p422, ...)
								if v1476() then
									if p421:_isStealPrompt(p422) then
										return
									end
								end
								Function(p422, ...)
							end))
						end
					end
				end
			end
		end
		t46._removePromptFilter = function(p423)
			local _promptFilter = p423._promptFilter
			if not _promptFilter then
				return
			end
			p423._promptFilter = nil
			for _, forwarder in ipairs(_promptFilter.forwarders) do
				pcall(forwarder.Disconnect, forwarder)
			end
			for _, v in ipairs(_promptFilter.muted) do
				pcall(v.Enable, v)
			end
		end
		t46._treadmillReset = function(p424, p425)
			p424._treadmillResetting = true
			local ok, result = pcall(p424._treadmillResetInner, p424, p425)
			p424._treadmillResetting = false
			return ok and result
		end
		t46._treadmillResetInner = function(p426, p427)
			local function v1495()
				return p427 ~= nil and p427()
			end
			local Treadmill = Remotes and Remotes.Treadmill
			if not Treadmill or v1495() then
				return false
			end
			local function v1497()
				local ok, result = pcall(function()
					return Treadmill.AskRenderSnapshot:InvokeServer()
				end)
				if ok and type(result) == "table" then
					return table.find(result, LocalPlayer2.UserId) ~= nil
				end
				return nil
			end
			local function v1500()
				local ok, result = pcall(function()
					local v1503 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
					local v1504 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
					local v1505 = v1504 and v1503 and v1504:FindFirstChild(tostring(v1503))
					local TreadmillBottom = v1505 and v1505:FindFirstChild("TreadmillBottom")
					if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
						return nil
					end
					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character
					local Humanoid, v1510
					if HumanoidRootPart then
						HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
						if Character then
							Humanoid = Character:FindFirstChildOfClass("Humanoid")
							if HumanoidRootPart and Humanoid then
								if Humanoid.RigType == Enum.HumanoidRigType.R15 then
									v1510 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)
									if not v1510 then
										v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
										return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
									end
								else
									v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
								end
								return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
							end
						end
					elseif Character then
						Humanoid = Character:FindFirstChildOfClass("Humanoid")
						if HumanoidRootPart and Humanoid then
							if Humanoid.RigType == Enum.HumanoidRigType.R15 then
								v1510 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)
								if not v1510 then
									v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
									return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
								end
							else
								v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
							end
							return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
						end
					end
					return nil
				end)
				local v1511 = ok and result or nil
				return v1511
			end
			local v1512 = v1500()
			if not v1512 or v1495() then
				return false
			end
			p426:_glideRoot(v1512, function()
				return v1495()
			end)
			if v1495() then
				return false
			end
			local v1513 = false
			local v1514 = os.clock() + 0.7
			if not v1495() and os.clock() < v1514 then
				while true do
					pcall(function()
						Treadmill.AskWearStill:InvokeServer()
					end)
					task.wait(0.08)
					if v1497() == true then
						v1513 = true
						break
					elseif v1495() or not (os.clock() < v1514) then
						break
					end
				end
				if v1513 then
					local v1515 = os.clock() + 0.25
					while not v1495() do
						if not (os.clock() < v1515) then
							break
						end
						task.wait(0.05)
					end
				end
			end
			local v1516 = false
			local v1517 = os.clock() + 0.7
			while not v1495() and os.clock() < v1517 do
				pcall(function()
					Treadmill.AskDoff:InvokeServer()
				end)
				task.wait(0.08)
				if v1497() == false then
					v1516 = true
					break
				end
			end
			local v1518 = v1513 and v1516
			return v1518
		end
		t46._instantReturn = function(p428, p429)
			if p428._instantReturnToken ~= nil then
				return
			end
			local instantReturnToken = {}
			p428._instantReturnToken = instantReturnToken
			p428._flyDeparting = false
			if p428.config.stealMode == "Fly" then
				p428:_showTreadmillDecoy()
			end
			task.spawn(function()
				local function v1520()
					return not p428.destroyed and (p428.enabled or p428._externalDeliver) and p428._instantReturnToken == instantReturnToken
				end
				local function v1521()
					local Character = LocalPlayer2.Character
					return Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				end
				local function v1523()
					return EggState2.ReadFieldEgg(p429)
				end
				local function v1524()
					local v1525 = v1523()
					return v1525 ~= nil and v1525.State == AreaEggs.States.Carried and v1525.CarrierUserId == LocalPlayer2.UserId
				end
				local function v1526()
					local v1527 = v1523()
					if v1527 then
						return v1527.State == AreaEggs.States.Claimed
					end
					return true
				end
				local function v1528(p430, p431)
					local v1529, v1530 = v1521()
					if v1529 and v1530 and typeof(p430) == "CFrame" then
						if p431 then
							p428:_setStatus(p431)
						end
						p428:_teleportRoot(v1529, v1530, p430)
					end
				end
				local function v1531()
					local v1532 = v1521()
					return v1532 and p428:_resolveSafeCFrame(v1532) or nil
				end
				local function v1533(p432)
					p428.settleBonus = p428.settleBonus or {}
					if p432 then
						p428.settleBonus[p429] = nil
					elseif p428.config.stealMode == "Instant" and p428.boostedUid ~= p429 then
						p428.settleBonus[p429] = {
							seconds = 2,
							untilAt = os.clock() + 300
						}
					end
				end
				local function v1534(p433)
					if p428._instantReturnToken ~= instantReturnToken then
						return
					end
					v1533(p433 == nil or p433 == "Safe return complete")
					p428._instantReturnToken = nil
					p428._forestDropInProgress = nil
					local _externalDeliver = p428._externalDeliver
					p428._externalDeliver = nil
					if p428.destroyed then
						return
					end
					if p428.enabled then
						p428:_reportStolen()
						p428:_finish(p433 or "Safe return complete")
					elseif _externalDeliver then
						p428:_reportStolen()
						p428.carry.active = false
						p428.carry.uid = nil
						p428.activeTarget = nil
						p428:_hideTreadmillDecoy()
					end
				end
				p428:_clearArrivalHold(p429)
				local treeRegrabMode = p428.treeBoostedUid == p429 and (p428.treeRegrabMode or "walk") or "glide"
				local function v1537()
					local v1538 = v1521()
					return v1538 ~= nil and p428:_isInSafeArea(v1538)
				end
				local function v1539(p434, p435, p436)
					return p428:_walkTo(p434, p435, p436 or 4)
				end
				local function v1540(p437, p438, p439, p440)
					local v1541 = treeRegrabMode == "walk" or p440 == "egg" and (treeRegrabMode == "glideSafe" or treeRegrabMode == "skipSafe") or p440 == "safe" and treeRegrabMode == "glideEgg"
					if v1541 and p440 == "safe" then
						local v1542 = p428
						local _walkTo = p428._walkTo
						local v1544 = p437
						local function v1545()
							return p438() or v1537()
						end
						local v1546 = p439 or 4
						return _walkTo(v1542, v1544, v1545, v1546)
					end
					if not v1541 then
						return p428:_glideRoot(p437, p438)
					end
					local v1547 = p428
					local _walkTo = p428._walkTo
					local v1549 = p437
					local v1550 = p438
					local v1551 = p439 or 4
					return _walkTo(v1547, v1549, v1550, v1551)
				end
				local v1552 = p428.config.stealMode == "Fly" or p428.boostedUid == p429 and not s2rHubConfig.HelpFriend
				local v1553 = v1552 and 0.15 or 0.4
				local v1554 = v1552 and 0.45 or 0.85
				local v1555 = v1524()
				if not v1555 then
					p428:_setStatus("Confirming carry record")
					local v1556 = os.clock() + 2.5
					while v1520() and os.clock() < v1556 do
						v1555 = v1524()
						if not v1555 then
							local v1557 = v1523()
							if not v1557 or v1557.State ~= AreaEggs.States.Claimed then
								RunService2.Heartbeat:Wait()
								continue
							end
						end
						break
					end
					if not v1520() then
						return
					end
				end
				if v1555 then
					p428._forestDropInProgress = p429
					p428:_setStatus("Bringing egg home")
					p428:_glideRoot(cFrame, function()
						return not v1520() or not v1524()
					end)
					if not v1520() then
						return
					end
					local v1558 = false
					for i = 1, 3 do
						if not v1520() or not v1524() then
							break
						end
						p428:_setStatus("Bringing egg home")
						p428:_glideRoot(cFrame, function()
							return not v1520() or not v1524()
						end)
						if not v1520() then
							return
						end
						if v1524() then
							task.wait(v1553)
							if not v1520() then
								return
							end
							if v1524() then
								pcall(EggState2.DropFieldEgg, "PlayerRequest")
							end
							local v1560 = os.clock() + v1554
							while v1520() and v1524() and os.clock() < v1560 do
								RunService2.Heartbeat:Wait()
							end
						end
						local v1561 = v1523()
						if not v1561 or v1561.State ~= AreaEggs.States.Dropped then
							if not v1524() then
								break
							end
							continue
						end
						v1558 = true
						break
					end
					if not v1520() then
						return
					end
					if not v1558 then
						if p428._instantReturnToken == instantReturnToken then
							p428._instantReturnToken = nil
						end
						p428._forestDropInProgress = nil
						v1533(false)
						p428:_finish("Drop failed — retrying")
						return
					end
					if s2rHubConfig.HelpFriend then
						p428.skippedEggs[p429] = os.clock() + 1800
						p428._forestDropInProgress = nil
						p428.carry.active = false
						p428.carry.uid = nil
						p428.stats.lastResult = "Dropped for a friend"
						p428:_setStatus("Egg dropped for a friend, heading back")
						local v1562 = v1531()
						if v1562 then
							p428:_glideRoot(v1562, function()
								return not v1520()
							end)
						end
						if not v1520() then
							return
						end
						local _externalDeliver = p428._externalDeliver
						p428._instantReturnToken = nil
						p428._externalDeliver = nil
						if p428.enabled then
							p428:_finish("Dropped for a friend")
						elseif _externalDeliver then
							p428.activeTarget = nil
							p428:_hideTreadmillDecoy()
						end
						return
					end
					local Position
					local v1565 = os.clock() + 3
					while v1520() and os.clock() < v1565 do
						local v1566 = v1523()
						if v1566 and v1566.State == AreaEggs.States.Dropped then
							local BottomCFrame = v1566.BottomCFrame or v1566.BoundsCFrame
							Position = BottomCFrame and BottomCFrame.Position
							if not Position then
								task.wait(0.1)
								continue
							end
						elseif not v1566 or v1566.State == AreaEggs.States.Carried then
							task.wait(0.1)
							continue
						end
						break
					end
					if not v1520() then
						return
					end
					p428._forestDropInProgress = nil
					p428:_setStatus("Bringing egg home")
					local v1568 = treeRegrabMode ~= "skipSafe" and v1531() or nil
					if v1568 then
						v1540(v1568, function()
							return not v1520()
						end, nil, "safe")
					end
					if not v1520() then
						return
					end
					local v1569 = p428:_claimCarryWorker("instant-regrab", p429)
					local cFrame2 = Position and cFrameNew(Position + Vector3.new(0, 3.2, 0)) or cFrame
					local function v1571()
						v1540(cFrame2, function()
							return not v1520() or v1524()
						end, 3, "egg")
					end
					local v1572 = false
					if v1569 then
						p428:_setStatus("Bringing egg home")
						v1571()
						if not v1520() then
							return
						end
						v1572 = p428:_regrabBurst(v1569, p429, 0.5)
						if not v1520() then
							return
						end
						if v1524() then
							v1572 = true
						end
						if not v1572 and not v1524() and p428:_isCarryWorkerCurrent(v1569) then
							p428:_setStatus("Bringing egg home")
							local v1573 = v1531()
							if v1573 then
								p428:_glideRoot(v1573, function()
									return not v1520()
								end)
							end
							if not v1520() then
								return
							end
							p428:_setStatus("Bringing egg home")
							p428:_treadmillReset(function()
								return not v1520()
							end)
							if not v1520() then
								return
							end
							p428:_setStatus("Bringing egg home")
							local v1574 = v1531()
							if v1574 then
								p428:_glideRoot(v1574, function()
									return not v1520()
								end)
							end
							if not v1520() then
								return
							end
							if p428:_isCarryWorkerCurrent(v1569) then
								p428:_setStatus("Bringing egg home")
								v1571()
								if not v1520() then
									return
								end
								v1572 = p428:_regrabBurst(v1569, p429, 0.6)
								if not v1520() then
									return
								end
							end
						end
					end
					if not v1572 and not v1524() then
						v1534(v1526() and "Safe return complete" or "Re-grab failed — retrying")
						return
					end
				end
				if v1524() then
					p428:_setStatus("Bringing egg home")
					local v1575 = v1531()
					if v1575 then
						v1539(v1575, function()
							return not v1520() or not v1524()
						end)
					end
				end
				p428:_setStatus("Waiting for deposit")
				local v1576 = os.clock() + 8
				while v1520() and not v1526() and os.clock() < v1576 do
					local v1577, v1578 = v1521()
					if v1577 and v1578 and not p428:_isInSafeArea(v1577) then
						local v1579 = p428:_resolveSafeCFrame(v1577)
						if v1579 then
							v1539(v1579, function()
								return not v1520() or v1526()
							end)
						end
					end
					task.wait(0.1)
				end
				v1534(v1526() and "Safe return complete" or "Bank not confirmed — retrying")
			end)
		end
		t46.deliverCarriedEgg = function(p441, p442, p443)
			if type(p442) ~= "string" or p442 == "" or p441.destroyed then
				return false
			end
			if p441._instantReturnToken ~= nil then
				return false
			end
			p441._externalDeliver = true
			if type(p443) == "table" then
				p441.activeTarget = p443
			end
			p441.carry.active = true
			p441.carry.uid = p442
			p441.reportedUid = nil
			p441:_instantReturn(p442)
			if p441._instantReturnToken ~= nil then
				task.spawn(function()
					local v1580 = os.clock() + 30
					while p441._instantReturnToken ~= nil and os.clock() < v1580 do
						task.wait(0.25)
					end
					if p441._externalDeliver then
						p441._externalDeliver = nil
						p441._instantReturnToken = nil
						p441.carry.active = false
						p441.carry.uid = nil
					end
				end)
				return true
			end
			p441._externalDeliver = nil
			p441.carry.active = false
			p441.carry.uid = nil
			return false
		end
		t46._adminSteal = function(p444, p445)
			local Uid = p445.Uid
			p444._adminBusyUid = Uid
			local function v1582()
				local v1583 = EggState2.ReadFieldEgg(Uid)
				return v1583 ~= nil and v1583.State == AreaEggs.States.Carried and v1583.CarrierUserId == LocalPlayer2.UserId
			end
			local function v1584()
				return not p444.destroyed and p444.enabled and genv.__S2rHubAdminBoost == true and p444._adminBusyUid == Uid
			end
			local ok, result = pcall(function()
				p444.instantPhase = nil
				p444.primerUid = nil
				p444.targetUid = nil
				p444.activeTarget = p445
				p444.stats.lastResult = "Admin Abuse"
				p444:_setStatus("Heading to target egg")
				local v1587 = os.clock() + 3
				local n27 = 0
				while true do
					if not v1584() or v1582() then
						if not v1584() then
							return
						end
						p444.carry.active = true
						p444.carry.uid = Uid
						p444:_adminDeliver(Uid)
						return
					end
					if v1587 <= os.clock() then
						break
					end
					local v1589 = EggState2.ReadFieldEgg(Uid)
					if not v1589 or v1589.State ~= AreaEggs.States.Slot and v1589.State ~= AreaEggs.States.Dropped then
						return p444:_finish("Target egg no longer available")
					end
					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
					if not HumanoidRootPart or not Humanoid then
						return p444:_finish("Character unavailable")
					end
					local v1593 = p444:_resolveEggDestination(v1589, HumanoidRootPart, Humanoid)
					if v1593 and (HumanoidRootPart.Position - v1593.Position).Magnitude > 4 then
						p444:_teleportRoot(HumanoidRootPart, Humanoid, v1593)
					end
					if n27 <= os.clock() then
						n27 = os.clock() + 0.1
						p444:_setStatus("Securing egg")
						task.spawn(function()
							pcall(function()
								EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = Uid
								})
							end)
						end)
					end
					RunService2.Heartbeat:Wait()
				end
				p444.skippedEggs[Uid] = os.clock() + 10
				return p444:_finish("Carry refused — next egg")
			end)
			if p444._adminBusyUid == Uid then
				p444._adminBusyUid = nil
			end
			if not ok then
				warn("[S2rHub Steal] admin steal error: " .. tostring(result))
				if not p444.destroyed and p444.enabled then
					p444:_finish("Steal error — retrying")
				end
			end
		end
		do
			t46._adminDeliver = function(p446, p447)
				if p446._adminDeliverUid == p447 then
					return
				end
				p446._adminDeliverUid = p447
				p446._adminBusyUid = p447
				local function v1594()
					return EggState2.ReadFieldEgg(p447)
				end
				local function v1595()
					local v1596 = v1594()
					return v1596 ~= nil and v1596.State == AreaEggs.States.Carried and v1596.CarrierUserId == LocalPlayer2.UserId
				end
				local function v1597()
					local v1598 = v1594()
					return v1598 == nil or v1598.State == AreaEggs.States.Claimed
				end
				p446:_clearArrivalHold(p447)
				p446:_setStatus("Bringing egg home")
				local v1599 = os.clock() + 4
				while not p446.destroyed and p446.enabled and not v1597() and v1595() and os.clock() < v1599 do
					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
					local v1603 = HumanoidRootPart and p446:_resolveSafeCFrame(HumanoidRootPart)
					if v1603 and Humanoid and (HumanoidRootPart.Position - v1603.Position).Magnitude > 4 then
						p446:_teleportRoot(HumanoidRootPart, Humanoid, v1603)
						p446:_setStatus("Waiting for deposit")
					end
					RunService2.Heartbeat:Wait()
				end
				p446._adminDeliverUid = nil
				if p446._adminBusyUid == p447 then
					p446._adminBusyUid = nil
				end
				if p446.destroyed or not p446.enabled then
					return
				end
				if v1597() then
					p446:_reportStolen()
					p446:_finish("Safe return complete")
				else
					p446:_finish(v1595() and "Bank not confirmed — retrying" or "Egg lost — retrying")
				end
			end
		end
		do
			t46._returnToSafe = function(p448)
				if p448:_isPrimerEgg(p448.carry.uid) then
					local uid = p448.carry.uid
					p448.stats.lastResult = "Steal not banked — retrying"
					p448.carry.active = false
					p448.carry.uid = nil
					local carry = p448.carry
					carry.generation += 1
					p448:_invalidateCarryWorker()
					p448.skippedEggs[uid] = os.clock() + 30
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
					if p448.instantPhase == "priming" then
						p448:_startPrimerTargetHunt()
					else
						task.delay(0.5, function()
							if not p448.destroyed and p448.enabled and not p448.running then
								p448:_schedule()
							end
						end)
					end
					p448:_notify()
					return
				end
				if p448.captureObjectiveEnabled and p448:_isCaptureEgg(p448.carry.uid) then
					p448:_captureHold(p448.carry.uid)
					return
				end
				if genv.__S2rHubAdminBoost == true then
					local uid = p448.carry.uid or p448.activeTarget and p448.activeTarget.Uid
					if uid and p448._adminBusyUid ~= uid then
						task.spawn(p448._adminDeliver, p448, uid)
					end
					return
				end
				if p448.config.stealMode == "Instant" or p448.config.stealMode == "Fly" then
					local uid = p448.carry.uid or p448.activeTarget and p448.activeTarget.Uid
					if not uid then
						p448:_finish("Carry lost — retrying")
						return
					end
					p448:_instantReturn(uid)
					return
				end
				local uid = p448.carry.uid
				local v1609 = p448:_claimCarryWorker("return", uid)
				if not v1609 then
					return
				end
				p448:_clearArrivalHold(uid)
				if not p448:_wallOpen() then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Reset interrupted carry")
					return
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Character unavailable")
					return
				end
				if not p448:_hasConfirmedCarry(uid) or p448:_recordShowsForeignCarry(uid) then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Carry not confirmed — retrying")
					return
				end
				if p448:_isInSafeArea(HumanoidRootPart) then
					p448:_finalizeReturn(v1609)
					return
				end
				if not s2rHubConfig.HelpFriend then
					local v1612 = p448:_resolveSafeCFrame(HumanoidRootPart)
					if not v1612 then
						p448:_releaseCarryWorker(v1609)
						p448:_finish("Safe destination unavailable")
						return
					end
					p448:_setStatus("Returning to safe area")
					p448:_tweenRoot(v1612, function()
						if p448:_isCarryWorkerCurrent(v1609) then
							p448:_finalizeReturn(v1609)
						end
					end, nil, {
						flightProfile = true
					})
					return
				end
				p448.handoffLane = (p448.handoffLane or 0) % #t44 + 1
				local v1613 = cFrameNew(612, vector32.Y, t44[p448.handoffLane]) * HumanoidRootPart.CFrame.Rotation
				p448:_setStatus("Taking the egg to the friend drop")
				p448:_tweenRoot(v1613, function()
					if p448:_isCarryWorkerCurrent(v1609) then
						task.spawn(p448._handOffEgg, p448, v1609, uid, v1613)
					end
				end, nil, {
					flightProfile = true
				})
			end
		end
		do
			t46._handOffEgg = function(p449, p450, p451, p452)
				local function v1614()
					local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
					if not HumanoidRootPart then
						return false
					end
					HumanoidRootPart.CFrame = p452
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
					return true
				end
				local function v1616()
					local v1617 = EggState2.ReadFieldEgg(p451)
					return v1617 ~= nil and v1617.State == AreaEggs.States.Carried and v1617.CarrierUserId == LocalPlayer2.UserId
				end
				p449:_setStatus("Dropping the egg for a friend")
				local n28 = 0.1
				pcall(function()
					n28 = LocalPlayer2:GetNetworkPing() or 0.1
				end)
				local v1619 = os.clock() + math.max(0.3, 0.2 + 2 * n28)
				while os.clock() < v1619 and v1614() do
					RunService2.Heartbeat:Wait()
				end
				p449.skippedEggs[p451] = os.clock() + 1800
				p449:_reportStolen()
				local v1620 = false
				for i = 1, 4 do
					v1614()
					if not v1616() then
						v1620 = true
						break
					end
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
					local v1622 = os.clock() + 0.6
					while true do
						RunService2.Heartbeat:Wait()
						v1620 = not v1616()
						if v1620 then
							break
						elseif v1622 <= os.clock() then
							break
						end
					end
					if v1620 then
						break
					end
				end
				if not v1620 then
					p449.skippedEggs[p451] = nil
					if p449:_isCarryWorkerCurrent(p450) then
						p449:_releaseCarryWorker(p450)
						p449:_finish("Friend drop failed — retrying")
					end
					return
				end
				local v1623 = os.clock() + 1
				while p449.carry.active and os.clock() < v1623 do
					RunService2.Heartbeat:Wait()
				end
				p449.carry.active = false
				p449.carry.uid = nil
				p449.stats.lastResult = "Dropped for a friend"
				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				local v1625 = HumanoidRootPart and p449:_resolveSafeCFrame(HumanoidRootPart)
				if not v1625 then
					p449:_finish("Dropped for a friend")
					return
				end
				p449:_setStatus("Egg dropped for a friend, heading back")
				p449:_tweenRoot(v1625, nil, nil, {
					flightProfile = true,
					onDone = function()
						p449:_finish("Dropped for a friend")
					end
				})
			end
		end
		do
			t46._reportStolen = function(p453)
				local activeTarget = p453.activeTarget
				if not (type(activeTarget) == "table" and activeTarget.Uid) then
					return
				end
				if p453.reportedUid == activeTarget.Uid then
					return
				end
				p453.reportedUid = activeTarget.Uid
				task.delay(1.5, function()
					if p453.destroyed then
						return
					end
					local u1627
					pcall(function()
						u1627 = EggState2.ReadFieldEgg(activeTarget.Uid)
					end)
					if type(u1627) == "table" and (u1627.State == AreaEggs.States.Slot or u1627.State == AreaEggs.States.Dropped or u1627.State == AreaEggs.States.Carried and u1627.CarrierUserId ~= LocalPlayer2.UserId) then
						p453.reportedUid = nil
						p453.stats.deliveryFailed = (p453.stats.deliveryFailed or 0) + 1
						p453.stats.lastResult = "Delivery failed — retrying"
						p453:_notify()
						if p453.enabled and not p453.running then
							p453:_schedule()
						end
						return
					end
					p453.stats.delivered = (p453.stats.delivered or 0) + 1
					local __S2rHubWebhook = genv.__S2rHubWebhook
					if not __S2rHubWebhook then
						return
					end
					local ok, result = pcall(p453.catalog.resolve, activeTarget)
					pcall(__S2rHubWebhook.stolen, activeTarget, ok and result or nil, nil)
				end)
			end
		end
		do
			t46._startWatchdog = function(p454)
				if p454.watchdogRunning then
					return
				end
				p454.watchdogRunning = true
				task.spawn(function()
					local v1631
					local now = os.clock()
					local now2
					local v1634
					local Position
					local now3
					while v16() and not p454.destroyed do
						if not p454.userStealEnabled then
							break
						end
						task.wait(2)
						local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
						local v1638 = tostring(p454.stats.status)
						if not p454.enabled or not p454.running or p454.carry.active or p454.carryAttemptToken ~= nil or p454._instantReturnToken ~= nil or p454._captureHoldUid or not HumanoidRootPart or v1638 ~= v1634 or not Position or not ((HumanoidRootPart.Position - Position).Magnitude < 3) then
							Position = HumanoidRootPart and HumanoidRootPart.Position
							v1634 = v1638
							now3 = os.clock()
						elseif os.clock() - now3 > 12 then
							v1634 = nil
							Position = nil
							now3 = nil
							v1631 = nil
							p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1
							pcall(function()
								p454:_invalidateCarryWorker()
							end)
							p454:_finish("Stuck - retrying")
							p454:_releaseOperation()
						end
						if not p454.enabled or p454._captureHoldUid then
							v1631 = nil
							now2 = nil
						elseif p454.running then
							now2 = nil
							local v1639 = tostring(p454.activeTarget and p454.activeTarget.Uid) .. "|" .. tostring(p454.carry.active)
							if v1639 ~= v1631 then
								v1631 = v1639
								now = os.clock()
							elseif os.clock() - now > 60 then
								v1631 = nil
								p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1
								local Uid = p454.activeTarget and p454.activeTarget.Uid
								if Uid and not p454.carry.active then
									p454.skippedEggs[Uid] = os.clock() + 45
									if p454.tweenRecoveryUid == Uid then
										p454.tweenRecoveryUid = nil
									end
								end
								pcall(function()
									p454:_invalidateCarryWorker()
								end)
								p454:_finish("Stuck — retrying")
							end
						else
							v1631 = nil
							local ok, result = pcall(p454._chooseTarget, p454)
							if p454:_wallOpen() and ok and result ~= nil then
								now2 = now2 or os.clock()
								if os.clock() - now2 > 6 then
									now2 = nil
									p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1
									p454:_releaseOperation()
									p454:_schedule()
								end
							else
								now2 = nil
							end
						end
					end
					p454.watchdogRunning = false
				end)
			end
		end
		t46._finalizeReturn = function(p455, p456)
			if not p455:_isCarryWorkerCurrent(p456) then
				return
			end
			if not p455.carry.active then
				p455:_releaseCarryWorker(p456)
				p455:_reportStolen()
				p455:_finish("Safe return complete")
				return
			end
			p455:_setStatus("Validating safe arrival")
			local now = os.clock()
			local v1644 = os.clock() + 6
			while true do
				if not p455:_isCarryWorkerCurrent(p456) or not p455.carry.active or not (os.clock() < v1644) then
					if not p455:_isCarryWorkerCurrent(p456) then
						return
					end
					if not p455.carry.active then
						p455:_releaseCarryWorker(p456)
						p455:_reportStolen()
						p455:_finish("Safe return complete")
						return
					end
					p455:_setStatus("Deposit pending — validating again")
					task.defer(function()
						if p455:_isCarryWorkerCurrent(p456) and p455.carry.active then
							p455:_finalizeReturn(p456)
						end
					end)
					return
				end
				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then
					p455:_releaseCarryWorker(p456)
					p455:_finish("Character unavailable")
					return
				end
				if not p455:_isInSafeArea(HumanoidRootPart) then
					break
				end
				if os.clock() - now >= 0.35 then
					p455:_setStatus("Waiting for deposit")
				end
				task.wait(0.08)
			end
			p455:_setStatus("Rollback detected — returning again")
			p455:_releaseCarryWorker(p456)
			task.defer(function()
				if not p455.destroyed and p455.enabled and p455.carry.active then
					p455:_returnToSafe()
				end
			end)
		end
		t46._finish = function(p457, p458)
			p457:_noteLowSpeedOutcome(p458)
			p457:_hideTreadmillDecoy()
			p457._forestDropInProgress = nil
			p457._instantReturnToken = nil
			p457.boostedUid = nil
			p457:_invalidateCarryWorker()
			p457.planGeneration += 1
			p457:_cancelTween(p458, p457.enabled)
			p457:_setStatus(p457.enabled and "Searching" or "Idle")
			if p457.enabled then
				task.delay(0.05, function()
					if p457.destroyed or not p457.enabled then
						p457:_releaseOperation()
						return
					end
					p457:_schedule()
				end)
			end
		end
		t46._scheduleMovementRetry = function(p459)
			if p459.movementRetryPending or p459.destroyed or not p459.enabled then
				return
			end
			p459.movementRetryPending = true
			task.delay(0.2, function()
				p459.movementRetryPending = false
				if not p459.destroyed and p459.enabled then
					p459:_schedule()
				end
			end)
		end
		t46._schedule = function(p460)
			if not p460.running then
				p460.safeStarting = false
			end
			if p460.destroyed or not p460.enabled or p460.running then
				return
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				p460:_releaseOperation()
				p460:_setStatus("Character unavailable")
				return
			end
			p460:_startMovementProtection()
			if p460.carry.active and p460.carry.uid ~= nil then
				if p460.instantPhase == "priming" and p460.carry.uid == p460.primerUid then
					return
				end
				if p460:_isPrimerEgg(p460.carry.uid) then
					p460:_setStatus("Dropping primer egg")
					p460.skippedEggs[p460.carry.uid] = os.clock() + 30
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
					task.delay(0.5, function()
						if not p460.destroyed and p460.enabled then
							p460:_schedule()
						end
					end)
					return
				end
				local v1649 = p460.records[p460.carry.uid] or EggState2.ReadFieldEgg(p460.carry.uid)
				local captureObjectiveEnabled = type(v1649) == "table" and (p460.riftWants[v1649.AssetCategory] or p460.captureObjectiveEnabled and p460:_isCaptureEgg(v1649.Uid) or p460.indexObjectiveEnabled and p460:_isIndexObjective(v1649) or p460.wispObjective and p460:_isWispObjective(v1649) or p460.userStealEnabled and not p460.riftOnly and p460:_matchesNormalFilter(v1649))
				if type(v1649) ~= "table" or captureObjectiveEnabled then
					p460:_returnToSafe()
					return
				end
				p460:_setStatus("Dropping unwanted egg")
				p460.skippedEggs[p460.carry.uid] = os.clock() + 30
				pcall(EggState2.DropFieldEgg, "PlayerRequest")
				task.delay(0.5, function()
					if not p460.destroyed and p460.enabled then
						p460:_schedule()
					end
				end)
				return
			end
			if not p460:_wallOpen() then
				p460:_releaseOperation()
				p460:_setStatus("Waiting for reset wall")
				return
			end
			local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
			local autoSteal = t25.blocker("auto_steal")
			local autoSteal2 = not autoSteal and t25.holder("auto_steal") or nil
			if autoSteal or autoSteal2 or __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
				p460:_releaseOperation()
				p460:_setStatus(autoSteal and "Yielding to " .. t25.TITLES[autoSteal] or autoSteal2 and "Waiting for " .. t25.TITLES[autoSteal2] .. " to hand over" or "Yielding to Steal Players")
				if p460._yieldRetryPending then
					return
				end
				p460._yieldRetryPending = true
				task.delay((autoSteal or autoSteal2) and 1 or 0.5, function()
					p460._yieldRetryPending = nil
					if not p460.destroyed and p460.enabled then
						p460:_schedule()
					end
				end)
				return
			end
			local tweenRecoveryUid = p460.tweenRecoveryUid
			local v1655 = tweenRecoveryUid and (EggState2.ReadFieldEgg(tweenRecoveryUid) or p460.records[tweenRecoveryUid]) or nil
			if tweenRecoveryUid then
				if type(v1655) ~= "table" or v1655.State ~= AreaEggs.States.Slot and v1655.State ~= AreaEggs.States.Dropped then
					p460.tweenRecoveryUid = nil
					tweenRecoveryUid = nil
					v1655 = nil
				end
			end
			v1655 = v1655 or p460:_chooseTarget()
			if not v1655 then
				if p460.stats.matching == 0 and p460.stats.available > 0 then
					if (p460.config.minWeightKg or 0) > 0 then
						p460:_setStatus(string.format("No eggs ≥ %dKg", p460.config.minWeightKg))
					else
						p460:_setStatus("No matching eggs")
					end
				else
					p460:_setStatus("No matching eggs")
				end
				p460:_releaseOperation()
				if not p460.activeTween and p460:_isInField(HumanoidRootPart) and not p460:_isInSafeArea(HumanoidRootPart) then
					local v1656 = p460:_resolveSafeCFrame(HumanoidRootPart)
					if v1656 then
						p460:_tweenRoot(v1656, nil, nil, {
							silent = true,
							flightProfile = true,
							abort = function()
								return not p460.enabled or p460.running
							end
						})
					end
				end
				return
			end
			if p460.treadmillManager then
				if p460.treadmillManager:isEngaged() then
					p460.treadmillManager:_cancelIdle(true)
				end
			end
			local planGeneration = p460.planGeneration
			local v1658, v1659 = p460:_acquireOperation()
			if not v1658 then
				p460:_setStatus("Waiting · " .. tostring(v1659 or "another operation"))
				task.delay(0.5, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)
				return
			end
			p460.safeStarting = true
			p460.running = true
			p460.activeTarget = v1655
			local v1660 = p460.catalog.resolve(v1655)
			p460.stats.lastTarget = string.format("%s · %s · %s", v1660.rarity, v1660.name, v1655.AreaId)
			if tweenRecoveryUid then
				p460.safeStarting = false
				p460.stats.lastResult = "Recovering with tween"
				local v1661 = p460:_resolveEggDestination(v1655, HumanoidRootPart, Humanoid)
				if not v1661 then
					p460.tweenRecoveryUid = nil
					p460:_finish("Recovery destination unavailable")
					return
				end
				p460:_setStatus("Returning to egg")
				p460:_tweenRoot(v1661, function()
					if p460.tweenRecoveryUid == v1655.Uid then
						p460:_requestCarry(v1655, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1655.Uid,
					flightProfile = true,
					carryTarget = v1655
				})
				return
			end
			if not p460:_leftTreadmill(HumanoidRootPart) then
				p460.running = false
				p460.safeStarting = false
				p460.activeTarget = nil
				p460:_releaseOperation()
				p460:_setStatus("Preparing steal")
				task.delay(0.3, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)
				return
			end
			if genv.__S2rHubAdminBoost == true and (not p460.captureObjectiveEnabled or not p460:_isCaptureEgg(v1655.Uid)) then
				p460.safeStarting = false
				task.spawn(p460._adminSteal, p460, v1655)
				return
			end
			local v1662 = HumanoidRootPart.Position - vector32
			local Magnitude = Vector2.new(v1662.X, v1662.Z).Magnitude
			local v1664 = false
			if p460.config.stealMode == "Fly" then
				local BottomCFrame = v1655.BottomCFrame or v1655.BoundsCFrame
				if BottomCFrame then
					local v1666 = BottomCFrame.Position - HumanoidRootPart.Position
					if Vector2.new(v1666.X, v1666.Z).Magnitude < Magnitude then
						v1664 = true
					end
				end
			end
			if not v1664 and Magnitude > 3 then
				if os.clock() - (p460.lastSafeRepositionAt or 0) > 5 then
					local v1667 = p460:_resolveSafeCFrame(HumanoidRootPart)
					if v1667 then
						p460.safeStarting = true
						p460.running = true
						p460.lastSafeRepositionAt = os.clock()
						p460:_setStatus("Repositioning to safe area")
						p460:_tweenRoot(v1667, function()
							p460:_groundSnap()
							p460.safeStarting = false
							p460.running = false
							task.delay(0.15, function()
								if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
									p460:_schedule()
								end
							end)
						end, nil, {
							flightProfile = true
						})
						return
					end
				end
			end
			p460.safeStarting = false
			if p460.config.stealMode == "Fly" then
				p460.instantPhase = "priming"
				p460.primerUid = nil
				p460.targetUid = v1655.Uid
				p460.activeTarget = v1655
				p460._flyDeparting = false
				p460.lowFpsPrime = false
				p460:_installGuardHitDistanceBoost()
				p460:_startMovementProtection()
				p460.stats.lastResult = "High Speed departing"
				p460:_startPrimerTargetHunt()
				return
			end
			local v1668 = p460:_choosePrimerEgg(v1655.Uid)
			if not v1668 then
				p460.running = false
				p460.activeTarget = nil
				p460:_releaseOperation()
				p460:_setStatus("Preparing steal")
				task.delay(0.25, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)
				return
			end
			p460.instantPhase = "priming"
			p460.primerUid = v1668.Uid
			p460.primerUids[v1668.Uid] = os.clock() + 120
			p460.skippedEggs[v1668.Uid] = os.clock() + 30
			p460.targetUid = v1655.Uid
			p460.activeTarget = v1668
			p460._flyDeparting = p460.config.stealMode == "Fly"
			if p460.config.stealMode == "Instant" then
				p460:_showTreadmillDecoy()
			end
			p460:_installGuardHitDistanceBoost()
			p460.stats.lastResult = p460.config.stealMode .. " priming"
			p460.lowFpsPrime = v19() < 30
			local v1669 = p460:_resolveEggDestination(v1668, HumanoidRootPart, Humanoid)
			if not v1669 then
				p460:_finish("Steal unavailable — retrying")
				return
			end
			if p460.lowFpsPrime then
				p460:_setStatus("Preparing steal")
				p460:_tweenRoot(v1669, function()
					if p460.instantPhase == "priming" and p460.primerUid == v1668.Uid then
						p460:_requestCarry(v1668, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1668.Uid,
					flightProfile = true,
					carryTarget = v1668
				})
				return
			end
			if p460.config.stealMode == "Fly" then
				p460:_setStatus("Preparing steal")
				if not p460:_glideRoot(v1669, function()
					return p460.destroyed or not p460.enabled or p460.instantPhase ~= "priming" or p460.primerUid ~= v1668.Uid
				end) then
					if p460.instantPhase == "priming" and p460.primerUid == v1668.Uid then
						p460:_finish("Steal unavailable — retrying")
					end
					return
				end
				p460:_setArrivalHold(v1669, v1668.Uid)
				p460:_requestCarry(v1668, true)
				return
			end
			p460:_setStatus("Preparing steal")
			if not p460:_teleportRoot(HumanoidRootPart, Humanoid, v1669) then
				p460:_finish("Steal unavailable — retrying")
				return
			end
			p460:_setArrivalHold(v1669, v1668.Uid)
			p460:_requestCarry(v1668, true)
		end
		t46._leftTreadmill = function(p461, p462)
			local treadmillManager = p461.treadmillManager
			if not treadmillManager or treadmillManager.destroyed then
				return true
			end
			if not (treadmillManager.activeTreadmill ~= nil or treadmillManager.treadmillEquipPending == true or treadmillManager.travelingToTreadmill == true or p462 ~= nil and p462.Anchored) then
				p461.treadmillLeaveAt = nil
				return true
			end
			local now = os.clock()
			p461.treadmillLeaveAt = p461.treadmillLeaveAt or now
			treadmillManager.idleGeneration += 1
			if not p461.treadmillDoffBusy then
				if now - (p461.treadmillDoffAt or 0) > 0.6 then
					p461.treadmillDoffBusy = true
					p461.treadmillDoffAt = now
					task.spawn(function()
						pcall(treadmillManager._requestUnequip, treadmillManager)
						pcall(treadmillManager._syncActiveTreadmillSnapshot, treadmillManager)
						p461.treadmillDoffBusy = false
					end)
				end
			end
			if p462 and p462.Anchored and now - p461.treadmillLeaveAt > 1 then
				pcall(function()
					p462.Anchored = false
				end)
			end
			if not (now - p461.treadmillLeaveAt > 8) then
				return false
			end
			p461.treadmillLeaveAt = nil
			return true
		end
		do
			t46._reconcileRunningState = function(p463)
				local enabled = p463.userStealEnabled == true or next(p463.riftWants) ~= nil or p463.indexObjectiveEnabled == true or p463.wispObjective ~= nil or p463.manualObjectiveEnabled == true or p463.captureObjectiveEnabled == true
				if p463.enabled == enabled then
					if p463.enabled then
						p463:_refreshCounts()
						p463:_schedule()
					end
					return
				end
				p463.enabled = enabled
				if p463.enabled then
					if LocalPlayer2.Character then
						v760(LocalPlayer2.Character)
						v769(p463, LocalPlayer2.Character)
					end
					p463:_installGuardHitDistanceBoost()
					p463:_startMovementProtection()
					pcall(p463._installPromptFilter, p463)
					p463:_setStatus("Searching")
					p463:_schedule()
				else
					if p463._instantReturnToken ~= nil and p463.carry.uid ~= nil and not p463._externalDeliver then
						p463._externalDeliver = true
						p463.planGeneration += 1
						p463.running = false
						p463:_setStatus("Finishing target egg")
						task.spawn(function()
							local v1673 = os.clock() + 45
							while p463._instantReturnToken ~= nil and os.clock() < v1673 and not p463.destroyed do
								task.wait(0.2)
							end
							if p463.destroyed or p463.enabled then
								return
							end
							p463._externalDeliver = nil
							p463._instantReturnToken = nil
							p463.carry.active = false
							p463.carry.uid = nil
							p463.activeTarget = nil
							p463:_cleanupInstantSteal()
							p463:_removeGuardHitDistanceBoost()
							p463:_restoreTreadmillVisualAtSafe()
							p463:_stopMovementProtection()
							v768(p463)
							p463:_setStatus("Idle")
						end)
						p463:_refreshCounts()
						return
					end
					p463.planGeneration += 1
					local carry = p463.carry
					carry.generation += 1
					p463:_cleanupInstantSteal()
					p463:_removeGuardHitDistanceBoost()
					p463:_invalidateCarryWorker()
					p463._forestDropInProgress = nil
					p463._instantReturnToken = nil
					p463.carry.active = false
					p463.carry.uid = nil
					p463.tweenRecoveryUid = nil
					p463.claimPresentationSuppression = nil
					p463.safeStarting = false
					p463.movementRetryPending = false
					p463:_cancelTween("Disabled")
					p463:_releaseOperation()
					p463:_restoreTreadmillVisualAtSafe()
					p463:_stopMovementProtection()
					v768(p463)
					p463.activeTarget = nil
					p463.running = false
					p463:_setStatus("Idle")
				end
				p463:_refreshCounts()
			end
		end
		t46.setEnabled = function(p464, p465)
			p464.userStealEnabled = p465 == true
			p464:_reconcileRunningState()
			if p464.userStealEnabled then
				p464:_startWatchdog()
			end
			p464:_reconcileScramblePortal()
		end
		do
			t46._neutralizeScramblePortal = function(p466, p467)
				if typeof(p467) ~= "Instance" or p467.Name ~= "ScrambleArenaPortal" then
					return
				end
				p466.scramblePortalOriginals = p466.scramblePortalOriginals or {}
				for _, descendant in ipairs(p467:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if p466.scramblePortalOriginals[descendant] == nil then
							local attribute = descendant:GetAttribute("S2rHubPortalOrig")
							if type(attribute) == "string" then
								p466.scramblePortalOriginals[descendant] = {
									CanCollide = attribute:sub(1, 1) == "1",
									CanTouch = attribute:sub(2, 2) == "1"
								}
							else
								p466.scramblePortalOriginals[descendant] = {
									CanCollide = descendant.CanCollide,
									CanTouch = descendant.CanTouch
								}
								pcall(descendant.SetAttribute, descendant, "S2rHubPortalOrig", (descendant.CanCollide and "1" or "0") .. (descendant.CanTouch and "1" or "0"))
							end
						end
						pcall(function()
							descendant.CanCollide = false
							descendant.CanTouch = false
						end)
					end
				end
			end
		end
		t46._startScramblePortalBypass = function(p468)
			local ScrambleArenaPortal = workspace:FindFirstChild("ScrambleArenaPortal")
			if ScrambleArenaPortal then
				p468:_neutralizeScramblePortal(ScrambleArenaPortal)
			end
			if not p468.scramblePortalConn then
				p468.scramblePortalConn = workspace.ChildAdded:Connect(function(child)
					if p468.destroyed or not p468.userStealEnabled or p468._scramblePortalHold or s2rHubConfig.ScrambleBossAuto == true then
						return
					end
					if child.Name ~= "ScrambleArenaPortal" then
						return
					end
					for _, v in ipairs({
						0,
						0.15,
						0.4,
						0.8
					}) do
						task.delay(v, function()
							if not p468.destroyed and p468.userStealEnabled and not p468._scramblePortalHold then
								if s2rHubConfig.ScrambleBossAuto ~= true and child.Parent then
									p468:_neutralizeScramblePortal(child)
								end
							end
						end)
					end
				end)
			end
		end
		t46._stopScramblePortalBypass = function(p469)
			if p469.scramblePortalConn then
				pcall(p469.scramblePortalConn.Disconnect, p469.scramblePortalConn)
				p469.scramblePortalConn = nil
			end
			if p469.scramblePortalOriginals then
				for k, scramblePortalOriginal in pairs(p469.scramblePortalOriginals) do
					if typeof(k) == "Instance" and k.Parent then
						pcall(function()
							k.CanCollide = scramblePortalOriginal.CanCollide
							k.CanTouch = scramblePortalOriginal.CanTouch
							k:SetAttribute("S2rHubPortalOrig", nil)
						end)
					end
				end
				p469.scramblePortalOriginals = nil
			end
		end
		do
			t46._setScramblePortalHold = function(p470, p471)
				local scramblePortalHold = p471 == true
				if p470._scramblePortalHold == scramblePortalHold then
					return
				end
				p470._scramblePortalHold = scramblePortalHold
				p470:_reconcileScramblePortal()
			end
		end
		t46._reconcileScramblePortal = function(p472)
			if not p472.userStealEnabled or p472._scramblePortalHold or s2rHubConfig.ScrambleBossAuto == true then
				p472:_stopScramblePortalBypass()
			else
				p472:_startScramblePortalBypass()
			end
		end
		t46._resolveWeightKg = function(p473, p474)
			local weightUtil = p473.weightUtil
			if not weightUtil or not p474 or not p474.AssetScale or not p474.AssetCategory then
				return nil
			end
			local ok, result = pcall(weightUtil.WeightKgForScale, p474.AssetCategory, p474.AssetScale)
			if ok and type(result) == "number" then
				return result
			end
			return nil
		end
		t46.setHeaviestFirst = function(p475, p476)
			p475.config.heaviestFirst = p476 == true
			if p475.config.heaviestFirst then
				p475.config.highestValueFirst = false
			end
			p475:_schedule()
		end
		t46.setHighestValueFirst = function(p477, p478)
			p477.config.highestValueFirst = p478 == true
			if p477.config.highestValueFirst then
				p477.config.heaviestFirst = false
			end
			p477:_schedule()
		end
		do
			local t53 = {
				rarity = true,
				name = true,
				kg = true,
				mutation = true,
				value = true,
				placed = true,
				icon = true
			}
			v748 = function(p479)
				if type(p479) ~= "table" then
					return nil
				end
				local Category = p479.Category or p479.AssetCategory
				local v1689 = tonumber(p479.Scale or p479.AssetScale)
				if type(Category) ~= "string" or not v1689 or v1689 <= 0 then
					return nil
				end
				local ok, result = pcall(AssetEarnings.MutationOnlyRatePerSecond, {
					Category = Category,
					Scale = v1689,
					Mutations = type(p479.Mutations) == "table" and table.clone(p479.Mutations) or {},
					BaseMutation = type(p479.BaseMutation) == "string" and p479.BaseMutation or nil
				})
				return ok and type(result) == "number" and result or nil
			end
			local u1692
			local function v1693(p480)
				if type(u1692) ~= "table" then
					local ok, result = pcall(require, ReplicatedStorage2.Packages.FormatNumber.Simple)
					if ok and type(result.FormatCompact) == "function" then
						u1692 = result
					end
				end
				if u1692 then
					local ok, result = pcall(u1692.FormatCompact, p480, ".#")
					if ok and type(result) == "string" then
						return result
					end
				end
				local v1698 = math.abs(p480)
				if v1698 >= 1e12 then
					return string.format("%.2fT", p480 / 1e12)
				end
				if v1698 >= 1e9 then
					return string.format("%.2fB", p480 / 1e9)
				end
				if v1698 >= 1000000 then
					return string.format("%.1fM", p480 / 1000000)
				end
				if v1698 >= 1000 then
					return string.format("%.1fK", p480 / 1000)
				end
				return string.format("%d", math.floor(p480 + 0.5))
			end
			local t54 = {
				["Carry not confirmed — retrying"] = true,
				["Carry refused — next egg"] = true,
				["Carry lost — retrying"] = true,
				["Drop failed — retrying"] = true,
				["Egg lost — retrying"] = true,
				["Re-steal failed — retrying"] = true,
				["Steal timed out — retrying"] = true
			}
			local t55 = {}
			local function v1701()
				if next(t55) then
					return t55
				end
				local v1702 = v14()
				local Areas = v1702 and v1702:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local ipairs_ = ipairs
				local children = GuardAreas and GuardAreas:GetChildren() or {}
				for _, child in ipairs_(children) do
					local ClosestExitPoint = child:FindFirstChild("ClosestExitPoint")
					if ClosestExitPoint and ClosestExitPoint:IsA("BasePart") then
						t55[child.Name] = ClosestExitPoint.Position.X
					end
				end
				return t55
			end
			t46.settleNeed = function(p481, p482, p483)
				return 2 + math.max(0, (v1701()[p482] or 597) - 597) / (3.2 * math.max(p483, 16))
			end
			t46.recommendLowSpeedLevel = function(p484, p485)
				local v1710 = p485 or v869()
				local t56 = {}
				if p484.config.areaEnabled and #p484.config.areas > 0 then
					t56 = p484.config.areas
				else
					for k in pairs(v1701()) do
						t56[#t56 + 1] = k
					end
				end
				local n29 = 10
				local n30 = 10
				local v1715
				for _, v in ipairs(t56) do
					local v1718 = p484:settleNeed(v, v1710)
					local n31 = 1
					local n32 = 1
					for i = 10, 1, -1 do
						if v1718 <= v1077(v, i) then
							n31 = i
							break
						end
					end
					for i = 10, 1, -1 do
						if v1718 * 1.25 <= v1077(v, i) then
							n32 = i
							break
						end
					end
					if n31 < n30 then
						n30 = n31
						v1715 = v
					end
					n29 = math.min(n29, n32)
				end
				local lowSpeedFailCap = p484.lowSpeedFailCap
				if lowSpeedFailCap then
					n30 = math.min(n30, lowSpeedFailCap)
					n29 = math.min(n29, lowSpeedFailCap)
				end
				return math.min(n29, n30), n30, v1710, v1715
			end
			t46._noteLowSpeedOutcome = function(p486, p487)
				local v1724 = p486._untrustedSeen == true
				p486._untrustedSeen = nil
				if p486.config.stealMode ~= "Instant" then
					return
				end
				if p486.boostedUid ~= nil or p486._boostHopUid ~= nil then
					return
				end
				local v1725 = t54[tostring(p487)] == true or v1724
				if not v1725 and p487 ~= "Safe return complete" then
					return
				end
				local v1726 = math.clamp(tonumber(s2rHubConfig.StealHoldSeconds) or 5, 1, 10)
				p486.lowSpeedOutcomes = p486.lowSpeedOutcomes or {}
				local v1727 = p486.lowSpeedOutcomes[v1726] or {}
				p486.lowSpeedOutcomes[v1726] = v1727
				v1727[#v1727 + 1] = {
					at = os.clock(),
					failed = v1725
				}
				while #v1727 > 8 do
					table.remove(v1727, 1)
				end
				local n33 = 0
				local n34 = 0
				for _, v in ipairs(v1727) do
					if os.clock() - v.at <= 600 then
						n34 += 1
						if v.failed then
							n33 += 1
						end
					end
				end
				if v1726 > 1 then
					if n33 >= 3 and n33 / n34 >= 0.4 then
						local lowSpeedFailCap = v1726 - 1
						if not p486.lowSpeedFailCap or lowSpeedFailCap < p486.lowSpeedFailCap then
							p486.lowSpeedFailCap = lowSpeedFailCap
							p486.lowSpeedAdvice = {
								from = v1726,
								to = lowSpeedFailCap,
								fails = n33,
								total = n34,
								fresh = true
							}
						end
					end
				end
			end
			t46.lowSpeedStatus = function(p488)
				local u1733
				pcall(function()
					u1733 = SpeedPowerProjection.ReadProjected()
				end)
				local v1734, v1735, v1736 = p488:recommendLowSpeedLevel()
				local v1737 = math.clamp(tonumber(s2rHubConfig.StealHoldSeconds) or 5, 1, 10)
				local lowSpeedAdvice = p488.lowSpeedAdvice
				if lowSpeedAdvice and v1737 <= lowSpeedAdvice.to then
					lowSpeedAdvice = nil
				end
				local t57 = {
					speedText = type(u1733) == "number" and v1693(u1733) or "?",
					walkSpeed = math.floor((v1736 or 0) + 0.5),
					safe = v1734,
					fast = v1735,
					level = v1737,
					advice = lowSpeedAdvice
				}
				return t57
			end
			t46.setEggEsp = function(p489, p490)
				p489.config.espEnabled = p490 == true
				if not p489.config.espEnabled then
					pcall(function()
						p489:_clearEsp()
					end)
				end
			end
			t46.setEspMinRank = function(p491, p492)
				p491.config.espMinRank = math.max(tonumber(p492) or 0, 0)
			end
			t46.setEspMinValue = function(p493, p494)
				p493.config.espMinValue = math.max(tonumber(p494) or 0, 0)
			end
			t46._espPasses = function(p495, p496, p497)
				local config = p495.config
				local espMinRank = config.espMinRank
				if (espMinRank or 0) > 0 then
					if (tonumber(p496 and p496.rarityRank) or 0) < config.espMinRank then
						return false
					end
				end
				if (config.espMinValue or 0) > 0 then
					if (tonumber(p497) or 0) < config.espMinValue then
						return false
					end
				end
				return true
			end
			t46.setEspOption = function(p498, p499, p500)
				if t53[p499] then
					p498.config["esp" .. p499:sub(1, 1):upper() .. p499:sub(2)] = p500 == true
				end
			end
			t46._clearEsp = function()
				local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
				if not AreaEggSlotsClient then
					return
				end
				for _, child in ipairs(AreaEggSlotsClient:GetChildren()) do
					local __S2rHubEggEsp = child:FindFirstChild("__S2rHubEggEsp")
					if __S2rHubEggEsp then
						__S2rHubEggEsp:Destroy()
					end
					local __S2rHubEggHighlight = child:FindFirstChild("__S2rHubEggHighlight")
					if __S2rHubEggHighlight then
						__S2rHubEggHighlight:Destroy()
					end
				end
			end
			t46._updateEsp = function(p501)
				local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
				if not AreaEggSlotsClient then
					return
				end
				local config = p501.config
				for _, child in ipairs(AreaEggSlotsClient:GetChildren()) do
					local v1751 = p501.records[child.Name]
					local v1752 = config.espEnabled and v1751 ~= nil and (v1751.State == AreaEggs.States.Slot or v1751.State == AreaEggs.States.Dropped)
					if v1752 and not p501:_espPasses(p501.catalog.resolve(v1751), v748(v1751)) then
						v1752 = false
					end
					local Hitbox = v1752 and (child:FindFirstChild("Hitbox") or child:FindFirstChildWhichIsA("BasePart", true))
					local __S2rHubEggEsp = child:FindFirstChild("__S2rHubEggEsp")
					local __S2rHubEggHighlight = child:FindFirstChild("__S2rHubEggHighlight")
					if v1752 and Hitbox then
						if __S2rHubEggEsp and not __S2rHubEggEsp:FindFirstChild("Icon") then
							__S2rHubEggEsp:Destroy()
							__S2rHubEggEsp = nil
						end
						if not __S2rHubEggEsp then
							__S2rHubEggEsp = Instance.new("BillboardGui")
							__S2rHubEggEsp.Name = "__S2rHubEggEsp"
							__S2rHubEggEsp.AlwaysOnTop = true
							__S2rHubEggEsp.Size = UDim2.fromOffset(220, 72)
							__S2rHubEggEsp.StudsOffset = Vector3.new(0, 4.4, 0)
							__S2rHubEggEsp.MaxDistance = 1000
							__S2rHubEggEsp.Adornee = Hitbox
							local ImageLabel = Instance.new("ImageLabel")
							ImageLabel.Name = "Icon"
							ImageLabel.AnchorPoint = Vector2.new(0.5, 1)
							ImageLabel.Position = UDim2.fromScale(0.5, 0.42)
							ImageLabel.Size = UDim2.fromOffset(30, 30)
							ImageLabel.BackgroundTransparency = 1
							ImageLabel.ScaleType = Enum.ScaleType.Fit
							ImageLabel.Visible = false
							ImageLabel.Parent = __S2rHubEggEsp
							local TextLabel = Instance.new("TextLabel")
							TextLabel.Name = "Text"
							TextLabel.AnchorPoint = Vector2.new(0.5, 0)
							TextLabel.Position = UDim2.fromScale(0.5, 0.45)
							TextLabel.Size = UDim2.new(1, 0, 0.55, 0)
							TextLabel.BackgroundTransparency = 1
							TextLabel.Font = Enum.Font.GothamBold
							TextLabel.TextSize = 13
							TextLabel.TextStrokeTransparency = 0.35
							TextLabel.TextXAlignment = Enum.TextXAlignment.Center
							TextLabel.TextYAlignment = Enum.TextYAlignment.Top
							TextLabel.Parent = __S2rHubEggEsp
							__S2rHubEggEsp.Parent = child
						end
						__S2rHubEggEsp.Adornee = Hitbox
						local v1758 = p501.catalog.resolve(v1751)
						local Icon = __S2rHubEggEsp:FindFirstChild("Icon")
						local icon = config.espIcon and type(v1758.icon) == "string" and v1758.icon ~= "" and v1758.icon or nil
						Icon.Image = icon or ""
						Icon.Visible = icon ~= nil
						local rarityColor = typeof(v1758.rarityColor) == "Color3" and v1758.rarityColor or Color3.fromRGB(255, 255, 255)
						local t58 = {}
						if config.espRarity then
							t58[#t58 + 1] = string.upper(v1758.rarity or "?")
						end
						if config.espName then
							t58[#t58 + 1] = tostring(v1758.name)
						end
						if config.espKg then
							local v1763 = p501:_resolveWeightKg(v1751)
							if v1763 then
								t58[#t58 + 1] = string.format("%d Kg", math.floor(v1763))
							end
						end
						if config.espMutation and type(v1751.Mutations) == "table" and next(v1751.Mutations) then
							local t59 = {}
							for _, mutation in pairs(v1751.Mutations) do
								t59[#t59 + 1] = tostring(mutation)
							end
							if #t59 > 0 then
								table.sort(t59)
								t58[#t58 + 1] = table.concat(t59, ", ")
							end
						end
						if config.espValue then
							local v1767 = v748(v1751)
							if v1767 then
								t58[#t58 + 1] = "$" .. v1693(v1767) .. "/s"
							end
						end
						local Text = __S2rHubEggEsp:FindFirstChild("Text")
						Text.Text = table.concat(t58, " | ")
						Text.TextColor3 = rarityColor
						if __S2rHubEggHighlight and not __S2rHubEggHighlight:IsA("Highlight") then
							__S2rHubEggHighlight:Destroy()
							__S2rHubEggHighlight = nil
						end
						if not __S2rHubEggHighlight then
							__S2rHubEggHighlight = Instance.new("Highlight")
							__S2rHubEggHighlight.Name = "__S2rHubEggHighlight"
							__S2rHubEggHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							__S2rHubEggHighlight.Parent = child
						end
						__S2rHubEggHighlight.Adornee = child
						__S2rHubEggHighlight.FillColor = rarityColor
						__S2rHubEggHighlight.FillTransparency = 0.72
						__S2rHubEggHighlight.OutlineColor = rarityColor
						__S2rHubEggHighlight.OutlineTransparency = 0
					else
						if __S2rHubEggEsp then
							__S2rHubEggEsp:Destroy()
						end
						if __S2rHubEggHighlight then
							__S2rHubEggHighlight:Destroy()
						end
					end
				end
				p501._placedEspAnchors = p501._placedEspAnchors or {}
				os.clock()
				if config.espPlaced then
					local v1769 = (Save.Peek or Save.Get)()
					local EggInventory = type(v1769) == "table" and v1769.EggInventory
					EggInventory = EggInventory or nil
					local v1771 = PlotState2.ResolveLocalSlot()
					local v1772 = PlotState2.ResolveFolder()
					local v1773 = v1772 and v1771 and v1772:FindFirstChild(tostring(v1771))
					local CenterPoint = v1773 and v1773:FindFirstChild("CenterPoint")
					if CenterPoint and not CenterPoint:IsA("BasePart") then
						CenterPoint = nil
					end
					local t60 = {}
					if type(EggInventory) == "table" and CenterPoint then
						local S2rHubPlacedEggAnchors = workspace:FindFirstChild("S2rHubPlacedEggAnchors")
						if not S2rHubPlacedEggAnchors then
							S2rHubPlacedEggAnchors = Instance.new("Folder")
							S2rHubPlacedEggAnchors.Name = "S2rHubPlacedEggAnchors"
							S2rHubPlacedEggAnchors.Parent = workspace
						end
						for _, child in ipairs(S2rHubPlacedEggAnchors:GetChildren()) do
							if child:IsA("Highlight") or child:IsA("BillboardGui") then
								child:Destroy()
							end
						end
						for k, v in pairs(EggInventory) do
							if type(k) == "string" and type(v) == "table" and type(v.Placement) == "table" then
								t60[k] = true
								local LocalCFrame = v.Placement.LocalCFrame
								if typeof(LocalCFrame) ~= "CFrame" then
									local ok, result = pcall(EggRecords.Decode, v)
									local Placement = ok and type(result) == "table" and result.Placement or nil
									LocalCFrame = type(Placement) == "table" and Placement.LocalCFrame or nil
								end
								if typeof(LocalCFrame) == "CFrame" then
									local ok, result = pcall(EggRecords.Decode, v)
									local v1787 = ok and type(result) == "table" and result or v
									local v1788 = tonumber(v1787.AssetScale) or 1
									local cFrame2 = CenterPoint.CFrame * LocalCFrame + Vector3.new(0, 3 + v1788 * 2, 0)
									p501._placedEspAnchors[k] = p501._placedEspAnchors[k] or {}
									local v1790 = p501._placedEspAnchors[k]
									if typeof(v1790.anchor) ~= "Instance" then
										local Part = Instance.new("Part")
										Part.Name = "S2rHubPE_" .. k
										Part.Size = Vector3.new(1.5, 1.5, 1.5)
										Part.Transparency = 1
										Part.Anchored = true
										Part.CanCollide = false
										Part.CanQuery = false
										Part.CanTouch = false
										Part.Parent = S2rHubPlacedEggAnchors
										v1790.anchor = Part
									end
									v1790.anchor.CFrame = cFrame2
									local v1792 = p501.catalog.resolve({
										AssetCategory = v1787.AssetCategory
									})
									local rarityColor = typeof(v1792.rarityColor) == "Color3" and v1792.rarityColor or Color3.fromRGB(255, 255, 255)
									local v1794 = v748({
										Category = v1787.AssetCategory,
										Mutations = type(v1787.Mutations) == "table" and v1787.Mutations or {},
										Scale = v1788,
										BaseMutation = type(v1787.BaseMutation) == "string" and v1787.BaseMutation or nil
									})
									if p501:_espPasses(v1792, v1794) then
										local t61 = {}
										if config.espRarity then
											t61[#t61 + 1] = string.upper(v1792.rarity or "?")
										end
										if config.espName then
											t61[#t61 + 1] = tostring(v1792.name)
										end
										if config.espKg then
											local ok2, result2 = pcall(EggRecords.WeightKgForScale, v1787.AssetCategory, v1788)
											if ok2 and type(result2) == "number" then
												t61[#t61 + 1] = string.format("%d Kg", math.floor(result2))
											end
										end
										if config.espValue and v1794 then
											t61[#t61 + 1] = "$" .. v1693(v1794) .. "/s"
										end
										if type(v.Placement.ReadyAt) == "number" or type(v1787.Placement) == "table" and v1787.Placement.ReadyAt ~= nil then
											t61[#t61 + 1] = "READY"
										end
										local __S2rHubEggEsp = v1790.anchor:FindFirstChild("__S2rHubEggEsp")
										if not __S2rHubEggEsp then
											__S2rHubEggEsp = Instance.new("BillboardGui")
											__S2rHubEggEsp.Name = "__S2rHubEggEsp"
											__S2rHubEggEsp.AlwaysOnTop = true
											__S2rHubEggEsp.Size = UDim2.fromOffset(220, 72)
											__S2rHubEggEsp.StudsOffset = Vector3.new(0, 1.4, 0)
											__S2rHubEggEsp.MaxDistance = 1000
											local ImageLabel = Instance.new("ImageLabel")
											ImageLabel.Name = "Icon"
											ImageLabel.AnchorPoint = Vector2.new(0.5, 1)
											ImageLabel.Position = UDim2.fromScale(0.5, 0.42)
											ImageLabel.Size = UDim2.fromOffset(34, 34)
											ImageLabel.BackgroundTransparency = 1
											ImageLabel.ScaleType = Enum.ScaleType.Fit
											ImageLabel.Visible = false
											ImageLabel.Parent = __S2rHubEggEsp
											local TextLabel = Instance.new("TextLabel")
											TextLabel.Name = "Text"
											TextLabel.AnchorPoint = Vector2.new(0.5, 0)
											TextLabel.Position = UDim2.fromScale(0.5, 0.45)
											TextLabel.Size = UDim2.new(1, 0, 0.55, 0)
											TextLabel.BackgroundTransparency = 1
											TextLabel.Font = Enum.Font.GothamBold
											TextLabel.TextSize = 13
											TextLabel.TextStrokeTransparency = 0.35
											TextLabel.TextXAlignment = Enum.TextXAlignment.Center
											TextLabel.TextYAlignment = Enum.TextYAlignment.Top
											TextLabel.Parent = __S2rHubEggEsp
											__S2rHubEggEsp.Parent = v1790.anchor
										end
										local Icon = __S2rHubEggEsp:FindFirstChild("Icon")
										if Icon then
											local icon = config.espIcon and type(v1792.icon) == "string" and v1792.icon ~= "" and v1792.icon or nil
											Icon.Image = icon or ""
											Icon.Visible = icon ~= nil
										end
										local Text = __S2rHubEggEsp:FindFirstChild("Text")
										Text.Text = table.concat(t61, " | ")
										Text.TextColor3 = rarityColor
										local __S2rHubEggHighlight = v1790.anchor:FindFirstChild("__S2rHubEggHighlight")
										if __S2rHubEggHighlight then
											__S2rHubEggHighlight:Destroy()
										end
									else
										t60[k] = nil
									end
								end
							end
						end
					end
					for k, placedEspAnchor in pairs(p501._placedEspAnchors) do
						if not t60[k] then
							if typeof(placedEspAnchor.anchor) == "Instance" then
								placedEspAnchor.anchor:Destroy()
							end
							if typeof(placedEspAnchor.highlight) == "Instance" then
								placedEspAnchor.highlight:Destroy()
							end
							p501._placedEspAnchors[k] = nil
						end
					end
				else
					local pairs_ = pairs
					local _placedEspAnchors = p501._placedEspAnchors or {}
					for k, _placedEspAnchor in pairs_(_placedEspAnchors) do
						if typeof(_placedEspAnchor.anchor) == "Instance" then
							_placedEspAnchor.anchor:Destroy()
						end
						if typeof(_placedEspAnchor.highlight) == "Instance" then
							_placedEspAnchor.highlight:Destroy()
						end
						p501._placedEspAnchors[k] = nil
					end
				end
			end
		end
		t46.setMinWeightKg = function(p502, p503)
			p502.config.minWeightKg = math.max(tonumber(p503) or 0, 0)
		end
		t46.setMinValuePerSec = function(p504, p505)
			p504.config.minValuePerSec = math.max(tonumber(p505) or 0, 0)
			p504:_refreshCounts()
			p504:_schedule()
		end
		t46.setSpeed = function(p506, p507)
			local v1811 = math.clamp(math.floor((tonumber(p507) or 60) + 0.5), 20, 100)
			p506.config.speed = v1811 * 10
			if genv.__S2rHubAdminBoost == true then
				p506.config.speed = 3000
			end
			if p506.enabled or p506.activeTween then
				p506:_startMovementProtection()
			end
			return v1811
		end
		do
			t46.getDefaultSpeed = function()
				return 60
			end
		end
		do
			t46.setFilterEnabled = function(p508, p509, p510)
				p508.config[p509 .. "Enabled"] = p510 == true
				p508:_refreshCounts()
				p508:_schedule()
			end
		end
		t46.setFilter = function(p511, p512, p513)
			local v1812 = type(p513) == "table" and table.clone(p513) or {}
			if p512 == "mutations" and type(p511.catalog.resolveMutationId) == "function" then
				local t62 = {}
				for _, v in ipairs(v1812) do
					local v1816 = p511.catalog.resolveMutationId(v)
					if v1816 then
						table.insert(t62, v1816)
					end
				end
				v1812 = t62
			end
			p511.config[p512] = v1812
			p511:_refreshCounts()
			p511:_schedule()
		end
		t46.destroy = function(p514)
			if p514.destroyed then
				return
			end
			p514.destroyed = true
			p514.enabled = false
			pcall(p514._stopScramblePortalBypass, p514)
			pcall(p514._removePromptFilter, p514)
			if p514._relocateConn then
				pcall(p514._relocateConn.Disconnect, p514._relocateConn)
				p514._relocateConn = nil
			end
			p514._recalling = nil
			p514:_hideTreadmillDecoy()
			p514.planGeneration += 1
			local carry = p514.carry
			carry.generation += 1
			p514:_invalidateCarryWorker()
			p514.carry.active = false
			p514.carry.uid = nil
			p514.tweenRecoveryUid = nil
			p514.safeStarting = false
			p514:_cancelTween("Destroyed")
			p514:_cleanupInstantSteal()
			p514:_removeGuardHitDistanceBoost()
			p514:_releaseOperation()
			p514:_stopMovementProtection()
			if p514._healthPinner then
				pcall(p514._healthPinner.Disconnect, p514._healthPinner)
				p514._healthPinner = nil
			end
			if p514._healthChangedConnection then
				pcall(p514._healthChangedConnection.Disconnect, p514._healthChangedConnection)
				p514._healthChangedConnection = nil
			end
			p514:_restoreClaimPresentationFilter()
			v779(LocalPlayer2.Character)
			pcall(function()
				p514:_clearEsp()
			end)
			pcall(function()
				local pairs_ = pairs
				local _placedEspAnchors = p514._placedEspAnchors or {}
				for _, _placedEspAnchor in pairs_(_placedEspAnchors) do
					if typeof(_placedEspAnchor.anchor) == "Instance" then
						_placedEspAnchor.anchor:Destroy()
					end
				end
				local S2rHubPlacedEggAnchors = workspace:FindFirstChild("S2rHubPlacedEggAnchors")
				if S2rHubPlacedEggAnchors then
					S2rHubPlacedEggAnchors:Destroy()
				end
			end)
			v740(p514.connections)
			table.clear(p514.listeners)
			table.clear(p514.records)
		end
		return t46
	end
	local v1823 = v704()
	local t63 = {
		k = 1000,
		m = 1000000,
		b = 1e9,
		t = 1e12,
		q = 1e15
	}
	local function v1825(p515)
		local match, v1827 = tostring(p515 or ""):lower():gsub("%s+", ""):gsub("%$", ""):gsub("/s$", ""):match("^([%d%.]+)([kmbtq]?)$")
		local v1828 = tonumber(match)
		if v1828 then
			return math.max(0, math.floor(v1828 * (t63[v1827] or 1) + 0.5))
		end
		return nil
	end
	local function v1829()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local Ragdoll = require(ReplicatedStorage2.Shared.Modules.Ragdoll)
		local RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
		local EggWorld = Remotes.EggWorld
		local t64 = {}
		t64.__index = t64
		local function v1840(p516)
			if p516 then
				pcall(p516.Disconnect, p516)
			end
		end
		t64.new = function(p517)
			local obj = setmetatable({}, t64)
			obj.eggRuntime = p517
			obj.enabled = true
			obj.destroyed = false
			obj.connections = {}
			obj.originalRagdoll = {}
			obj.originalHumanoidStates = setmetatable({}, {
				__mode = "k"
			})
			obj.stats = {
				blockedHits = 0,
				blockedDrops = 0,
				recarriedEggs = 0
			}
			obj.lastHeldEggUid = nil
			obj.lastHeldSlotKey = nil
			obj._installed = false
			obj._stickyToken = 0
			obj._nextBodyRecoveryAt = 0
			obj._nextJointSweepAt = 0
			obj._forestStrikeOldFire = nil
			return obj
		end
		t64._liveBody = function()
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			return Character, Humanoid, Character and Character:FindFirstChild("HumanoidRootPart")
		end
		t64._recoverBody = function(p518, p519)
			if not p518.enabled or p518.destroyed then
				return
			end
			local v1844, v1845, v1846 = p518:_liveBody()
			if not v1844 or not v1845 or not v1846 then
				return
			end
			local now = os.clock()
			if not p519 and now < p518._nextBodyRecoveryAt then
				return
			end
			p518._nextBodyRecoveryAt = now + 0.03
			if not p518.originalHumanoidStates[v1845] then
				p518.originalHumanoidStates[v1845] = {
					Physics = v1845:GetStateEnabled(Enum.HumanoidStateType.Physics),
					FallingDown = v1845:GetStateEnabled(Enum.HumanoidStateType.FallingDown),
					Ragdoll = v1845:GetStateEnabled(Enum.HumanoidStateType.Ragdoll)
				}
			end
			local state = v1845:GetState()
			local v1849 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown
			v1849 = v1849 or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated
			pcall(function()
				v1845.BreakJointsOnDeath = false
				v1845.RequiresNeck = false
				v1845:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				v1845.PlatformStand = false
				v1845.Sit = false
				local state2 = v1845:GetState()
				if state2 == Enum.HumanoidStateType.Physics or state2 == Enum.HumanoidStateType.FallingDown or state2 == Enum.HumanoidStateType.Ragdoll or state2 == Enum.HumanoidStateType.PlatformStanding or state2 == Enum.HumanoidStateType.Seated then
					v1845:ChangeState(Enum.HumanoidStateType.GettingUp)
					v1845:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			for _, descendant in ipairs(v1844:GetDescendants()) do
				if not descendant:IsA("Motor6D") then
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
						if descendant.Name:find("Ragdoll", 1, true) or descendant:GetAttribute("RagdollConstraint") then
							pcall(descendant.Destroy, descendant)
						end
					end
				elseif not descendant.Enabled then
					descendant.Enabled = true
				end
			end
			local AssemblyLinearVelocity = v1846.AssemblyLinearVelocity
			local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
			local v1855 = math.max(340, (tonumber(v1845.WalkSpeed) or 0) * 1.5)
			if v1849 or v1855 < Magnitude or math.abs(AssemblyLinearVelocity.Y) > 240 then
				v1846.AssemblyLinearVelocity = Vector3.zero
				v1846.AssemblyAngularVelocity = Vector3.zero
				p518.stats.blockedHits += 1
			end
		end
		t64._watchCharacter = function(p520, p521)
			if not p521 then
				return
			end
			local connection = p521.DescendantAdded:Connect(function(descendant)
				if not p520.enabled or p520.destroyed then
					return
				end
				if not descendant:IsA("BallSocketConstraint") and not descendant:IsA("HingeConstraint") then
					if descendant:IsA("Motor6D") and not descendant.Enabled then
						descendant.Enabled = true
					end
				elseif descendant.Name:find("Ragdoll", 1, true) or descendant:GetAttribute("RagdollConstraint") then
					pcall(descendant.Destroy, descendant)
					p520:_recoverBody(true)
				end
			end)
			table.insert(p520.connections, connection)
		end
		t64._installRagdollHooks = function(p522)
			if p522._installed then
				return
			end
			p522._installed = true
			task.spawn(function()
				task.wait()
				local __S2rHubForestGate = genv.__S2rHubForestGate
				if type(__S2rHubForestGate) == "table" and __S2rHubForestGate.comp and __S2rHubForestGate.orig then
					pcall(rawset, __S2rHubForestGate.comp, "_attackHandler", __S2rHubForestGate.orig)
					genv.__S2rHubForestGate = nil
				end
				if type(getgc) ~= "function" then
					return
				end
				local ok, result = pcall(getgc, true)
				if not ok or type(result) ~= "table" then
					return
				end
				for i, v in ipairs(result) do
					if i % 20000 == 0 then
						RunService2.Heartbeat:Wait()
					end
					if p522.destroyed then
						return
					end
					if type(v) ~= "table" or rawget(v, "_areaId") ~= "Forest" or type(rawget(v, "_attackHandler")) ~= "function" then
						continue
					end
					local value = rawget(v, "_attackHandler")
					p522._forestGate = {
						comp = v,
						orig = value
					}
					genv.__S2rHubForestGate = p522._forestGate
					rawset(v, "_attackHandler", function(...)
						if not p522.enabled or p522.destroyed or p522.eggRuntime and p522.eggRuntime.instantPhase == "priming" or genv.__S2rHubPlayerSteal and genv.__S2rHubPlayerSteal.running then
							return value(...)
						end
						p522.stats.blockedHits += 1
						p522:_recoverBody(true)
						if genv.__S2rHubGodMode then
							genv.__S2rHubGodMode:startDefend()
						end
					end)
					break
				end
			end)
			for _, v in ipairs({
				"ApplyClientRagdoll",
				"Ragdoll",
				"TimedRagdoll",
				"TimedRagdollAsync"
			}) do
				if type(Ragdoll[v]) == "function" then
					p522.originalRagdoll[v] = Ragdoll[v]
					Ragdoll[v] = function(...)
						if p522.enabled then
							if not p522.destroyed then
								p522.stats.blockedHits += 1
								p522:_recoverBody(true)
								return
							end
						end
						return p522.originalRagdoll[v](...)
					end
				end
			end
			if type(Ragdoll.IsRagdolled) == "function" then
				p522.originalRagdoll.IsRagdolled = Ragdoll.IsRagdolled
				Ragdoll.IsRagdolled = function(p523)
					if p522.enabled then
						if p523 == LocalPlayer2.Character then
							return false
						end
					end
					return p522.originalRagdoll.IsRagdolled(p523)
				end
			end
		end
		t64._restoreLocalState = function(p524)
			for k, originalHumanoidState in pairs(p524.originalHumanoidStates) do
				if k.Parent then
					pcall(function()
						k:SetStateEnabled(Enum.HumanoidStateType.Physics, originalHumanoidState.Physics)
						k:SetStateEnabled(Enum.HumanoidStateType.FallingDown, originalHumanoidState.FallingDown)
						k:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, originalHumanoidState.Ragdoll)
					end)
				end
			end
			p524.originalHumanoidStates = setmetatable({}, {
				__mode = "k"
			})
			pcall(RagdollJoints.Release, LocalPlayer2.Character)
		end
		t64._slotKey = function(p525, p526)
			if type(p526) == "table" and type(p526.AreaId) == "string" and type(p526.NestId) == "string" then
				return string.format("%s:%s", p526.AreaId, p526.NestId)
			end
			return nil
		end
		t64._requestCarry = function(p527, p528, p529)
			local t65 = {
				Uid = p528
			}
			if p529 ~= nil then
				t65.FirstAreaSlotKey = p529
			end
			return EggWorld.AskFieldEggCarry:InvokeServer(t65)
		end
		t64._startSticky = function(p530, p531, p532)
			if type(p531) ~= "string" or p531 == "" then
				return
			end
			p530._stickyToken += 1
			local _stickyToken = p530._stickyToken
			p530.stats.recarriedEggs += 1
			task.spawn(function()
				local v1869 = os.clock() + 5
				while not p530.destroyed and p530.enabled and _stickyToken == p530._stickyToken and os.clock() < v1869 do
					local v1870 = EggState2.ReadFieldEgg(p531)
					if v1870 and v1870.State == "Carried" and v1870.CarrierUserId == LocalPlayer2.UserId then
						p530.lastHeldEggUid = p531
						p530.lastHeldSlotKey = p532 or p530:_slotKey(v1870)
						return
					end
					if v1870 and (v1870.State == "Dropped" or v1870.State == "Slot") then
						if p530.eggRuntime then
							if p530.eggRuntime:requestCarryRecovery(p531) then
								return
							end
						end
						local _, _, v1873 = p530:_liveBody()
						if v1873 and v1870.BottomCFrame and (v1873.Position - v1870.BottomCFrame.Position).Magnitude <= 10 then
							pcall(p530._requestCarry, p530, p531, p532 or p530:_slotKey(v1870))
						end
					end
					task.wait(0.05)
				end
			end)
		end
		t64._bindSignals = function(p533)
			table.insert(p533.connections, EggState2.CarryChanged:Connect(function(p534)
				if not p533.enabled then
					return
				end
				if p534.IsCarrying and type(p534.Uid) == "string" then
					p533._stickyToken += 1
					p533.lastHeldEggUid = p534.Uid
					local v1874 = EggState2.ReadFieldEgg(p534.Uid)
					p533.lastHeldSlotKey = p533:_slotKey(v1874)
					return
				end
				local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
				if __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
					return
				end
				local Uid = p534.Uid or p533.lastHeldEggUid
				local lastHeldSlotKey = p533.lastHeldSlotKey
				if p533.eggRuntime then
					if p533.eggRuntime:isSkippedEgg(Uid) then
						return
					end
				end
				if Uid then
					p533.stats.blockedDrops += 1
					p533:_startSticky(Uid, lastHeldSlotKey)
					if genv.__S2rHubGodMode then
						genv.__S2rHubGodMode:startDefend(Uid)
					end
				end
			end))
			table.insert(p533.connections, LocalPlayer2.CharacterAdded:Connect(function(character)
				p533:_watchCharacter(character)
				task.defer(function()
					p533:_recoverBody(true)
				end)
			end))
			if LocalPlayer2.Character then
				p533:_watchCharacter(LocalPlayer2.Character)
			end
			table.insert(p533.connections, RunService2.Stepped:Connect(function()
				p533:_recoverBody()
			end))
		end
		t64.setEnabled = function(p535, p536)
			local enabled = p536 == true
			if p535.enabled == enabled then
				return
			end
			p535.enabled = enabled
			if p535.enabled then
				p535:_recoverBody()
			else
				p535._stickyToken += 1
				p535:_restoreLocalState()
			end
		end
		t64.install = function(p537)
			if p537.destroyed then
				return false
			end
			getgenv().__S2rHubAntiGuard = p537
			p537:_installRagdollHooks()
			p537:_bindSignals()
			p537:_recoverBody()
			return true
		end
		local s2 = "destroy"
		local function v1880(p538)
			if p538.destroyed then
				return
			end
			p538.enabled = false
			p538:_restoreLocalState()
			p538.destroyed = true
			p538._stickyToken += 1
			for _, connection in ipairs(p538.connections) do
				v1840(connection)
			end
			table.clear(p538.connections)
			for k, v in pairs(p538.originalRagdoll) do
				if type(v) == "function" then
					Ragdoll[k] = v
				end
			end
			if p538._forestGate then
				pcall(rawset, p538._forestGate.comp, "_attackHandler", p538._forestGate.orig)
				if genv.__S2rHubForestGate == p538._forestGate then
					genv.__S2rHubForestGate = nil
				end
				p538._forestGate = nil
			end
			p538.eggRuntime = nil
			if getgenv().__S2rHubAntiGuard == p538 then
				getgenv().__S2rHubAntiGuard = nil
			end
		end
		t64[s2] = v1880
		t64.getStats = function(p539)
			return p539.stats
		end
		return t64
	end
	local v1885 = v1829()
	local function v1886()
		local Players2 = game:GetService("Players")
		game:GetService("RunService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local t66 = {}
		t66.__index = t66
		t66.new = function(p540)
			local obj = setmetatable({}, t66)
			obj.eggRuntime = p540
			obj.enabled = s2rHubConfig.GodMode == nil and true or s2rHubConfig.GodMode == true
			obj.active = false
			obj.activeDroppedUid = nil
			obj.swingSequence = 0
			obj.lastSwingAt = 0
			obj.defendThread = nil
			obj.connections = {}
			obj.targetRange = 35
			obj:_bindSignals()
			return obj
		end
		t66._isBat = function(p541, p542)
			if not p542 or not p542:IsA("Tool") then
				return false
			end
			local __S2rHubIsBatTool = genv.__S2rHubIsBatTool
			if __S2rHubIsBatTool and __S2rHubIsBatTool(p542) then
				return true
			end
			if not __S2rHubIsBatTool and (p542:GetAttribute("IsBat") == true or p542:GetAttribute("GearName") == "Bat") then
				return true
			end
			local attribute = p542:GetAttribute("ItemType")
			if attribute == nil or attribute == "Gear" then
				return string.find(string.lower(p542.Name), "slap", 1, true) ~= nil
			end
			return false
		end
		t66._findBat = function(p543)
			local Character = LocalPlayer2.Character
			local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")
			if Character then
				for _, child in ipairs(Character:GetChildren()) do
					if not p543:_isBat(child) then
						continue
					end
					return child, true
				end
			end
			if Backpack then
				for _, child in ipairs(Backpack:GetChildren()) do
					if not p543:_isBat(child) then
						continue
					end
					return child, false
				end
			end
			pcall(function()
				local Networking = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking")
				local RFCodexAskWearFieldBat = Networking and Networking:FindFirstChild("RF/Codex/AskWearFieldBat")
				if RFCodexAskWearFieldBat then
					RFCodexAskWearFieldBat:InvokeServer()
				end
			end)
			return nil, false
		end
		t66._equipBat = function(p544)
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not Humanoid or Humanoid.Health <= 0 then
				return nil
			end
			local v1904, v1905 = p544:_findBat()
			if not v1904 then
				return nil
			end
			if v1905 and v1904.Parent == Character then
				return v1904
			end
			pcall(Humanoid.EquipTool, Humanoid, v1904)
			local v1906 = os.clock() + 0.35
			while true do
				if not (os.clock() < v1906) then
					return v1904.Parent == Character and v1904 or nil
				end
				if v1904.Parent == Character then
					break
				end
				task.wait(0.05)
			end
			return v1904
		end
		t66._getNearbyEnemies = function(p545)
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then
				return {}
			end
			local t67 = {}
			for _, player in ipairs(Players2:GetPlayers()) do
				if player ~= LocalPlayer2 and player.Character then
					local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
					if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
						local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude
						if Magnitude <= p545.targetRange then
							table.insert(t67, {
								player = player,
								root = HumanoidRootPart2,
								humanoid = Humanoid,
								distance = Magnitude
							})
						end
					end
				end
			end
			table.sort(t67, function(p546, p547)
				return p546.distance < p547.distance
			end)
			return t67
		end
		t66._swing = function(p548, p549, p550)
			if not p549 or p549.Parent ~= LocalPlayer2.Character then
				return false
			end
			local serverTimeNow = workspace:GetServerTimeNow()
			if serverTimeNow - p548.lastSwingAt < 0.22 then
				return false
			end
			p548.lastSwingAt = serverTimeNow
			pcall(p549.Activate, p549)
			local Handle = p549:FindFirstChild("Handle") or p549:FindFirstChildWhichIsA("BasePart", true)
			if Handle and p550 and type(firetouchinterest) == "function" then
				pcall(function()
					firetouchinterest(Handle, p550, 0)
					task.wait(0.01)
					firetouchinterest(Handle, p550, 1)
				end)
			end
			pcall(function()
				local BatSwing = require(ReplicatedStorage2.Shared.Remotes).BatSwing
				if BatSwing and BatSwing.Trigger then
					p548.swingSequence += 1
					local v1918 = string.format("%d:%d:%d", LocalPlayer2.UserId, p548.swingSequence, math.floor(serverTimeNow * 1000))
					BatSwing.Trigger:FireServer(nil, v1918)
				end
			end)
			return true
		end
		t66.startDefend = function(p551, p552)
			if not p551.enabled then
				return
			end
			if p551.eggRuntime and p551.eggRuntime.instantPhase == "priming" then
				return
			end
			if p552 and p551.eggRuntime then
				if p551.eggRuntime:isSkippedEgg(p552) then
					return
				end
			end
			local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
			if __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
				return
			end
			p551.active = true
			p551.activeDroppedUid = p552 or p551.activeDroppedUid
			if not p551.defendThread then
				p551.defendThread = task.spawn(function()
					local v1920 = false
					while p551.active and p551.enabled and (not p551.eggRuntime or not p551.eggRuntime.carry or not p551.eggRuntime.carry.active) do
						local __S2rHubPlayerSteal2 = genv.__S2rHubPlayerSteal
						if __S2rHubPlayerSteal2 and __S2rHubPlayerSteal2.running then
							v1920 = true
							break
						end
						local v1922 = p551:_getNearbyEnemies()
						if #v1922 > 0 then
							local v1923 = p551:_equipBat()
							if v1923 then
								for _, v in ipairs(v1922) do
									if v.root and v.root.Parent then
										p551:_swing(v1923, v.root)
									end
								end
							end
						end
						task.wait(0.1)
					end
					p551.active = false
					p551.defendThread = nil
					if v1920 then
						return
					end
					pcall(function()
						local Character = LocalPlayer2.Character
						local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
						if Humanoid then
							Humanoid:UnequipTools()
						end
					end)
				end)
				return
			end
		end
		t66.stopDefend = function(p553)
			p553.active = false
			p553.activeDroppedUid = nil
		end
		t66.setEnabled = function(p554, p555)
			p554.enabled = p555 == true
			if not p554.enabled then
				p554:stopDefend()
			end
		end
		t66._bindSignals = function(p556)
			pcall(function()
				table.insert(p556.connections, require(ReplicatedStorage2.Client.EggState).CarryChanged:Connect(function(p557)
					if p557.IsCarrying then
						p556:stopDefend()
					elseif p556.enabled then
						p556:startDefend(p557.Uid)
					end
				end))
			end)
			pcall(function()
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)
				local ForestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike
				if ForestStrike then
					table.insert(p556.connections, ForestStrike.OnClientEvent:Connect(function()
						if p556.enabled then
							p556:startDefend()
						end
					end))
				end
			end)
		end
		t66.destroy = function(p558)
			p558:stopDefend()
			for _, connection in ipairs(p558.connections) do
				pcall(connection.Disconnect, connection)
			end
			table.clear(p558.connections)
		end
		return t66
	end
	local v1932 = v1886()
	local function v1933()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
		local Hud = require(ReplicatedStorage2.Client.Hud)
		local Save = require(ReplicatedStorage2.Shared.Save)
		local Treadmills = require(ReplicatedStorage2.Data.Treadmills)
		local function v1942()
			local treadmill = t25.blocker("treadmill")
			if treadmill then
				return "Yielding to " .. t25.TITLES[treadmill]
			end
			local treadmill2 = t25.holder("treadmill")
			if treadmill2 then
				return "Waiting for " .. t25.TITLES[treadmill2]
			end
			return nil
		end
		local function v1945()
			return v1942() ~= nil
		end
		local function v1946()
			return t25.blocker("treadmill") == "auto_steal"
		end
		local function v1947()
			return v1942() or "Yielding"
		end
		local t68 = {}
		t68.__index = t68
		t68.new = function(p559, p560)
			local obj = setmetatable({}, t68)
			obj.coordinator = p559
			obj.travel = p560
			obj.destroyed = false
			obj.listeners = {}
			obj.resources = {}
			obj.config = {
				disableDuringAutomation = true,
				idleFarm = false,
				autoUpgrade = false
			}
			obj.stats = {
				mode = "Idle",
				boost = "Waiting"
			}
			obj.busy = p559 and p559:getSnapshot().busy == true or false
			obj.idleGeneration = 0
			obj.lastEquipAt = 0
			obj.activeTreadmill = nil
			obj.travelingToTreadmill = false
			obj.treadmillEquipPending = false
			obj.unequipGuardRunning = false
			obj.backgroundYieldRunning = false
			obj.lastBackgroundYieldAt = 0
			obj.carryPulseRunning = false
			obj.treadmillStateRevision = 0
			obj:_listenActiveTreadmill()
			task.spawn(function()
				pcall(function()
					obj:_syncActiveTreadmillSnapshot()
				end)
			end)
			obj:_listenCoordinator()
			obj:_listenSpeedGain()
			return obj
		end
		t68._snapshot = function(p561)
			return {
				mode = p561.stats.mode,
				boost = p561.stats.boost,
				disableDuringAutomation = p561.config.disableDuringAutomation,
				idleFarm = p561.config.idleFarm
			}
		end
		t68._emit = function(p562)
			local v1950 = p562:_snapshot()
			for _, listener in ipairs(p562.listeners) do
				pcall(listener, v1950)
			end
		end
		t68._setStatus = function(p563, p564, p565)
			if p564 ~= nil then
				p563.stats.mode = p564
			end
			if p565 ~= nil then
				p563.stats.boost = p565
			end
			p563:_emit()
		end
		t68.subscribe = function(p566, p567)
			table.insert(p566.listeners, p567)
			pcall(p567, p566:_snapshot())
			local function v1953()
				local v1954 = table.find(p566.listeners, p567)
				if v1954 then
					table.remove(p566.listeners, v1954)
				end
			end
			return v1953
		end
		t68._requestUnequip = function()
			local ok, result, result2 = pcall(function()
				return Remotes.Treadmill.AskDoff:InvokeServer()
			end)
			if not ok then
				return false, tostring(result)
			end
			if result ~= false then
				return true
			end
			local v1958 = false
			local tostring_ = tostring
			local v1960 = result2 or "Server rejected"
			return v1958, tostring_(v1960)
		end
		t68._shouldBlockTreadmill = function(p568)
			if p568.destroyed or p568.carryPulseRunning then
				return false
			end
			if p568.busy and p568.config.disableDuringAutomation then
				return true
			end
			local __S2rHubEggRuntime = genv.__S2rHubEggRuntime
			if __S2rHubEggRuntime and __S2rHubEggRuntime._treadmillResetting then
				return false
			end
			local ok, result = pcall(t25.holder, "treadmill")
			return ok and result ~= nil
		end
		t68._startUnequipGuard = function(p569)
			if p569.unequipGuardRunning or not p569:_shouldBlockTreadmill() or p569.activeTreadmill == nil then
				return
			end
			p569.unequipGuardRunning = true
			task.spawn(function()
				local n35 = 0.15
				while p569:_shouldBlockTreadmill() and p569.activeTreadmill ~= nil do
					local v1965, v1966 = p569:_requestUnequip()
					p569:_setStatus("Automation active", v1965 and "Blocked" or "Release retry: " .. tostring(v1966))
					task.wait(n35)
					n35 = math.min(n35 * 2, 0.75)
				end
				p569.unequipGuardRunning = false
				if p569:_shouldBlockTreadmill() and p569.activeTreadmill ~= nil then
					p569:_startUnequipGuard()
				end
			end)
		end
		t68._cancelIdle = function(p570, p571)
			p570.idleGeneration += 1
			if p571 then
				p570:_requestUnequip()
			end
		end
		t68.setDisableDuringAutomation = function(p572)
			p572.config.disableDuringAutomation = true
			if p572.busy and p572.config.disableDuringAutomation then
				p572:_cancelIdle(true)
				p572:_startUnequipGuard()
				p572:_setStatus("Automation active", "Blocked")
			elseif not p572.busy and p572.config.idleFarm then
				p572:_startIdle()
			end
		end
		t68.setIdleFarm = function(p573, p574)
			p573.config.idleFarm = p574 == true
			if not p573.config.idleFarm then
				p573:_cancelIdle(true)
				p573:_setStatus(p573.busy and "Automation active" or "Idle", "Disabled")
				return
			end
			if not p573.busy then
				p573:_startIdle()
			end
			if p573.idleWatchdog then
				return
			end
			p573.idleWatchdog = task.spawn(function()
				while not p573.destroyed and p573.config.idleFarm do
					task.wait(2)
					if p573.idleRunning == nil and not p573.busy and p573.config.idleFarm and not p573.destroyed then
						p573:_startIdle()
					end
				end
				p573.idleWatchdog = nil
			end)
		end
		t68._readUpgradeState = function()
			local ok, result, result2, result3 = pcall(function()
				local v1971 = (Save.Peek or Save.Get)()
				if not v1971 then
					return nil
				end
				local v1972 = tonumber(v1971.TreadmillUpgradeLevel) or 0
				return v1972, v1971.Money, Treadmills.GetByUpgradeLevel(v1972 + 1)
			end)
			if not ok or result == nil then
				return nil
			end
			return result, result2, result3
		end
		t68._raiseTier = function(p575)
			local _, v1974, v1975 = p575:_readUpgradeState()
			if not v1975 then
				return false, "Max tier"
			end
			if (tonumber(v1974) or 0) < (tonumber(v1975.Price) or 0) then
				return false, "Not enough money"
			end
			local ok, result, result2 = pcall(function()
				return Remotes.Treadmill.AskTierRaise:InvokeServer(v1975._id)
			end)
			if not ok then
				return false, tostring(result)
			end
			if result ~= true then
				local v1979 = false
				local tostring_ = tostring
				local v1981 = result2 or "Server rejected"
				return v1979, tostring_(v1981)
			end
			local v1982 = true
			local DisplayName = v1975.DisplayName or v1975._id
			return v1982, DisplayName
		end
		t68.setAutoUpgrade = function(p576, p577)
			p576.config.autoUpgrade = p577 == true
			if not p576.config.autoUpgrade or p576.autoUpgradeRunning then
				return
			end
			p576.autoUpgradeRunning = true
			task.spawn(function()
				while not p576.destroyed and p576.config.autoUpgrade do
					while true do
						local v1984, v1985 = p576:_raiseTier()
						if v1984 then
							p576:_setStatus(p576.busy and "Automation active" or "Idle", "Upgraded to " .. tostring(v1985))
							task.wait(1)
						else
							if v1985 ~= "Max tier" then
								break
							end
							p576:_setStatus(p576.busy and "Automation active" or "Idle", "Treadmill maxed")
							task.wait(30)
						end
						if not p576.destroyed and p576.config.autoUpgrade then
							continue
						end
						p576.autoUpgradeRunning = false
						return
					end
					task.wait(5)
				end
				p576.autoUpgradeRunning = false
			end)
		end
		t68._resolveStandCFrame = function()
			local v1986 = PlotState2.ResolveLocalSlot()
			local v1987 = PlotState2.ResolveFolder()
			local v1988 = v1987 and v1986 and v1987:FindFirstChild(tostring(v1986))
			local TreadmillBottom = v1988 and v1988:FindFirstChild("TreadmillBottom")
			if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
				return nil
			end
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid then
				return nil
			end
			local v1993
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				v1993 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)
			else
				v1993 = HumanoidRootPart.Size.Y * 0.5 + 2
			end
			return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1993 + 0.05, 0)
		end
		t68.isEngaged = function(p578)
			return p578.activeTreadmill ~= nil or p578.travelingToTreadmill or p578.treadmillEquipPending or p578.carryPulseRunning
		end
		t68._isTreadmillHudActive = function()
			local ok, result = pcall(function()
				local Game = Hud.Frame("Game")
				local Treadmill = Hud.Frame("Treadmill")
				return Game.Visible == false and Treadmill.Visible == true
			end)
			local v1998 = ok and result == true
			return v1998
		end
		t68._isGameHudRestored = function()
			local ok, result = pcall(function()
				local Game = Hud.Frame("Game")
				local Treadmill = Hud.Frame("Treadmill")
				return Game.Visible == true and Treadmill.Visible == false
			end)
			local v2003 = ok and result == true
			return v2003
		end
		t68.pulseForCarry = function(p579, p580, p581)
			if p579.destroyed or p579.carryPulseRunning or type(p580) ~= "function" then
				return false, "Preparation unavailable"
			end
			p579:_cancelIdle(false)
			p579.carryPulseRunning = true
			local function v2004()
				return p579.destroyed or p581 ~= nil and p581()
			end
			local function v2005(p582)
				local v2006 = os.clock() + p582
				local n36 = 0
				local v2008
				local treadmillStateRevision = p579.treadmillStateRevision
				while not p579.destroyed and os.clock() < v2006 do
					local now = os.clock()
					if n36 <= now then
						p579:_requestUnequip()
						n36 = now + 0.15
					end
					local v2011 = p579:_syncActiveTreadmillSnapshot()
					local v2012 = p579:_isGameHudRestored()
					if p579.treadmillStateRevision ~= treadmillStateRevision then
						treadmillStateRevision = p579.treadmillStateRevision
						v2008 = nil
					end
					if not v2011 and p579.activeTreadmill == nil and v2012 then
						v2008 = v2008 or now
						if now - v2008 >= 0.35 then
							return true
						end
					else
						v2008 = nil
					end
					task.wait(0.03)
				end
				return false
			end
			local function v2013(p583, p584)
				if not p583 then
					v2005(1.85)
				end
				p579.treadmillEquipPending = false
				p579.carryPulseRunning = false
				if p583 then
					p579:_setStatus("Automation active", "Preparation complete")
				elseif not p579.destroyed then
					p579:_setStatus("Automation active", tostring(p584 or "Preparation failed"))
				end
				if p579:_shouldBlockTreadmill() and p579.activeTreadmill ~= nil then
					p579:_startUnequipGuard()
				end
				return p583, p584
			end
			p579:_syncActiveTreadmillSnapshot()
			local v2014 = false
			local v2015
			for i = 1, 3 do
				if v2004() then
					return v2013(false, "Cancelled")
				end
				local v2017 = p579:_resolveStandCFrame()
				if v2017 then
					p579:_setStatus("Preparing carry", i == 1 and "Positioning" or "Repositioning")
					local ok, result = pcall(p580, v2017)
					if ok and result == true then
						task.wait(0.35)
						p579.treadmillEquipPending = true
						p579:_setStatus("Preparing carry", "Activating")
						local v2020 = os.clock() + 2.5
						local n37 = 0
						local n38 = 0
						while not v2004() and os.clock() < v2020 do
							local now = os.clock()
							if n38 <= now then
								n38 = now + 0.25
								p579:_syncActiveTreadmillSnapshot()
							end
							if p579.activeTreadmill ~= nil and p579:_isTreadmillHudActive() then
								v2014 = true
								break
							end
							if p579.activeTreadmill == nil and n37 <= now then
								n37 = now + 0.2
								local ok2, result2, result3 = pcall(function()
									return Remotes.Treadmill.AskWearStill:InvokeServer()
								end)
								if not ok2 or result2 == false then
									v2015 = tostring(result3 or result2)
									p579:_setStatus("Preparing carry", "Activation retry")
								end
							end
							task.wait(0.03)
						end
					else
						v2015 = "Positioning failed"
					end
				else
					v2015 = "Position unavailable"
				end
				if v2014 then
					break
				end
				if not v2004() then
					p579:_setStatus("Preparing carry", "Resetting position")
					v2005(1.85)
					continue
				end
				return v2013(false, "Cancelled")
			end
			if not v2014 then
				local v2027 = v2013
				local v2028 = false
				local tostring_ = tostring
				local v2030 = v2015 or "Unknown"
				return v2027(v2028, "Activation not confirmed: " .. tostring_(v2030))
			end
			p579.treadmillEquipPending = false
			p579:_setStatus("Preparing carry", "Active")
			local v2031 = os.clock() + 0.1
			while not v2004() and os.clock() < v2031 do
				task.wait(0.03)
			end
			if v2004() then
				return v2013(false, "Cancelled")
			end
			p579:_setStatus("Preparing carry", "Releasing")
			if v2005(1.85) then
				return v2013(true)
			end
			local v2032 = v2013
			local v2033 = false
			local v2034 = v2004() and "Cancelled" or "Release not confirmed"
			return v2032(v2033, v2034)
		end
		t68.yieldForBackground = function(p585)
			if p585.destroyed then
				return
			end
			p585:_cancelIdle(false)
			if p585.backgroundYieldRunning then
				return
			end
			p585.backgroundYieldRunning = true
			task.spawn(function()
				local n39 = 0.15
				while not p585.destroyed do
					if p585.coordinator and p585.coordinator:isBackgroundBusy() then
						p585.lastBackgroundYieldAt = os.clock()
						p585:_setStatus("Idle", "Yielding to background inventory")
						p585:_requestUnequip()
						task.wait(n39)
						if p585:_syncActiveTreadmillSnapshot() then
							n39 = math.min(n39 * 2, 0.75)
							continue
						end
					end
					break
				end
				p585.backgroundYieldRunning = false
				if not p585.destroyed and not p585:isEngaged() then
					p585:_setStatus("Idle", "Background inventory ready")
				end
			end)
		end
		t68._startIdle = function(p586)
			if p586.destroyed or p586.busy or not p586.config.idleFarm then
				return
			end
			p586:_cancelIdle(false)
			local idleGeneration = p586.idleGeneration
			local now = os.clock()
			p586.idleRunning = idleGeneration
			task.spawn(function()
				local ok, result = xpcall(function()
					while not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration do
						if p586.coordinator then
							if p586.coordinator:isBackgroundBusy() then
								now = os.clock()
								p586:_setStatus("Idle", "Waiting for background inventory")
								task.wait(0.25)
								continue
							end
						end
						if v1946() then
							now = os.clock()
							p586:_setStatus("Idle", "Yielding to Auto Steal")
							task.wait(0.25)
						elseif genv.__S2rHubIsAutoSellEggBusy and genv.__S2rHubIsAutoSellEggBusy() then
							now = os.clock()
							p586:_setStatus("Idle", "Waiting for Auto Sell Egg")
							task.wait(0.25)
						elseif v1945() then
							now = os.clock()
							p586:_setStatus("Idle", v1947())
							task.wait(0.25)
						else
							local v2040 = 1 - (os.clock() - now)
							if v2040 > 0 then
								p586:_setStatus("Idle", string.format("Starting in %.0fs", math.ceil(v2040)))
								task.wait(math.min(v2040, 0.25))
							else
								local v2041 = p586:_resolveStandCFrame()
								if v2041 then
									p586.travelingToTreadmill = true
									p586:_setStatus("Moving", "Waiting")
									local travel = p586.travel and p586.travel:travelAndWait(v2041, {
										abort = function()
											return p586.destroyed or p586.busy or not p586.config.idleFarm or idleGeneration ~= p586.idleGeneration or p586.coordinator and p586.coordinator:isBackgroundBusy() or genv.__S2rHubIsAutoSellEggBusy and genv.__S2rHubIsAutoSellEggBusy() or v1945()
										end
									})
									p586.travelingToTreadmill = false
									if not travel then
										if not p586.busy and p586.config.idleFarm then
											p586:_setStatus("Idle", "Travel failed")
											task.wait(1)
										end
									elseif not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
										if p586.coordinator then
											if p586.coordinator:isBackgroundBusy() then
												continue
											end
										end
										if (not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy()) and not v1945() then
											task.wait(0.35)
											if not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
												if p586.coordinator then
													if p586.coordinator:isBackgroundBusy() then
														continue
													end
												end
												if (not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy()) and not v1945() then
													p586.treadmillEquipPending = true
													local ok, result, result2 = pcall(function()
														return Remotes.Treadmill.AskWearStill:InvokeServer()
													end)
													if ok and result ~= false then
														p586.lastEquipAt = os.clock()
														p586:_setStatus("Active", "Waiting for gain")
														task.delay(2, function()
															if not p586.destroyed and p586.activeTreadmill == nil then
																p586.treadmillEquipPending = false
															end
														end)
														local v2046 = os.clock() + 8
														while (p586.activeTreadmill ~= nil or os.clock() < v2046) and not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration do
															local ok33 = not p586.coordinator
															if not ok33 then
																ok33 = not p586.coordinator:isBackgroundBusy()
															end
															if not ok33 then
																break
															end
															if v1946() then
																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Steal")
																break
															end
															if not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy() then
																if not v1945() then
																	task.wait(0.25)
																	continue
																end
																p586:_requestUnequip()
																p586:_setStatus("Idle", v1947())
																break
															end
															p586:_cancelIdle(true)
															p586:_setStatus("Idle", "Yielding to Auto Sell Egg")
															break
														end
														continue
													end
													p586.treadmillEquipPending = false
													p586:_setStatus("Preparing carry", "Activation failed: " .. tostring(result2 or result))
													local v2048 = os.clock() + 8
													while true do
														local coordinator
														if p586.activeTreadmill == nil then
															if os.clock() < v2048 and not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
																if not p586.coordinator then
																	if v1946() then
																		p586:_cancelIdle(true)
																		p586:_setStatus("Idle", "Yielding to Auto Steal")
																		break
																	end
																	if not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy() then
																		if not v1945() then
																			task.wait(0.25)
																			continue
																		end
																		p586:_requestUnequip()
																		p586:_setStatus("Idle", v1947())
																		break
																	end
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Sell Egg")
																	break
																end
																coordinator = p586.coordinator
																if not coordinator:isBackgroundBusy() then
																	if v1946() then
																		p586:_cancelIdle(true)
																		p586:_setStatus("Idle", "Yielding to Auto Steal")
																		break
																	end
																	if not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy() then
																		if not v1945() then
																			task.wait(0.25)
																			continue
																		end
																		p586:_requestUnequip()
																		p586:_setStatus("Idle", v1947())
																		break
																	end
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Sell Egg")
																	break
																end
															end
															break
														end
														if not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
															if not p586.coordinator then
																if v1946() then
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Steal")
																	break
																end
																if not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy() then
																	if not v1945() then
																		task.wait(0.25)
																		continue
																	end
																	p586:_requestUnequip()
																	p586:_setStatus("Idle", v1947())
																	break
																end
																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Sell Egg")
																break
															end
															coordinator = p586.coordinator
															if not coordinator:isBackgroundBusy() then
																if v1946() then
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Steal")
																	break
																end
																if not genv.__S2rHubIsAutoSellEggBusy or not genv.__S2rHubIsAutoSellEggBusy() then
																	if not v1945() then
																		task.wait(0.25)
																		continue
																	end
																	p586:_requestUnequip()
																	p586:_setStatus("Idle", v1947())
																	break
																end
																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Sell Egg")
																break
															end
														end
														break
													end
												end
											end
										end
									end
								else
									p586:_setStatus("Idle", "Position unavailable")
									task.wait(2)
								end
							end
						end
					end
				end, debug.traceback)
				if not ok then
					warn("[SAE][treadmill] idle error:\n" .. tostring(result))
				end
				if p586.idleRunning == idleGeneration then
					p586.idleRunning = nil
				end
			end)
		end
		t68._onCoordinator = function(p587, p588)
			local busy = p587.busy
			p587.busy = p588.busy == true
			if p587.busy then
				p587:_cancelIdle(p587.config.disableDuringAutomation)
				p587:_startUnequipGuard()
				p587:_setStatus("Automation active", p587.config.disableDuringAutomation and "Blocked" or "Unchanged")
			elseif busy or p587.config.idleFarm then
				if p587.config.idleFarm then
					p587:_startIdle()
				else
					p587:_setStatus("Idle", "Disabled")
				end
			end
		end
		t68._listenCoordinator = function(p589)
			if not p589.coordinator then
				return
			end
			table.insert(p589.resources, p589.coordinator:subscribe(function(p590)
				p589:_onCoordinator(p590)
			end))
			table.insert(p589.resources, p589.coordinator:subscribeBackground(function(p591)
				if p591.busy then
					p589:_cancelIdle(false)
					p589:_setStatus("Idle", "Waiting for background inventory")
				elseif not p589.destroyed and not p589.busy and p589.config.idleFarm then
					p589:_startIdle()
				end
			end))
		end
		t68._syncActiveTreadmillSnapshot = function(p592)
			local ok, result = pcall(function()
				return Remotes.Treadmill.AskRenderSnapshot:InvokeServer()
			end)
			if not ok or type(result) ~= "table" then
				return p592.activeTreadmill ~= nil
			end
			local v2053 = table.find(result, LocalPlayer2.UserId) ~= nil
			p592.activeTreadmill = v2053 and "snapshot" or nil
			if not v2053 then
				p592.treadmillEquipPending = false
			end
			return v2053
		end
		t68._listenActiveTreadmill = function(p593)
			local function v2054(p594)
				p593.treadmillStateRevision += 1
				p593.activeTreadmill = p594
				p593.treadmillEquipPending = false
				if p594 ~= nil and p593:_shouldBlockTreadmill() then
					p593:_startUnequipGuard()
				elseif p594 == nil and p593:_shouldBlockTreadmill() then
					p593:_setStatus("Automation active", "Blocked")
				elseif p594 == nil then
					p593:_setStatus("Idle", p593.config.idleFarm and "Released" or "Disabled")
				elseif not p593.busy then
					p593:_setStatus("Active", "Waiting for gain")
				end
			end
			local AssignedBeltShifted
			local RenderStateShifted
			pcall(function()
				AssignedBeltShifted = Remotes.Treadmill.AssignedBeltShifted
			end)
			pcall(function()
				RenderStateShifted = Remotes.Treadmill.RenderStateShifted
			end)
			if AssignedBeltShifted then
				table.insert(p593.resources, AssignedBeltShifted.OnClientEvent:Connect(function(p595)
					v2054(p595)
				end))
				return
			end
			if RenderStateShifted then
				table.insert(p593.resources, RenderStateShifted.OnClientEvent:Connect(function(p596, p597)
					if p596 ~= LocalPlayer2.Name then
						return
					end
					local v2057 = v2054
					local v2058 = p597 and p596
					v2057(v2058 or nil)
				end))
			end
		end
		t68._listenSpeedGain = function(p598)
			local SpeedGained = Remotes.Treadmill.SpeedGained
			if SpeedGained then
				table.insert(p598.resources, SpeedGained.OnClientEvent:Connect(function()
					p598.activeTreadmill = p598.activeTreadmill or true
					p598.treadmillEquipPending = false
					if not p598:_shouldBlockTreadmill() then
						p598:_setStatus("Active", "Gain ticking")
						return
					end
					p598:_startUnequipGuard()
				end))
			end
		end
		t68.destroy = function(p599)
			if p599.destroyed then
				return
			end
			p599.destroyed = true
			p599:_cancelIdle(true)
			for _, resource in ipairs(p599.resources) do
				pcall(function()
					if typeof(resource) == "RBXScriptConnection" then
						resource:Disconnect()
					elseif type(resource) == "function" then
						resource()
					elseif type(resource) == "table" and type(resource.Disconnect) == "function" then
						resource:Disconnect()
					end
				end)
			end
			table.clear(p599.resources)
			table.clear(p599.listeners)
		end
		t68.Destroy = t68.destroy
		return t68
	end
	local v2062 = v1933()
	local v2063 = v662.new()
	v612 = v1823.new(v611, v703, v2063)
	genv.__S2rHubEggRuntime = v612
	v613 = v2062.new(v2063, v612)
	genv.__S2rHubTreadmillManager = v613
	v612:setTreadmillManager(v613)
	v613:setDisableDuringAutomation(true)
	if s2rHubConfig.AutoTreadmillIdle then
		v613:setIdleFarm(true)
	end
	if s2rHubConfig.AutoIndex then
		v612:setIndexObjective(true)
	end
	if s2rHubConfig.AutoTreadmillUpgrade then
		v613:setAutoUpgrade(true)
	end
	local function v2064()
		local HttpService = game:GetService("HttpService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = game:GetService("Players").LocalPlayer
		local http_request_ = http_request or request or http and http.request or syn and syn.request or fluxus and fluxus.request
		local t70 = {}
		local u2071 = false
		local t71 = {}
		local u2073
		local AssetEarnings
		local EggRecords
		pcall(function()
			AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
		end)
		pcall(function()
			EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
		end)
		local function v2076(p600)
			local match = tostring(p600 or ""):match("%d+")
			if not match then
				return nil
			end
			local v2078 = t71[match]
			if v2078 ~= nil then
				if v2078 == "" then
					return nil
				end
				return v2078
			end
			local v2079
			for _, v in ipairs({
				"512x512",
				"150x150"
			}) do
				local imageUrl
				pcall(function()
					local v2083 = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. match .. "&size=" .. v .. "&format=Png&isCircular=false"
					local Body
					if http_request_ then
						local v2085 = http_request_({
							Url = v2083,
							Method = "GET"
						})
						Body = type(v2085) == "table" and (v2085.Body or v2085.body) or nil
					else
						Body = HttpService:GetAsync(v2083)
					end
					if type(Body) == "string" and Body ~= "" then
						local data = HttpService:JSONDecode(Body)
						local data2 = data and data.data and data.data[1]
						if data2 and data2.state == "Completed" and type(data2.imageUrl) == "string" and data2.imageUrl ~= "" then
							imageUrl = data2.imageUrl
						end
					end
				end)
				if imageUrl then
					v2079 = v2079 or imageUrl
					if imageUrl:find("/Png/", 1, true) then
						v2079 = imageUrl
						break
					else
					end
				else
				end
			end
			t71[match] = v2079 or ""
			return v2079
		end
		local function v2088()
			if u2073 == nil then
				u2073 = v2076("96240498384290") or false
			end
			return u2073 or nil
		end
		local function v2089()
			if u2071 then
				return
			end
			u2071 = true
			task.spawn(function()
				while #t70 > 0 do
					local v2090 = table.remove(t70, 1)
					pcall(function()
						if v2090.thumbAsset then
							local v2091 = v2090.payload.embeds[1]
							local v2092 = v2076(v2090.thumbAsset)
							if v2092 then
								v2091.thumbnail = {
									url = v2092
								}
							end
						end
						local json = HttpService:JSONEncode(v2090.payload)
						if http_request_ then
							http_request_({
								Url = v2090.url,
								Method = "POST",
								Headers = {
									["Content-Type"] = "application/json"
								},
								Body = json
							})
						else
							HttpService:PostAsync(v2090.url, json, Enum.HttpContentType.ApplicationJson)
						end
					end)
					task.wait(0.6)
				end
				u2071 = false
			end)
		end
		local function v2094(p601)
			if typeof(p601) == "Color3" then
				return math.floor(p601.R * 255 + 0.5) * 65536 + math.floor(p601.G * 255 + 0.5) * 256 + math.floor(p601.B * 255 + 0.5)
			end
			return 5814783
		end
		local function compact(p602)
			local Simple
			pcall(function()
				Simple = require(ReplicatedStorage2.Packages.FormatNumber.Simple)
			end)
			if Simple and Simple.FormatCompact then
				local ok, result = pcall(Simple.FormatCompact, p602, ".#")
				if ok and result then
					return tostring(result)
				end
			end
			local format = string.format
			local s3 = "%.1f"
			local v2101 = p602 or 0
			return format(s3, v2101)
		end
		local t69 = {
			compact = compact,
			rateOf = function(p603)
				if not AssetEarnings or type(p603) ~= "table" then
					return 0
				end
				local v2102 = tonumber(p603.AssetScale) or 1
				local t72 = {
					Category = p603.AssetCategory,
					Scale = v2102,
					AssetScale = v2102,
					BaseMutation = p603.BaseMutation,
					Mutations = p603.Mutations or {}
				}
				for _, v in ipairs({
					"LiveRatePerSecond",
					"RatePerSecond",
					"CatalogRatePerSecond"
				}) do
					if type(AssetEarnings[v]) == "function" then
						local ok, result = pcall(AssetEarnings[v], t72)
						if ok and type(result) == "number" and result > 0 then
							return result
						end
					end
				end
				return 0
			end,
			weightOf = function(p604)
				if not EggRecords or type(p604) ~= "table" then
					return 0
				end
				local ok, result = pcall(EggRecords.WeightKgForScale, p604.AssetCategory, tonumber(p604.AssetScale) or 1)
				if ok and type(result) == "number" then
					return result
				end
				return 0
			end,
			sizeText = function(p605)
				local v2110 = tonumber(p605 and (p605.AssetScale or p605.Scale)) or 1
				if v2110 >= 100 then
					return string.format("%.0fx", v2110)
				end
				return string.format("%.2fx", v2110)
			end,
			weightText = function(p606)
				local v2111 = tonumber(p606) or 0
				if v2111 >= 1000 then
					return compact(v2111) .. " kg"
				end
				return string.format("%.1fkg", v2111)
			end,
			rateText = function(p607)
				local v2112 = tonumber(p607) or 0
				if v2112 >= 1000 then
					return "$" .. compact(v2112) .. "/s"
				end
				return string.format("$%d/s", math.floor(v2112))
			end,
			passes = function(p608, p609, p610)
				local t73 = {}
				local v2114 = false
				local ipairs_ = ipairs
				local WebhookRarities = s2rHubConfig.WebhookRarities or {}
				for _, WebhookRarity in ipairs_(WebhookRarities) do
					if WebhookRarity ~= "None" and WebhookRarity ~= "" then
						t73[WebhookRarity] = true
						v2114 = true
					end
				end
				if v2114 and not t73[p609.rarity] then
					return false
				end
				local v2119 = tonumber(s2rHubConfig.WebhookMinValue) or 0
				if v2119 > 0 and p610 < v2119 then
					return false
				end
				return true
			end
		}
		local t74 = {
			"Image",
			"Icon",
			"Thumbnail",
			"ImageId",
			"IconId",
			"Texture",
			"Asset",
			"DisplayImage"
		}
		t69.eggAsset = function(p611)
			local Directory
			pcall(function()
				Directory = require(ReplicatedStorage2.Data.Assets).Directory
			end)
			local v2122 = Directory and Directory[p611]
			if type(v2122) ~= "table" then
				return nil
			end
			for _, v in ipairs({
				v2122,
				v2122.Egg,
				v2122.Pet
			}) do
				if type(v) == "table" then
					for _, v2 in ipairs(t74) do
						local v2127 = v[v2]
						local match = (type(v2127) == "string" or type(v2127) == "number") and tostring(v2127):match("%d+")
						if not match or not (tonumber(match) > 0) then
							continue
						end
						return match
					end
				end
			end
			return nil
		end
		t69.stolen = function(p612, p613, p614)
			if s2rHubConfig.WebhookEnabled ~= true then
				return
			end
			local WebhookURL = s2rHubConfig.WebhookURL
			if type(WebhookURL) ~= "string" or WebhookURL == "" then
				return
			end
			if not (type(p612) == "table" and p612.AssetCategory) then
				return
			end
			local v2130 = p613 or {
				name = p612.AssetCategory,
				rarity = "Unknown",
				rarityColor = nil
			}
			local v2131 = t69.rateOf(p612)
			if not t69.passes(p612, v2130, v2131) then
				return
			end
			local t75 = {
				{
					name = "User",
					value = LocalPlayer2.Name,
					inline = true
				},
				{
					name = "Rarity",
					value = tostring(v2130.rarity),
					inline = true
				},
				{
					name = "Size",
					value = t69.sizeText(p612),
					inline = true
				},
				{
					name = "Weight",
					value = t69.weightText(t69.weightOf(p612)),
					inline = true
				},
				{
					name = "Cash/s",
					value = t69.rateText(v2131),
					inline = true
				},
				{
					name = "Area",
					value = tostring(p612.AreaId or "?"),
					inline = true
				}
			}
			local Mutations = p612.Mutations or {}
			if #Mutations > 0 then
				local t82 = {}
				for _, Mutation in ipairs(Mutations) do
					t82[#t82 + 1] = tostring(Mutation)
				end
				t75[#t75 + 1] = {
					name = "Mutations",
					value = table.concat(t82, ", "),
					inline = false
				}
			end
			if p614 and p614 ~= "" then
				t75[#t75 + 1] = {
					name = "Taken From",
					value = tostring(p614),
					inline = false
				}
			end
			local v2143 = v2088()
			local t83 = {
				title = "Egg Stolen",
				description = string.format("You've stolen a **%s** %s", tostring(v2130.rarity), tostring(v2130.name)),
				color = v2094(v2130.rarityColor),
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				author = {
					name = "S2rHub",
					icon_url = v2143
				},
				footer = {
					text = "https://discord.gg/H7vmT7cqM",
					icon_url = v2143
				},
				fields = t75
			}
			if #t70 > 40 then
				table.remove(t70, 1)
			end
			table.insert(t70, {
				url = WebhookURL,
				payload = {
					embeds = { t83 }
				}
			})
			v2089()
		end
		t69.test = function()
			local WebhookURL = s2rHubConfig.WebhookURL
			if type(WebhookURL) ~= "string" or WebhookURL == "" then
				return false
			end
			local v2146 = v2088()
			local t84 = {
				title = "Webhook Test",
				description = string.format("Connection test for **%s**", LocalPlayer2.Name),
				color = 5814783,
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				author = {
					name = "S2rHub",
					icon_url = v2146
				},
				footer = {
					text = "https://discord.gg/H7vmT7cqM",
					icon_url = v2146
				},
				fields = {
					{
						name = "User",
						value = LocalPlayer2.Name,
						inline = true
					},
					{
						name = "User ID",
						value = tostring(LocalPlayer2.UserId),
						inline = true
					},
					{
						name = "Place ID",
						value = tostring(game.PlaceId),
						inline = true
					},
					{
						name = "Status",
						value = "Connected",
						inline = true
					}
				}
			}
			local v2148 = v2076("96240498384290")
			if v2148 then
				t84.thumbnail = {
					url = v2148
				}
			end
			table.insert(t70, {
				url = WebhookURL,
				payload = {
					embeds = { t84 }
				}
			})
			v2089()
			return true
		end
		return t69
	end
	genv.__S2rHubWebhook = v2064()
	local function v2149()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
		local t85 = {}
		t85.__index = t85
		local t86 = {
			1.1,
			0.2,
			0.7,
			1.4,
			0.45
		}
		t85.new = function(p615, p616, p617)
			local obj = setmetatable({}, t85)
			obj.eggRuntime = p615
			obj.godMode = p616
			obj.catalog = p617
			obj.enabled = false
			obj.running = false
			obj.status = "idle"
			obj.taken = 0
			obj.attempts = 0
			obj.history = {}
			obj.blacklist = {}
			obj.forced = false
			obj.listeners = {}
			obj.swingSeq = 0
			obj.leadIdx = 1
			obj.hitIdx = nil
			obj.missStreak = 0
			return obj
		end
		t85.onChanged = function(p618, p619)
			table.insert(p618.listeners, p619)
		end
		t85._notify = function(p620)
			for _, listener in ipairs(p620.listeners) do
				pcall(listener, p620)
			end
		end
		t85._setStatus = function(p621, p622)
			if p621.status == p622 then
				return
			end
			p621.status = p622
			p621:_notify()
		end
		t85._log = function(p623, p624, p625, p626)
			table.insert(p623.history, 1, {
				at = os.time(),
				player = p624 or "?",
				egg = p625 or "?",
				outcome = p626 or "?"
			})
			while #p623.history > 20 do
				table.remove(p623.history)
			end
			p623:_notify()
		end
		t85.setEnabled = function(p627, p628)
			p627.enabled = p628 == true
			if p627.enabled then
				p627:_setStatus("looking for a carrier")
				p627:_start()
			else
				p627:_setStatus("idle")
			end
		end
		t85._passes = function(p629, p630)
			if not (type(p630) == "table" and p630.AssetCategory) then
				return false
			end
			local v2160 = p629.catalog.resolve(p630)
			local t87 = {}
			local v2162 = false
			local ipairs_ = ipairs
			local StealPlayerRarities = s2rHubConfig.StealPlayerRarities or {}
			for _, StealPlayerRarity in ipairs_(StealPlayerRarities) do
				if StealPlayerRarity ~= "None" and StealPlayerRarity ~= "" then
					t87[StealPlayerRarity] = true
					v2162 = true
				end
			end
			if not v2162 then
				local ipairs_2 = ipairs
				local StealRarities = s2rHubConfig.StealRarities or {}
				for _, StealRarity in ipairs_2(StealRarities) do
					if StealRarity ~= "None" and StealRarity ~= "" then
						t87[StealRarity] = true
						v2162 = true
					end
				end
			end
			if v2162 and not t87[v2160.rarity] then
				return false
			end
			local v2171 = tonumber(s2rHubConfig.StealPlayerMinValue) or 0
			if v2171 > 0 then
				if (genv.__S2rHubWebhook and genv.__S2rHubWebhook.rateOf(p630) or 0) < v2171 then
					return false
				end
			end
			return true
		end
		t85.carriers = function(p631)
			local t88 = {}
			local ok, result = pcall(function()
				return EggState2.ReadFieldEggs()
			end)
			if not ok or not result then
				return t88
			end
			local ipairs_ = ipairs
			local Records = result.Records or {}
			for _, Record in ipairs_(Records) do
				if (Record.State == "Carried" or AreaEggs and AreaEggs.States and Record.State == AreaEggs.States.Carried) and not p631.blacklist[Record.Uid] then
					local u2179
					pcall(function()
						u2179 = EggState2.ReadFieldEgg(Record.Uid)
					end)
					u2179 = u2179 or Record
					local CarrierUserId = u2179.CarrierUserId
					if CarrierUserId and CarrierUserId ~= LocalPlayer2.UserId then
						local playerByUserId = Players2:GetPlayerByUserId(CarrierUserId)
						local HumanoidRootPart = playerByUserId and playerByUserId.Character and playerByUserId.Character:FindFirstChild("HumanoidRootPart")
						if playerByUserId and HumanoidRootPart then
							table.insert(t88, {
								record = u2179,
								player = playerByUserId,
								root = HumanoidRootPart
							})
						end
					end
				end
			end
			return t88
		end
		t85.clearHistory = function(p632)
			table.clear(p632.history)
			p632:_notify()
		end
		local function v2183(p633)
			if typeof(p633) == "Color3" then
				return string.format("%02x%02x%02x", math.floor(p633.R * 255 + 0.5), math.floor(p633.G * 255 + 0.5), math.floor(p633.B * 255 + 0.5))
			end
			return "ffffff"
		end
		t85.listEntries = function(p634)
			local t89 = {}
			for _, v in ipairs(p634:carriers()) do
				t89[v.player] = v.record
			end
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			local t90 = {}
			local v2189
			for _, player in ipairs(Players2:GetPlayers()) do
				if player ~= LocalPlayer2 then
					local v2192, s4
					if player.Character then
						local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
						v2192 = t89[player]
						local ok = not (HumanoidRootPart2 and HumanoidRootPart)
						if not ok then
							v2189 = math.floor((HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude + 0.5)
							ok = not v2189
						end
						if ok then
							v2189 = nil
						end
						s4 = "Offline"
						if v2192 and v2192.AreaId then
							s4 = tostring(v2192.AreaId)
						elseif HumanoidRootPart2 then
							s4 = HumanoidRootPart2.Position.X <= 552.2 and "Safe Zone" or "Field"
						end
					else
						v2192 = t89[player]
						v2189 = nil
						s4 = "Offline"
						if v2192 and v2192.AreaId then
							s4 = tostring(v2192.AreaId)
						end
					end
					local rarityRank
					local v2197, v2198
					if v2192 then
						local ok, result = pcall(function()
							return p634.catalog.resolve(v2192)
						end)
						local v2201 = ok and result
						if not v2201 then
							v2201 = {
								rarityRank = 0,
								name = tostring(v2192.AssetCategory or "Egg"),
								rarity = "Unknown",
								rarityColor = Color3.fromRGB(245, 196, 81)
							}
						end
						local v2202 = v2201
						rarityRank = v2202.rarityRank or 0
						v2197 = string.format("<font color=\"#%s\">%s</font>  <font color=\"#A2A2AE\">[%s]</font>", v2183(v2202.rarityColor), tostring(v2202.name or "Egg"), tostring(v2202.rarity or "Common"))
						v2198 = string.format("Running in %s%s", s4, v2189 and "  -  " .. v2189 .. " studs" or "")
					else
						v2197 = "No Egg Carried"
						v2198 = string.format("Idle in %s%s", s4, v2189 and "  -  " .. v2189 .. " studs" or "")
					end
					t90[#t90 + 1] = {
						id = tostring(player.UserId),
						name = tostring(player.DisplayName or player.Name),
						sub = string.format("<font color=\"#4ADE80\">@%s</font>  <font color=\"#A2A2AE\">[%s]</font>", tostring(player.Name), s4),
						status = v2197,
						statusSub = v2198,
						button = "Steal",
						buttonColor = v2192 and "accent" or "dim",
						player = player,
						carrying = v2192 ~= nil,
						rank = rarityRank or -1,
						distance = v2189 or 1e9,
						onClick = function(p635, p636)
							local v2203 = p634:strike(p635.player)
							p636(v2203 and "Chasing" or "No Egg", v2203 and "green" or "red")
							task.delay(1.6, function()
								pcall(p636, "Steal", p635.carrying and "accent" or "dim")
							end)
						end
					}
				end
			end
			table.sort(t90, function(p637, p638)
				if p637.carrying ~= p638.carrying then
					return p637.carrying
				end
				if not p637.carrying or p637.rank == p638.rank then
					return p637.distance < p638.distance
				end
				return p637.rank > p638.rank
			end)
			return t90
		end
		t85._pick = function(p639)
			local StealPlayerTarget = s2rHubConfig.StealPlayerTarget
			local v2205
			local v2206
			local v2207, v2208, v2209 = ipairs(p639:carriers())
			local v2210 = geniter(v2207, v2208, v2209)
			while true do
				local v2211 = table.pack(v2210())
				if not v2211[1] then
					break
				end
				local v2212 = v2211[3]
				local v2213 = StealPlayerTarget == nil or StealPlayerTarget == "" or StealPlayerTarget == "Any Player" or v2212.player.Name == StealPlayerTarget
				if not (v2212.root.Position.X > 672.2) then
					continue
				end
				local exitTo2
				while true do
					local v2215 = v2212.player:GetAttribute("InBossArena") ~= true
					local exitTo
					while true do
						if not v2213 or not v2215 then
							local v2217 = table.pack(v2210())
							if not v2217[1] then
								break
							end
							v2212 = v2217[3]
							v2213 = StealPlayerTarget == nil or StealPlayerTarget == "" or StealPlayerTarget == "Any Player" or v2212.player.Name == StealPlayerTarget
							v2215 = v2212.root.Position.X > 672.2
							if not v2215 then
								continue
							end
							exitTo = 2
							break
						end
						exitTo = 1
						break
					end
					if exitTo == 1 then
						exitTo2 = 1
						break
					elseif exitTo == 2 then
						continue
					end
					break
				end
				if exitTo2 == 1 then
					if p639:_passes(v2212.record) then
						local rarityRank = p639.catalog.resolve(v2212.record).rarityRank or 0
						if not v2206 or v2206 < rarityRank then
							v2205 = v2212
							v2206 = rarityRank
						end
					end
					continue
				end
				break
			end
			return v2205
		end
		t85.strike = function(p640, p641)
			if not p641 or p641 == LocalPlayer2 then
				return false
			end
			for _, v in ipairs(p640:carriers()) do
				if v.player == p641 then
					p640.forced = true
					task.spawn(function()
						p640:_chase(v)
					end)
					return true
				end
			end
			p640:_setStatus(p641.Name .. " is not carrying an egg")
			return false
		end
		local function v2221()
			local Character = LocalPlayer2.Character
			if not Character then
				return
			end
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			for _, descendant in ipairs(Character:GetDescendants()) do
				if not descendant:IsA("Motor6D") then
					if not descendant:IsA("BallSocketConstraint") then
						if not descendant:IsA("HingeConstraint") then
							if not descendant:IsA("Attachment") then
								continue
							end
							if not descendant.Name:find("Ragdoll") and not descendant:GetAttribute("RagdollAttachment") then
								continue
							end
							pcall(function()
								descendant:Destroy()
							end)
							continue
						end
					end
					if descendant.Name:find("Ragdoll") or descendant:GetAttribute("RagdollConstraint") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				elseif not descendant.Enabled then
					descendant.Enabled = true
				end
			end
			if Humanoid then
				Humanoid.PlatformStand = false
				Humanoid.Sit = false
				pcall(function()
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
					Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					task.wait(0.02)
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
			if HumanoidRootPart then
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end
		end
		local function v2227()
			local v2228 = v14()
			local Areas = v2228 and v2228:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
			if Forest then
				local Guard = Forest:FindFirstChild("Guard")
				local HumanoidRootPart = Guard and (Guard:FindFirstChild("HumanoidRootPart") or Guard:FindFirstChild("Collider") or Guard:IsA("Model") and Guard.PrimaryPart)
				if Guard and HumanoidRootPart then
					return Guard, HumanoidRootPart
				end
				local ForestGuardAuthored = Forest:FindFirstChild("ForestGuardAuthored")
				local HumanoidRootPart2 = ForestGuardAuthored and (ForestGuardAuthored:FindFirstChild("HumanoidRootPart") or ForestGuardAuthored:IsA("Model") and ForestGuardAuthored.PrimaryPart)
				if ForestGuardAuthored and HumanoidRootPart2 then
					return ForestGuardAuthored, HumanoidRootPart2
				end
			end
			local AreaGuards = workspace:FindFirstChild("AreaGuards")
			if AreaGuards then
				for _, child in ipairs(AreaGuards:GetChildren()) do
					local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")
					if HumanoidRootPart and HumanoidRootPart.Position.X < 850 then
						return child, HumanoidRootPart
					end
				end
			end
			return nil, nil
		end
		local function v2240(p642)
			local u2241
			pcall(function()
				u2241 = EggState2.ReadFieldEggs()
			end)
			local Records = u2241 and u2241.Records or {}
			local v2243
			for _, Record in ipairs(Records) do
				if (Record.State == "Slot" or Record.State == "Dropped") and Record.Uid ~= p642 and (not Record.CarrierUserId or Record.CarrierUserId == LocalPlayer2.UserId) then
					local Position = Record.BottomCFrame and Record.BottomCFrame.Position or Record.BoundsCFrame and Record.BoundsCFrame.Position
					if Record.AreaId == "Forest" or tostring(Record.Uid):find("Forest", 1, true) or tostring(Record.Uid):find("^FirstArea") or Position and Position.X < 680 then
						if Record.State == "Slot" then
							v2243 = Record
							break
						end
						v2243 = v2243 or Record
					end
				end
			end
			return v2243
		end
		t85._primeForest = function(p643, p644)
			local eggRuntime = p643.eggRuntime
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not HumanoidRootPart or not Humanoid or not (Humanoid.Health > 0) then
				return false
			end
			if eggRuntime and eggRuntime.carry and eggRuntime.carry.active and eggRuntime.carry.uid then
				pcall(function()
					eggRuntime:_returnToSafe()
				end)
				task.wait(0.08)
			end
			p643:_setStatus("Finding Forest bait egg")
			local v2251 = v2240(p644)
			if not v2251 then
				p643:_setStatus("No Forest bait egg available")
				return false
			end
			local Position = v2251.BottomCFrame and v2251.BottomCFrame.Position or v2251.BoundsCFrame and v2251.BoundsCFrame.Position or Vector3.new(596.6, 67.7, -325)
			local vector32 = Vector3.new(Position.X, Position.Y + 2.5, Position.Z)
			local u2254 = "Forest:" .. tostring(v2251.NestId or "Slot_001")
			pcall(function()
				local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)
				if AreaEggSlotIdentity and v2251.AreaId and v2251.NestId then
					u2254 = AreaEggSlotIdentity.SlotKey(v2251.AreaId, v2251.NestId)
				end
			end)
			p643:_setStatus("Grabbing Forest bait egg")
			HumanoidRootPart.CFrame = cFrameNew(vector32)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			RunService.Heartbeat:Wait()
			local v2256 = false
			local now = os.clock()
			local n40 = 0
			while os.clock() - now < 0.8 do
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or HumanoidRootPart
				if HumanoidRootPart.Position.Y < 65 then
					HumanoidRootPart.CFrame = cFrameNew(vector32)
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				end
				if n40 <= os.clock() then
					n40 = os.clock() + 0.1
					task.spawn(function()
						pcall(function()
							EggState2.CarryFieldEgg(v2251.Uid, u2254)
						end)
					end)
					task.spawn(function()
						pcall(function()
							local Remotes = require(ReplicatedStorage2.Shared.Remotes)
							if Remotes and Remotes.EggWorld and Remotes.EggWorld.AskFieldEggCarry then
								Remotes.EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = v2251.Uid,
									FirstAreaSlotKey = u2254
								})
							end
						end)
					end)
				end
				local u2260
				pcall(function()
					u2260 = EggState2.ReadFieldEgg(v2251.Uid)
				end)
				if u2260 and u2260.State == "Carried" and u2260.CarrierUserId == LocalPlayer2.UserId then
					v2256 = true
					break
				else
					RunService.Heartbeat:Wait()
				end
			end
			if not v2256 then
				p643:_setStatus("Failed to carry Forest bait egg")
				v2221()
				return false
			end
			p643:_setStatus("Moving to Forest Guard")
			local u2261, u2262 = v2227()
			local Position2, u2264, t91
			if u2261 then
				if not u2261:FindFirstChild("Collider") then
				end
				Position2 = u2262 and u2262.Position or Vector3.new(596.6, 69.4, -317.1)
				HumanoidRootPart.CFrame = cFrameNew(Position2.X, Position2.Y + 0.8, Position2.Z)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				u2264 = false
				t91 = {}
			else
				Position2 = u2262 and u2262.Position or Vector3.new(596.6, 69.4, -317.1)
				HumanoidRootPart.CFrame = cFrameNew(Position2.X, Position2.Y + 0.8, Position2.Z)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				u2264 = false
				t91 = {}
			end
			pcall(function()
				local RERigSyncRefresh = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking") and ReplicatedStorage2.Packages.Networking:FindFirstChild("RE/RigSync/Refresh")
				if RERigSyncRefresh then
					table.insert(t91, RERigSyncRefresh.OnClientEvent:Connect(function()
						u2264 = true
					end))
				end
			end)
			pcall(function()
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)
				if Remotes and Remotes.EggWorld and Remotes.EggWorld.OwnerDropped then
					table.insert(t91, Remotes.EggWorld.OwnerDropped.OnClientEvent:Connect(function()
						u2264 = true
					end))
				end
			end)
			table.insert(t91, Humanoid.StateChanged:Connect(function(old, new)
				if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.PlatformStanding then
					u2264 = true
				end
			end))
			table.insert(t91, Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
				if Humanoid.PlatformStand then
					u2264 = true
				end
			end))
			local function v2268()
				local v2269, v2270 = v2227()
				u2261 = v2269
				u2262 = v2270
				local Position3 = u2262 and u2262.Position or Position2
				local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart2 then
					HumanoidRootPart2.CFrame = cFrameNew(Position3.X, Position3.Y + 0.8, Position3.Z)
					HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
				end
				local Collider = u2261 and u2261:FindFirstChild("Collider") or u2262
				if Collider and type(firetouchinterest) == "function" and HumanoidRootPart2 then
					pcall(function()
						firetouchinterest(HumanoidRootPart2, Collider, 0)
						firetouchinterest(HumanoidRootPart2, Collider, 1)
					end)
				end
				pcall(function()
					local Remotes = require(ReplicatedStorage2.Shared.Remotes)
					if Remotes then
						if Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike then
							Remotes.GuardPatrol.ForestStrike:FireServer({
								EggUid = v2251.Uid,
								GuardCFrame = u2262 and u2262.CFrame or cFrameNew(Position3)
							})
						end
					end
				end)
			end
			p643:_setStatus("Triggering Forest Guard hit")
			v2268()
			local v2275 = os.clock() + 0.75
			local v2276 = os.clock() + 0.05
			while os.clock() < v2275 and not u2264 do
				local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
				if Humanoid2 and (Humanoid2.PlatformStand or Humanoid2.Sit) then
					u2264 = true
					break
				end
				local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart2 and HumanoidRootPart2.AssemblyLinearVelocity.Magnitude > 18 then
					u2264 = true
					break
				else
					if HumanoidRootPart2 and HumanoidRootPart2.Position.Y < 65 then
						HumanoidRootPart2.CFrame = cFrameNew(Position2.X, 70, Position2.Z)
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					end
					if v2276 <= os.clock() then
						v2276 = os.clock() + 0.05
						v2268()
					end
					RunService.Heartbeat:Wait()
				end
			end
			for _, v in ipairs(t91) do
				pcall(v.Disconnect, v)
			end
			if not u2264 then
				p643:_setStatus("Forest Guard hit timed out")
				v2221()
				return false, v2251.Uid
			end
			p643:_setStatus("Recovering posture")
			v2221()
			local v2281 = os.clock() + 0.35
			while os.clock() < v2281 do
				local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if not Humanoid2 or not HumanoidRootPart2 or Humanoid2.PlatformStand or Humanoid2.Sit then
					v2221()
					RunService.Heartbeat:Wait()
				else
					local state = Humanoid2:GetState()
					if state ~= Enum.HumanoidStateType.Ragdoll and state ~= Enum.HumanoidStateType.FallingDown and state ~= Enum.HumanoidStateType.PlatformStanding then
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						break
					end
					v2221()
					RunService.Heartbeat:Wait()
				end
			end
			return true, v2251.Uid
		end
		t85._swingBatAt = function(p645, p646, p647)
			if not p647 or p647.Parent ~= LocalPlayer2.Character then
				return false
			end
			p645.swingSeq += 1
			local v2285 = string.format("%d:%d:%d", LocalPlayer2.UserId, p645.swingSeq, math.floor(workspace:GetServerTimeNow() * 1000))
			local function v2286()
				require(ReplicatedStorage2.Shared.Remotes).BatSwing.Trigger:FireServer(p646, v2285)
			end
			return pcall(v2286)
		end
		t85._returnSafe = function(p648)
			local eggRuntime = p648.eggRuntime
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if not eggRuntime or not HumanoidRootPart or not Humanoid or eggRuntime:_isInSafeArea(HumanoidRootPart) then
				return
			end
			local v2291 = eggRuntime:_resolveSafeCFrame(HumanoidRootPart)
			if not v2291 then
				return
			end
			p648:_setStatus("Returning to safe zone")
			v232(HumanoidRootPart, Humanoid, v2291, function()
				return Humanoid.Health <= 0 or not HumanoidRootPart.Parent
			end, false, nil, true)
		end
		t85.intercept = function(p649, p650)
			if p649.running then
				return false
			end
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			if not HumanoidRootPart then
				return false
			end
			for _, v in ipairs(p649:carriers()) do
				if v.record.Uid == p650 then
					if v.root.Position.X <= 552.2 or (v.root.Position - HumanoidRootPart.Position).Magnitude > 80 then
						return false
					end
					p649.forced = true
					task.spawn(p649._chase, p649, v, true)
					return p649.running
				end
			end
			return false
		end
		local s5 = "_chase"
		local function v2296(p651, p652, p653)
			if p651.running then
				return
			end
			p651.running = true
			p651.attempts += 1
			local record = p652.record
			local Uid = record.Uid
			local v2299 = p651.catalog.resolve(record)
			local player = p652.player
			local DisplayName = player.DisplayName or player.Name
			if p651.godMode then
				p651.godMode:stopDefend()
			end
			if not p653 then
				p651:_returnSafe()
				p651:_setStatus(string.format("Priming at Forest Guard for %s", DisplayName))
				local ok, result, result2 = pcall(p651._primeForest, p651, Uid)
				local u2305
				if ok and not result and result2 then
					pcall(function()
						u2305 = EggState2.ReadFieldEgg(result2)
					end)
				end
				if u2305 and u2305.State == "Carried" and u2305.CarrierUserId == LocalPlayer2.UserId then
					p651:_returnSafe()
					p651:_log(DisplayName, v2299.name, "Forest priming failed")
					p651:_setStatus(p651.enabled and "looking for a carrier" or "idle")
					p651.running = false
					p651.forced = false
					return
				end
			end
			local godMode = p651.godMode and p651.godMode:_equipBat()
			local v2307 = os.clock() + (p653 and 8 or 16)
			local s6 = "could not catch them"
			local n41 = 0
			local n42 = 0
			local now
			local v2312
			local now2
			local t92 = {}
			local vector32 = Vector3.zero
			local attribute = player:GetAttribute("RagdollEndTime") or false
			local n43 = 0.1
			pcall(function()
				n43 = math.clamp(LocalPlayer2:GetNetworkPing() or 0.1, 0.03, 0.6)
			end)
			local v2318 = math.clamp(0.14 + n43, 0.14, 0.35)
			local hitIdx = p651.hitIdx or p651.leadIdx
			p651.leadIdx = hitIdx or 1
			p651.missStreak = 0
			local connection
			pcall(function()
				connection = RunService.Stepped:Connect(function()
					local Character = LocalPlayer2.Character
					if Character then
						for _, descendant in ipairs(Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end
				end)
			end)
			p651:_setStatus(string.format("Chasing %s", DisplayName))
			while os.clock() < v2307 do
				local result = RunService.PreSimulation:Wait()
				if not p651.enabled and not p651.forced then
					s6 = "stopped"
					break
				end
				local u2325
				pcall(function()
					u2325 = EggState2.ReadFieldEgg(Uid)
				end)
				local State = u2325 and u2325.State
				if not u2325 or State == "Slot" or State == "GuardCarried" then
					s6 = "egg reset"
					break
				end
				if State == "Claimed" then
					s6 = "they banked it"
					break
				end
				if State == "Carried" and u2325.CarrierUserId == LocalPlayer2.UserId then
					s6 = "taken"
					break
				end
				if State == "Dropped" then
					if now and os.clock() - now <= 1 then
						p651.hitIdx = p651.leadIdx
					end
					p651:_setStatus(string.format("Grabbing dropped egg from %s", DisplayName))
					s6 = p651:_grab(u2325) and "taken" or "someone else grabbed it"
					break
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
					s6 = "character died"
					break
				end
				local HumanoidRootPart2, now3, v2332, AssemblyLinearVelocity, vector33, Magnitude, LookVector, vector34, Unit, Unit2, clamp, v2341, v2342, vector35, cFrame, v2345, Magnitude2, v2347, v2348, v2349, v2350, attribute2, v2352
				if u2325.CarrierUserId == player.UserId then
					HumanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if not HumanoidRootPart2 then
						s6 = "lost sight of them"
						break
					end
					if HumanoidRootPart2.Position.X <= 552.2 then
						s6 = "banked"
						break
					end
					now3 = os.clock()
					v2332 = #t92 + 1
					t92[v2332] = {
						t = now3,
						p = HumanoidRootPart2.Position
					}
					while #t92 > 2 and now3 - t92[1].t > 0.4 do
						table.remove(t92, 1)
					end
					AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
					if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 8 then
						vector32 = AssemblyLinearVelocity
					elseif #t92 >= 2 and now3 - t92[1].t > 0.15 then
						vector32 = (HumanoidRootPart2.Position - t92[1].p) / (now3 - t92[1].t)
					end
					vector33 = Vector3.new(vector32.X, 0, vector32.Z)
					Magnitude = vector33.Magnitude
					if Magnitude > 6 then
						Unit2 = vector33.Unit
					else
						LookVector = HumanoidRootPart2.CFrame.LookVector
						vector34 = Vector3.new(LookVector.X, 0, LookVector.Z)
						Unit = vector34.Magnitude > 0.05 and vector34.Unit or Vector3.new(-1, 0, 0)
						Unit2 = Unit
					end
					clamp = math.clamp
					v2341 = t86[p651.leadIdx] or 1
					v2342 = HumanoidRootPart2.Position + Unit2 * clamp(v2341 * Magnitude * v2318, 3, 110)
					if v2342.X < 557.2 then
						v2342 = Vector3.new(557.2, v2342.Y, v2342.Z)
					end
					vector35 = Vector3.new(HumanoidRootPart2.Position.X, v2342.Y, HumanoidRootPart2.Position.Z)
					if (vector35 - v2342).Magnitude < 0.5 then
						vector35 = v2342 - Unit2
					end
					cFrame = lookAt(v2342, vector35)
					v2345 = v2342 - HumanoidRootPart.Position
					Magnitude2 = v2345.Magnitude
					v2347 = v20()
					v2348 = v2347 * math.min(result, 0.05)
					v27(Character, v2347 * t1.HEADROOM)
					if v2348 < Magnitude2 then
						HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position + v2345.Unit * v2348) * cFrame.Rotation
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						v2349 = v2345.Unit * v2347
					else
						HumanoidRootPart.CFrame = cFrame
						HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
						v2349 = HumanoidRootPart2.AssemblyLinearVelocity
					end
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
					if not v32(Humanoid, HumanoidRootPart, v2347, v2349) then
						v31(Humanoid, HumanoidRootPart, v2347)
						v32(Humanoid, HumanoidRootPart, v2347, v2349)
					end
					v2350 = Magnitude * result * 1.5
					if not (Magnitude2 <= 5 + v2350) then
						if 12 + v2350 < Magnitude2 and now2 then
							now2 = nil
							p651:_setStatus(string.format("Chasing %s", DisplayName))
						end
					elseif not now2 then
						now2 = os.clock()
						p651:_setStatus(string.format("Attacking %s", DisplayName))
					end
					attribute2 = player:GetAttribute("RagdollEndTime") or false
					if attribute2 ~= attribute then
						attribute = attribute2
						p651.hitIdx = p651.leadIdx
						p651.missStreak = 0
						now = nil
					end
					if (not godMode or godMode.Parent ~= Character) and n42 <= os.clock() then
						n42 = os.clock() + 0.5
						task.spawn(function()
							godMode = p651.godMode and p651.godMode:_equipBat() or godMode
						end)
					end
					v2352 = godMode and tonumber(godMode:GetAttribute("CooldownEndTime")) or 0
					if now and os.clock() - now > 0.9 then
						if v2352 ~= v2312 then
							p651.missStreak += 1
							if p651.missStreak >= 2 then
								p651.missStreak = 0
								p651.leadIdx = p651.leadIdx % #t86 + 1
								now2 = nil
							end
						end
						now = nil
					end
					if godMode and godMode.Parent == Character and now2 and v2318 + 0.05 <= os.clock() - now2 and godMode:GetAttribute("CooldownActive") ~= true and v2352 <= workspace:GetServerTimeNow() and os.clock() - n41 >= 0.35 then
						n41 = os.clock()
						if not now then
							now = os.clock()
							v2312 = v2352
						end
						task.spawn(p651._swingBatAt, p651, player, godMode)
					end
				else
					local playerByUserId = Players2:GetPlayerByUserId(u2325.CarrierUserId or 0)
					if not playerByUserId then
						s6 = "taken by another player"
						break
					end
					player = playerByUserId
					DisplayName = player.DisplayName or player.Name
					attribute = player:GetAttribute("RagdollEndTime") or false
					now2 = nil
					now = nil
					table.clear(t92)
					p651:_setStatus(string.format("Chasing %s", DisplayName))
					HumanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if not HumanoidRootPart2 then
						s6 = "lost sight of them"
						break
					end
					if HumanoidRootPart2.Position.X <= 552.2 then
						s6 = "banked"
						break
					end
					now3 = os.clock()
					v2332 = #t92 + 1
					t92[v2332] = {
						t = now3,
						p = HumanoidRootPart2.Position
					}
					while #t92 > 2 and now3 - t92[1].t > 0.4 do
						table.remove(t92, 1)
					end
					AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
					if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 8 then
						vector32 = AssemblyLinearVelocity
					elseif #t92 >= 2 and now3 - t92[1].t > 0.15 then
						vector32 = (HumanoidRootPart2.Position - t92[1].p) / (now3 - t92[1].t)
					end
					vector33 = Vector3.new(vector32.X, 0, vector32.Z)
					Magnitude = vector33.Magnitude
					if Magnitude > 6 then
						Unit2 = vector33.Unit
					else
						LookVector = HumanoidRootPart2.CFrame.LookVector
						vector34 = Vector3.new(LookVector.X, 0, LookVector.Z)
						Unit = vector34.Magnitude > 0.05 and vector34.Unit or Vector3.new(-1, 0, 0)
						Unit2 = Unit
					end
					clamp = math.clamp
					v2341 = t86[p651.leadIdx] or 1
					v2342 = HumanoidRootPart2.Position + Unit2 * clamp(v2341 * Magnitude * v2318, 3, 110)
					if v2342.X < 557.2 then
						v2342 = Vector3.new(557.2, v2342.Y, v2342.Z)
					end
					vector35 = Vector3.new(HumanoidRootPart2.Position.X, v2342.Y, HumanoidRootPart2.Position.Z)
					if (vector35 - v2342).Magnitude < 0.5 then
						vector35 = v2342 - Unit2
					end
					cFrame = lookAt(v2342, vector35)
					v2345 = v2342 - HumanoidRootPart.Position
					Magnitude2 = v2345.Magnitude
					v2347 = v20()
					v2348 = v2347 * math.min(result, 0.05)
					v27(Character, v2347 * t1.HEADROOM)
					if v2348 < Magnitude2 then
						HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position + v2345.Unit * v2348) * cFrame.Rotation
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						v2349 = v2345.Unit * v2347
					else
						HumanoidRootPart.CFrame = cFrame
						HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
						v2349 = HumanoidRootPart2.AssemblyLinearVelocity
					end
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
					if not v32(Humanoid, HumanoidRootPart, v2347, v2349) then
						v31(Humanoid, HumanoidRootPart, v2347)
						v32(Humanoid, HumanoidRootPart, v2347, v2349)
					end
					v2350 = Magnitude * result * 1.5
					if not (Magnitude2 <= 5 + v2350) then
						if 12 + v2350 < Magnitude2 and now2 then
							now2 = nil
							p651:_setStatus(string.format("Chasing %s", DisplayName))
						end
					elseif not now2 then
						now2 = os.clock()
						p651:_setStatus(string.format("Attacking %s", DisplayName))
					end
					attribute2 = player:GetAttribute("RagdollEndTime") or false
					if attribute2 ~= attribute then
						attribute = attribute2
						p651.hitIdx = p651.leadIdx
						p651.missStreak = 0
						now = nil
					end
					if (not godMode or godMode.Parent ~= Character) and n42 <= os.clock() then
						n42 = os.clock() + 0.5
						task.spawn(function()
							godMode = p651.godMode and p651.godMode:_equipBat() or godMode
						end)
					end
					v2352 = godMode and tonumber(godMode:GetAttribute("CooldownEndTime")) or 0
					if now and os.clock() - now > 0.9 then
						if v2352 ~= v2312 then
							p651.missStreak += 1
							if p651.missStreak >= 2 then
								p651.missStreak = 0
								p651.leadIdx = p651.leadIdx % #t86 + 1
								now2 = nil
							end
						end
						now = nil
					end
					if godMode and godMode.Parent == Character and now2 and v2318 + 0.05 <= os.clock() - now2 and godMode:GetAttribute("CooldownActive") ~= true and v2352 <= workspace:GetServerTimeNow() and os.clock() - n41 >= 0.35 then
						n41 = os.clock()
						if not now then
							now = os.clock()
							v2312 = v2352
						end
						task.spawn(p651._swingBatAt, p651, player, godMode)
					end
				end
			end
			if connection then
				pcall(function()
					connection:Disconnect()
				end)
			end
			if s6 == "taken" then
				p651.taken += 1
				pcall(function()
					local Humanoid = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid:UnequipTools()
					end
				end)
			else
				p651.blacklist[Uid] = os.clock() + 20
			end
			p651:_returnSafe()
			p651:_log(DisplayName, v2299.name, s6)
			p651:_setStatus(p651.enabled and "looking for a carrier" or "idle")
			p651.running = false
			p651.forced = false
		end
		t85[s5] = v2296
		t85._grab = function(p654, p655)
			local eggRuntime = p654.eggRuntime
			local Uid = p655.Uid
			local v2357 = os.clock() + 3
			local n44 = 0
			while true do
				if not (os.clock() < v2357) then
					return false
				end
				local u2359
				pcall(function()
					u2359 = EggState2.ReadFieldEgg(Uid)
				end)
				local State = u2359 and u2359.State
				if State == "Carried" then
					if u2359.CarrierUserId ~= LocalPlayer2.UserId then
						return false
					end
					if genv.__S2rHubWebhook then
						local ok, result = pcall(p654.catalog.resolve, u2359)
						pcall(genv.__S2rHubWebhook.stolen, u2359, ok and result or nil, "player carry")
					end
					return true
				end
				if State ~= "Dropped" then
					return false
				end
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
					break
				end
				local cFrame = eggRuntime and eggRuntime:_resolveEggDestination(u2359, HumanoidRootPart, Humanoid)
				if not cFrame then
					local Position = u2359.BottomCFrame and u2359.BottomCFrame.Position or u2359.BoundsCFrame and u2359.BoundsCFrame.Position
					cFrame = Position and cFrameNew(Position.X, Position.Y + 2.5, Position.Z)
				end
				if cFrame then
					HumanoidRootPart.CFrame = cFrame
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end
				if n44 <= os.clock() then
					n44 = os.clock() + 0.1
					task.spawn(function()
						pcall(function()
							EggState2.CarryFieldEgg(Uid)
						end)
					end)
					task.spawn(function()
						pcall(function()
							require(ReplicatedStorage2.Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({
								Uid = Uid
							})
						end)
					end)
				end
				RunService.Heartbeat:Wait()
			end
			return false
		end
		t85._start = function(p656)
			if p656.loop then
				return
			end
			p656.loop = task.spawn(function()
				while true do
					task.wait(0.4)
					if genv.__S2rHubPlayerSteal ~= p656 then
						break
					end
					for k, v in pairs(p656.blacklist) do
						if v < os.clock() then
							p656.blacklist[k] = nil
						end
					end
					local eggRuntime = p656.eggRuntime
					local __S2rHubScrambleRuntime = genv.__S2rHubScrambleRuntime
					if p656.enabled and not p656.running and (not eggRuntime or not eggRuntime.running and (not eggRuntime.carry or not eggRuntime.carry.active)) and (__S2rHubScrambleRuntime == nil or __S2rHubScrambleRuntime.active ~= true) then
						local v2372 = p656:_pick()
						if v2372 then
							p656:_chase(v2372)
						end
					end
				end
				p656.loop = nil
			end)
		end
		return t85
	end
	local v2373 = v2149()
	v614 = v1885.new(v612)
	v614:install()
	v614:setEnabled(s2rHubConfig.AntiGuardKnockback == true)
	genv.__S2rHubAntiGuard = v614
	v615 = v1932.new(v612)
	v615:setEnabled(s2rHubConfig.GodMode == nil and true or s2rHubConfig.GodMode == true)
	genv.__S2rHubGodMode = v615
	local v2374 = v2373.new(v612, v615, v611)
	local function v2375()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local LocalPlayer2 = Players2.LocalPlayer
		local t93 = {}
		t93.__index = t93
		t93.new = function()
			local obj = setmetatable({}, t93)
			obj.flyEnabled = false
			obj.flyConnection = nil
			obj.flyMover = nil
			obj.grabEnabled = false
			obj.grabConnection = nil
			obj.grabOriginals = setmetatable({}, {
				__mode = "k"
			})
			obj.jumpEnabled = false
			obj.jumpConnections = {}
			obj.lastJumpAt = 0
			obj.speedMultiplier = 1
			obj.speedModules = nil
			obj.speedConnection = nil
			return obj
		end
		t93._root = function()
			local Character = LocalPlayer2.Character
			return Character and Character:FindFirstChild("HumanoidRootPart")
		end
		t93._humanoid = function()
			local Character = LocalPlayer2.Character
			return Character and Character:FindFirstChildOfClass("Humanoid")
		end
		t93._ensureMover = function(p657, p658)
			if p657.flyMover and p657.flyMover.Parent == p658 then
				return
			end
			if p657.flyMover then
				pcall(function()
					p657.flyMover:Destroy()
				end)
			end
			local BodyVelocity = Instance.new("BodyVelocity")
			BodyVelocity.Name = "S2rHubFlyCaptureHover"
			BodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
			BodyVelocity.Velocity = Vector3.zero
			BodyVelocity.Parent = p658
			p657.flyMover = BodyVelocity
		end
		local function v2385()
			local __S2rHubTreadmillManager = genv.__S2rHubTreadmillManager
			return __S2rHubTreadmillManager ~= nil and not __S2rHubTreadmillManager.destroyed and __S2rHubTreadmillManager.config ~= nil and __S2rHubTreadmillManager.config.idleFarm == true
		end
		local t94 = {
			at = 0,
			value = false
		}
		local function v2388()
			local now = os.clock()
			if now - t94.at < 0.25 then
				return t94.value
			end
			t94.at = now
			local value = false
			pcall(function()
				local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
				local GetAreaEggSnapshot = EggState2.GetAreaEggSnapshot and EggState2.GetAreaEggSnapshot()
				if (not GetAreaEggSnapshot or not GetAreaEggSnapshot.Records) and EggState2.ReadFieldEggs then
					GetAreaEggSnapshot = EggState2.ReadFieldEggs()
				end
				local ipairs_ = ipairs
				local Records = GetAreaEggSnapshot and GetAreaEggSnapshot.Records or {}
				for _, Record in ipairs_(Records) do
					if Record.State == "Carried" and Record.CarrierUserId == LocalPlayer2.UserId then
						value = true
						break
					end
				end
			end)
			t94.value = value
			return value
		end
		t93._dropMover = function(p659, p660)
			if p659.flyMover then
				pcall(function()
					p659.flyMover:Destroy()
				end)
				p659.flyMover = nil
			end
			local S2rHubFlyCaptureHover = p660 and p660:FindFirstChild("S2rHubFlyCaptureHover")
			if S2rHubFlyCaptureHover then
				pcall(function()
					S2rHubFlyCaptureHover:Destroy()
				end)
			end
		end
		t93.setFlyForCapture = function(p661, p662)
			p661.flyEnabled = p662 == true
			if p661.flyEnabled then
				if not p661.flyConnection then
					p661.flyAnchored = false
					p661.flyConnection = RunService2.PreSimulation:Connect(function()
						if not p661.flyEnabled then
							return
						end
						local v2398 = p661:_root()
						if not v2398 then
							return
						end
						local running = not v2388() or v2385() or next(t9) ~= nil or v612 and (v612.running or v612.activeTween)
						if not running then
							local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
							if __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
								running = true
							end
						end
						if running then
							if p661.flyAnchored then
								pcall(function()
									v2398.Anchored = false
								end)
								p661.flyAnchored = false
							end
							return
						end
						if v2398.Position.Y < 109 then
							if p661.flyAnchored then
								pcall(function()
									v2398.Anchored = false
								end)
								p661.flyAnchored = false
							end
							v2398.CFrame = cFrameNew(v2398.Position.X, v2398.Position.Y + math.min(110 - v2398.Position.Y, 4), v2398.Position.Z) * v2398.CFrame.Rotation
							v2398.AssemblyLinearVelocity = Vector3.zero
							v2398.AssemblyAngularVelocity = Vector3.zero
						elseif v2398.Anchored then
							p661.flyAnchored = true
						else
							pcall(function()
								v2398.Anchored = true
							end)
							p661.flyAnchored = true
						end
					end)
					return
				end
				return
			end
			if p661.flyConnection then
				pcall(function()
					p661.flyConnection:Disconnect()
				end)
				p661.flyConnection = nil
			end
			if p661.flyMover then
				pcall(function()
					p661.flyMover:Destroy()
				end)
				p661.flyMover = nil
			end
			local v2401 = p661:_root()
			if v2401 then
				local S2rHubFlyCaptureHover = v2401:FindFirstChild("S2rHubFlyCaptureHover")
				if S2rHubFlyCaptureHover then
					pcall(function()
						S2rHubFlyCaptureHover:Destroy()
					end)
				end
				if p661.flyAnchored then
					pcall(function()
						v2401.Anchored = false
					end)
				end
			end
			p661.flyAnchored = false
		end
		t93._isGrabPrompt = function(p663, p664)
			return p664:IsA("ProximityPrompt") and p664.Name == "CarryAreaEgg"
		end
		t93._applyGrab = function(p665, p666)
			if not p665:_isGrabPrompt(p666) then
				return
			end
			if p665.grabOriginals[p666] == nil then
				p665.grabOriginals[p666] = p666.HoldDuration
			end
			if p666.HoldDuration > 0.1 then
				p666.HoldDuration = 0.1
			end
		end
		t93._restoreGrab = function(p667)
			local v2403 = workspace:GetAttribute("FastEggPickupTime") and 0.25 or 1.2
			for k, grabOriginal in pairs(p667.grabOriginals) do
				pcall(function()
					if k.Parent then
						k.HoldDuration = tonumber(grabOriginal) and grabOriginal > 0.1 and grabOriginal or v2403
					end
				end)
			end
			p667.grabOriginals = setmetatable({}, {
				__mode = "k"
			})
		end
		t93._fireGrab = function(p668, p669)
			if not p668:_isGrabPrompt(p669) or not p669.Enabled then
				return
			end
			p668.grabFiring = p668.grabFiring or setmetatable({}, {
				__mode = "k"
			})
			if p668.grabFiring[p669] then
				return
			end
			local Parent = p669.Parent
			local v2407 = p668:_root()
			if not v2407 or not Parent or not Parent:IsA("BasePart") then
				return
			end
			if (tonumber(p669.MaxActivationDistance) or 10) + 1 < (Parent.Position - v2407.Position).Magnitude then
				return
			end
			p668.grabFiring[p669] = true
			task.spawn(function()
				pcall(function()
					local v2408 = math.max(0.1, tonumber(p669.HoldDuration) or 0.1)
					p669:InputHoldBegin()
					task.wait(v2408 + 0.05)
					p669:InputHoldEnd()
				end)
				task.wait(0.4)
				if p668.grabFiring then
					p668.grabFiring[p669] = nil
				end
			end)
		end
		t93.setInstantGrab = function(p670, p671)
			p670.grabEnabled = p671 == true
			if p670.grabEnabled then
				for _, descendant in ipairs(workspace:GetDescendants()) do
					p670:_applyGrab(descendant)
				end
				if not p670.grabConnection then
					p670.grabConnection = workspace.DescendantAdded:Connect(function(descendant)
						if p670.grabEnabled then
							if p670:_isGrabPrompt(descendant) then
								task.defer(function()
									p670:_applyGrab(descendant)
								end)
							end
						end
					end)
				end
			else
				if p670.grabConnection then
					pcall(function()
						p670.grabConnection:Disconnect()
					end)
					p670.grabConnection = nil
				end
				p670.grabFireLoop = nil
				p670:_restoreGrab()
			end
		end
		t93.triggerJump = function(p672)
			if not p672.jumpEnabled then
				return
			end
			local now = os.clock()
			if now - p672.lastJumpAt < 0.08 then
				return
			end
			local v2412 = p672:_humanoid()
			local v2413 = p672:_root()
			if not v2412 or not v2413 or v2412.Health <= 0 then
				return
			end
			p672.lastJumpAt = now
			pcall(function()
				v2412:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				v2412:ChangeState(Enum.HumanoidStateType.Jumping)
				v2412.Jump = true
			end)
			local n45 = 55
			if v2412.UseJumpPower and v2412.JumpPower > 0 then
				n45 = v2412.JumpPower
			elseif v2412.JumpHeight and v2412.JumpHeight > 0 then
				n45 = math.sqrt(2 * workspace.Gravity * v2412.JumpHeight)
			end
			if n45 < 55 then
				n45 = 55
			end
			pcall(function()
				local AssemblyLinearVelocity = v2413.AssemblyLinearVelocity
				v2413.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, n45, AssemblyLinearVelocity.Z)
			end)
		end
		t93.setInfiniteJump = function(p673, p674)
			p673.jumpEnabled = p674 == true
			if #p673.jumpConnections > 0 then
				return
			end
			pcall(function()
				table.insert(p673.jumpConnections, UserInputService.InputBegan:Connect(function(input)
					if not p673.jumpEnabled then
						return
					end
					if UserInputService:GetFocusedTextBox() then
						return
					end
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						p673:triggerJump()
					end
				end))
				table.insert(p673.jumpConnections, UserInputService.JumpRequest:Connect(function()
					if not p673.jumpEnabled then
						return
					end
					if UserInputService:GetFocusedTextBox() then
						return
					end
					p673:triggerJump()
				end))
			end)
			task.spawn(function()
				while true do
					RunService2.Heartbeat:Wait()
					if p673.jumpEnabled and not UserInputService:GetFocusedTextBox() then
						local u2416 = false
						pcall(function()
							if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA) then
								u2416 = true
							end
						end)
						if u2416 and os.clock() - p673.lastJumpAt >= 0.28 then
							p673:triggerJump()
						end
					end
				end
			end)
		end
		t93._gameWalkSpeed = function(p675)
			local speedModules = p675.speedModules
			if not speedModules then
				speedModules = {}
				pcall(function()
					speedModules.TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
				end)
				pcall(function()
					speedModules.Projection = require(ReplicatedStorage.Client.SpeedPowerProjection)
				end)
				pcall(function()
					speedModules.Save = require(ReplicatedStorage.Shared.Save)
				end)
				p675.speedModules = speedModules
			end
			if not speedModules.TreadmillUtil or not speedModules.TreadmillUtil.SpeedPowerToWalkSpeed then
				return nil
			end
			local SpeedPower
			if speedModules.Projection then
				pcall(function()
					SpeedPower = speedModules.Projection.ReadProjected()
				end)
			end
			if type(SpeedPower) ~= "number" and speedModules.Save then
				pcall(function()
					SpeedPower = (speedModules.Save.Peek or speedModules.Save.Get)().SpeedPower
				end)
			end
			if type(SpeedPower) ~= "number" then
				return nil
			end
			local ok, result = pcall(speedModules.TreadmillUtil.SpeedPowerToWalkSpeed, SpeedPower)
			local v2421 = ok and tonumber(result) or nil
			return v2421
		end
		t93.setSpeedMultiplier = function(p676, p677)
			p676.speedMultiplier = math.clamp(tonumber(p677) or 1, 1, 2.1)
			p676:_applySpeedMultiplier()
			if not p676.speedConnection then
				p676.speedConnection = RunService2.Heartbeat:Connect(function()
					if p676.speedMultiplier <= 1.001 then
						return
					end
					p676:_applySpeedMultiplier()
				end)
				return
			end
		end
		t93._applySpeedMultiplier = function(p678)
			local __S2rHubTreadmillManager = genv.__S2rHubTreadmillManager
			if __S2rHubTreadmillManager and __S2rHubTreadmillManager.activeTreadmill ~= nil then
				return
			end
			local v2423 = p678:_humanoid()
			if not v2423 then
				return
			end
			local v2424 = p678:_gameWalkSpeed()
			if not v2424 or v2424 <= 0 then
				return
			end
			local walkSpeed = v2424 * p678.speedMultiplier
			if math.abs(v2423.WalkSpeed - walkSpeed) > 0.05 then
				pcall(function()
					v2423.WalkSpeed = walkSpeed
				end)
			end
		end
		t93.destroy = function(p679)
			p679:setFlyForCapture(false)
			p679:setInstantGrab(false)
			p679.jumpEnabled = false
			for _, jumpConnection in ipairs(p679.jumpConnections) do
				pcall(function()
					jumpConnection:Disconnect()
				end)
			end
			p679.jumpConnections = {}
			if p679.speedConnection then
				pcall(function()
					p679.speedConnection:Disconnect()
				end)
				p679.speedConnection = nil
			end
		end
		return t93
	end
	local v2428 = v2375().new()
	genv.__S2rHubMovementExtras = v2428
	if s2rHubConfig.FlyForCapture then
		v2428:setFlyForCapture(true)
	end
	if s2rHubConfig.InstantGrab then
		v2428:setInstantGrab(true)
	end
	if s2rHubConfig.InfiniteJump then
		v2428:setInfiniteJump(true)
	end
	if (s2rHubConfig.WalkSpeedMultiplier or 1) > 1 then
		v2428:setSpeedMultiplier(s2rHubConfig.WalkSpeedMultiplier)
	end
	local function v2429()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local cFrame = cFrameNew(544.76, 71.5, -416.48)
		local t95 = {}
		t95.__index = t95
		t95.new = function()
			local obj = setmetatable({}, t95)
			obj.enabled = false
			obj.running = false
			obj.destroyed = false
			obj.connection = nil
			obj.wasHolding = false
			obj.lastResult = "Idle"
			return obj
		end
		t95._character = function()
			return LocalPlayer2.Character
		end
		t95._root = function(p680)
			local v2437 = p680:_character()
			return v2437 and v2437:FindFirstChild("HumanoidRootPart")
		end
		t95._carriedUid = function()
			local Uid
			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				local v2440
				if EggState2.GetAreaEggSnapshot then
					v2440 = EggState2.GetAreaEggSnapshot()
				end
				if (not v2440 or not v2440.Records) and EggState2.ReadFieldEggs then
					v2440 = EggState2.ReadFieldEggs()
				end
				if not v2440 or not v2440.Records then
					return
				end
				local UserId = LocalPlayer2.UserId
				for _, record in ipairs(v2440.Records) do
					if record.State == "Carried" and record.CarrierUserId == UserId then
						Uid = record.Uid
						return
					end
				end
			end)
			return Uid
		end
		t95._record = function(p681, p682)
			local ReadFieldEgg
			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				ReadFieldEgg = EggState2.ReadFieldEgg and EggState2.ReadFieldEgg(p682)
			end)
			return ReadFieldEgg
		end
		t95._guardFor = function(p683, p684)
			local Guard
			pcall(function()
				local v2447 = p683:_record(p684)
				local v2448 = v14()
				local Areas = v2448 and v2448:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local AreaId = GuardAreas and v2447 and v2447.AreaId and GuardAreas:FindFirstChild(v2447.AreaId)
				Guard = AreaId and AreaId:FindFirstChild("Guard")
			end)
			return Guard
		end
		t95._skips = function(p685, p686)
			local __S2rHubEggRuntime = genv.__S2rHubEggRuntime
			if __S2rHubEggRuntime then
				if __S2rHubEggRuntime.instantPhase == "priming" then
					return true
				end
				if __S2rHubEggRuntime.enabled or __S2rHubEggRuntime.running then
					return true
				end
			end
			local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
			if __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
				return true
			end
			if not p686 then
				return false
			end
			local v2454 = p685:_record(p686)
			return v2454 ~= nil and tostring(v2454.AreaId) == "Forest"
		end
		t95._freeze = function(p687, p688)
			local v2455 = p687:_character()
			local Humanoid = v2455 and v2455:FindFirstChildOfClass("Humanoid")
			local CurrentCamera = workspace.CurrentCamera
			local CFrame_2 = CurrentCamera and CurrentCamera.CFrame
			local CameraType = CurrentCamera and CurrentCamera.CameraType
			local clone
			pcall(function()
				v2455.Archivable = true
				clone = v2455:Clone()
				if p688 then
					pcall(function()
						clone:PivotTo(p688)
					end)
				end
				clone.Name = "S2rHubAntiHitGhost"
				for _, descendant in ipairs(clone:GetDescendants()) do
					if descendant:IsA("LuaSourceContainer") or descendant:IsA("Sound") then
						descendant:Destroy()
					elseif descendant:IsA("BasePart") then
						descendant.CanCollide = false
						descendant.Anchored = true
					end
				end
				clone.Parent = workspace
				for _, descendant in ipairs(v2455:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						descendant.LocalTransparencyModifier = 1
					end
					if descendant:IsA("Trail") then
						descendant.Enabled = false
					end
				end
				if CurrentCamera then
					CurrentCamera.CameraType = Enum.CameraType.Scriptable
					CurrentCamera.CFrame = CFrame_2
				end
			end)
			local t96 = {}
			pcall(function()
				for _, descendant in ipairs(v2455:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						t96[#t96 + 1] = descendant
					end
				end
			end)
			local function v2468()
				if CurrentCamera then
					CurrentCamera.CameraType = Enum.CameraType.Scriptable
					CurrentCamera.CFrame = CFrame_2
				end
				for _, v in ipairs(t96) do
					if v.Parent then
						v.LocalTransparencyModifier = 1
					end
				end
			end
			local function v2471(p689)
				pcall(function()
					if clone then
						clone:Destroy()
					end
					for _, descendant in ipairs(v2455:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.LocalTransparencyModifier = 0
						end
						if descendant:IsA("Trail") then
							descendant.Enabled = true
						end
					end
					if CurrentCamera then
						CurrentCamera.CameraType = CameraType ~= Enum.CameraType.Scriptable and CameraType or Enum.CameraType.Custom
						if Humanoid then
							CurrentCamera.CameraSubject = Humanoid
						end
						if p689 then
							CurrentCamera.CFrame = CFrame_2
						end
					end
				end)
			end
			return v2471, v2468
		end
		t95.shield = function(p690, p691)
			if not p690.enabled or p690.running then
				return false
			end
			if p690:_skips(p691) then
				return false
			end
			local v2474 = p690:_root()
			if not v2474 then
				return false
			end
			p690.running = true
			local CFrame_2 = v2474.CFrame
			local v2476 = p690:_guardFor(p691)
			local function v2477()
				local v2478 = p690:_root()
				if not v2478 then
					return false
				end
				v2478.CFrame = cFrame
				v2478.AssemblyLinearVelocity = Vector3.zero
				v2478.AssemblyAngularVelocity = Vector3.zero
				return true
			end
			v2477()
			local v2479, v2480 = p690:_freeze(CFrame_2)
			local n46 = 1
			local u2482 = false
			pcall(function()
				local now = os.clock()
				local v2484 = false
				while (os.clock() - now < 0.9 or v2484 and os.clock() - now < 1.6 and v2476 and (v2476:GetAttribute("GuardState") == "Waking" or v2476:GetAttribute("GuardState") == "Chasing")) and v2477() do
					v2480()
					n46 += 1
					local attribute = v2476 and v2476:GetAttribute("GuardState")
					if attribute == "Waking" or attribute == "Chasing" then
						v2484 = true
						RunService2.Heartbeat:Wait()
					elseif v2484 and attribute == "Sleeping" and os.clock() - now > 0.2 then
						u2482 = true
						break
					else
						RunService2.Heartbeat:Wait()
					end
				end
			end)
			v2479(true)
			p690.lastResult = (u2482 and "Guard slept" or "Held") .. " (" .. n46 .. " writes)"
			p690.running = false
			return true
		end
		t95._check = function(p692, p693)
			if not p692.enabled then
				p692.wasHolding = false
				return
			end
			local Uid
			if type(p693) == "table" and p693.IsCarrying and p693.Uid then
				Uid = p693.Uid
			else
				Uid = p692:_carriedUid()
			end
			local wasHolding = Uid ~= nil
			if wasHolding and not p692.wasHolding and not p692.running and not p692:_skips(Uid) then
				task.spawn(function()
					pcall(function()
						p692:shield(Uid)
					end)
				end)
			end
			p692.wasHolding = wasHolding
		end
		t95.setEnabled = function(p694, p695)
			p694.enabled = p695 == true
			if p694.enabled then
				p694.wasHolding = p694:_carriedUid() ~= nil
			end
			if not p694.watcher then
				p694.watcher = true
				task.spawn(function()
					while not p694.destroyed do
						if not p694.enabled or p694.running then
							task.wait(0.5)
						else
							pcall(function()
								p694:_check()
							end)
							task.wait(0.15)
						end
					end
				end)
			end
			if p694.connection then
				return
			end
			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				if EggState2 and EggState2.CarryChanged then
					p694.connection = EggState2.CarryChanged:Connect(function(p696)
						task.defer(function()
							p694:_check(p696)
						end)
					end)
				end
			end)
		end
		t95.destroy = function(p697)
			p697.destroyed = true
			p697.enabled = false
			if p697.connection then
				pcall(function()
					p697.connection:Disconnect()
				end)
				p697.connection = nil
			end
		end
		return t95
	end
	local v2489 = v2429().new()
	genv.__S2rHubAntiHitGuard = v2489
	if s2rHubConfig.AntiHitGuard then
		v2489:setEnabled(true)
	end
	genv.__S2rHubPlayerSteal = v2374
end
do
	local t97 = {
		at = 0,
		value = false
	}
	genv.__S2rHubStealWantsCharacter = function()
		local __S2rHubPlayerSteal = genv.__S2rHubPlayerSteal
		if __S2rHubPlayerSteal and __S2rHubPlayerSteal.running then
			return true
		end
		local __S2rHubEggRuntime = genv.__S2rHubEggRuntime
		if not __S2rHubEggRuntime or not __S2rHubEggRuntime.enabled or __S2rHubEggRuntime.destroyed then
			return false
		end
		if __S2rHubEggRuntime.running or __S2rHubEggRuntime.activeTween and not __S2rHubEggRuntime.activeTween.sharedTravel or __S2rHubEggRuntime.carry and __S2rHubEggRuntime.carry.active then
			return true
		end
		local now = os.clock()
		if now - t97.at < 0.5 then
			return t97.value
		end
		t97.at = now
		local ok, result = pcall(function()
			return __S2rHubEggRuntime:_wallOpen() and __S2rHubEggRuntime:_chooseTarget() or nil
		end)
		t97.value = ok and result ~= nil
		return t97.value
	end
	genv.__S2rHubDronesWantCharacter = function()
		local __S2rHubButterflyRuntime = genv.__S2rHubButterflyRuntime
		return __S2rHubButterflyRuntime ~= nil and (__S2rHubButterflyRuntime.active == true or __S2rHubButterflyRuntime.wantsCharacter == true)
	end
end
v612:setStealMode(s2rHubConfig.StealMode == "Semi Teleport" and "Instant" or s2rHubConfig.StealMode)
v612:setSpeed(s2rHubConfig.TweenSpeedMultiplier or 60)
if s2rHubConfig.StealMinValue and s2rHubConfig.StealMinValue > 0 then
	v612:setMinValuePerSec(s2rHubConfig.StealMinValue)
end
if s2rHubConfig.StealAreas and not table.find(s2rHubConfig.StealAreas, "None") and #s2rHubConfig.StealAreas > 0 then
	local t98 = {}
	for _, stealArea in ipairs(s2rHubConfig.StealAreas) do
		if stealArea ~= "None" then
			table.insert(t98, stealArea)
		end
	end
	v612:setFilter("areas", t98)
	v612:setFilterEnabled("area", #t98 > 0)
end
if s2rHubConfig.StealRarities and not table.find(s2rHubConfig.StealRarities, "None") and #s2rHubConfig.StealRarities > 0 then
	local t99 = {}
	for _, stealRarity in ipairs(s2rHubConfig.StealRarities) do
		if stealRarity ~= "None" then
			table.insert(t99, stealRarity)
		end
	end
	v612:setFilter("rarities", t99)
	v612:setFilterEnabled("rarity", #t99 > 0)
end
if s2rHubConfig.StealNamesFilter and not table.find(s2rHubConfig.StealNamesFilter, "None") and #s2rHubConfig.StealNamesFilter > 0 then
	local t100 = {}
	for _, v in ipairs(s2rHubConfig.StealNamesFilter) do
		if v ~= "None" then
			table.insert(t100, v)
		end
	end
	v612:setFilter("names", t100)
	v612:setFilterEnabled("name", #t100 > 0)
end
do
	genv.__S2rHubEggRuntimeCleanup = function()
		if v612 then
			pcall(v612.destroy, v612)
		end
		if v613 then
			pcall(v613.destroy, v613)
		end
		if genv.__S2rHubEggRuntime == v612 then
			genv.__S2rHubEggRuntime = nil
		end
		if genv.__S2rHubTreadmillManager == v613 then
			genv.__S2rHubTreadmillManager = nil
		end
	end
	genv.__S2rHubAntiGuardCleanup = function()
		if v614 then
			pcall(v614.destroy, v614)
		end
		if v615 then
			pcall(v615.destroy, v615)
		end
		if genv.__S2rHubAntiGuard == v614 then
			genv.__S2rHubAntiGuard = nil
		end
		if genv.__S2rHubGodMode == v615 then
			genv.__S2rHubGodMode = nil
		end
	end
end
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local function safeRequire(getter)
	local ok, result = pcall(function()
		return require(getter())
	end)
	return ok and result or nil
end
local networkingFolder = nil
do
    local ok, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 8):WaitForChild("Networking", 8)
    end)
    networkingFolder = ok and result or nil
end
local EggState   = safeRequire(function() return ReplicatedStorage.Client.EggState end)
local Assets     = safeRequire(function() return ReplicatedStorage.Data.Assets end)
local Mutations  = safeRequire(function() return ReplicatedStorage.Shared.Modules.Mutations end)
local function remote(name)
    if not networkingFolder then return nil end
    return networkingFolder:FindFirstChild(name)
end
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
-- S2rHub / Obsidian Violet design system
local WHITE = Color3.fromRGB(247, 243, 255)
local SILVER = Color3.fromRGB(185, 173, 208)
local STEEL = Color3.fromRGB(130, 112, 159)
local BG = Color3.fromRGB(11, 9, 19)
local SURFACE = Color3.fromRGB(21, 17, 34)
local RAISED = Color3.fromRGB(31, 24, 49)
local ACCENT = Color3.fromRGB(157, 92, 255)
local ACCENT_DARK = Color3.fromRGB(105, 51, 187)
local BORDER = Color3.fromRGB(70, 50, 103)
local COMMUNITY_URL = "https://discord.gg/H7vmT7cqM"
local RARITY_COLORS = {
	Color3.fromRGB(190, 190, 190), Color3.fromRGB(110, 210, 110), Color3.fromRGB(90, 160, 255),
	Color3.fromRGB(190, 110, 255), Color3.fromRGB(255, 170, 50), Color3.fromRGB(255, 80, 80),
	Color3.fromRGB(255, 90, 200), Color3.fromRGB(80, 235, 235),
}
local function parentGui()
	if typeof(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and typeof(result) == "Instance" then
			return result
		end
	end
	if typeof(getnilinstances) == "function" then
		local ok, list = pcall(getnilinstances)
		if ok and list then
			for _, v in ipairs(list) do
				if typeof(v) == "Instance" and v:IsA("CoreGui") then
					return v
				end
			end
		end
	end
	if CoreGui then
		return CoreGui
	end
	local ok2, cg = pcall(game.GetService, game, "CoreGui")
	if ok2 and cg then
		return cg
	end
	local lp = game:GetService("Players").LocalPlayer
	local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5))
	if pg then
		return pg
	end
	return game:GetService("Players").LocalPlayer.PlayerGui
end
local function make(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	return inst
end
local function corner(parent, radius)
	make("UICorner", { CornerRadius = UDim.new(0, radius or 6) }).Parent = parent
end
local living = {}
local function bands(a, b)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(0.25, b), ColorSequenceKeypoint.new(0.5, a),
		ColorSequenceKeypoint.new(0.75, b), ColorSequenceKeypoint.new(1, a),
	})
end
local function livingStroke(parent, thickness, bright)
    local s = make("UIStroke", {
        Thickness = thickness or 1,
        Color = bright and ACCENT or BORDER,
        Transparency = bright and 0.12 or 0.35,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    s.Parent = parent
    return s
end
local function livingText(label)
    local g = make("UIGradient", {
        Color = ColorSequence.new(WHITE, Color3.fromRGB(205, 168, 255)),
        Rotation = 0,
    })
    g.Parent = label
    return g
end
local function text(parent, props)
    local alive = props.Living == true
    props.Living = nil
    props.BackgroundTransparency = 1
    props.TextColor3 = props.TextColor3 or WHITE
    local l = make("TextLabel", props)
    l.Parent = parent
    if alive then livingText(l) end
    return l
end

local function animateButton(button, baseColor, hoverColor)
    local tweenService = game:GetService("TweenService")
    local settings = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    button:SetAttribute("S2rHubRestColor",baseColor)
    button.MouseEnter:Connect(function()
        if button.Parent then tweenService:Create(button, settings, {BackgroundColor3=hoverColor}):Play() end
    end)
    button.MouseLeave:Connect(function()
        if button.Parent then
            local resting=button:GetAttribute("S2rHubRestColor") or baseColor
            tweenService:Create(button, settings, {BackgroundColor3=resting}):Play()
        end
    end)
end

local Rarities = {
    { name="Common",    color=RARITY_COLORS[1] },
    { name="Uncommon",  color=RARITY_COLORS[2] },
    { name="Rare",      color=RARITY_COLORS[3] },
    { name="Epic",      color=RARITY_COLORS[4] },
    { name="Legendary", color=RARITY_COLORS[5] },
    { name="Mythic",    color=RARITY_COLORS[6] },
    { name="Cosmic",    color=RARITY_COLORS[7] },
    { name="Secret",    color=RARITY_COLORS[8] },
}

local NumToStr = {
    [1]="Common",[2]="Uncommon",[3]="Rare",[4]="Epic",
    [5]="Legendary",[6]="Mythic",[7]="Cosmic",[8]="Secret",
    [9]="Eternal",[10]="Divine",
}

local rarityChosen = {}

local function anyRarityChosen()
    for _,v in pairs(rarityChosen) do if v then return true end end
    return false
end

local function rarityPasses(rarStr)
    return not anyRarityChosen() or rarityChosen[rarStr]==true
end

local function applyFilter()
    if not v612 then return end
    if anyRarityChosen() then
        local list={}
        for _,r in ipairs(Rarities) do
            if rarityChosen[r.name] then table.insert(list,r.name) end
        end
        v612:setFilter("rarities",list)
        v612:setFilterEnabled("rarity",true)
        s2rHubConfig.StealRarities=list
    else
        v612:setFilter("rarities",{})
        v612:setFilterEnabled("rarity",false)
        s2rHubConfig.StealRarities={"None"}
    end
    v612:setFilter("names",{})
    v612:setFilterEnabled("name",false)
    s2rHubConfig.StealNamesFilter={"None"}
end

local function hasTargetEggs()
    for _,record in ipairs(snapshot()) do
        local info=describe(record)
        local rarStr=NumToStr[info.Rarity] or "Common"
        if rarityPasses(rarStr) then return true end
    end
    return false
end

local function getDelivered()
    if v612 and v612.stats then return v612.stats.delivered or 0 end
    return 0
end

if v612 then v612:setStealMode("Instant") end

local guiParent = parentGui()
if guiParent then
    local old = guiParent:FindFirstChild("S2rHub")
    if old then old:Destroy() end
else
    warn("[S2rHub] parentGui() returned nil — GUI may not render")
end

-- Larger touch targets, responsive scaling, clear hierarchy, and no flashing/glow.
local GuiW, GuiH, HeaderH, TabH = 348, 490, 70, 42
local gui=make("ScreenGui",{
    Name="S2rHub", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, IgnoreGuiInset=true,
    DisplayOrder=30,
})
if guiParent then
    gui.Parent=guiParent
else
    gui.Parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local window=make("Frame",{
    Name="S2rHubWindow",
    AnchorPoint=Vector2.new(0.5,0.5),
    Size=UDim2.fromOffset(GuiW,GuiH),
    Position=UDim2.fromScale(0.5,0.5),
    BackgroundColor3=BG,BorderSizePixel=0,ClipsDescendants=false,
})
window.Parent=gui
corner(window,18)
livingStroke(window,1.5,true)

-- Fit smaller phone displays without shrinking desktop UI unnecessarily.
local uiScale=make("UIScale",{Scale=1})
uiScale.Parent=window
local function fitToViewport()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local viewport=camera.ViewportSize
    uiScale.Scale=math.clamp(math.min((viewport.X-24)/GuiW,(viewport.Y-50)/GuiH),0.58,1)
end
fitToViewport()
local cameraForScale=workspace.CurrentCamera
local viewportConn=cameraForScale and cameraForScale:GetPropertyChangedSignal("ViewportSize"):Connect(fitToViewport)

local header=make("Frame",{
    Name="BrandHeader",
    Size=UDim2.new(1,-20,0,54),Position=UDim2.fromOffset(10,9),
    BackgroundColor3=SURFACE,BorderSizePixel=0,
})
header.Parent=window
corner(header,12)

local logo=make("Frame",{
    Name="S2rHubMonogram",
    Size=UDim2.fromOffset(38,38),Position=UDim2.fromOffset(9,8),
    BackgroundColor3=ACCENT,BorderSizePixel=0,
})
logo.Parent=header
corner(logo,11)
make("UIGradient",{
    Color=ColorSequence.new(ACCENT,ACCENT_DARK),Rotation=125,
}).Parent=logo
text(logo,{
    Name="MonogramText",Size=UDim2.fromScale(1,1),
    Font=Enum.Font.GothamBlack,TextSize=21,Text="S",
    TextColor3=WHITE,Living=false,
})
text(header,{
    Name="BrandTitle", Size=UDim2.new(1,-151,0,24),Position=UDim2.fromOffset(56,6),
    Font=Enum.Font.GothamBlack,TextSize=19,
    TextXAlignment=Enum.TextXAlignment.Left,
    Text="S2rHub",Living=false,
})
text(header,{
    Name="BrandSubtitle", Size=UDim2.new(1,-151,0,14),Position=UDim2.fromOffset(57,30),
    Font=Enum.Font.GothamMedium,TextSize=9,
    TextColor3=SILVER,TextXAlignment=Enum.TextXAlignment.Left,
    Text="STEAL AN EGG  /  CONTROL PANEL",Living=false,
})
local function makeHeaderBtn(label, xOff)
    local b=make("TextButton",{
        Size=UDim2.fromOffset(27,27),Position=UDim2.new(1,xOff,0.5,-14),
        BackgroundColor3=RAISED,Font=Enum.Font.GothamBold,TextSize=14,
        TextColor3=WHITE,Text=label,AutoButtonColor=false,
    })
    b.Parent=header
    corner(b,8)
    livingStroke(b,1,false)
    animateButton(b,RAISED,ACCENT_DARK)
    return b
end
local minimizeBtn=makeHeaderBtn("−",-67)
local closeBtn=makeHeaderBtn("×",-35)

local tabBar=make("Frame",{
    Name="Navigation",Size=UDim2.new(1,-24,0,34),
    Position=UDim2.fromOffset(12,HeaderH+3),
    BackgroundColor3=SURFACE,BorderSizePixel=0,
})
tabBar.Parent=window
corner(tabBar,10)
make("UIListLayout",{
    FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),
    SortOrder=Enum.SortOrder.LayoutOrder,
}).Parent=tabBar
make("UIPadding",{
    PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),
    PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),
}).Parent=tabBar

local activeTab,tabFrames=nil,{}
local function makeTabBtn(label,order)
    local b=make("TextButton",{
        Size=UDim2.new(0.5,-4,1,0),BackgroundColor3=SURFACE,
        Font=Enum.Font.GothamBold,TextSize=12,TextColor3=SILVER,
        Text=label,AutoButtonColor=false,LayoutOrder=order,
    })
    b.Parent=tabBar
    corner(b,7)
    return b
end
local eggsTabBtn=makeTabBtn("EGGS",1)
local autoTabBtn=makeTabBtn("AUTOMATION",2)

local bodyTop=HeaderH+TabH+6
local body=make("Frame",{
    Name="Content",Size=UDim2.new(1,-28,1,-(bodyTop+56)),
    Position=UDim2.fromOffset(14,bodyTop),
    BackgroundTransparency=1,
})
body.Parent=window

local footer=make("Frame",{
    Name="StatusFooter",Size=UDim2.new(1,-24,0,38),
    Position=UDim2.new(0,12,1,-48),
    BackgroundColor3=SURFACE,BorderSizePixel=0,
})
footer.Parent=window
corner(footer,10)
local statusDot=make("Frame",{
    Size=UDim2.fromOffset(7,7),Position=UDim2.fromOffset(10,16),
    BackgroundColor3=ACCENT,BorderSizePixel=0,
})
statusDot.Parent=footer
corner(statusDot,4)
local statusLabel=text(footer,{
    Size=UDim2.new(1,-128,1,0),Position=UDim2.fromOffset(23,0),
    Font=Enum.Font.GothamMedium,TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextTruncate=Enum.TextTruncate.AtEnd,Text="Ready • Select an egg",Living=false,
})
local function setStatus(msg) statusLabel.Text=tostring(msg) end
local discordBtn=make("TextButton",{
    Name="CopyDiscord",Size=UDim2.fromOffset(108,26),
    Position=UDim2.new(1,-113,0.5,-13),
    BackgroundColor3=RAISED,BorderSizePixel=0,
    Font=Enum.Font.GothamBold,TextSize=9,Text="COPY DISCORD",
    TextColor3=WHITE,AutoButtonColor=false,
})
discordBtn.Parent=footer
corner(discordBtn,7)
livingStroke(discordBtn,1,true)
animateButton(discordBtn,RAISED,ACCENT_DARK)
discordBtn.MouseButton1Click:Connect(function()
    local clipboardFn=setclipboard or toclipboard or (type(Clipboard)=="table" and Clipboard.set)
    if type(clipboardFn)=="function" then
        local ok=pcall(clipboardFn,COMMUNITY_URL)
        setStatus(ok and "Discord invite copied" or "Unable to copy invite")
    else
        setStatus("Invite: discord.gg/H7vmT7cqM")
    end
end)

local function makeBigBtn(parent,label,pos,sz)
    local primary=(label=="Steal")
    local baseColor=primary and ACCENT or RAISED
    local b=make("TextButton",{
        Size=sz,Position=pos,BackgroundColor3=baseColor,BorderSizePixel=0,
        Font=Enum.Font.GothamBlack,TextSize=13,
        TextColor3=WHITE,Text=label,AutoButtonColor=false,
    })
    b.Parent=parent
    corner(b,10)
    livingStroke(b,1,primary)
    animateButton(b,baseColor,primary and ACCENT_DARK or Color3.fromRGB(45,34,69))
    return b
end

local eggsFrame=make("Frame",{
    Name="EggsPage",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
})
eggsFrame.Parent=body
tabFrames["Eggs"]=eggsFrame

text(eggsFrame,{
    Size=UDim2.new(1,0,0,16),Position=UDim2.fromOffset(2,0),
    Font=Enum.Font.GothamBold,TextSize=10,TextColor3=SILVER,
    TextXAlignment=Enum.TextXAlignment.Left,Text="TARGET EGG",Living=false,
})

local selectedUid,selectedRarity,selectedName,selectedCategory=nil,nil,nil,nil

local eggDropBtn=make("TextButton",{
    Size=UDim2.new(1,0,0,36),Position=UDim2.fromOffset(0,20),
    BackgroundColor3=RAISED,Font=Enum.Font.GothamBold,TextSize=11,
    TextColor3=SILVER,TextXAlignment=Enum.TextXAlignment.Left,
    Text="   Select an egg...",AutoButtonColor=true,
})
eggDropBtn.Parent=eggsFrame;corner(eggDropBtn,10);livingStroke(eggDropBtn,1,true)

local eggDropArrow=make("TextLabel",{
    Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-20,0.5,-9),
    BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=SILVER,Text="v",
})
eggDropArrow.Parent=eggDropBtn

local eggDropList=make("ScrollingFrame",{
    Size=UDim2.new(1,0,0,1),
    Position=UDim2.new(0,0,0,59),
    BackgroundColor3=SURFACE,BorderSizePixel=0,
    ScrollBarThickness=3,ScrollBarImageColor3=ACCENT,
    CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    Visible=false,ZIndex=20,ClipsDescendants=true,
})
eggDropList.Parent=eggsFrame;corner(eggDropList,8);livingStroke(eggDropList,1,false)
make("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder}).Parent=eggDropList
make("UIPadding",{PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3),PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,4)}).Parent=eggDropList

local dropOpen=false
local dropRows={}

local function closeEggDrop()
    dropOpen=false
    eggDropList.Visible=false
    eggDropArrow.Text="v"
end

local function populateDrop()
    for _,row in pairs(dropRows) do row:Destroy() end
    table.clear(dropRows)
    for i=#living,1,-1 do if not living[i].Parent then table.remove(living,i) end end

    local infos={}
    for _,record in ipairs(snapshot()) do
        local info=describe(record)
        info.Category=record.AssetCategory
        infos[#infos+1]=info
    end
    table.sort(infos,function(a,b) return a.Value>b.Value end)

    for idx,info in ipairs(infos) do
        local rarStr=NumToStr[info.Rarity] or "Common"
        local col=RARITY_COLORS[math.clamp(info.Rarity,1,#RARITY_COLORS)] or WHITE
        local isSelected=info.Uid==selectedUid

        local row=make("TextButton",{
            Size=UDim2.new(1,0,0,34),LayoutOrder=idx,
            BackgroundColor3=isSelected and ACCENT_DARK or RAISED,
            Text="",AutoButtonColor=true,ZIndex=21,
        })
        row.Parent=eggDropList;corner(row,6)
        if isSelected then
            local rs=make("UIStroke",{Thickness=1,Color=WHITE,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
            rs.Parent=row
        end

        make("ImageLabel",{
            Size=UDim2.fromOffset(26,26),Position=UDim2.fromOffset(4,4),
            BackgroundTransparency=1,Image=info.Icon,ScaleType=Enum.ScaleType.Fit,ZIndex=22,
        }).Parent=row

        local nameLabel=make("TextLabel",{
            Size=UDim2.new(1,-38,0,17),Position=UDim2.fromOffset(38,2),
            BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=10,
            TextColor3=col,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,Text=info.Name,ZIndex=22,
        })
        nameLabel.Parent=row

        local valLabel=make("TextLabel",{
            Size=UDim2.new(1,-38,0,13),Position=UDim2.fromOffset(38,19),
            BackgroundTransparency=1,Font=Enum.Font.GothamMedium,TextSize=9,
            TextColor3=SILVER,TextXAlignment=Enum.TextXAlignment.Left,
            Text=money(info.Value),ZIndex=22,
        })
        valLabel.Parent=row

        table.insert(dropRows,row)

        row.MouseButton1Click:Connect(function()
            selectedUid      = info.Uid
            selectedRarity   = rarStr
            selectedName     = info.Name
            selectedCategory = info.Category
            eggDropBtn.Text  = "  "..info.Name.."  ("..money(info.Value)..")"
            eggDropBtn.TextColor3 = col
            closeEggDrop()
            setStatus("Selected: "..info.Name)
        end)
    end

    if #infos==0 then
        local empty=make("TextLabel",{
            Size=UDim2.new(1,0,0,22),
            BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=9,
            TextColor3=STEEL,TextXAlignment=Enum.TextXAlignment.Center,
            Text="No eggs on field",ZIndex=22,
        })
        empty.Parent=eggDropList
        table.insert(dropRows,empty)
    end

    local maxH=math.min(#infos*36+6,170)
    eggDropList.Size=UDim2.new(1,0,0,maxH)
end

eggDropBtn.MouseButton1Click:Connect(function()
    if dropOpen then
        closeEggDrop()
    else
        populateDrop()
        eggDropList.Visible=true
        dropOpen=true
        eggDropArrow.Text="^"
    end
end)

local stealModeOptions={"Low Speed User","High Speed User","High Speed User (Fly)"}
local stealModeIndex=1

local function applyStealMode(label)
    if not v612 then return end
    local isInstant=not (label:find("High") or label:find("Fly"))
    local mode=isInstant and "Instant" or "Fly"
    local aerial=label:find("%(Fly%)")~=nil
    s2rHubConfig.StealMode=mode
    s2rHubConfig.FlyAerial=aerial
    v612:setStealMode(mode,aerial)
end

text(eggsFrame,{
    Size=UDim2.new(1,0,0,16),Position=UDim2.fromOffset(2,67),
    Font=Enum.Font.GothamBold,TextSize=10,TextColor3=SILVER,
    TextXAlignment=Enum.TextXAlignment.Left,Text="STEAL MODE",Living=false,
})
local modeDropBtn=make("TextButton",{
    Size=UDim2.new(1,0,0,36),Position=UDim2.fromOffset(0,87),
    BackgroundColor3=RAISED,Font=Enum.Font.GothamBold,TextSize=11,
    TextColor3=SILVER,TextXAlignment=Enum.TextXAlignment.Left,
    Text="   Mode: "..stealModeOptions[stealModeIndex],AutoButtonColor=true,
})
modeDropBtn.Parent=eggsFrame;corner(modeDropBtn,10);livingStroke(modeDropBtn,1,false)

local modeArrow=make("TextLabel",{
    Size=UDim2.fromOffset(16,16),Position=UDim2.new(1,-18,0.5,-8),
    BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=9,TextColor3=STEEL,Text="v",
})
modeArrow.Parent=modeDropBtn

local modeDropList=make("Frame",{
    Size=UDim2.new(1,0,0,#stealModeOptions*30+4),
    Position=UDim2.new(0,0,0,126),
    BackgroundColor3=SURFACE,BorderSizePixel=0,
    Visible=false,ZIndex=18,
})
modeDropList.Parent=eggsFrame;corner(modeDropList,6);livingStroke(modeDropList,1,false)
make("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder}).Parent=modeDropList
make("UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2)}).Parent=modeDropList

local modeOpen=false
for i,opt in ipairs(stealModeOptions) do
    local ob=make("TextButton",{
        Size=UDim2.new(1,0,0,28),LayoutOrder=i,
        BackgroundColor3=i==stealModeIndex and ACCENT_DARK or RAISED,
        Font=Enum.Font.GothamBold,TextSize=10,TextColor3=WHITE,
        TextXAlignment=Enum.TextXAlignment.Left,
        Text="  "..opt,AutoButtonColor=true,ZIndex=19,
    })
    ob.Parent=modeDropList;corner(ob,5)
    ob.MouseButton1Click:Connect(function()
        stealModeIndex=i
        modeDropBtn.Text="  Mode: "..opt
        modeDropList.Visible=false
        modeOpen=false
        modeArrow.Text="v"
        applyStealMode(opt)
    end)
end

modeDropBtn.MouseButton1Click:Connect(function()
    modeOpen=not modeOpen
    modeDropList.Visible=modeOpen
    modeArrow.Text=modeOpen and "^" or "v"
    if modeOpen then closeEggDrop() end
end)

applyStealMode(stealModeOptions[1])

local overviewCard=make("Frame",{
    Name="OverviewCard",Size=UDim2.new(1,0,0,62),
    Position=UDim2.fromOffset(0,214),BackgroundColor3=SURFACE,
    BorderSizePixel=0,
})
overviewCard.Parent=eggsFrame
corner(overviewCard,10)
livingStroke(overviewCard,1,false)
text(overviewCard,{
    Size=UDim2.new(0.6,-14,0,16),Position=UDim2.fromOffset(12,8),
    Font=Enum.Font.GothamBold,TextSize=9,TextColor3=SILVER,
    TextXAlignment=Enum.TextXAlignment.Left,Text="TOTAL DELIVERED",Living=false,
})
local deliveredValue=text(overviewCard,{
    Size=UDim2.new(0.55,-14,0,28),Position=UDim2.fromOffset(12,25),
    Font=Enum.Font.GothamBlack,TextSize=19,
    TextXAlignment=Enum.TextXAlignment.Left,Text="0",Living=false,
})
text(overviewCard,{
    Size=UDim2.new(0.4,-8,0,16),Position=UDim2.new(0.6,0,0,8),
    Font=Enum.Font.GothamBold,TextSize=9,TextColor3=SILVER,
    TextXAlignment=Enum.TextXAlignment.Left,Text="SYSTEM STATUS",Living=false,
})
local systemValue=text(overviewCard,{
    Size=UDim2.new(0.4,-8,0,26),Position=UDim2.new(0.6,0,0,27),
    Font=Enum.Font.GothamBold,TextSize=11,TextColor3=ACCENT,
    TextXAlignment=Enum.TextXAlignment.Left,Text="READY",Living=false,
})

task.spawn(function()
    while gui.Parent do
        deliveredValue.Text=tostring(getDelivered())
        systemValue.Text=s2rHubConfig.AutoSteal and "RUNNING" or "READY"
        task.wait(0.6)
    end
end)

local refreshBtn=makeBigBtn(eggsFrame,"REFRESH",UDim2.new(0,0,1,-42),UDim2.new(0.38,-4,0,42))
local stealBtn  =makeBigBtn(eggsFrame,"Steal",  UDim2.new(0.38,4,1,-42),UDim2.new(0.62,-4,0,42))

refreshBtn.MouseButton1Click:Connect(function()
    populateDrop()
    if not dropOpen then
        eggDropList.Visible=true
        dropOpen=true
        eggDropArrow.Text="^"
    end
end)

local manualActive=false

stealBtn.MouseButton1Click:Connect(function()
    if not v612 then setStatus("Engine not ready") return end

    if manualActive or s2rHubConfig.AutoSteal then
        manualActive=false
        s2rHubConfig.AutoSteal=false
        v612:setEnabled(false)
        v612:setFilter("names",{})
        v612:setFilterEnabled("name",false)
        s2rHubConfig.StealNamesFilter={"None"}
        applyFilter()
        setStatus("Stopped")
        return
    end

    if not selectedUid then setStatus("Select an egg first") return end
    closeEggDrop()

    local nameList={}
    if selectedName     then table.insert(nameList,selectedName)     end
    if selectedCategory then table.insert(nameList,selectedCategory) end

    if #nameList>0 then
        v612:setFilter("names",nameList)
        v612:setFilterEnabled("name",true)
        s2rHubConfig.StealNamesFilter=nameList
    end
    if selectedRarity and anyRarityChosen() then
        v612:setFilter("rarities",{selectedRarity})
        v612:setFilterEnabled("rarity",true)
        s2rHubConfig.StealRarities={selectedRarity}
    else
        v612:setFilter("rarities",{})
        v612:setFilterEnabled("rarity",false)
        s2rHubConfig.StealRarities={"None"}
    end

    local before=getDelivered()
    manualActive=true
    s2rHubConfig.AutoSteal=true
    v612:setEnabled(true)
    setStatus("Stealing \226\134\146 "..(selectedName or "?"))

    task.spawn(function()
        local w=0
        while manualActive and not (v612 and v612.running) and w<10 do
            w+=task.wait(0.2)
        end
        w=0
        while manualActive and w<45 do
            if getDelivered()>before then break end
            w+=task.wait(0.2)
        end
        if manualActive then
            manualActive=false
            s2rHubConfig.AutoSteal=false
            if v612 then v612:setEnabled(false) end
            v612:setFilter("names",{})
            v612:setFilterEnabled("name",false)
            s2rHubConfig.StealNamesFilter={"None"}
            applyFilter()
            local done=getDelivered()>before
            setStatus(done and "Delivered!" or "Timed out")
        end
    end)
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.3)
        stealBtn.Text=(manualActive or s2rHubConfig.AutoSteal) and "Cancel" or "Steal"
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(4)
        if activeTab=="Eggs" and not s2rHubConfig.AutoSteal and not manualActive and body.Visible then
            populateDrop()
        end
    end
end)

local autoFrame=make("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false})
autoFrame.Parent=body;tabFrames["Auto"]=autoFrame

local function makeToggleBtn(parent,off,on,yPos,onEnable,onDisable)
    local state=false
    local btn=makeBigBtn(parent,"●  "..off,UDim2.fromOffset(0,yPos),UDim2.new(1,0,0,31))
    btn.BackgroundColor3=RAISED
    btn.TextSize=11
    btn.MouseButton1Click:Connect(function()
        state=not state
        if state then
            btn.Text="●  "..on
            btn.BackgroundColor3=ACCENT_DARK
            btn:SetAttribute("S2rHubRestColor",ACCENT_DARK)
            onEnable()
        else
            btn.Text="●  "..off
            btn.BackgroundColor3=RAISED
            btn:SetAttribute("S2rHubRestColor",RAISED)
            onDisable()
        end
    end)
    return btn,function() return state end
end

local loopThread=nil

local function loopStop()
    loopThread=nil
    s2rHubConfig.AutoSteal=false
    if v612 then v612:setEnabled(false) end
    setStatus("Loop stopped")
end

local function loopStart()
    if loopThread then return end
    applyFilter()
    v612:setStealMode("Instant")
    s2rHubConfig.AutoSteal=true
    v612:setEnabled(true)
    local mine
    mine=task.spawn(function()
        while mine==loopThread and gui.Parent and s2rHubConfig.AutoSteal do
            local infos={}
            for _,record in ipairs(snapshot()) do
                local info=describe(record)
                local rarStr=NumToStr[info.Rarity] or "Common"
                if rarityPasses(rarStr) then infos[#infos+1]=info end
            end
            table.sort(infos,function(a,b) return a.Value>b.Value end)
            if #infos>0 then
                local best=infos[1]
                setStatus("Loop \226\134\146 "..best.Name.."  "..money(best.Value))
            else
                setStatus("Loop: no matching eggs")
            end
            task.wait(2)
        end
    end)
    loopThread=mine
end

local loopBtn,getLoopOn=makeToggleBtn(autoFrame,"Loop OFF","Loop ON",0,loopStart,loopStop)

local treadmillBtn,getTreadOn=makeToggleBtn(autoFrame,"Treadmill OFF","Treadmill ON",35,
    function()
        if v613 then v613:setIdleFarm(true) end
        setStatus("Treadmill ON")
    end,
    function()
        if v613 then v613:setIdleFarm(false) end
        setStatus("Treadmill OFF")
    end
)

local hatchOn=false
local function hatchLoop()
    if s2rHubConfig.IsAutoHatchWorkerRunning then return end
    s2rHubConfig.IsAutoHatchWorkerRunning=true
    local cooldown={}
    task.spawn(function()
        while hatchOn and gui.Parent do
            task.wait(1.5)
            pcall(function()
                if s2rHubConfig.IsStealing then return end
                local records=EggState.GetOwnerRuntimeRecords(LocalPlayer.UserId)
                if not records then return end
                local placed={}
                for uid,rec in pairs(records) do
                    if rec.Placement~=nil then table.insert(placed,uid) end
                end
                local now=os.time()
                for _,uid in ipairs(placed) do
                    if not hatchOn then break end
                    if cooldown[uid] and now<cooldown[uid] then continue end
                    local rec=records[uid]
                    local isReady=false
                    if type(EggState.IsReadyToHatch)=="function" then
                        local ok,res=pcall(EggState.IsReadyToHatch,uid)
                        isReady=ok and res==true
                    end
                    if isReady or (rec and rec.Ready==true) or not cooldown[uid] then
                        if EggState.RequestHatchEgg(uid) then
                            EggState.RequestCompleteHatchEgg(uid)
                            cooldown[uid]=nil
                            task.wait(0.1)
                        else
                            cooldown[uid]=now+10
                        end
                    end
                end
            end)
        end
        s2rHubConfig.IsAutoHatchWorkerRunning=false
    end)
end

local hatchBtn,getHatchOn=makeToggleBtn(autoFrame,"Hatch OFF","Hatch ON",70,
    function() hatchOn=true ; task.spawn(hatchLoop) ; setStatus("Auto Hatch ON") end,
    function() hatchOn=false ; setStatus("Auto Hatch OFF") end
)

local placeOn=false
local function placeLoop()
    if s2rHubConfig.IsAutoPlaceWorkerRunning then return end
    s2rHubConfig.IsAutoPlaceWorkerRunning=true
    while placeOn and gui.Parent do
        task.wait(1.5)
        local ok,_=pcall(function()
            if s2rHubConfig.IsStealing then return end
            local stealWants=genv.__S2rHubStealWantsCharacter
            if stealWants and stealWants() then return end

            local plot=nil
            local Plots=workspace:FindFirstChild("Plots")
            if Plots then
                for _,p in ipairs(Plots:GetChildren()) do
                    local sign=p:FindFirstChild("PlotSign")
                    local playerSign=sign and sign:FindFirstChild("PlayerPlotSign")
                    local frame=playerSign and playerSign:FindFirstChild("Frame")
                    local nameLabel=frame and frame:FindFirstChild("PlayerName")
                    if nameLabel then
                        local stripped=string.gsub(nameLabel.Text,"<[^>]+>","")
                        if string.find(string.lower(stripped),string.lower(LocalPlayer.Name))
                        or string.find(string.lower(stripped),string.lower(LocalPlayer.DisplayName)) then
                            plot=p ; break
                        end
                    end
                end
            end
            if not plot then return end

            local ToUpdate=plot:FindFirstChild("ToUpdate")
            local PetArea=ToUpdate and ToUpdate:FindFirstChild("PetArea")
            local CenterPoint=plot:FindFirstChild("CenterPoint") or PetArea
            if not PetArea then return end

            local records=EggState.GetOwnerRuntimeRecords(LocalPlayer.UserId)
            if type(records)~="table" then return end

            local placed,unplaced,placedPositions=0,{},{}
            for uid,rec in pairs(records) do
                if rec.Placement==nil then
                    local assetData=Assets and Assets.Directory and Assets.Directory[rec.AssetCategory]
                    local kg=tonumber(rec.Kg) or tonumber(rec.Weight)
                       or (assetData and (tonumber(assetData.Kg) or tonumber(assetData.Weight))) or 0
                    table.insert(unplaced,{Uid=uid,Kg=kg})
                else
                    placed+=1
                    local pos
                    if typeof(rec.Placement)=="CFrame" then pos=rec.Placement.Position
                    elseif typeof(rec.Placement)=="Vector3" then pos=rec.Placement
                    elseif type(rec.Placement)=="table" then pos=rec.Placement.Position end
                    if pos then table.insert(placedPositions,pos) end
                end
            end

            if #unplaced==0 or placed>=50 then return end
            table.sort(unplaced,function(a,b) return a.Kg>b.Kg end)

            if s2rHubConfig.IsStealing then return end
            s2rHubConfig.IsPlacing=true

            local tmgr=genv.__S2rHubTreadmillManager
            if tmgr and tmgr.activeTreadmill~=nil then
                local deadline=os.clock()+5
                while tmgr.activeTreadmill~=nil and os.clock()<deadline do
                    pcall(function() tmgr:_requestUnequip() end)
                    task.wait(0.3)
                end
            end

            local char=LocalPlayer.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local humanoid=char and char:FindFirstChildOfClass("Humanoid")
            local originCF=root and root.CFrame

            local function shouldAbort()
                return not placeOn or s2rHubConfig.IsStealing
                    or (stealWants and stealWants())
            end

            if root and humanoid then
                if not shouldAbort() then
                    v232(root,humanoid,
                        cFrameNew(518.66,70.57,-364.73)*Angles(math.pi,-1.5677,math.pi),
                        shouldAbort)
                end
                if not shouldAbort() then
                    v232(root,humanoid,PetArea.CFrame*cFrameNew(0,3,0),shouldAbort)
                end
                local w=0
                while w<0.5 and not shouldAbort() do task.wait(0.05);w+=0.05 end
            end

            local slotIdx,full=0,false
            for _,item in ipairs(unplaced) do
                if full or not placeOn or placed>=50 then break end
                if shouldAbort() then break end
                if not EggState.RequestEquipTool(item.Uid) then continue end
                if shouldAbort() then break end
                task.wait(0.15)

                local slotCF=nil
                if CenterPoint then
                    local areaX=PetArea.Size.X-6
                    local step=areaX/10
                    while slotIdx<30 do
                        local sx=-(areaX/2)+step/2+slotIdx%10*step
                        local sz=-(PetArea.Size.Z-6)/2+3+math.floor(slotIdx/10)*6
                        local obj=CenterPoint.CFrame:PointToObjectSpace(PetArea.CFrame*Vector3.new(sx,0,sz))
                        local candidate=cFrameNew(obj.X,-0.5,obj.Z)
                        local taken=false
                        for _,pos in ipairs(placedPositions) do
                            if (pos-candidate.Position).Magnitude<1 then taken=true;break end
                        end
                        if not taken then slotCF=candidate;break end
                        slotIdx+=1
                    end
                end

                if not slotCF then full=true;break end
                if shouldAbort() then break end

                local success,msg=EggState.RequestPlaceEgg(item.Uid,slotCF)
                if success then
                    table.insert(placedPositions,slotCF.Position)
                    placed+=1;task.wait(0.15)
                else
                    local m=string.lower(tostring(msg or ""))
                    if m:find("full") or m:find("limit") or m:find("capacity") or m:find("maximum") then
                        full=true;break
                    end
                    slotIdx+=1;task.wait(0.1)
                end
            end

            if originCF and root and humanoid and not shouldAbort() then
                v232(root,humanoid,
                    cFrameNew(518.66,70.57,-364.73)*Angles(math.pi,-1.5677,math.pi),shouldAbort)
                if not shouldAbort() then
                    v232(root,humanoid,originCF,shouldAbort)
                end
            end
            s2rHubConfig.IsPlacing=false
        end)
        if not ok then s2rHubConfig.IsPlacing=false end
    end
    s2rHubConfig.IsAutoPlaceWorkerRunning=false
end

local placeBtn,getPlaceOn=makeToggleBtn(autoFrame,"Place OFF","Place ON",105,
    function() placeOn=true ; task.spawn(placeLoop) ; setStatus("Auto Place ON") end,
    function() placeOn=false ; setStatus("Auto Place OFF") end
)

text(autoFrame,{
    Size=UDim2.new(1,0,0,16),Position=UDim2.fromOffset(1,145),
    Font=Enum.Font.GothamBold,TextSize=10,TextColor3=SILVER,
    TextXAlignment=Enum.TextXAlignment.Left,
    Text="RARITY FILTER   (none = steal all)",Living=false,
})

local chipW,chipH,chipPad=155,23,6
local chipFns={}

for i,rarity in ipairs(Rarities) do
    local col=(i-1)%2
    local row=math.floor((i-1)/2)
    local xOff=col*(chipW+chipPad)
    local yOff=164+row*(chipH+4)
    local col3=rarity.color or WHITE

    local chip=make("TextButton",{
        Size=UDim2.fromOffset(chipW,chipH),Position=UDim2.fromOffset(xOff,yOff),
        BackgroundColor3=SURFACE,
        Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=col3,Text=rarity.name,AutoButtonColor=false,
    })
    chip.Parent=autoFrame;corner(chip,8)
    make("UIStroke",{Thickness=0.8,Color=col3,ApplyStrokeMode=Enum.ApplyStrokeMode.Border}).Parent=chip

    local function refreshChip()
        if rarityChosen[rarity.name] then
            chip.BackgroundColor3=Color3.new(col3.R*0.3,col3.G*0.3,col3.B*0.3)
            chip.TextColor3=WHITE
        else
            chip.BackgroundColor3=SURFACE
            chip.TextColor3=col3
        end
    end
    chip.MouseButton1Click:Connect(function()
        rarityChosen[rarity.name]=not rarityChosen[rarity.name]
        refreshChip()
        if loopThread then applyFilter() end
    end)
    chipFns[rarity.name]=refreshChip
end

local chipsBottom=164+math.ceil(#Rarities/2)*(chipH+4)+5

local function makeSmallBtn(parent,label,xScale,xOff)
    local b=make("TextButton",{
        Size=UDim2.new(0.5,-3,0,26),Position=UDim2.new(xScale,xOff,0,chipsBottom),
        BackgroundColor3=RAISED,Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=WHITE,Text=label,AutoButtonColor=true,
    })
    b.Parent=parent;corner(b,5);livingStroke(b,0.8,false);return b
end

makeSmallBtn(autoFrame,"Select All",0,0).MouseButton1Click:Connect(function()
    for _,r in ipairs(Rarities) do rarityChosen[r.name]=true end
    for _,fn in pairs(chipFns) do fn() end
    if loopThread then applyFilter() end
end)
makeSmallBtn(autoFrame,"Clear All",0.5,2).MouseButton1Click:Connect(function()
    for _,r in ipairs(Rarities) do rarityChosen[r.name]=false end
    for _,fn in pairs(chipFns) do fn() end
    if loopThread then applyFilter() end
end)

local function switchTab(name)
    activeTab=name
    for n,f in pairs(tabFrames) do f.Visible=(n==name) end
    eggsTabBtn.TextColor3  = name=="Eggs" and WHITE or SILVER
    autoTabBtn.TextColor3  = name=="Auto" and WHITE or SILVER
    eggsTabBtn.BackgroundColor3 = name=="Eggs" and ACCENT_DARK or SURFACE
    autoTabBtn.BackgroundColor3 = name=="Auto" and ACCENT_DARK or SURFACE
    if name~="Eggs" then closeEggDrop() end
end
eggsTabBtn.MouseButton1Click:Connect(function() switchTab("Eggs") end)
autoTabBtn.MouseButton1Click:Connect(function()  switchTab("Auto") end)
switchTab("Eggs")

local dragInputConn
do
    local dragging,startPos,startMouse
    header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true;startPos=window.Position;startMouse=input.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    dragInputConn=UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-startMouse
            window.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local minimized=false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    body.Visible=not minimized
    tabBar.Visible=not minimized
    footer.Visible=not minimized
    minimizeBtn.Text=minimized and "+" or "−"
    window.Size=minimized and UDim2.fromOffset(GuiW,HeaderH) or UDim2.fromOffset(GuiW,GuiH)
end)

local shuttingDown=false
local function shutdownS2rHub()
    if shuttingDown then return end
    shuttingDown=true
    loopStop()
    hatchOn=false;placeOn=false;manualActive=false
    s2rHubConfig.AutoSteal=false
    if v612 then pcall(v612.setEnabled,v612,false) end
    if v613 then pcall(v613.setIdleFarm,v613,false) end
    if viewportConn then viewportConn:Disconnect() end
    if dragInputConn then dragInputConn:Disconnect() end
    if genv.__S2rHubShutdown==shutdownS2rHub then
        genv.__S2rHubShutdown=nil
    end
    gui:Destroy()
end
-- Re-executing the file can close the previous S2rHub panel cleanly.
genv.__S2rHubShutdown=shutdownS2rHub
closeBtn.MouseButton1Click:Connect(shutdownS2rHub)

populateDrop()
