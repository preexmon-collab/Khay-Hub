local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local API_URL = "https://cozy-cupcake-a74943.netlify.app/api/getPets"
local REFRESH_INTERVAL = 2 -- balanced live updates without unnecessary network pressure
local MAX_ITEMS = 300
local DEFAULT_RARITY = "Secret"
local FORCE_INTERVAL = 3
local TITLE = "S2rHub Finder by Khay"
local DISCORD_LINK = "https://discord.gg/z5CSuSYzh"

local rarityByName, colorByName = {}, {}

do
	local ok, err = pcall(function()
		local Assets = require(ReplicatedStorage:WaitForChild("Data", 5):WaitForChild("Assets", 5))
		for id, e in pairs(Assets.Directory) do
			if type(e) == "table" and type(e.Rarity) == "table" then
				local r = e.Rarity.DisplayName or e.Rarity._id
				rarityByName[id] = r
				colorByName[id] = e.Rarity.Color
				if e.DisplayName then
					rarityByName[e.DisplayName] = r
					colorByName[e.DisplayName] = e.Rarity.Color
				end
			end
		end
	end)
	if not ok then
		warn("[" .. TITLE .. "] Assets unavailable; using API rarity/default:", err)
	end
end

local function getRarity(petName)
	return rarityByName[petName]
end

local function getRarityColor(petName)
	local c = colorByName[petName]
	if typeof(c) == "Color3" then
		return c
	end
	return nil
end

local WHITE = Color3.fromRGB(255, 255, 255)
local ACCENT_HI = Color3.fromRGB(195, 145, 255)
local ACCENT = Color3.fromRGB(145, 83, 235)
local ACCENT_DARK = Color3.fromRGB(78, 39, 140)
local ACCENT_DEEP = Color3.fromRGB(38, 21, 67)
local SUB_TEXT = Color3.fromRGB(198, 186, 216)
local MUTED = Color3.fromRGB(151, 135, 174)

local FONT_BOLD = Enum.Font.GothamBold
local FONT_MED = Enum.Font.GothamMedium

local function new(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function corner(parent, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function gradient(parent, c0, c1, rotation)
	return new("UIGradient", {
		Color = ColorSequence.new(c0, c1),
		Rotation = rotation or 0,
	}, parent)
end

local function accentStroke(parent, thickness, transparency)
	local s = stroke(parent, WHITE, thickness, transparency)
	gradient(s, ACCENT_HI, ACCENT_DARK, 90)
	return s
end

local function label(parent, text, size, font, color, pos, sz, alignX)
	return new("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = size,
		Font = font,
		TextColor3 = color,
		Position = pos,
		Size = sz,
		TextXAlignment = alignX or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

local function button(parent, o)
	local bg = new("Frame", {
		AnchorPoint = o.anchor or Vector2.new(0, 0),
		Position = o.pos,
		Size = o.size,
		BackgroundColor3 = WHITE,
		BackgroundTransparency = o.bgTransparency or 0,
		BorderSizePixel = 0,
	}, parent)
	corner(bg, o.radius or 8)
	gradient(bg, o.c0, o.c1, o.rotation or 90)
	if o.strokeColor then
		stroke(bg, o.strokeColor, o.strokeThickness or 1.2, o.strokeTransparency or 0)
	end
	local btn = new("TextButton", {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = o.text,
		TextSize = o.textSize or 12,
		Font = FONT_BOLD,
		TextColor3 = o.textColor or WHITE,
		BorderSizePixel = 0,
	}, bg)
	return btn, bg
end

local VALUE_UNITS = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
local function formatValue(v)
    for _, u in ipairs(VALUE_UNITS) do
        if v >= u[1] then
            return ("$%.1f%s/s"):format(v / u[1], u[2])
        end
    end
    return ("$%d/s"):format(math.floor(v))
end

local function formatAge(tsMs)
	local s = math.max(0, math.floor(os.time() - tsMs / 1000))
	return ("%d:%02d"):format(math.floor(s / 60), s % 60)
end

local function richColor(c)
	return ("rgb(%d,%d,%d)"):format(
		math.floor(c.R * 255 + 0.5),
		math.floor(c.G * 255 + 0.5),
		math.floor(c.B * 255 + 0.5))
end

local function escapeRich(s)
	return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function httpGet(url)
	local okR, res = pcall(function()
		local fn = (syn and syn.request) or http_request or request
		if fn then
			return fn({ Url = url, Method = "GET" })
		end
		return nil
	end)
	if okR and res and res.Body then
		return res.Body
	end
	local ok, body = pcall(function()
		return game:HttpGet(url)
	end)
	if ok and body then
		return body
	end
	local ok2, body2 = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if ok2 then
		return body2
	end
	return nil
end

-- Destroy earlier instances of this GUI so re-execution never stacks windows or polling loops.
for _, existing in ipairs(playerGui:GetChildren()) do
    if existing:IsA("ScreenGui") and
        (existing.Name == "S2rHubFinderByKhay" or existing.Name == ("Source" .. "HubFinder")) then
        existing:Destroy()
    end
end

local gui = new("ScreenGui", {
	Name = "S2rHubFinderByKhay",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
	DisplayOrder = 50,
}, playerGui)

local main = new("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(860, 510),
	BackgroundColor3 = WHITE,
	BackgroundTransparency = 0.06,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, gui)
corner(main, 14)
accentStroke(main, 1.6, 0)
new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 21, 71)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(16, 13, 26)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 7, 13)),
	}),
	Rotation = 35,
}, main)

