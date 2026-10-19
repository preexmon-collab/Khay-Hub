--!nocheck
-- StealAnEgg / BigFroot - repaired, self-contained CONFIGURATION UI
-- IMPORTANT: The uploaded file does NOT contain a runnable automation engine.
-- This repair implements a functional GUI and config editor only.
-- It does not implement the game's automation, remotes, premium or anti-cheat code.
-- Optional integration: before running, set getgenv().BF_UI_Bridge to:
-- { OnSettingChanged = function(flag, value) end, Actions = { ["Action name"] = function() end } }
-- Without the optional bridge, actions are visibly unavailable.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
if not player then
    warn("[BF UI] LocalPlayer unavailable - run this on a Roblox client")
    return
end
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("[BF UI] PlayerGui unavailable")
    return
end

local env = (type(getgenv) == "function" and getgenv()) or _G
local bridge = type(env.BF_UI_Bridge) == "table" and env.BF_UI_Bridge or {}
local config = type(env.StealAnEggConfig) == "table" and env.StealAnEggConfig or {}
local configPath = "StealAnEgg_config.json"
local canWrite = type(writefile) == "function"
local function loadConfig()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    local ok, exists = pcall(isfile, configPath)
    if not ok or not exists then return end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(configPath))
    end)
    if success and type(data) == "table" then
        config = data
    elseif not success then
        warn("[BF UI] Existing config could not be decoded; using fresh settings")
    end
end
local function saveConfig()
    if not canWrite then return false end
    local ok, err = pcall(function()
        writefile(configPath, HttpService:JSONEncode(config))
    end)
    if not ok then warn("[BF UI] Could not save config:", err) end
    return ok
end
local function getFlag(flag, default)
    if not flag or flag == "" then return default end
    if config[flag] == nil then config[flag] = default end
    return config[flag]
end
local function setFlag(flag, value)
    if not flag or flag == "" then return false end
    config[flag] = value
    local saved = saveConfig()
    if type(bridge.OnSettingChanged) == "function" then
        local ok, err = pcall(bridge.OnSettingChanged, flag, value)
        if not ok then warn("[BF UI] Bridge rejected setting", flag, err) end
    end
    return saved
end
loadConfig()

for _, oldName in ipairs({"StealAnEggUI", "BF_Repaired_UI"}) do
    local old = playerGui:FindFirstChild(oldName)
    if old then old:Destroy() end
end
if type(env.BF_RepairedCleanup) == "function" then
    pcall(env.BF_RepairedCleanup)
end

local C = {
    background = Color3.fromRGB(20, 23, 27),
    sidebar = Color3.fromRGB(27, 31, 36),
    card = Color3.fromRGB(39, 44, 51),
    mutedCard = Color3.fromRGB(47, 52, 60),
    stroke = Color3.fromRGB(70, 77, 86),
    red = Color3.fromRGB(178, 34, 52),
    redHover = Color3.fromRGB(196, 44, 62),
    text = Color3.fromRGB(248, 250, 252),
    muted = Color3.fromRGB(204, 210, 219),
    disabled = Color3.fromRGB(156, 163, 175),
}

local gui = Instance.new("ScreenGui")
gui.Name = "BF_Repaired_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 30
gui.Parent = playerGui

local function round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
    return corner
end
local function outline(obj, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thick or 1
    s.Parent = obj
    return s
end
local function textLabel(parent, value, size, color, bold)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextColor3 = color or C.text
    lbl.TextSize = size or 14
    lbl.Text = tostring(value)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.TextWrapped = true
    lbl.Parent = parent
    return lbl
end
local function textButton(parent, value, fontSize)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = C.text
    b.TextSize = fontSize or 13
    b.Text = value
    b.Parent = parent
    round(b, 9)
    return b
end

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.94, 0, 0.84, 0)
main.BackgroundColor3 = C.background
main.BorderSizePixel = 0
main.Parent = gui
round(main, 14)
outline(main, C.stroke)
local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(680, 540)
constraint.MinSize = Vector2.new(0, 0)
constraint.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 59)
titleBar.BackgroundColor3 = C.sidebar
titleBar.BorderSizePixel = 0
titleBar.Parent = main
round(titleBar, 14)
local logo = textLabel(titleBar, "BF", 18, C.text, true)
logo.TextXAlignment = Enum.TextXAlignment.Center
logo.Size = UDim2.fromOffset(40, 36)
logo.Position = UDim2.fromOffset(12, 11)
logo.BackgroundColor3 = C.red
logo.BackgroundTransparency = 0
round(logo, 10)
local heading = textLabel(titleBar, "Egg Console", 17, C.text, true)
heading.Position = UDim2.fromOffset(61, 6)
heading.Size = UDim2.new(1, -154, 0, 26)
heading.TextTruncate = Enum.TextTruncate.AtEnd
local subtitle = textLabel(titleBar, "REPAIRED CONFIG UI  |  GRAY + RED", 10, C.muted, false)
subtitle.Position = UDim2.fromOffset(62, 30)
subtitle.Size = UDim2.new(1, -160, 0, 19)
subtitle.TextTruncate = Enum.TextTruncate.AtEnd