-- Responsive scaling for smaller windows and mobile screens. No asset-ID wallpaper is used.
local mainScale = new("UIScale", { Scale = 1 }, main)
local connections = {}
local function track(connection)
    table.insert(connections, connection)
    return connection
end

gui.Destroying:Connect(function()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    table.clear(connections)
end)

local cameraSizeConnection
local function applyViewportScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local vp = camera.ViewportSize
    mainScale.Scale = math.max(0.3, math.min(1, (vp.X - 24) / 860, (vp.Y - 42) / 510))
end
local function bindCamera()
    if cameraSizeConnection then cameraSizeConnection:Disconnect() end
    local camera = workspace.CurrentCamera
    if camera then
        cameraSizeConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyViewportScale)
    end
    applyViewportScale()
end
bindCamera()
track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
gui.Destroying:Connect(function()
    if cameraSizeConnection then cameraSizeConnection:Disconnect() end
end)

-- Only drag from the heading area, so buttons and the scrolling feed stay responsive.
do
    local dragging, dragStart, startPos, activeTouch = false, nil, nil, nil
    main.InputBegan:Connect(function(input)
        local kind = input.UserInputType
        if (kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch)
            and input.Position.Y <= main.AbsolutePosition.Y + 67 * mainScale.Scale then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            activeTouch = kind == Enum.UserInputType.Touch and input or nil
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseMovement and input ~= activeTouch then return end
        local offset = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset.X,
            startPos.Y.Scale, startPos.Y.Offset + offset.Y)
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input == activeTouch then
            dragging = false
            activeTouch = nil
        end
    end))
end

local sidebar = new("Frame", {
	Name = "Sidebar",
	Size = UDim2.new(0, 184, 1, 0),
	BackgroundColor3 = WHITE,
	BackgroundTransparency = 0.15,
	BorderSizePixel = 0,
}, main)
gradient(sidebar, Color3.fromRGB(11, 10, 20), Color3.fromRGB(40, 21, 69), 90)

local divider = new("Frame", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(0, 1, 1, 0),
	BackgroundColor3 = WHITE,
	BorderSizePixel = 0,
}, sidebar)
gradient(divider, ACCENT_HI, ACCENT_DARK, 90)

local titleLabel = label(sidebar, "S2rHub Finder", 16, FONT_BOLD, WHITE,
    UDim2.fromOffset(14, 14), UDim2.fromOffset(165, 24))
gradient(titleLabel, WHITE, ACCENT_HI, 0)
label(sidebar, "by Khay", 11, FONT_MED, ACCENT_HI,
    UDim2.fromOffset(15, 39), UDim2.fromOffset(156, 18))

local indicator = new("Frame", {
    Position = UDim2.fromOffset(16, 70),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = ACCENT_HI,
    BorderSizePixel = 0,
}, sidebar)
corner(indicator, 4)
local statusLabel = label(sidebar, "Connecting...", 10, FONT_MED, SUB_TEXT,
    UDim2.fromOffset(30, 64), UDim2.fromOffset(143, 20))

local logPanel = new("Frame", {
    Position = UDim2.fromOffset(10, 97),
    Size = UDim2.fromOffset(164, 37),
    BackgroundColor3 = ACCENT_DEEP,
    BorderSizePixel = 0,
}, sidebar)
corner(logPanel, 10)
accentStroke(logPanel, 1, 0.5)
label(logPanel, "LIVE FINDER  •  LOGS", 10, FONT_BOLD, WHITE,
    UDim2.fromOffset(12, 0), UDim2.new(1, -20, 1, 0))

local COPY_TEXT = "Copy Discord Link"
local copyBtn = button(sidebar, {
	text = COPY_TEXT,
	textSize = 10,
	pos = UDim2.fromOffset(10, 148),
	size = UDim2.fromOffset(164, 34),
	c0 = Color3.fromRGB(42, 27, 65),
	c1 = Color3.fromRGB(15, 12, 27),
	strokeColor = ACCENT,
	strokeTransparency = 0.25,
	radius = 10,
})

local copyToken = 0
copyBtn.MouseButton1Click:Connect(function()
	local fn = setclipboard or toclipboard
	local ok = fn and pcall(fn, DISCORD_LINK)
	copyToken += 1
	local myToken = copyToken
	copyBtn.Text = ok and "Copied!" or "Copy failed"
	if not ok then
		warn("[" .. TITLE .. "] Clipboard tidak didukung executor. Link: " .. DISCORD_LINK)
	end
	task.delay(1.5, function()
		if copyToken == myToken and copyBtn.Parent then
			copyBtn.Text = COPY_TEXT
		end
	end)
end)

local hideBtn = button(sidebar, {
	text = "Hide",
	textSize = 12,
	anchor = Vector2.new(0, 1),
	pos = UDim2.new(0, 10, 1, -23),
	size = UDim2.fromOffset(164, 36),
	c0 = Color3.fromRGB(42, 27, 65),
	c1 = Color3.fromRGB(15, 12, 27),
	strokeColor = ACCENT,
	strokeTransparency = 0.25,
	radius = 10,
})

local showBtn, showBg = button(gui, {
	text = TITLE,
	textSize = 12,
	anchor = Vector2.new(0.5, 0),
	pos = UDim2.new(0.5, 0, 0, 12),
	size = UDim2.fromOffset(215, 34),
	c0 = Color3.fromRGB(52, 28, 84),
	c1 = Color3.fromRGB(13, 11, 24),
	strokeColor = ACCENT,
	strokeTransparency = 0.15,
	radius = 10,
})
showBg.Visible = false
new("UIScale", { Scale = 1 }, showBg)

hideBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	showBg.Visible = true
end)
showBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	showBg.Visible = false
end)

local content = new("Frame", {
	Name = "Content",
	Position = UDim2.fromOffset(202, 0),
	Size = UDim2.new(1, -202, 1, 0),
	BackgroundTransparency = 1,
}, main)

local TRACK_OFF = Color3.fromRGB(45, 35, 57)
local function toggleCard(text, x, onChanged)
	local card = new("Frame", {
		Position = UDim2.fromOffset(x, 20),
		Size = UDim2.fromOffset(288, 46),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
	}, content)
	corner(card, 10)
	gradient(card, Color3.fromRGB(41, 25, 67), Color3.fromRGB(16, 13, 29), 0)
	accentStroke(card, 1.2, 0.2)

	label(card, text, 12, FONT_BOLD, WHITE,
		UDim2.fromOffset(14, 0), UDim2.new(1, -90, 1, 0))

	local track = new("TextButton", {
		AutoButtonColor = false,
		Text = "",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(48, 26),
		BackgroundColor3 = TRACK_OFF,
		BorderSizePixel = 0,
	}, card)
	corner(track, 13)
	stroke(track, ACCENT_DARK, 1, 0.2)
	gradient(track, WHITE, Color3.fromRGB(165, 165, 165), 90)

	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 4, 0.5, 0),
		Size = UDim2.fromOffset(20, 20),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
	}, track)
	corner(knob, 10)

	local state = false
	local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	track.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(knob, info, {
			Position = state and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
		}):Play()
		TweenService:Create(track, info, {
			BackgroundColor3 = state and ACCENT or TRACK_OFF,
		}):Play()
		if onChanged then
			onChanged(state)
		end
	end)
	return card
end

local autoJoinState, autoForceState = false, false
local forceKey, forceJobId, forceRun = nil, nil, 0
local render, startForce, stopForce

toggleCard("Auto-Join", 0, function(v)
	autoJoinState = v
	render()
end)
toggleCard("Auto-Force", 314, function(v)
	autoForceState = v
	if not v then
		stopForce()
	end
	render()
end)

label(content, "LIVE FEED", 9, FONT_BOLD, ACCENT_HI,
	UDim2.fromOffset(2, 74), UDim2.fromOffset(100, 16))

local detectedLabel = label(content, "0 detected", 8, FONT_MED, MUTED,
	UDim2.fromOffset(484, 74), UDim2.fromOffset(84, 16), Enum.TextXAlignment.Right)

local clearBtn = button(content, {
	text = "Clear",
	textSize = 9,
	pos = UDim2.fromOffset(584, 70),
	size = UDim2.fromOffset(49, 22),
	c0 = ACCENT_DARK,
	c1 = ACCENT_DEEP,
	strokeColor = ACCENT,
	strokeThickness = 1,
	strokeTransparency = 0.4,
})