local minimize = textButton(titleBar, "_", 17)
minimize.Size = UDim2.fromOffset(33, 32)
minimize.Position = UDim2.new(1, -79, 0, 13)
minimize.BackgroundColor3 = C.card
local close = textButton(titleBar, "X", 14)
close.Size = UDim2.fromOffset(33, 32)
close.Position = UDim2.new(1, -41, 0, 13)
close.BackgroundColor3 = C.red

local launcher = textButton(gui, "BF", 17)
launcher.Size = UDim2.fromOffset(52, 52)
launcher.Position = UDim2.new(0, 15, 0.45, 0)
launcher.BackgroundColor3 = C.red
launcher.Visible = false
round(launcher, 16)
outline(launcher, C.text)
minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    launcher.Visible = true
end)
launcher.MouseButton1Click:Connect(function()
    main.Visible = true
    launcher.Visible = false
end)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local tabs = Instance.new("ScrollingFrame")
tabs.Name = "Tabs"
tabs.Size = UDim2.new(1, -20, 0, 41)
tabs.Position = UDim2.fromOffset(10, 64)
tabs.BackgroundTransparency = 1
tabs.BorderSizePixel = 0
tabs.ScrollBarThickness = 3
tabs.ScrollBarImageColor3 = C.red
tabs.ScrollingDirection = Enum.ScrollingDirection.X
tabs.ClipsDescendants = true
tabs.CanvasSize = UDim2.fromOffset(0, 0)
tabs.Parent = main
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 7)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabLayout.Parent = tabs
local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 2)
tabPadding.PaddingLeft = UDim.new(0, 2)
tabPadding.PaddingRight = UDim.new(0, 8)
tabPadding.Parent = tabs

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabs.CanvasSize = UDim2.fromOffset(tabLayout.AbsoluteContentSize.X + 16, 0)
end)

local content = Instance.new("ScrollingFrame")
content.Name = "Features"
content.Size = UDim2.new(1, -20, 1, -163)
content.Position = UDim2.fromOffset(10, 109)
content.BackgroundColor3 = C.sidebar
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = C.red
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.fromOffset(0, 0)
content.Parent = main
round(content, 10)
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content
local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft = UDim.new(0, 10)
contentPad.PaddingRight = UDim.new(0, 14)
contentPad.PaddingTop = UDim.new(0, 12)
contentPad.PaddingBottom = UDim.new(0, 12)
contentPad.Parent = content

local footer = textLabel(main, "GUI-only repair. Settings saved; gameplay backend unavailable.", 12, C.muted)
footer.Position = UDim2.new(0, 14, 1, -49)
footer.Size = UDim2.new(1, -28, 0, 43)
footer.TextWrapped = true
footer.TextYAlignment = Enum.TextYAlignment.Center
local function note(message)
    footer.Text = message
end

local trackedConnections = {}
local function track(connection)
    table.insert(trackedConnections, connection)
    return connection
end
local dragging, dragStart, dragPos, dragTouch = false, nil, nil, nil
track(titleBar.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging = true
    dragStart = input.Position
    dragPos = main.Position
    dragTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
end))