local feedBox = new("Frame", {
	Position = UDim2.fromOffset(0, 96),
	Size = UDim2.new(1, -2, 1, -112),
	BackgroundColor3 = WHITE,
	BackgroundTransparency = 0.2,
	BorderSizePixel = 0,
}, content)
corner(feedBox, 12)
gradient(feedBox, Color3.fromRGB(19, 14, 32), Color3.fromRGB(8, 8, 16), 90)
stroke(feedBox, ACCENT, 1, 0.6)

local feed = new("ScrollingFrame", {
	Position = UDim2.fromOffset(7, 7),
	Size = UDim2.new(1, -14, 1, -14),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = ACCENT,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, feedBox)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, feed)
new("UIPadding", { PaddingRight = UDim.new(0, 8) }, feed)

local function joinServer(jobId)
	if not jobId or jobId == "" then
		return
	end
	if jobId == game.JobId then
		return
	end
	local ok, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
	end)
	if not ok then
		warn("[" .. TITLE .. "] Gagal join:", err)
	end
end

stopForce = function()
	forceRun += 1
	forceKey, forceJobId = nil, nil
end

startForce = function(key, jobId)
	forceRun += 1
	local myRun = forceRun
	forceKey, forceJobId = key, jobId
	task.spawn(function()
		while forceRun == myRun and autoForceState and gui.Parent do
			if jobId == game.JobId then
				stopForce()
				render()
				break
			end
			joinServer(jobId)
			task.wait(FORCE_INTERVAL)
		end
	end)
end

-- Row pooling prevents destroying and rebuilding hundreds of GUI objects on each refresh.
-- The icon IDs are pet thumbnails only; no rbxassetid background is created.
local rowPool = {}

local function subText(entry)
    local rarityText = escapeRich(entry.rarity)
    if entry.rarityColor then
        rarityText = ("<font color=\"%s\">%s</font>"):format(richColor(entry.rarityColor), rarityText)
    end
    return formatAge(entry.ts) .. " • " .. rarityText
end

local function makeRow(order)
    local frame = new("Frame", {
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
    }, feed)
    corner(frame, 10)
    gradient(frame, Color3.fromRGB(44, 29, 74), Color3.fromRGB(16, 14, 30), 0)
    accentStroke(frame, 1, 0.55)

    local bar = new("Frame", {
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(5, 48),
        BackgroundColor3 = ACCENT_HI,
        BorderSizePixel = 0,
    }, frame)
    corner(bar, 3)
    gradient(bar, ACCENT_HI, ACCENT_DARK, 90)

    local icon = new("ImageLabel", {
        Position = UDim2.fromOffset(18, 8),
        Size = UDim2.fromOffset(44, 44),
        BackgroundTransparency = 1,
        Image = "",
        ScaleType = Enum.ScaleType.Fit,
    }, frame)
    local nameLabel = label(frame, "", 15, FONT_BOLD, WHITE,
        UDim2.fromOffset(70, 7), UDim2.new(1, -210, 0, 26))
    nameLabel.RichText = true
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    local descLabel = label(frame, "", 11, FONT_MED, SUB_TEXT,
        UDim2.fromOffset(70, 33), UDim2.new(1, -210, 0, 16))
    descLabel.RichText = true

    local join = button(frame, {
        text = "JOIN", textSize = 9,
        anchor = Vector2.new(1, 0.5),
        pos = UDim2.new(1, -75, 0.5, 0),
        size = UDim2.fromOffset(52, 27),
        c0 = ACCENT, c1 = ACCENT_DARK,
        strokeColor = ACCENT_HI, strokeTransparency = 0.3,
    })
    local force, forceBg = button(frame, {
        text = "FORCE", textSize = 9,
        anchor = Vector2.new(1, 0.5),
        pos = UDim2.new(1, -12, 0.5, 0),
        size = UDim2.fromOffset(49, 27),
        c0 = ACCENT_DEEP, c1 = Color3.fromRGB(19, 17, 32),
        strokeColor = ACCENT_DARK, strokeTransparency = 0.55,
    })
    local state = {
        frame = frame, icon = icon, name = nameLabel, sub = descLabel,
        force = force, forceBg = forceBg,
        forceGradient = forceBg:FindFirstChildOfClass("UIGradient"),
        forceStroke = forceBg:FindFirstChildOfClass("UIStroke"),
        data = nil,
    }
    join.MouseButton1Click:Connect(function()
        if state.data then joinServer(state.data.jobId) end
    end)
    force.MouseButton1Click:Connect(function()
        if not autoForceState or not state.data then return end
        if forceKey == state.data.key then
            stopForce()
        else
            startForce(state.data.key, state.data.jobId)
        end
        render()
    end)
    return state