local sliderUpdate = nil
local sliderCommit = nil
local sliderTouch = nil
track(UserInputService.InputChanged:Connect(function(input)
    local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
    local isTrackedTouch = input.UserInputType == Enum.UserInputType.Touch and input == dragTouch
    if dragging and dragStart and dragPos and (isMouse or isTrackedTouch) then
        local delta = input.Position - dragStart
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1000, 800)
        local size = main.AbsoluteSize
        local allowedX = math.max(0, (viewport.X - size.X) / 2 - 4)
        local allowedY = math.max(0, (viewport.Y - size.Y) / 2 - 4)
        main.Position = UDim2.new(0.5, math.clamp(dragPos.X.Offset + delta.X, -allowedX, allowedX), 0.5, math.clamp(dragPos.Y.Offset + delta.Y, -allowedY, allowedY))
    end
    if sliderUpdate and (isMouse or (input.UserInputType == Enum.UserInputType.Touch and input == sliderTouch)) then
        sliderUpdate(input.Position.X)
    end
end))
track(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        if sliderCommit then sliderCommit() end
        sliderUpdate = nil
        sliderCommit = nil
        sliderTouch = nil
    elseif input.UserInputType == Enum.UserInputType.Touch then
        if input == dragTouch then dragging = false dragTouch = nil end
        if input == sliderTouch then
            if sliderCommit then sliderCommit() end
            sliderUpdate = nil
            sliderCommit = nil
            sliderTouch = nil
        end
    end
end))

local function clearContent()
    if sliderCommit then sliderCommit() end
    sliderUpdate = nil
    sliderCommit = nil
    sliderTouch = nil
    for _, item in ipairs(content:GetChildren()) do
        if item ~= contentLayout and item ~= contentPad then item:Destroy() end
    end
    content.CanvasPosition = Vector2.new(0, 0)
end

local function groupLabel(text)
    local lbl = textLabel(content, text:upper(), 12, C.muted, true)
    lbl.Size = UDim2.new(1, -2, 0, 24)
    return lbl
end
local function newCard(height)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, height)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    row.Parent = content
    round(row, 8)
    return row
end

local function makeToggle(name, flag)
    local availableWidth = math.max(126, content.AbsoluteSize.X - 122)
    local ok, measured = pcall(function()
        return TextService:GetTextSize(name, 14, Enum.Font.Gotham, Vector2.new(availableWidth, 2000)).Y
    end)
    local neededHeight = ok and measured + 21 or (#name > 31 and 76 or 62)
    local row = newCard(math.max(62, neededHeight))
    local label = textLabel(row, name, 14, C.text)
    label.Position = UDim2.fromOffset(13, 8)
    label.Size = UDim2.new(1, -102, 1, -16)
    local b = textButton(row, "OFF", 13)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, -12, 0.5, 0)
    b.Size = UDim2.fromOffset(68, 34)
    local enabled = getFlag(flag, false) == true
    local function paint()
        b.Text = enabled and "ON" or "OFF"
        b.BackgroundColor3 = enabled and C.red or C.mutedCard
        b.TextColor3 = C.text
    end
    paint()
    b.MouseButton1Click:Connect(function()
        enabled = not enabled
        local saved = setFlag(flag, enabled)
        paint()
        note((saved and "Saved: " or "Updated in memory: ") .. name .. " (gameplay callback not bundled)")
    end)
end

local function parseCSV(s)
    local values = {}
    for part in string.gmatch(s, "[^,]+") do
        local trimmed = part:match("^%s*(.-)%s*$")
        if trimmed ~= "" then table.insert(values, trimmed) end
    end
    return values
end
local singleSelect = {
    StealAnEgg_Priority = true, StealAnEgg_ReturnTo = true,
    StealAnEgg_ShardKind = true, StealAnEgg_ShrineRole = true,
    StealAnEgg_ShrinePet = true,
}
local knownOptions = {
    StealAnEgg_ShardKind = {"Fractured (Boss)", "Scrambled"},
    StealAnEgg_ShrineRole = {"Light", "Dark"},
}
local function makeDropdown(name, flag)
    local row = newCard(88)
    local lbl = textLabel(row, name, 13, C.text, true)
    lbl.Position = UDim2.fromOffset(12, 6)
    lbl.Size = UDim2.new(1, -20, 0, 22)
    local options = knownOptions[flag]
    if options then
        local b = textButton(row, "", 13)
        b.Position = UDim2.fromOffset(12, 34)
        b.Size = UDim2.new(1, -24, 0, 42)
        local value = tostring(getFlag(flag, options[1]))
        local function paint() b.Text = value .. "   (tap to change)" end
        paint()
        b.MouseButton1Click:Connect(function()
            local index = table.find(options, value) or 0
            value = options[index % #options + 1]
            setFlag(flag, value)
            paint()
            note("Saved setting: " .. name .. " = " .. value)
        end)
        return
    end
    local isSingle = singleSelect[flag] == true
    local data = getFlag(flag, isSingle and "" or {})
    local initial = ""
    if type(data) == "table" then
        local texts = {}
        for _, item in ipairs(data) do table.insert(texts, tostring(item)) end
        initial = table.concat(texts, ", ")
    elseif data ~= nil then
        initial = tostring(data)
    end
    local input = Instance.new("TextBox")
    input.Position = UDim2.fromOffset(12, 34)
    input.Size = UDim2.new(1, -24, 0, 42)
    input.BackgroundColor3 = C.mutedCard
    input.BorderSizePixel = 0
    input.TextColor3 = C.text
    input.PlaceholderColor3 = C.muted
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.TextTruncate = Enum.TextTruncate.AtEnd
    input.ClearTextOnFocus = false
    input.Text = initial
    input.PlaceholderText = isSingle and "Type a value, then press Enter" or "Comma-separated values (empty = any)"
    input.Parent = row
    round(input, 8)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = input
    input.FocusLost:Connect(function()
        local savedValue = isSingle and input.Text:match("^%s*(.-)%s*$") or parseCSV(input.Text)
        local saved = setFlag(flag, savedValue)
        note((saved and "Saved filter: " or "Updated filter in memory: ") .. name)
    end)
end

local function makeSlider(name, flag, minV, maxV)
    minV = tonumber(minV) or 0
    maxV = tonumber(maxV) or 100
    if maxV <= minV then maxV = minV + 1 end
    local row = newCard(90)
    local lbl = textLabel(row, "", 13, C.text, true)
    lbl.Position = UDim2.fromOffset(12, 6)
    lbl.Size = UDim2.new(1, -20, 0, 32)
    local val = math.clamp(tonumber(getFlag(flag, minV)) or minV, minV, maxV)
    local bar = Instance.new("TextButton")
    bar.AutoButtonColor = false
    bar.Text = ""
    bar.Position = UDim2.fromOffset(14, 55)
    bar.Size = UDim2.new(1, -28, 0, 15)
    bar.BackgroundColor3 = C.mutedCard
    bar.BorderSizePixel = 0
    bar.Parent = row
    round(bar, 7)
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = C.red
    fill.BorderSizePixel = 0
    fill.Size = UDim2.fromScale(0, 1)
    fill.Parent = bar
    round(fill, 7)
    local step = (minV % 1 ~= 0 or maxV % 1 ~= 0) and 0.25 or 1
    local function updateUI()
        local out = math.floor(val * 100 + 0.5) / 100
        lbl.Text = name .. ": " .. tostring(out)
        fill.Size = UDim2.new(math.clamp((val - minV)/(maxV - minV), 0, 1), 0, 1, 0)
    end
    local function move(x)
        if not bar.Parent then return end
        local width = math.max(bar.AbsoluteSize.X, 1)
        local ratio = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
        val = math.clamp(minV + math.floor((ratio * (maxV-minV)) / step + 0.5) * step, minV, maxV)
        updateUI()
        config[flag] = val
    end
    updateUI()
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderUpdate = move
            sliderCommit = function()
                local saved = setFlag(flag, val)
                note((saved and "Saved slider: " or "Slider updated in memory: ") .. name)
            end
            sliderTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
            move(input.Position.X)
        end
    end)
end

local function makeButton(name)
    local handler = type(bridge.Actions) == "table" and bridge.Actions[name]
    local row = newCard(53)
    local b = textButton(row, name .. (type(handler) == "function" and "" or "  •  unavailable"), 13)
    b.Position = UDim2.fromOffset(8, 7)
    b.Size = UDim2.new(1, -16, 1, -14)
    b.TextWrapped = true
    if type(handler) == "function" then
        b.BackgroundColor3 = C.red
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(handler)
            if ok then note("Action executed: " .. name)
            else
                warn("[BF UI] Action failed", name, err)
                note("Action error: " .. name .. " (check console)")
            end
        end)
    else
        b.BackgroundColor3 = C.mutedCard
        b.TextColor3 = C.disabled
        b.Active = false
    end