end

local hidden, latest = {}, {}
local function keyOf(e)
    return e.key
end

local function updateRow(row, entry, order)
    row.data = entry
    row.frame.LayoutOrder = order
    row.frame.Visible = true
    local imageId = entry.iconId
    local iconUri = imageId and tostring(imageId):match("^%d+$")
        and ("rbxassetid://" .. tostring(imageId)) or ""
    if row.icon.Image ~= iconUri then row.icon.Image = iconUri end

    local titleText = ("%s  <font color=\"%s\">[ %s ]</font>"):format(
        escapeRich(entry.name), richColor(ACCENT_HI), formatValue(entry.value))
    if row.name.Text ~= titleText then row.name.Text = titleText end
    local detail = subText(entry)
    if row.sub.Text ~= detail then row.sub.Text = detail end

    local selected = autoForceState and forceKey == entry.key
    local c0, c1
    if selected then
        c0, c1 = ACCENT_HI, ACCENT
    elseif autoForceState then
        c0, c1 = Color3.fromRGB(57, 35, 88), Color3.fromRGB(22, 17, 37)
    else
        c0, c1 = Color3.fromRGB(40, 36, 52), Color3.fromRGB(26, 24, 35)
    end
    row.forceGradient.Color = ColorSequence.new(c0, c1)
    row.force.TextColor3 = (autoForceState and WHITE) or MUTED
    row.forceStroke.Color = selected and ACCENT_HI or ACCENT_DARK
    row.forceStroke.Transparency = selected and 0.1 or 0.7
end

function render()
    local shown = 0
    for _, entry in ipairs(latest) do
        if autoJoinState and not hidden[keyOf(entry)] then
            shown += 1
            if shown <= MAX_ITEMS then
                local cell = rowPool[shown]
                if not cell then
                    cell = makeRow(shown)
                    rowPool[shown] = cell
                end
                updateRow(cell, entry, shown)
            end
        end
    end
    for i = math.min(shown, MAX_ITEMS) + 1, #rowPool do
        rowPool[i].frame.Visible = false
        rowPool[i].data = nil
    end
    detectedLabel.Text = shown .. " detected"
end

clearBtn.MouseButton1Click:Connect(function()
	for _, e in ipairs(latest) do
		hidden[keyOf(e)] = true
	end
	render()
end)

local lastFeedSignature = nil
local function fetchPets()
	local body = httpGet(API_URL)
	if not body then
		return false
	end
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(body)
	end)
	if not ok or type(decoded) ~= "table" then
		return false
	end

	local list = {}
	for _, p in ipairs(decoded) do
		if p.petName and p.jobId and tonumber(p.value) then
			local name = tostring(p.petName)
			local rarity = getRarity(name)
				or (p.rarity and tostring(p.rarity))
				or DEFAULT_RARITY
			table.insert(list, {
				name = name,
				value = tonumber(p.value),
				jobId = tostring(p.jobId),
				iconId = p.iconId,
				key = tostring(p.jobId) .. "|" .. name .. "|" .. tostring(p.timestamp),
				ts = tonumber(p.timestamp) or (os.time() * 1000),
				rarity = rarity,
				rarityColor = getRarityColor(name),
			})
		end
	end
	table.sort(list, function(a, b)
		return a.value > b.value
	end)
    local fingerprint = { tostring(#list) }
    for i = 1, #list do
        local entry = list[i]
        fingerprint[#fingerprint + 1] = table.concat({
            entry.key, tostring(entry.value), tostring(entry.iconId),
            tostring(entry.rarity)
        }, "|")
    end
    local signature = table.concat(fingerprint, "\31")
    local changed = (signature ~= lastFeedSignature)
    lastFeedSignature = signature
	latest = list
	return true, changed
end

task.spawn(function()
    while gui.Parent do
        if main.Visible then
            for _, cell in ipairs(rowPool) do
                if cell.frame.Visible and cell.data then
                    local nextText = subText(cell.data)
                    if cell.sub.Text ~= nextText then cell.sub.Text = nextText end
                end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while gui.Parent do
        local ok, changed = fetchPets()
        statusLabel.Text = ok and "Connected" or "Disconnected"
        indicator.BackgroundColor3 = ok and Color3.fromRGB(119, 222, 172) or ACCENT_HI
        if ok and changed then render() end
        task.wait(REFRESH_INTERVAL)
    end
end)