end

local PAGE_DATA = {
	["Steal"] = {
		toggles = {
			{name="Auto Steal Eggs", flag="StealAnEgg_AutoSteal"},
			{name="Premium Steal", flag="StealAnEgg_PremiumSteal"},
			{name="Return To Plot", flag="StealAnEgg_ReturnToPlot"},
			{name="Return To Last Position", flag="StealAnEgg_ReturnLast"},
			{name="Match ALL Selected Mutations", flag="StealAnEgg_RequireAllMuts"},
			{name="Only Mutated Eggs", flag="StealAnEgg_OnlyMutated"},
			{name="Always Steal Dragon Eggs", flag="StealAnEgg_DragonEgg"},
			{name="Claim Offline Earnings", flag="StealAnEgg_AutoClaimOffline"},
			{name="Auto Trade-In", flag="StealAnEgg_AutoRift"},
			{name="Auto Steal Recipe Eggs", flag="StealAnEgg_AutoRiftNeed"},
			{name="Stock Up Spares", flag="StealAnEgg_RiftStockUp"},
			{name="Optimization Mode (FPS BOOST, rejoin to undo)", flag="StealAnEgg_Optimize"},
			{name="Ultra FPS Boost", flag="StealAnEgg_UltraFps"},
			{name="Mention @everyone", flag="StealAnEgg_MentionEveryone"},
		},
		dropdowns = {
			{name="Target Priority", flag="StealAnEgg_Priority"},
			{name="Return To", flag="StealAnEgg_ReturnTo"},
			{name="Areas", flag="StealAnEgg_FilterAreas"},
			{name="Categories", flag="StealAnEgg_FilterCategories"},
			{name="Rarities", flag="StealAnEgg_FilterRarities"},
			{name="Mutations", flag="StealAnEgg_FilterMutations"},
			{name="Banners (empty = any)", flag="StealAnEgg_RiftBanners"},
			{name="Categories", flag="StealAnEgg_WhCategories"},
			{name="Rarities", flag="StealAnEgg_WhRarities"},
			{name="Mutations", flag="StealAnEgg_WhMutations"},
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Other"] = {
		toggles = {
		},
		dropdowns = {
		},
		sliders = {
		},
		buttons = {
			{name="Reset Session Counter"},
			{name="Drop Carried Egg"},
			{name="Refresh Lists"},
			{name="Refresh"},
			{name="Send Test Post"},
		},
	},
	["Eggs"] = {
		toggles = {
			{name="Auto Place Selected", flag="StealAnEgg_AutoPlaceSelected"},
			{name="Auto Place All", flag="StealAnEgg_AutoPlaceAll"},
			{name="Auto Hatch Ready", flag="StealAnEgg_AutoHatchReady"},
			{name="Use Filter for Auto Hatch Ready", flag="StealAnEgg_HatchUseFilter"},
			{name="Auto Sell Eggs", flag="StealAnEgg_AutoSellEggs"},
		},
		dropdowns = {
			{name="Categories", flag="StealAnEgg_PlaceCategories"},
			{name="Rarities", flag="StealAnEgg_PlaceRarities"},
			{name="Mutations", flag="StealAnEgg_PlaceMutations"},
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Upgrades"] = {
		toggles = {
			{name="Anti Treadmill", flag="StealAnEgg_AntiTreadmill"},
			{name="Auto Upgrade Pen", flag="StealAnEgg_AutoUpgradePen"},
			{name="Auto Treadmill Training", flag="StealAnEgg_AutoTreadmillTrain"},
			{name="Auto Treadmill Upgrade", flag="StealAnEgg_AutoTreadmillUpgrade"},
			{name="Auto Buy Selected Trails", flag="StealAnEgg_AutoBuyTrails"},
			{name="Auto Buy All Cash Trails", flag="StealAnEgg_AutoBuyAllTrails"},
			{name="Auto Equip Best Trail", flag="StealAnEgg_AutoEquipBestTrail"},
			{name="Auto Equip Best Gear", flag="StealAnEgg_AutoEquipBestGear"},
			{name="Auto Claim Index Rewards", flag="StealAnEgg_AutoClaimIndex"},
			{name="Auto Claim Group Reward", flag="StealAnEgg_AutoClaimGroup"},
			{name="Bat Aura", flag="StealAnEgg_BatAura"},
			{name="Auto Equip Best Bat", flag="StealAnEgg_AutoEquipBat"},
		},
		dropdowns = {
			{name="Trails To Buy", flag="StealAnEgg_BuyTrailList"},
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Pets"] = {
		toggles = {
			{name="Auto Equip Pets", flag="StealAnEgg_AutoEquipPets"},
			{name="Auto Sell Selected", flag="StealAnEgg_AutoSellSelected"},
			{name="Auto Sell All Eligible", flag="StealAnEgg_AutoSellAll"},
			{name="Auto Unequip for Selling", flag="StealAnEgg_AutoUnequipForSell"},
			{name="Delete Pets (FPS BOOST)", flag="StealAnEgg_DeletePets"},
		},
		dropdowns = {
			{name="Categories", flag="StealAnEgg_SellEggCategories"},
			{name="Rarities", flag="StealAnEgg_SellEggRarities"},
			{name="Mutations", flag="StealAnEgg_SellEggMutations"},
			{name="Sell Categories", flag="StealAnEgg_SellCategories"},
			{name="Sell Rarities", flag="StealAnEgg_SellRarities"},
			{name="Sell Mutations", flag="StealAnEgg_SellMutations"},
		},
		sliders = {
			{name="Auto Equip Pets Interval", flag="StealAnEgg_EquipInterval", min=1, max=300},
			{name="Keep Best (never sell)", flag="StealAnEgg_SellKeepBest", min=0, max=50},
			{name="Sell Delay (per sale, pets + eggs)", flag="StealAnEgg_SellDelay", min=0.25, max=10},
		},
		buttons = {
		},
	},
	["Scramble"] = {
		toggles = {
			{name="Auto Collect", flag="StealAnEgg_ScrambleFarm"},
			{name="Rarest Drones First", flag="StealAnEgg_ScrambleRarest"},
			{name="Auto Quest", flag="StealAnEgg_ScrambleQuest"},
			{name="Auto Buy", flag="StealAnEgg_ScrambleBuy"},
			{name="Auto Fight Boss", flag="StealAnEgg_ScrBoss"},
			{name="Auto Claim Mastery", flag="StealAnEgg_ScrBossMastery"},
			{name="Auto Mutation Shards", flag="StealAnEgg_AutoShard"},
		},
		dropdowns = {
			{name="Buy", flag="StealAnEgg_ScrambleBuyPicks"},
			{name="Shard Type", flag="StealAnEgg_ShardKind"},
			{name="Shard Eggs", flag="StealAnEgg_ShardPicks"},
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Contest"] = {
		toggles = {
			{name="Auto Capture Egg", flag="StealAnEgg_AutoContest"},
			{name="Skip Contested Eggs", flag="StealAnEgg_SkipContested"},
			{name="Contest Players (BETA)", flag="StealAnEgg_ContestPlayers"},
		},
		dropdowns = {
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Fuse"] = {
		toggles = {
			{name="Auto Fuse Selected", flag="StealAnEgg_AutoFuseSelected"},
			{name="Auto Fuse All Eligible", flag="StealAnEgg_AutoFuseAll"},
			{name="Auto Shrine Fusion", flag="StealAnEgg_ShrineAuto"},
		},
		dropdowns = {
			{name="Categories", flag="StealAnEgg_FuseCategories"},
			{name="Rarities", flag="StealAnEgg_FuseRarities"},
			{name="Mutations", flag="StealAnEgg_FuseMutations"},
			{name="My Pad", flag="StealAnEgg_ShrineRole"},
			{name="Pet To Hold", flag="StealAnEgg_ShrinePet"},
		},
		sliders = {
		},
		buttons = {
		},
	},
	["Player"] = {
		toggles = {
			{name="God Mode", flag="StealAnEgg_GodMode"},
			{name="Anti Hit", flag="StealAnEgg_AntiHit"},
			{name="Avoid Traps", flag="StealAnEgg_AvoidTraps"},
			{name="Anti AFK", flag="StealAnEgg_AntiAFK"},
		},
		dropdowns = {
		},
		sliders = {
		},
		buttons = {
		},
	},
	["ESP"] = {
		toggles = {
			{name="Inventory Value ESP", flag="StealAnEgg_InvValueEsp"},
			{name="Egg ESP", flag="StealAnEgg_EggEsp"},
			{name="Show Everyone (wild + all plots)", flag="StealAnEgg_EspShowEveryone"},
			{name="Only Mutated", flag="StealAnEgg_EspOnlyMutated"},
		},
		dropdowns = {
			{name="Categories", flag="StealAnEgg_EspCategories"},
			{name="Rarities", flag="StealAnEgg_EspRarities"},
			{name="Mutations", flag="StealAnEgg_EspMutations"},
		},
		sliders = {
			{name="Premium Glide Speed", flag="StealAnEgg_PremiumGlideSpeed", min=100, max=1000},
		},
		buttons = {
		},
	},
	["System"] = {
		toggles = {
			{name="Auto Execute", flag="StealAnEgg_AutoExecute"},
			{name="Auto Reconnect", flag="StealAnEgg_AutoReconnect"},
			{name="Report To Dashboard", flag="StealAnEgg_Dashboard"},
			{name="Enable Webhook", flag="StealAnEgg_Webhook"},
			{name="Trade-In Webhook", flag="StealAnEgg_WebhookRift"},
		},
		dropdowns = {
		},
		sliders = {
		},
		buttons = {
			{name="Send Report Now"},
		},
	},
}


local tabButtons = {}
local displayOrder = {"Steal", "Eggs", "Pets", "Upgrades", "Scramble", "Contest", "Fuse", "Player", "ESP", "System", "Other"}
local function showTab(tabName)
    local page = PAGE_DATA[tabName]
    if not page then return end
    clearContent()
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = name == tabName and C.red or C.card
        button.TextColor3 = name == tabName and C.text or C.muted
    end
    if #page.toggles > 0 then
        groupLabel("Switches / saved settings")
        for _, item in ipairs(page.toggles) do makeToggle(item.name, item.flag) end
    end
    if #page.dropdowns > 0 then
        groupLabel("Filters / editable values")
        for _, item in ipairs(page.dropdowns) do makeDropdown(item.name, item.flag) end
    end
    if #page.sliders > 0 then
        groupLabel("Values / drag sliders")
        for _, item in ipairs(page.sliders) do makeSlider(item.name, item.flag, item.min, item.max) end
    end
    if #page.buttons > 0 then
        groupLabel("Actions / backend required")
        for _, item in ipairs(page.buttons) do makeButton(item.name) end
    end
    if #page.toggles == 0 and #page.dropdowns == 0 and #page.sliders == 0 and #page.buttons == 0 then
        groupLabel("No settings in this category")
    end
    note("GUI-only repair • " .. tabName .. " • " .. (canWrite and "config saves to file" or "config is session-only") .. " • gameplay backend unavailable")
end
for index, tabName in ipairs(displayOrder) do
    if PAGE_DATA[tabName] then
        local b = textButton(tabs, tabName, 13)
        b.LayoutOrder = index
        b.Size = UDim2.fromOffset(math.max(78, #tabName*9+28), 34)
        b.Parent = tabs
        tabButtons[tabName] = b
        b.MouseButton1Click:Connect(function() showTab(tabName) end)
    end
end

local cleanup
track(gui.Destroying:Connect(function()
    sliderUpdate = nil
    dragging = false
    for _, c in ipairs(trackedConnections) do pcall(function() c:Disconnect() end) end
    if env.StealAnEggUI == gui then env.StealAnEggUI = nil end
    if env.BF_RepairedCleanup == cleanup then env.BF_RepairedCleanup = nil end
end))
cleanup = function()
    if gui and gui.Parent then gui:Destroy() end
end
env.BF_RepairedCleanup = cleanup
env.StealAnEggConfig = config
env.StealAnEggUI = gui
showTab("Steal")
print("[BF UI] Repaired config-only interface loaded. No gameplay backend is included.")
