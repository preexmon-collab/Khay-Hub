-- ZENHUB | VIOLET & WHITE | V4 READABILITY + RESPONSIVE GUI
-- Rework window detection, lower-page colors, text legibility and mobile layout.
-- Feature URLs, existing buttons and upstream feature callbacks are retained.
-- Original remote feature engine remains untouched. This file customizes the front end.
-- Before running any remote game script, review the dependency URLs below.
-- Original game automation is retained. The visible UI is rebranded below.
-- Upstream source URLs are functional dependencies, not displayed hub names.

local ZEN_DEPENDENCY_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "ZenHub_AutoRun.lua"
local LANG_SAVE_FILE = "ZenHub_Lang.txt"

local ZEN_CORE_PAYLOAD = [===[
-- ZenHub violet/white front end, modern lightweight cards and responsive borders.
local ZEN_ENV = (getgenv and getgenv()) or _G
-- A different version may already have started in this Roblox session.
-- Allow an upgraded theme pass but do not reload the feature engine.
local ZEN_THEME_REVISION = 4
if ZEN_ENV.__ZenHubAirThemeRunning
    and ZEN_ENV.__ZenHubAirThemeRevision == ZEN_THEME_REVISION then
    return
end
ZEN_ENV.__ZenHubAirThemeRunning = true
ZEN_ENV.__ZenHubAirThemeRevision = ZEN_THEME_REVISION

local NEW_TITLE = "ZenHub"
local LOGO_BG_COLOR = Color3.fromRGB(105, 59, 196)
local ISLAND_WHITE_BG = Color3.fromRGB(255, 255, 255)

local ZEN_DEPENDENCY_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "ZenHub_AutoRun.lua"
local LANG_SAVE_FILE = "ZenHub_Lang.txt"

-- ==================== 1. BỘ CHẶN TELEPORT TUYỆT ĐỐI (100% CHỈ CHẠY ZENHUB) ====================
do
    local env = (getgenv and getgenv()) or _G
    local realQueue = env.__ZENOrigQueue
        or env.queue_on_teleport
        or env.queueonteleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (delta and delta.queue_on_teleport)

    -- Đoạn mã tự chạy khi vào Server mới: Đợi game tải xong rồi chạy ZenHub của bạn
    local teleportBootstrap = string.format([[
        --ZEN_HUB_AUTHORIZED_TELEPORT--
        task.spawn(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            local Players = game:GetService("Players")
            while not Players.LocalPlayer do
                task.wait(0.1)
            end
            task.wait(1.0)
            local executed = false
            if isfile and readfile and isfile("%s") then
                local ok, fn = pcall(function() return loadstring(readfile("%s")) end)
                if ok and type(fn) == "function" then
                    executed = true
                    task.spawn(fn)
                end
            end
            if not executed then
                -- Never load the unrelated upstream Chilli UI as a fallback.
                warn("[ZEN] Saved AutoRun is unavailable. Relaunch the ZEN script manually.")
            end
        end)
    ]], AUTO_RUN_FILE, AUTO_RUN_FILE)

    if realQueue then
        env.__ZENOrigQueue = realQueue

        -- Bất kỳ script nào (kể cả Venyx đã mã hóa) gọi queue_on_teleport đều bị ép đổi thành ZenHub!
        local function forceZENQueue(scriptCode)
            local codeStr = tostring(scriptCode or "")
            if codeStr:find("ZEN_HUB_AUTHORIZED_TELEPORT", 1, true) then
                return realQueue(scriptCode)
            end
            return realQueue(teleportBootstrap)
        end

        -- 1. Ghi đè trên toàn bộ bảng môi trường
        env.queue_on_teleport = forceZENQueue
        env.queueonteleport = forceZENQueue
        pcall(function() getfenv(0).queue_on_teleport = forceZENQueue end)
        pcall(function() getfenv(0).queueonteleport = forceZENQueue end)
        if syn then pcall(function() syn.queue_on_teleport = forceZENQueue end) end
        if fluxus then pcall(function() fluxus.queue_on_teleport = forceZENQueue end) end
        if delta then pcall(function() delta.queue_on_teleport = forceZENQueue end) end

        -- 2. Hook trực tiếp C-Closure nếu Executor hỗ trợ hookfunction
        if hookfunction and not env.__ZENHookFuncDone then
            env.__ZENHookFuncDone = true
            pcall(function()
                local oldHook
                oldHook = hookfunction(realQueue, function(code)
                    local s = tostring(code or "")
                    if s:find("ZEN_HUB_AUTHORIZED_TELEPORT", 1, true) then
                        return oldHook(code)
                    end
                    return oldHook(teleportBootstrap)
                end)
            end)
        end

        -- 3. Vô hiệu hóa clearteleportqueue để Venyx không thể xóa hàng đợi của bạn
        local noop = function() end
        env.clearteleportqueue = noop
        env.clear_teleport_queue = noop
        if syn then pcall(function() syn.clear_teleport_queue = noop end) end
        if fluxus then pcall(function() fluxus.clear_teleport_queue = noop end) end

        -- 4. Nạp ngay ZenHub vào hàng đợi Teleport
        pcall(function()
            realQueue(teleportBootstrap)
        end)

        -- The ZEN bootstrap is queued above once; do not disable or requeue
        -- unrelated OnTeleport connections (doing so can break game features).
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Build a DENSE list: an unavailable gethui() at index 1 previously made
-- ipairs stop before CoreGui/PlayerGui, leaving the gray legacy GUI untouched.
local scanRoots = {}
local function addScanRoot(root)
    if not root then return end
    for _, existing in ipairs(scanRoots) do
        if existing == root then return end
    end
    table.insert(scanRoots, root)
end
if type(gethui) == "function" then
    local ok, hiddenRoot = pcall(gethui)
    if ok then addScanRoot(hiddenRoot) end
end
addScanRoot(CoreGui)
addScanRoot(LocalPlayer:WaitForChild("PlayerGui"))

local IGNORED_GUI_NAMES = {
    ["RobloxGui"] = true, ["TopBarApp"] = true, ["TouchGui"] = true,
    ["Chat"] = true, ["BubbleChat"] = true, ["Freecam"] = true,
    ["BackpackGui"] = true, ["PlayerList"] = true, ["PurchasePrompt"] = true
}

-- ZenHub Air palette: clean white canvas, plum-violet navigation and lilac controls.
-- Everything is flat: no neon, flashing gradients, or UI input overlays.
local ZEN_THEME = {
    Back = Color3.fromRGB(248, 246, 253),         -- warm-white app background
    Rail = Color3.fromRGB(79, 45, 145),           -- signature solid violet rail
    Header = Color3.fromRGB(255, 255, 255),       -- bright top bar
    Panel = Color3.fromRGB(255, 255, 255),        -- card background
    Surface = Color3.fromRGB(250, 248, 254),      -- secondary card background
    Control = Color3.fromRGB(243, 239, 251),      -- pale-lilac controls
    Active = Color3.fromRGB(114, 65, 201),        -- selected state
    Accent = Color3.fromRGB(121, 70, 213),        -- ZenHub violet
    AccentHover = Color3.fromRGB(91, 46, 175),   -- dark-violet brand ink
    Border = Color3.fromRGB(219, 208, 239),      -- delicate violet border
    StrokeMuted = Color3.fromRGB(233, 226, 245), -- barely visible card outline
    Text = Color3.fromRGB(41, 32, 62),           -- ink for white surfaces
    Muted = Color3.fromRGB(111, 100, 131),       -- supporting text
    Subtle = Color3.fromRGB(145, 134, 161),      -- placeholders
    Knob = Color3.fromRGB(255, 255, 255),        -- toggle handle
    OnAccent = Color3.fromRGB(255, 255, 255),    -- lettering on violet
    RailMuted = Color3.fromRGB(228, 217, 250),  -- muted lettering on violet rail
}

-- ==================== 2. BỘ TẠO FPS ẢO (85 - 120 FPS) BẤT TỬ ====================
local currentFakeFps = math.random(96, 112)
local lastFpsStepClock = 0
local TrackedFpsLabels = {}

local function getSmoothFakeFps()
    local now = os.clock()
    if now - lastFpsStepClock >= 0.65 then
        lastFpsStepClock = now
        local delta = math.random(-4, 4)
        currentFakeFps = math.clamp(currentFakeFps + delta, 85, 120)
    end
    return currentFakeFps
end

local function isFpsCounterText(str)
    if type(str) ~= "string" or str == "" then return false end
    return str:find("FPS", 1, true) ~= nil and str:find("ms", 1, true) ~= nil and str:find("%d+%s*FPS") ~= nil
end

local function forceUpdateFpsLabel(lbl)
    if not (lbl and lbl.Parent) then return end
    if lbl:GetAttribute("__UpdatingFps") then return end
    local raw = lbl.Text
    if not isFpsCounterText(raw) then return end

    local fakeVal = getSmoothFakeFps()
    local patched = raw:gsub("%d+%s*FPS", tostring(fakeVal) .. " FPS", 1)
    if raw ~= patched then
        lbl:SetAttribute("__UpdatingFps", true)
        lbl.Text = patched
        lbl:SetAttribute("__UpdatingFps", false)
    end
end

local function hookFakeFpsCounter(lbl)
    if not (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return end
    TrackedFpsLabels[lbl] = true
    forceUpdateFpsLabel(lbl)

    if not lbl:GetAttribute("__FpsHooked") then
        lbl:SetAttribute("__FpsHooked", true)
        lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if not lbl:GetAttribute("__UpdatingFps") then
                forceUpdateFpsLabel(lbl)
            end
        end)
    end
end

-- Vòng lặp duy trì FPS ảo 85-120 xuyên suốt toàn bộ phiên chơi
if not ZEN_ENV.__ZENFpsDaemon then
    ZEN_ENV.__ZENFpsDaemon = true
    task.spawn(function()
        while true do
            task.wait(0.5)
            getSmoothFakeFps()
            for lbl in pairs(TrackedFpsLabels) do
                if lbl and lbl.Parent then
                    forceUpdateFpsLabel(lbl)
                else
                    TrackedFpsLabels[lbl] = nil
                end
            end
        end
    end)
end

-- ==================== 3. HỆ THỐNG TỪ ĐIỂN DỊCH THUẬT 3 TẦNG (100% TIẾNG VIỆT) ====================
local currentLanguage = "EN"
pcall(function()
    currentLanguage = "EN"
    if writefile then writefile(LANG_SAVE_FILE, "EN") end
end)

local FastCache = {}
local TrackedTexts = {}
local GlobalRefreshIslandStatus = nil

local EXACT_MATCH_VI = {
    ["Idle"] = "Đang rảnh",
    ["Waiting"] = "Đang chờ",
    ["Nothing"] = "Không có gì",
    ["No egg matches your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No eggs match your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No egg matches filter"] = "Không có trứng khớp bộ lọc",
    ["No eggs match filter"] = "Không có trứng khớp bộ lọc",
    ["No target egg found"] = "Không tìm thấy trứng mục tiêu",
    ["No matching eggs"] = "Không có trứng nào khớp",
    ["No matching pets"] = "Không có pet nào khớp",
    ["No valid targets"] = "Không có mục tiêu hợp lệ",
    ["No targets found"] = "Không tìm thấy mục tiêu",
    ["Bag is full"] = "Túi đã đầy",
    ["Egg bag is full"] = "Túi trứng đã đầy",
    ["Pet bag is full"] = "Túi pet đã đầy",
    ["Pen is full"] = "Chuồng ấp đã đầy",
    ["All pens are full"] = "Tất cả chuồng đã đầy",
    ["Field is closed"] = "Sân trứng đang đóng",
    ["Waiting for field to open"] = "Đang chờ sân trứng mở",
    ["Waiting for eggs to spawn"] = "Đang chờ trứng xuất hiện",
    ["Waiting for next race"] = "Đang chờ chặng đua tiếp theo",
    ["Waiting for shooting star"] = "Đang chờ sao băng rơi",
    ["Waiting for butterfly bloom"] = "Đang chờ mùa bướm nở",
    ["Waiting in safe zone"] = "Đợi ở vùng an toàn",
    ["Returning to safe zone"] = "Đang về vùng an toàn",
    ["Returning home"] = "Đang quay về nhà",
    ["Going home"] = "Đang về nhà",
    ["Going to safe zone"] = "Đang về vùng an toàn",
    ["Delivering egg"] = "Đang giao trứng về chuồng",
    ["Dropping egg"] = "Đang thả trứng",
    ["Dropping eggs"] = "Đang thả trứng",
    ["Selling eggs"] = "Đang bán trứng",
    ["Selling pets"] = "Đang bán pet",
    ["Selling lab eggs"] = "Đang bán trứng Lab",
    ["Hatching eggs"] = "Đang ấp trứng",
    ["Placing eggs"] = "Đang đặt trứng",
    ["Mutating eggs"] = "Đang đột biến trứng",
    ["Fusing pets"] = "Đang dung hợp pet",
    ["Hopping server"] = "Đang đổi máy chủ",
    ["Finding server"] = "Đang tìm máy chủ mới",
    ["Rejoining"] = "Đang vào lại phòng",
    ["Avoiding guard"] = "Đang né vệ sĩ",
    ["Evading guard"] = "Đang né vệ sĩ",
    ["Using treadmill"] = "Đang chạy máy tập",
    ["Upgrading treadmill"] = "Đang nâng cấp máy tập",
    ["Upgrading base"] = "Đang nâng cấp căn cứ",
    ["Claiming rewards"] = "Đang nhận thưởng",
    ["Claiming offline cash"] = "Đang nhận tiền ngoại tuyến",
    ["Catching shooting star"] = "Đang bắt sao băng",
    ["Catching butterfly"] = "Đang bắt bướm",
    ["Joining race"] = "Đang vào đường đua",
    ["Racing"] = "Đang đua xe",

    -- Trang Home & Dashboard Mới
    ["Home"] = "Trang Chủ",
    ["Dashboard"] = "Bảng Điều Khiển",
    ["Welcome back"] = "Chào mừng trở lại",
    ["Venyx Discord"] = "ZenHub Discord",
    ["Updates, keys, support"] = "Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"] = "Chép Link Mời",
    ["Discord"] = "Discord",
    ["MONEY /S"] = "TIỀN /GIÂY",
    ["OPEN"] = "MỞ",
    ["Open"] = "Mở",
    ["Close"] = "Đóng",
    ["Welcome to Venyx 1.0.0! Join our Discord for updates and support"] = "Chào mừng tới ZenHub! Tham gia Discord để cập nhật và nhận hỗ trợ",
    ["Beta version"] = "Phiên bản Beta",
    ["This is a test build. Features may change and bugs can happen."] = "Đây là bản thử nghiệm. Tính năng có thể thay đổi và phát sinh lỗi.",
    ["Rejoin"] = "Vào lại",
    ["Server hop"] = "Đổi server",
    ["Copy Job ID"] = "Chép Job ID",
    ["Unload hub"] = "Tắt Hub",
    ["Save config"] = "Lưu cấu hình",
    ["Hide UI"] = "Ẩn Menu",
    ["SESSION"] = "PHIÊN CHƠI",
    ["STOLEN"] = "ĐÃ CƯỚP",
    ["LAST EGG"] = "TRỨNG CUỐI",
    ["PLACED"] = "ĐÃ ĐẶT",
    ["HATCHED"] = "ĐÃ ẤP",
    ["NIGHT IN"] = "ĐÊM SAU",
    ["SESSION TIME"] = "THỜI GIAN",
    ["BEST STEAL"] = "CƯỚP TỐT NHẤT",
    ["EGG BAG"] = "TÚI TRỨNG",
    ["PET BAG"] = "TÚI PET",
    ["WHAT'S NEW"] = "CÓ GÌ MỚI",
    ["NEW"] = "MỚI",
    ["Event"] = "Sự Kiện",
    ["Racing Event: ragdoll jump to the portal, races, leaves and claims"] = "Sự Kiện Đua Xe: tự nhảy vào cổng, đua, rời đi và nhận thưởng",
    ["Shooting Star catcher with ragdoll jump and run fallback"] = "Bắt Sao Băng kết hợp nhảy ragdoll và chạy dự phòng",
    ["Steal panel joins the game buttons and lists every egg"] = "Bảng Cướp tích hợp nút game và liệt kê mọi quả trứng",
    ["Search"] = "Tìm kiếm",
    ["Filter"] = "Lọc tìm",

    -- Steal & Egg Predictor
    ["Steal"] = "Cướp Trứng",
    ["Auto Steal"] = "Tự Động Cướp",
    ["AUTO STEAL"] = "TỰ ĐỘNG CƯỚP",
    ["Auto steal"] = "Tự động cướp",
    ["Egg Predictor"] = "Dự Đoán Trứng",
    ["EGG PREDICTOR"] = "DỰ ĐOÁN TRỨNG",
    ["Go to egg"] = "Di chuyển tới trứng",
    ["Teleport to egg"] = "Dịch chuyển tới trứng",
    ["Teleport zones"] = "Khu vực dịch chuyển",
    ["Teleport zone"] = "Khu vực dịch chuyển",
    ["Tween"] = "Bay (Tween)",
    ["Walk"] = "Đi bộ",
    ["Delivery method"] = "Cách mang về",
    ["Fast tween speed"] = "Tốc độ bay nhanh",
    ["Tween speed"] = "Tốc độ bay",
    ["Steal missing index eggs"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal back from players"] = "Cướp lại từ người chơi",
    ["Steal from other players"] = "Cướp từ người chơi khác",
    ["Steal from players"] = "Cướp từ người chơi",
    ["Anti guard"] = "Chống vệ sĩ",
    ["Drop eggs at safe zone"] = "Thả trứng ở vùng an toàn",
    ["FILTER"] = "BỘ LỌC",
    ["Zones"] = "Khu vực",
    ["Zone"] = "Khu vực",
    ["None"] = "Không có",
    ["Steal first"] = "Ưu tiên cướp",
    ["Best value"] = "Giá trị cao nhất",
    ["Lowest value"] = "Giá trị thấp nhất",
    ["Best rarity"] = "Độ hiếm cao nhất",
    ["Best mutation"] = "Đột biến tốt nhất",
    ["Biggest"] = "Kích thước to nhất",
    ["Closest"] = "Khoảng cách gần nhất",
    ["Mutations"] = "Đột biến",
    ["Rarities"] = "Độ hiếm",
    ["Only these eggs"] = "Chỉ những trứng này",
    ["Min value /s"] = "Giá trị tối thiểu /s",
    ["Max value /s"] = "Giá trị tối đa /s",
    ["Off"] = "Tắt",
    ["OFF"] = "TẮT",
    ["On"] = "Bật",
    ["ON"] = "BẬT",
    ["Sell cheapest egg when bag is full"] = "Bán trứng rẻ nhất khi đầy túi",
    ["Keep lab eggs"] = "Giữ lại trứng Lab",
    ["AUTO HOP SERVER"] = "TỰ ĐỔI MÁY CHỦ",
    ["Auto hop server"] = "Tự đổi máy chủ",
    ["Hop when no matching egg"] = "Đổi server khi không có trứng khớp",
    ["Hop when no egg matches"] = "Đổi server khi không có trứng khớp",
    ["Hop delay"] = "Độ trễ đổi server",
    ["Only sell eggs below /s"] = "Chỉ bán trứng dưới mức /s",
    ["EGG SHOWCASE"] = "TRƯNG BÀY TRỨNG",
    ["Sort eggs"] = "Sắp xếp trứng",
    ["Preview card"] = "Thẻ xem trước",
    ["Pick one"] = "Chọn một mục",
    ["Pick any"] = "Chọn bất kỳ",
    ["Value"] = "Giá trị",
    ["Rarity"] = "Độ hiếm",
    ["Time left"] = "Thời gian còn lại",
    ["Default"] = "Mặc định",
    ["Clear"] = "Xóa chọn",
    ["Select all"] = "Chọn tất cả",
    ["SIZE"] = "KÍCH CỠ",
    ["WEIGHT"] = "CÂN NẶNG",
    ["READY"] = "SẴN SÀNG",
    ["IN BAG"] = "TRONG TÚI",
    ["GROWING"] = "ĐANG LỚN",
    ["Hatch now"] = "Ấp ngay",
    ["Hold egg"] = "Cầm trứng",
    ["Fly to egg"] = "Bay tới trứng",
    ["Steal egg"] = "Cướp trứng",

    -- Zones (Khu vực)
    ["Enchanted Forest"] = "Rừng Phù Phép",
    ["Light Dark"] = "Sáng Tối",
    ["Titan Temple"] = "Đền Titan",
    ["Cherry Blossom"] = "Hoa Anh Đào",
    ["Prehistoric"] = "Tiền Sử",
    ["Abyss Ocean"] = "Đáy Đại Dương",
    ["Volcano"] = "Núi Lửa",
    ["Snow"] = "Tuyết",
    ["Jungle"] = "Rừng Rậm",
    ["Desert"] = "Sa Mạc",
    ["Lake"] = "Hồ Nước",
    ["Forest"] = "Khu Rừng",

    -- Mutations (Đột biến)
    ["Silver"] = "Bạc",
    ["Rainbow"] = "Cầu Vồng",
    ["Golden"] = "Vàng",
    ["Fractured"] = "Rạn Nứt",
    ["Scrambled"] = "Hỗn Loạn",
    ["Enchanted"] = "Phù Phép",
    ["Nitro"] = "Nitro",
    ["SCRAMBLED"] = "HỖN LOẠN",
    ["NITRO"] = "NITRO",
    ["FRACTURED"] = "RẠN NỨT",
    ["ENCHANTED"] = "PHÙ PHÉP",

    -- Farm: Pen, Treadmill, Mutate, Sell, Fuse, Priority
    ["Farm"] = "Cày Cuốc",
    ["Pen"] = "Chuồng Ấp",
    ["PEN"] = "CHUỒNG ẤP",
    ["Treadmill"] = "Máy Tập",
    ["TREADMILL"] = "MÁY TẬP CHẠY",
    ["Mutate"] = "Đột Biến",
    ["MUTATE"] = "ĐỘT BIẾN",
    ["Sell"] = "Bán",
    ["SELL"] = "BÁN TỰ ĐỘNG",
    ["Fuse"] = "Dung Hợp",
    ["FUSE"] = "DUNG HỢP",
    ["Priority"] = "Ưu Tiên",
    ["PRIORITY"] = "THỨ TỰ ƯU TIÊN",
    ["AUTO PLACE"] = "TỰ ĐỘNG ĐẶT TRỨNG",
    ["Auto place"] = "Tự động đặt trứng",
    ["Place when"] = "Đặt khi",
    ["Always"] = "Luôn luôn",
    ["Place first"] = "Ưu tiên đặt",
    ["AUTO HATCH"] = "TỰ ĐỘNG ẤP TRỨNG",
    ["Auto hatch"] = "Tự động ấp trứng",
    ["Equip best pets"] = "Trang bị pet mạnh nhất",
    ["READY NOW"] = "SẴN SÀNG ẤP",
    ["Auto treadmill"] = "Tự chạy máy tập",
    ["Auto upgrade treadmill"] = "Tự nâng cấp máy tập",
    ["PROGRESS"] = "TIẾN TRÌNH",
    ["Auto upgrade base"] = "Tự nâng cấp căn cứ",
    ["Auto buy trails"] = "Tự mua vệt sáng",
    ["Auto claim offline cash"] = "Tự nhận tiền ngoại tuyến",
    ["Auto claim index rewards"] = "Tự nhận thưởng Chỉ mục",
    ["AUTO MUTATE"] = "TỰ ĐỘNG ĐỘT BIẾN",
    ["Auto mutate"] = "Tự động đột biến",
    ["MUTATE FILTER"] = "BỘ LỌC ĐỘT BIẾN",
    ["Use items"] = "Dùng vật phẩm",
    ["Mutate first"] = "Ưu tiên đột biến",
    ["Auto buy Nitro"] = "Tự mua Nitro",
    ["PETS"] = "THÚ CƯNG (PETS)",
    ["EGGS"] = "TRỨNG (EGGS)",
    ["Auto sell pets"] = "Tự động bán pet",
    ["Auto sell eggs"] = "Tự động bán trứng",
    ["Sell rarities"] = "Độ hiếm bán",
    ["Never sell"] = "Không bao giờ bán",
    ["Only mutations"] = "Chỉ bán đột biến",
    ["Only below /s"] = "Chỉ dưới mức /s",
    ["Keep mutated"] = "Giữ lại đồ đột biến",
    ["Sell matching pets now"] = "Bán các pet khớp ngay",
    ["Sell matching eggs now"] = "Bán các trứng khớp ngay",
    ["LAB EGGS"] = "TRỨNG PHÒNG LAB",
    ["FAVORITE"] = "YÊU THÍCH (KHÓA)",
    ["Auto favorite"] = "Tự động khóa bảo vệ",
    ["Auto sell lab eggs"] = "Tự động bán trứng Lab",
    ["Sell matching lab eggs now"] = "Bán trứng Lab khớp ngay",
    ["Match"] = "Điều kiện khớp",
    ["All picked rules"] = "Khớp tất cả quy tắc",
    ["Any picked rule"] = "Khớp bất kỳ quy tắc",
    ["Always favorite"] = "Luôn khóa loài này",
    ["Favorite equipped"] = "Khóa pet đang trang bị",
    ["FUSE MACHINE"] = "MÁY DUNG HỢP",
    ["No 3 matching pets"] = "Chưa đủ 3 pet cùng loại",
    ["Auto fuse"] = "Tự động dung hợp",
    ["Fuse first"] = "Ưu tiên dung hợp",
    ["Lowest rarity"] = "Độ hiếm thấp nhất",
    ["Highest rarity"] = "Độ hiếm cao nhất",
    ["Use pets"] = "Sử dụng pet",
    ["Lowest value first"] = "Giá trị thấp nhất trước",
    ["Highest value first"] = "Giá trị cao nhất trước",
    ["Skip mutated"] = "Bỏ qua pet đột biến",
    ["Eject odd pets"] = "Đẩy pet lẻ ra ngoài",
    ["FUSE FILTER"] = "BỘ LỌC DUNG HỢP",
    ["Only these pets"] = "Chỉ những pet này",
    ["Never fuse"] = "Không bao giờ dung hợp",
    ["FUSE PREDICTOR"] = "DỰ ĐOÁN DUNG HỢP",
    ["SLOTS"] = "Ô CHỨA",
    ["STATUS"] = "TRẠNG THÁI",
    ["Waiting for pets"] = "Đang chờ pet",
    ["LIKELY SIZE"] = "KÍCH CỠ DỰ KIẾN",
    ["CHANCE"] = "TỶ LỆ",
    ["VALUE"] = "GIÁ TRỊ",
    ["BEST CASE"] = "TỐT NHẤT CÓ THỂ",
    ["TASK ORDER"] = "THỨ TỰ TÁC VỤ",
    ["Top goes first. A carried egg is always delivered first, and before the field opens every task waits in the safe zone."] = "Mục ở trên làm trước. Trứng đang bê luôn được giao trước, và trước khi khu vực mở thì mọi tác vụ sẽ đợi ở vùng an toàn.",
    ["DOING"] = "ĐANG LÀM",
    ["WAITING"] = "ĐANG CHỜ",
    ["Steal filter eggs"] = "Cướp trứng theo bộ lọc",
    ["Shooting Star"] = "Bắt Sao Băng",
    ["Racing Event"] = "Sự Kiện Đua Xe",
    ["Butterfly"] = "Bắt Bướm",
    ["Steal wisp eggs"] = "Cướp trứng Wisp",
    ["Wisp"] = "Nhặt Wisp",
    ["Steal missing index"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal lab eggs"] = "Cướp trứng phòng Lab",
    ["Place"] = "Đặt trứng vào chuồng",
    ["Butterfly machine"] = "Máy đổi Bướm",

    -- Event: Race, Star, Butterfly, Lab, AA
    ["Race"] = "Đua Xe",
    ["RACE"] = "ĐUA XE",
    ["Star"] = "Sao Băng",
    ["STAR"] = "SAO BĂNG",
    ["BUTTERFLY"] = "BẮT BƯỚM",
    ["Lab"] = "Phòng Lab",
    ["LAB"] = "PHÒNG LAB",
    ["AA"] = "Admin (AA)",
    ["RACING EVENT"] = "SỰ KIỆN ĐUA XE",
    ["NEXT RACE"] = "ĐUA TIẾP THEO",
    ["WINS"] = "THẮNG",
    ["TROPHIES"] = "CÚP",
    ["Auto race"] = "Tự động đua xe",
    ["Race speed"] = "Tốc độ đua",
    ["Lower it if wins do not count"] = "Giảm tốc độ nếu thắng không được tính",
    ["Use power-ups"] = "Tự dùng vật phẩm tăng tốc",
    ["REWARDS"] = "PHẦN THƯỞNG",
    ["Auto claim rewards"] = "Tự nhận phần thưởng",
    ["Auto equip racer"] = "Tự trang bị xe đua",
    ["Racer"] = "Xe đua",
    ["Best owned"] = "Tốt nhất đang có",
    ["Auto buy shop"] = "Tự mua vật phẩm Shop",
    ["Shop items"] = "Vật phẩm Shop",
    ["SHOOTING STAR"] = "SAO BĂNG RƠI",
    ["LANDS IN"] = "RƠI SAU",
    ["CATCH"] = "BẮT SAO BĂNG",
    ["A Shooting Star is rare and only you can catch yours. It lands in Cosmic, runs from you, and needs a 1.6 s hold."] = "Sao Băng rất hiếm và chỉ bạn mới bắt được của mình. Nó rơi ở khu Vũ Trụ (Cosmic), chạy trốn bạn và cần nhấn giữ 1.6 giây.",
    ["CAUGHT"] = "ĐÃ BẮT",
    ["EXPIRES IN"] = "BIẾN MẤT SAU",
    ["SLIPPED"] = "TUỘT MẤT",
    ["TRIES"] = "SỐ LẦN THỬ",
    ["DISTANCE"] = "KHOẢNG CÁCH",
    ["Auto catch shooting star"] = "Tự động bắt sao băng",
    ["BUTTERFLY BLOOM"] = "MÙA BƯỚM NỞ",
    ["Auto butterfly bloom"] = "Tự động bắt bướm",
    ["EMERALD"] = "LỤC BẢO",
    ["SAPPHIRE"] = "LAM NGỌC",
    ["AMETHYST"] = "THẠCH ANH TÍM",
    ["RADIANT"] = "RỰC RỠ",
    ["ESSENCE"] = "TINH CHẤT",
    ["Catch mode"] = "Chế độ bắt",
    ["Stand"] = "Đứng yên",
    ["Chase"] = "Đuổi theo",
    ["BUTTERFLY MACHINE"] = "MÁY ĐỔI BƯỚM",
    ["Auto trade up"] = "Tự nâng cấp bậc bướm",
    ["Trade"] = "Giao dịch đổi",
    ["Smart trade for essence"] = "Đổi bướm lấy tinh chất thông minh",
    ["Auto craft essence"] = "Tự chế tạo tinh chất",
    ["WISP COMPANION"] = "ĐỒNG HÀNH WISP",
    ["Catch priority"] = "Ưu tiên bắt",
    ["Rarest"] = "Hiếm nhất",
    ["Catch"] = "Loại bướm bắt",
    ["Radiant"] = "Rực Rỡ",
    ["Catch speed"] = "Tốc độ bắt",
    ["Auto wisp quest"] = "Tự làm nhiệm vụ Wisp",
    ["Auto banjo cricket"] = "Tự bắt dế Banjo",
    ["STAGE"] = "GIAI ĐOẠN",
    ["LAB ODDS"] = "TỶ LỆ PHÒNG LAB",
    ["BANNER"] = "BĂNG RÔN",
    ["ENDS IN"] = "KẾT THÚC SAU",
    ["BANNER CHANCE"] = "TỶ LỆ BĂNG RÔN",
    ["NEXT"] = "TIẾP THEO",
    ["Experimental Pets"] = "Pet Thí Nghiệm",
    ["Biohazard Pets"] = "Pet Sinh Học",
    ["Lab banners"] = "Băng rôn phòng Lab",
    ["Auto trade in"] = "Tự động đổi trứng Lab",
    ["Auto reroll recipe"] = "Tự đổi lại công thức",
    ["Place lab reward eggs"] = "Đặt trứng thưởng từ Lab",
    ["ADMIN ABUSE"] = "LẠM DỤNG ADMIN (ABUSE)",
    ["No admin boost right now"] = "Hiện không có buff Admin nào",
    ["Instant steal (Admin Treadmill)"] = "Cướp tức thì (Máy tập Admin)",
    ["Use admin treadmill"] = "Tự dùng máy tập Admin",
    ["CAPTURE THE EGG"] = "CƯỚP TRỨNG SỰ KIỆN",
    ["Auto capture event egg"] = "Tự bắt trứng sự kiện",
    ["Take it from the holder"] = "Giật trứng từ người đang cầm",
    ["Hold height"] = "Độ cao giữ trứng",
    ["Keep away"] = "Khoảng cách né tránh",
    ["MINIGAME EGGS"] = "TRỨNG MINIGAME",
    ["Waiting for Red Light Green Light or T-Rex Run"] = "Đang chờ Đèn Đỏ Đèn Xanh hoặc Chạy Trốn T-Rex",
    ["Auto steal minigame egg"] = "Tự cướp trứng Minigame",

    -- Player: ESP, Move, Combat
    ["Player"] = "Người Chơi",
    ["ESP"] = "Định Vị (ESP)",
    ["Move"] = "Di Chuyển",
    ["MOVE"] = "DI CHUYỂN",
    ["Combat"] = "Chiến Đấu",
    ["COMBAT"] = "CHIẾN ĐẤU",
    ["FIELD EGGS"] = "TRỨNG NGOÀI SÂN",
    ["Egg ESP"] = "ESP Trứng",
    ["Show"] = "Hiển thị",
    ["Name"] = "Tên",
    ["Fixed size"] = "Cố định kích cỡ",
    ["OTHERS"] = "MỤC KHÁC",
    ["Pen egg ESP"] = "ESP trứng trong chuồng",
    ["Other pens ESP"] = "ESP chuồng người khác",
    ["Guard ESP"] = "ESP Vệ sĩ",
    ["Player ESP"] = "ESP Người chơi",
    ["ESP size"] = "Kích cỡ ESP",
    ["MOVEMENT"] = "TỐC ĐỘ & DI CHUYỂN",
    ["Speed boost"] = "Tăng tốc chạy",
    ["Boost speed"] = "Tốc độ tăng thêm",
    ["Infinite jump"] = "Nhảy vô hạn",
    ["God mode"] = "Bất tử (God mode)",
    ["PROTECTION"] = "BẢO VỆ NHÂN VẬT",
    ["Anti ragdoll"] = "Chống ngã (Anti Ragdoll)",
    ["Ignore traps"] = "Bỏ qua bẫy",
    ["Instant prompts"] = "Tương tác nhấn giữ tức thì",
    ["Anti AFK"] = "Chống treo máy (Anti AFK)",
    ["Invisible"] = "Tàng hình",
    ["AUTO HIT"] = "TỰ ĐỘNG ĐÁNH",
    ["Auto hit"] = "Tự động đánh",
    ["Hit who"] = "Mục tiêu đánh",
    ["Nearest player"] = "Người chơi gần nhất",
    ["Chosen player"] = "Người chơi chỉ định",
    ["Chase speed"] = "Tốc độ đuổi theo",
    ["HIT AURA"] = "VÒNG ĐÁNH TỰ ĐỘNG",
    ["Hit aura"] = "Vòng đánh tự động (Hit Aura)",
    ["Skip friends"] = "Bỏ qua bạn bè",
    ["WEAPONS"] = "VŨ KHÍ",
    ["Use weapons"] = "Sử dụng vũ khí",
    ["Hold each"] = "Thời gian cầm mỗi món",

    -- System: Server, Webhook, Optimizer, Interface, Config
    ["System"] = "Hệ Thống",
    ["Server"] = "Máy Chủ",
    ["SERVER"] = "MÁY CHỦ",
    ["Webhook"] = "Webhook",
    ["WEBHOOK"] = "WEBHOOK",
    ["Optimizer"] = "Tối Ưu Hóa",
    ["OPTIMIZER"] = "TỐI ƯU HÓA (GIẢM LAG)",
    ["Interface"] = "Giao Diện",
    ["INTERFACE"] = "GIAO DIỆN",
    ["Config"] = "Cấu Hình",
    ["CONFIG"] = "CẤU HÌNH",
    ["Hop to"] = "Chuyển tới server",
    ["Least players"] = "Ít người chơi nhất",
    ["Most players"] = "Đông người chơi nhất",
    ["Random"] = "Ngẫu nhiên",
    ["Hop server"] = "Đổi máy chủ",
    ["Hop"] = "Đổi ngay",
    ["Rejoin this server"] = "Vào lại máy chủ này",
    ["Copy"] = "Sao chép",
    ["JOIN AND STAY"] = "VÀO PHÒNG & DUY TRÌ",
    ["Job ID"] = "Mã phòng (Job ID)",
    ["Paste a Job ID"] = "Dán mã Job ID vào đây",
    ["Join that server"] = "Vào máy chủ đó",
    ["Join"] = "Vào ngay",
    ["Rejoin on kick"] = "Tự vào lại khi bị văng/kick",
    ["Auto load script"] = "Tự chạy lại script khi chuyển server",
    ["DISCORD WEBHOOK"] = "WEBHOOK DISCORD",
    ["Webhook URL"] = "Đường dẫn Webhook",
    ["Ping everyone"] = "Tag @everyone",
    ["WHAT TO POST"] = "NỘI DUNG GỬI BÁO CÁO",
    ["Post stolen eggs"] = "Báo cáo trứng cướp được",
    ["Post fused eggs"] = "Báo cáo trứng dung hợp",
    ["POSTED"] = "ĐÃ GỬI",
    ["Send a test post"] = "Gửi tin nhắn thử nghiệm",
    ["Test"] = "Thử nghiệm",
    ["Post when bag is full"] = "Gửi thông báo khi đầy túi",
    ["GRAPHICS"] = "ĐỒ HỌA",
    ["Low graphics"] = "Đồ họa thấp (Tăng FPS)",
    ["Disable 3D Render"] = "Tắt kết xuất 3D (Treo máy)",
    ["Background color"] = "Màu nền màn hình",
    ["Black"] = "Màu Đen",
    ["White"] = "Màu Trắng",
    ["Hide game UI"] = "Ẩn giao diện gốc của Game",
    ["FRAME RATE"] = "TỐC ĐỘ KHUNG HÌNH (FPS)",
    ["FPS cap"] = "Giới hạn FPS",
    ["Show FPS and ping"] = "Hiện chỉ số FPS và Ping",
    ["BASES"] = "CĂN CỨ (BASES)",
    ["Hide other players' pets and eggs"] = "Ẩn pet và trứng của người chơi khác",
    ["Hide my pets and eggs"] = "Ẩn pet và trứng của bản thân",
    ["Theme"] = "Chủ đề màu",
    ["Toggle key"] = "Phím đóng/mở Menu",
    ["Quick bar"] = "Thanh phím tắt nhanh",
    ["QUICK BAR"] = "THANH PHÍM TẮT NHANH",
    ["Auto save"] = "Tự động lưu cấu hình",
    ["Auto load"] = "Tự động nạp cấu hình",
    ["Load config"] = "Nạp cấu hình",
    ["Reset config"] = "Đặt lại mặc định",
    ["Delete config"] = "Xóa cấu hình",

    -- Độ hiếm
    ["Common"] = "Phổ Thông",
    ["Uncommon"] = "Thường",
    ["Rare"] = "Hiếm",
    ["Epic"] = "Sử Thi",
    ["Legendary"] = "Huyền Thoại",
    ["Mythic"] = "Thần Thoại",
    ["Cosmic"] = "Vũ Trụ",
    ["Secret"] = "Bí Ẩn",
    ["Divine"] = "Thánh Thần",
    ["Eternal"] = "Vĩnh Cửu",
    ["COMMON"] = "PHỔ THÔNG",
    ["UNCOMMON"] = "THƯỜNG",
    ["RARE"] = "HIẾM",
    ["EPIC"] = "SỬ THI",
    ["LEGENDARY"] = "HUYỀN THOẠI",
    ["MYTHIC"] = "THẦN THOẠI",
    ["COSMIC"] = "VŨ TRỤ",
    ["SECRET"] = "BÍ ẨN",
    ["DIVINE"] = "THÁNH THẦN",
    ["ETERNAL"] = "VĨNH CỬU"
}

local STATUS_ACTION_PATTERNS_VI = {
    { pat = "^[Nn]o eggs? match%(?e?s?%)? your (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o eggs? match%(?e?s?%)? (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o pets? match%(?e?s?%)? (.+)$", rep = "Không có pet nào khớp %1" },
    { pat = "^[Nn]o (.+) found$", rep = "Không tìm thấy %1" },
    { pat = "^[Nn]o (.+) available$", rep = "Không có sẵn %1" },
    { pat = "^[Nn]o (.+) to (.+)$", rep = "Không có %1 để %2" },
    { pat = "^[Cc]arrying (.+) to safe zone$", rep = "Đang mang %1 về vùng an toàn" },
    { pat = "^[Cc]arrying (.+) to base$", rep = "Đang mang %1 về căn cứ" },
    { pat = "^[Cc]arrying (.+) to pen$", rep = "Đang mang %1 về chuồng" },
    { pat = "^[Cc]arrying (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Cc]arrying (.+)$", rep = "Đang bê %1" },
    { pat = "^[Dd]elivering (.+) to (.+)$", rep = "Đang giao %1 tới %2" },
    { pat = "^[Dd]elivering (.+) home$", rep = "Đang giao %1 về nhà" },
    { pat = "^[Dd]elivering (.+)$", rep = "Đang giao %1" },
    { pat = "^[Bb]ringing (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Bb]ringing (.+)$", rep = "Đang mang %1" },
    { pat = "^[Tt]aking (.+) from (.+)$", rep = "Đang giật %1 từ %2" },
    { pat = "^[Tt]aking (.+) home$", rep = "Đang đem %1 về nhà" },
    { pat = "^[Tt]aking (.+)$", rep = "Đang lấy %1" },
    { pat = "^[Ss]tealing (.+) from (.+)$", rep = "Đang cướp %1 từ %2" },
    { pat = "^[Ss]tealing (.+)$", rep = "Đang cướp %1" },
    { pat = "^[Gg]rabbing (.+)$", rep = "Đang chộp lấy %1" },
    { pat = "^[Pp]icking up (.+)$", rep = "Đang nhặt %1" },
    { pat = "^[Cc]ollecting (.+)$", rep = "Đang thu thập %1" },
    { pat = "^[Hh]olding (.+)$", rep = "Đang giữ %1" },
    { pat = "^[Cc]apturing (.+)$", rep = "Đang bắt giữ %1" },
    { pat = "^[Dd]ropping (.+) at (.+)$", rep = "Đang thả %1 tại %2" },
    { pat = "^[Dd]ropping (.+)$", rep = "Đang thả %1" },
    { pat = "^[Tt]weening to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Tt]eleporting to (.+)$", rep = "Đang dịch chuyển tới %1" },
    { pat = "^[Gg]oing to (.+)$", rep = "Đang đi tới %1" },
    { pat = "^[Mm]oving to (.+)$", rep = "Đang di chuyển tới %1" },
    { pat = "^[Ww]alking to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Rr]unning to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Ff]lying to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Rr]eturning to (.+)$", rep = "Đang quay về %1" },
    { pat = "^[Hh]eading to (.+)$", rep = "Đang hướng tới %1" },
    { pat = "^[Pp]lacing (.+)$", rep = "Đang đặt %1" },
    { pat = "^[Hh]atching (.+)$", rep = "Đang ấp %1" },
    { pat = "^[Mm]utating (.+)$", rep = "Đang đột biến %1" },
    { pat = "^[Ss]elling (.+)$", rep = "Đang bán %1" },
    { pat = "^[Ff]using (.+)$", rep = "Đang dung hợp %1" },
    { pat = "^[Uu]pgrading (.+)$", rep = "Đang nâng cấp %1" },
    { pat = "^[Bb]uying (.+)$", rep = "Đang mua %1" },
    { pat = "^[Cc]laiming (.+)$", rep = "Đang nhận %1" },
    { pat = "^[Ee]quipping (.+)$", rep = "Đang trang bị %1" },
    { pat = "^[Ff]avoriting (.+)$", rep = "Đang khóa bảo vệ %1" },
    { pat = "^[Ee]jecting (.+)$", rep = "Đang đẩy %1 ra" },
    { pat = "^[Cc]atching (.+)$", rep = "Đang bắt %1" },
    { pat = "^[Cc]hasing (.+)$", rep = "Đang đuổi theo %1" },
    { pat = "^[Aa]ttacking (.+)$", rep = "Đang tấn công %1" },
    { pat = "^[Hh]itting (.+)$", rep = "Đang đánh %1" },
    { pat = "^[Kk]illing (.+)$", rep = "Đang hạ %1" },
    { pat = "^[Tt]rading (.+) for (.+)$", rep = "Đang đổi %1 lấy %2" },
    { pat = "^[Tt]rading in (.+)$", rep = "Đang đổi %1" },
    { pat = "^[Tt]rading (.+)$", rep = "Đang giao dịch %1" },
    { pat = "^[Cc]rafting (.+)$", rep = "Đang chế tạo %1" },
    { pat = "^[Rr]erolling (.+)$", rep = "Đang đổi lại %1" },
    { pat = "^[Aa]voiding (.+)$", rep = "Đang né %1" },
    { pat = "^[Ee]vading (.+)$", rep = "Đang tránh %1" },
    { pat = "^[Ww]aiting for (.+)$", rep = "Đang chờ %1" },
    { pat = "^[Ww]aiting in (.+)$", rep = "Đang đợi ở %1" },
    { pat = "^[Ww]aiting %((.+)%)$", rep = "Đang chờ (%1)" },
    { pat = "^[Ss]earching for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ll]ooking for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ff]arming (.+)$", rep = "Đang cày %1" },
    { pat = "^[Uu]sing (.+)$", rep = "Đang dùng %1" },
    { pat = "^[Jj]oining (.+)$", rep = "Đang tham gia %1" },
    { pat = "^[Hh]opping (.+)$", rep = "Đang đổi %1" }
}

local SMART_PHRASE_FALLBACK_VI = {
    { "No egg matches your targets", "Không có trứng nào khớp mục tiêu" },
    { "no egg matches your targets", "không có trứng nào khớp mục tiêu" },
    { "your targets", "mục tiêu của bạn" },
    { "matches your", "khớp với" },
    { "matches filter", "khớp bộ lọc" },
    { "safe zone", "vùng an toàn" },
    { "other players", "người chơi khác" },
    { "from players", "từ người chơi" },
    { "missing index", "thiếu trong Chỉ mục" },
    { "shooting star", "sao băng" },
    { "butterfly bloom", "mùa bướm nở" },
    { "admin treadmill", "máy tập Admin" },
    { "offline cash", "tiền ngoại tuyến" },
    { "index rewards", "thưởng Chỉ mục" },
    { "lab eggs", "trứng Lab" },
    { "lab egg", "trứng Lab" },
    { "event egg", "trứng sự kiện" },
    { "minigame egg", "trứng Minigame" },
    { "is full", "đã đầy" },
    { "is closed", "đang đóng" },
    { "is open", "đang mở" },
    { "to open", "mở cửa" },
    { "Carrying ", "Đang mang " },
    { "Delivering ", "Đang giao " },
    { "Stealing ", "Đang cướp " },
    { "Teleporting ", "Đang dịch chuyển " },
    { "Tweening ", "Đang bay " },
    { "Moving ", "Đang di chuyển " },
    { "Walking ", "Đang đi bộ " },
    { "Running ", "Đang chạy " },
    { "Placing ", "Đang đặt " },
    { "Hatching ", "Đang ấp " },
    { "Mutating ", "Đang đột biến " },
    { "Selling ", "Đang bán " },
    { "Fusing ", "Đang dung hợp " },
    { "Catching ", "Đang bắt " },
    { "Chasing ", "Đang đuổi theo " },
    { "Waiting ", "Đang chờ " },
    { "Searching ", "Đang tìm " },
    { "Claiming ", "Đang nhận " },
    { "Upgrading ", "Đang nâng cấp " },
    { "Buying ", "Đang mua " },
    { "Trading ", "Đang đổi " },
    { "Crafting ", "Đang chế tạo " },
    { "Collecting ", "Đang thu thập " },
    { "Holding ", "Đang giữ " },
    { "Dropping ", "Đang thả " },
    { "Returning ", "Đang quay về " },
    { "Avoiding ", "Đang né " },
    { "Evading ", "Đang né " },
    { "Attacking ", "Đang đánh " },
    { "Hitting ", "Đang đánh " },
    { "Finding ", "Đang tìm " },
    { "Checking ", "Đang kiểm tra " },
    { "Skipping ", "Đang bỏ qua " },
    { " home", " về nhà" },
    { "targets", "mục tiêu" },
    { "target", "mục tiêu" },
    { "guards", "vệ sĩ" },
    { "guard", "vệ sĩ" }
}

local DYNAMIC_PATTERNS_VI = {
    { pat = "^QUICK BAR (%d+)$", rep = "THANH NHANH %1" },
    { pat = "Venyx(.-)(%d+) hours? ago", rep = "ZenHub%1%2 giờ trước" },
    { pat = "Venyx(.-)(%d+) minutes? ago", rep = "ZenHub%1%2 phút trước" },
    { pat = "Venyx(.-)(%d+) days? ago", rep = "ZenHub%1%2 ngày trước" },
    { pat = "^ALL (%d+)$", rep = "TẤT CẢ %1" },
    { pat = "^READY (%d+)$", rep = "SẴN SÀNG %1" },
    { pat = "^GROWING (%d+)$", rep = "ĐANG LỚN %1" },
    { pat = "^IN BAG (%d+)$", rep = "TRONG TÚI %1" },
    { pat = "Pen (%d+/%d+) · (%d+) egg%(s%) ready to place", rep = "Chuồng %1 · %2 trứng sẵn sàng đặt" },
    { pat = "(%d+) egg%(s%) can be mutated", rep = "%1 trứng có thể đột biến" },
    { pat = "(%d+) pet%(s%) match", rep = "%1 pet khớp bộ lọc" },
    { pat = "(%d+) egg%(s%) match", rep = "%1 trứng khớp bộ lọc" },
    { pat = "(%d+) lab egg%(s%) match", rep = "%1 trứng Lab khớp bộ lọc" },
    { pat = "^(%d+) pets$", rep = "%1 thú cưng" },
    { pat = "(%d+ / %d+) players · (.+)", rep = "%1 người chơi · %2" },
    { pat = "Experimental Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Thí Nghiệm · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Biohazard Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Sinh Học · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Unstable DNA · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "DNA Bất Ổn · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "^Mythic · 1 in ([%d%.]+)$", rep = "Thần Thoại · 1 trên %1" },
    { pat = "^Cosmic · 1 in ([%d%.]+)$", rep = "Vũ Trụ · 1 trên %1" },
    { pat = "^Secret · 1 in ([%d%.]+)$", rep = "Bí Ẩn · 1 trên %1" },
    { pat = "^Divine · 1 in ([%d%.]+)$", rep = "Thánh Thần · 1 trên %1" },
    { pat = "^Eternal · 1 in ([%d%.]+)$", rep = "Vĩnh Cửu · 1 trên %1" }
}

local function applySmartPhraseFallback(str)
    local out = str
    for _, pair in ipairs(SMART_PHRASE_FALLBACK_VI) do
        local en, vi = pair[1], pair[2]
        if out:find(en, 1, true) then
            out = out:gsub(en:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"), vi)
        end
    end
    return out
end

local function translateStatusAction(cleanEn)
    if not cleanEn or cleanEn == "" then return "Đang rảnh" end
    if currentLanguage == "EN" then
        if cleanEn == "Đang rảnh" then return "Idle" end
        return cleanEn
    end

    local trimmed = (cleanEn:match("^%s*(.-)%s*$") or cleanEn):gsub("%s+", " ")
    if trimmed:lower() == "idle" or trimmed == "Đang rảnh" then
        return "Đang rảnh"
    end

    local cacheKey = "STATUS_VI|" .. trimmed
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if EXACT_MATCH_VI[trimmed] then
        FastCache[cacheKey] = EXACT_MATCH_VI[trimmed]
        return EXACT_MATCH_VI[trimmed]
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if trimmed:find(item.pat) then
            local out = trimmed:gsub(item.pat, item.rep)
            out = applySmartPhraseFallback(out)
            FastCache[cacheKey] = out
            return out
        end
    end

    local fallbackOut = applySmartPhraseFallback(trimmed)
    FastCache[cacheKey] = fallbackOut
    return fallbackOut
end

local function brandZENText(input)
    if type(input) ~= "string" or input == "" then return input end
    local out = input
    if out == "Venyx Discord" or out == "ZenHub Discord" then
        return "ZenHub Discord"
    end
    -- Names found in the loader and names commonly supplied by the remote GUI.
    for _, pattern in ipairs({
        "[Rr][Oo][Nn][Nn][Ee][Ii]%s*[Hh][Uu][Bb]",
        "[Cc][Hh][Ii][Ll][Ll][Ii]%s*[Hh][Uu][Bb]",
        "[Cc][Hh][Ii][Ll][Ii]%s*[Hh][Uu][Bb]",
        "[Vv][Ee][Nn][Yy][Xx]%s*[Hh][Uu][Bb]",
        "[Ss][Ee][Nn][Aa]%s*[Hh][Uu][Bb]",
    }) do
        out = out:gsub(pattern, NEW_TITLE)
    end
    out = out:gsub("RONNEI", NEW_TITLE):gsub("Ronnei", NEW_TITLE):gsub("ronnei", NEW_TITLE)
    out = out:gsub("VENYX", NEW_TITLE):gsub("Venyx", NEW_TITLE):gsub("venyx", NEW_TITLE)
    out = out:gsub("CHILLI", NEW_TITLE):gsub("Chilli", NEW_TITLE)
    out = out:gsub("CHILI", NEW_TITLE):gsub("Chili", NEW_TITLE)
    -- Normalize old source variants and stray versioned titles to the same brand.
    out = out:gsub("[Ss]" .. "2" .. "[Rr]%s*[-_]?%s*[Hh][Uu][Bb]%s*[Vv]?%d*[%d%.]*", NEW_TITLE)
    out = out:gsub("[Ss]" .. "2" .. "[Rr]", NEW_TITLE)
    out = out:gsub("ZenHub%s+[Vv]%d+[%d%.]*", NEW_TITLE)
    return out
end

-- Reverse the local legacy translation for already-translated UI descendants.
-- Original upstream feature wording is kept whenever available.
local VI_TO_ENGLISH = {}
for english, vietnamese in pairs(EXACT_MATCH_VI) do
    if VI_TO_ENGLISH[vietnamese] == nil then
        VI_TO_ENGLISH[vietnamese] = english
    end
end
local function zenRecoverEnglish(raw)
    local direct = VI_TO_ENGLISH[raw]
    if direct then return direct end
    local prefix, body = raw:match("^([^%w%s]+%s*)(.+)$")
    if prefix and body and VI_TO_ENGLISH[body] then
        return prefix .. VI_TO_ENGLISH[body]
    end
    local dynamic = {
        {"^Đang chờ (.+)$", "Waiting for %1"},
        {"^Đang cướp (.+)$", "Stealing %1"},
        {"^Đang giao (.+)$", "Delivering %1"},
        {"^Đang chạy (.+)$", "Running to %1"},
        {"^Đang mang (.+)$", "Carrying %1"},
        {"^Đang bán (.+)$", "Selling %1"},
        {"^Đang tìm (.+)$", "Searching for %1"},
    }
    for _, entry in ipairs(dynamic) do
        if raw:match(entry[1]) then return raw:gsub(entry[1], entry[2]) end
    end
    return raw
end

local function translateBaseText(raw)
    if not raw or raw == "" then return raw end
    local cacheKey = currentLanguage .. "|" .. raw
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if raw:find("Venyx SAE", 1, true) then
        raw = raw:gsub("Venyx SAE", "ZenHub SAE")
    elseif raw == "VENYX" then
        raw = NEW_TITLE
    end

    if currentLanguage == "EN" then
        local english = zenRecoverEnglish(raw)
        FastCache[cacheKey] = english
        return english
    end

    local normalized = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")

    if EXACT_MATCH_VI[normalized] then
        local out = EXACT_MATCH_VI[normalized]
        FastCache[cacheKey] = out
        return out
    end

    local baseBeforeDots = normalized:match("^(.+)%.%.%.$")
    if baseBeforeDots then
        baseBeforeDots = baseBeforeDots:match("^%s*(.-)%s*$") or baseBeforeDots
        if EXACT_MATCH_VI[baseBeforeDots] then
            local out = EXACT_MATCH_VI[baseBeforeDots] .. "..."
            FastCache[cacheKey] = out
            return out
        end
    end

    local prefix, wordPart = normalized:match("^([^%w%s]+%s*)(.+)$")
    if prefix and wordPart and EXACT_MATCH_VI[wordPart] then
        local out = prefix .. EXACT_MATCH_VI[wordPart]
        FastCache[cacheKey] = out
        return out
    end

    local result = normalized
    for _, item in ipairs(DYNAMIC_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            FastCache[cacheKey] = result
            return result
        end
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            result = applySmartPhraseFallback(result)
            FastCache[cacheKey] = result
            return result
        end
    end

    FastCache[cacheKey] = raw
    return raw
end

local function applyElementTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__FpsHooked") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ZEN_ExpandedIsland") then return end
    if inst:GetAttribute("__IsTranslating") then return end

    if inst:IsA("TextBox") then
        local origPh = inst:GetAttribute("OrigPlaceholder")
        if not origPh and inst.PlaceholderText ~= "" then
            origPh = inst.PlaceholderText
            inst:SetAttribute("OrigPlaceholder", origPh)
        end
        if origPh then
            inst.PlaceholderText = brandZENText(translateBaseText(origPh))
        end

        if not inst:IsFocused() then
            local boxTxt = inst.Text
            if boxTxt == "Off" or boxTxt == "Tắt" or boxTxt == "None" or boxTxt == "Không có" then
                local origBox = inst:GetAttribute("OrigBoxText")
                if not origBox or (boxTxt == "Off" or boxTxt == "None") then
                    origBox = (boxTxt == "Tắt") and "Off" or ((boxTxt == "Không có") and "None" or boxTxt)
                    inst:SetAttribute("OrigBoxText", origBox)
                end
                local mappedBox = brandZENText(translateBaseText(origBox))
                if inst.Text ~= mappedBox then
                    inst:SetAttribute("__IsTranslating", true)
                    pcall(function() inst.Text = mappedBox end)
                    inst:SetAttribute("__IsTranslating", false)
                end
            end
        end
        return
    end

    local rawText = inst.Text
    if isFpsCounterText(rawText) then
        hookFakeFpsCounter(inst)
        return
    end

    local original = inst:GetAttribute("OrigRawText")
    if not original then
        original = rawText
        inst:SetAttribute("OrigRawText", original)
    end

    local mapped = brandZENText(translateBaseText(original))
    if inst.Text ~= mapped then
        inst:SetAttribute("__IsTranslating", true)
        inst:SetAttribute("__LastTranslated", mapped)
        pcall(function() inst.Text = mapped end)
        inst:SetAttribute("__IsTranslating", false)
    end
end

local function hookTextForTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ZEN_ExpandedIsland") then return end

    if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
        hookFakeFpsCounter(inst)
        return
    end

    applyElementTranslation(inst)

    if inst:GetAttribute("__TransHooked") then return end
    inst:SetAttribute("__TransHooked", true)
    table.insert(TrackedTexts, inst)

    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") then return end
        if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
            hookFakeFpsCounter(inst)
            return
        end
        if inst:IsA("TextBox") then
            applyElementTranslation(inst)
            return
        end
        if inst.Text ~= inst:GetAttribute("__LastTranslated") then
            inst:SetAttribute("OrigRawText", inst.Text)
            applyElementTranslation(inst)
        end
    end)
end

local function refreshAllTranslations()
    task.spawn(function()
        if GlobalRefreshIslandStatus then
            GlobalRefreshIslandStatus()
        end
        local count = 0
        for i = #TrackedTexts, 1, -1 do
            local el = TrackedTexts[i]
            if el and el.Parent then
                applyElementTranslation(el)
                count = count + 1
                if count % 50 == 0 then
                    task.wait()
                end
            else
                table.remove(TrackedTexts, i)
            end
        end
    end)
end

-- ==================== 4. ZEN STATUS PILL AND SETTINGS ====================
local function setupDynamicIslandFromStatus(statusLbl, hubGui)
    local pill = statusLbl.Parent
    if not (pill and pill:IsA("GuiObject")) then return end

    local badHitbox = pill:FindFirstChild("IslandClickHitbox")
    if badHitbox then
        badHitbox:Destroy()
    end

    for _, child in ipairs(pill:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end

    pill.BackgroundColor3 = ISLAND_WHITE_BG
    pill.BackgroundTransparency = 0
    pill.Size = UDim2.new(0, 0, 0, 28)
    pill.AutomaticSize = Enum.AutomaticSize.X

    if not pill:GetAttribute("__WhiteBgLocked") then
        pill:SetAttribute("__WhiteBgLocked", true)
        pill:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            if pill.BackgroundColor3 ~= ISLAND_WHITE_BG then
                pill.BackgroundColor3 = ISLAND_WHITE_BG
            end
        end)
        pill:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
            if pill.BackgroundTransparency ~= 0 then
                pill.BackgroundTransparency = 0
            end
        end)
    end

    local expandHint = pill:FindFirstChild("IslandExpandHint")
    if not expandHint then
        expandHint = Instance.new("TextLabel")
        expandHint.Name = "IslandExpandHint"
        expandHint.Size = UDim2.new(0, 18, 0, 18)
        expandHint.BackgroundColor3 = ZEN_THEME.Surface
        expandHint.BorderSizePixel = 0
        expandHint.Text = "▼"
        expandHint.Font = Enum.Font.GothamBold
        expandHint.TextSize = 9
        expandHint.TextColor3 = ZEN_THEME.Muted
        expandHint.LayoutOrder = 99
        expandHint.ZIndex = 10000
        expandHint.Parent = pill

        local hintCorner = Instance.new("UICorner")
        hintCorner.CornerRadius = UDim.new(1, 0)
        hintCorner.Parent = expandHint

        local hintStroke = Instance.new("UIStroke")
        hintStroke.Thickness = 1
        hintStroke.Color = ZEN_THEME.Border
        hintStroke.Parent = expandHint
    end

    local function updateStatusText(forceFromSavedOrig)
        if statusLbl:GetAttribute("__Updating") then return end
        statusLbl:SetAttribute("__Updating", true)

        local cleanEn
        if forceFromSavedOrig and statusLbl:GetAttribute("OrigStatusEn") then
            cleanEn = statusLbl:GetAttribute("OrigStatusEn")
        else
            local currentRaw = statusLbl.Text:gsub("●", ""):gsub("•", ""):gsub("✨%s*rainbow", ""):match("^%s*(.-)%s*$") or ""
            if currentRaw ~= "" and currentRaw ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
                cleanEn = currentRaw
                statusLbl:SetAttribute("OrigStatusEn", cleanEn)
            else
                cleanEn = statusLbl:GetAttribute("OrigStatusEn") or currentRaw or "Idle"
            end
        end

        local translatedStatus = brandZENText(translateStatusAction(cleanEn))
        statusLbl:SetAttribute("__LastTranslatedStatus", translatedStatus)

        statusLbl.Text = translatedStatus
        statusLbl.TextColor3 = ZEN_THEME.Text
        statusLbl.TextTransparency = 0
        statusLbl.Size = UDim2.new(0, 0, 1, 0)
        statusLbl.AutomaticSize = Enum.AutomaticSize.X

        statusLbl:SetAttribute("__Updating", false)
    end

    GlobalRefreshIslandStatus = function()
        updateStatusText(true)
    end

    if statusLbl:GetAttribute("__IslandDone") and hubGui:FindFirstChild("ZEN_ExpandedIsland") then
        updateStatusText(false)
        return
    end
    statusLbl:SetAttribute("__IslandDone", true)

    updateStatusText(false)

    -- Explicitly strip the old animated rainbow text treatment.
    for _, effect in ipairs(statusLbl:GetChildren()) do
        if effect:IsA("UIGradient") then effect:Destroy() end
    end

    pill.Parent = hubGui
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.Position = UDim2.new(0.5, 0, 0, 10)
    pill.ZIndex = 9999
    pill.Active = true
    statusLbl.Active = true
    expandHint.Active = true

    local pillCorner = pill:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill

    local pillStroke = pill:FindFirstChild("IslandStroke") or Instance.new("UIStroke")
    pillStroke.Name = "IslandStroke"
    pillStroke.Thickness = 1.2
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = ZEN_THEME.Border
    pillStroke.Parent = pill

    for _, effect in ipairs(pillStroke:GetChildren()) do
        if effect:IsA("UIGradient") then effect:Destroy() end
    end

    local oldExp = hubGui:FindFirstChild("ZEN_ExpandedIsland")
    if oldExp then oldExp:Destroy() end

    local ExpandedIsland = Instance.new("Frame")
    ExpandedIsland.Name = "ZEN_ExpandedIsland"
    ExpandedIsland.AnchorPoint = Vector2.new(0.5, 0)
    ExpandedIsland.Position = pill.Position
    ExpandedIsland.Size = UDim2.new(0, 260, 0, 78)
    ExpandedIsland.BackgroundColor3 = ISLAND_WHITE_BG
    ExpandedIsland.BackgroundTransparency = 0
    ExpandedIsland.BorderSizePixel = 0
    ExpandedIsland.Visible = false
    ExpandedIsland.Active = true
    ExpandedIsland.ZIndex = 10000
    ExpandedIsland.Parent = hubGui

    local ExpCorner = Instance.new("UICorner")
    ExpCorner.CornerRadius = UDim.new(0, 16)
    ExpCorner.Parent = ExpandedIsland

    local ExpStroke = Instance.new("UIStroke")
    ExpStroke.Thickness = 1.2
    ExpStroke.Color = ZEN_THEME.Border
    ExpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ExpStroke.Parent = ExpandedIsland

    local ExpTitle = Instance.new("TextLabel")
    ExpTitle.Size = UDim2.new(1, -44, 0, 28)
    ExpTitle.Position = UDim2.new(0, 14, 0, 4)
    ExpTitle.BackgroundTransparency = 1
    ExpTitle.Text = "ZENHUB   /   PREFERENCES"
    ExpTitle.Font = Enum.Font.GothamBold
    ExpTitle.TextSize = 11.5
    ExpTitle.TextColor3 = ZEN_THEME.AccentHover
    ExpTitle.TextXAlignment = Enum.TextXAlignment.Left
    ExpTitle.ZIndex = 10001
    ExpTitle.Parent = ExpandedIsland

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 24, 0, 22)
    CollapseBtn.Position = UDim2.new(1, -32, 0, 7)
    CollapseBtn.BackgroundColor3 = ZEN_THEME.Control
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "▲"
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.TextSize = 10
    CollapseBtn.TextColor3 = ZEN_THEME.Muted
    CollapseBtn.ZIndex = 10002
    CollapseBtn.Parent = ExpandedIsland

    local CollapseCorner = Instance.new("UICorner")
    CollapseCorner.CornerRadius = UDim.new(1, 0)
    CollapseCorner.Parent = CollapseBtn

    local LangCapsule = Instance.new("Frame")
    LangCapsule.Size = UDim2.new(1, -20, 0, 34)
    LangCapsule.Position = UDim2.new(0, 10, 0, 36)
    LangCapsule.BackgroundColor3 = ZEN_THEME.Panel
    LangCapsule.BorderSizePixel = 0
    LangCapsule.ZIndex = 10001
    LangCapsule.Parent = ExpandedIsland

    local LangCorner = Instance.new("UICorner")
    LangCorner.CornerRadius = UDim.new(1, 0)
    LangCorner.Parent = LangCapsule

    local LangSlider = Instance.new("Frame")
    LangSlider.Size = UDim2.new(0.5, -4, 1, -4)
    LangSlider.Position = (currentLanguage == "VI") and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 2, 0, 2)
    LangSlider.BackgroundColor3 = ZEN_THEME.Accent
    LangSlider.BorderSizePixel = 0
    LangSlider.ZIndex = 10002
    LangSlider.Parent = LangCapsule

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = LangSlider

    local BtnVI = Instance.new("TextButton")
    BtnVI.Size = UDim2.new(0.5, 0, 1, 0)
    BtnVI.Position = UDim2.new(0, 0, 0, 0)
    BtnVI.BackgroundTransparency = 1
    BtnVI.Text = "🇻🇳 VIETNAMESE"
    BtnVI.Font = Enum.Font.GothamBold
    BtnVI.TextSize = 10.5
    BtnVI.TextColor3 = (currentLanguage == "VI") and ZEN_THEME.OnAccent or ZEN_THEME.Muted
    BtnVI.ZIndex = 10003
    BtnVI.Parent = LangCapsule

    local BtnEN = Instance.new("TextButton")
    BtnEN.Size = UDim2.new(0.5, 0, 1, 0)
    BtnEN.Position = UDim2.new(0.5, 0, 0, 0)
    BtnEN.BackgroundTransparency = 1
    BtnEN.Text = "🌐 ENGLISH"
    BtnEN.Font = Enum.Font.GothamBold
    BtnEN.TextSize = 10.5
    BtnEN.TextColor3 = (currentLanguage == "EN") and ZEN_THEME.OnAccent or ZEN_THEME.Muted
    BtnEN.ZIndex = 10003
    BtnEN.Parent = LangCapsule

    local function setLanguage(lang)
        if currentLanguage == lang then return end
        currentLanguage = lang
        pcall(function()
            if writefile then writefile(LANG_SAVE_FILE, lang) end
        end)

        if lang == "VI" then
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            BtnVI.TextColor3 = ZEN_THEME.OnAccent
            BtnEN.TextColor3 = ZEN_THEME.Muted
        else
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 2, 0, 2)
            }):Play()
            BtnEN.TextColor3 = ZEN_THEME.OnAccent
            BtnVI.TextColor3 = ZEN_THEME.Muted
        end

        refreshAllTranslations()
    end

    BtnVI.MouseButton1Click:Connect(function() setLanguage("VI") end)
    BtnEN.MouseButton1Click:Connect(function() setLanguage("EN") end)

    task.defer(function()
        if currentLanguage ~= "EN" then
            setLanguage("EN")
        else
            refreshAllTranslations()
        end
    end)

    local function toggleIsland(expand)
        if expand then
            ExpandedIsland.Position = pill.Position
            pill.Visible = false
            ExpandedIsland.Size = UDim2.new(0, 150, 0, 28)
            ExpandedIsland.Visible = true
            TweenService:Create(ExpandedIsland, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 260, 0, 78)
            }):Play()
        else
            pill.Position = ExpandedIsland.Position
            ExpandedIsland.Visible = false
            pill.Visible = true
        end
    end

    CollapseBtn.MouseButton1Click:Connect(function()
        toggleIsland(false)
    end)

    local function attachDragAndClick(triggerObj, moveFrame, onTapCallback)
        if triggerObj:GetAttribute("__DragBound") then return end
        triggerObj:SetAttribute("__DragBound", true)

        local dragging, dragStart, startPos, moved = false, nil, nil, false

        triggerObj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = moveFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragging and not moved and onTapCallback then
                            onTapCallback()
                        end
                        dragging = false
                    end
                end)
            end
        end)

        triggerObj.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                local delta = input.Position - dragStart
                if delta.Magnitude > 6 then
                    moved = true
                end
                local cam = workspace.CurrentCamera
                local maxX = cam and cam.ViewportSize.X - 140 or 800
                local maxY = cam and cam.ViewportSize.Y - 50 or 600
                local newX = math.clamp(startPos.X.Offset + delta.X, -maxX / 2, maxX / 2)
                local newY = math.clamp(startPos.Y.Offset + delta.Y, 4, maxY)
                local newPos = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                pill.Position = newPos
                ExpandedIsland.Position = newPos
            end
        end)
    end

    local openCallback = function() toggleIsland(true) end
    attachDragAndClick(pill, pill, openCallback)
    attachDragAndClick(statusLbl, pill, openCallback)
    attachDragAndClick(expandHint, pill, openCallback)
    attachDragAndClick(ExpandedIsland, ExpandedIsland, nil)

    statusLbl:GetPropertyChangedSignal("Text"):Connect(function()
        if not statusLbl:GetAttribute("__Updating") and statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
            updateStatusText(false)
        end
    end)
end

-- ==================== 5. ZEN FLOATING LAUNCHER AND HEADER ====================
local function setupUnclippedCircularLogo(targetObj)
    local topPanel = targetObj
    while topPanel.Parent and topPanel.Parent:IsA("GuiObject") and not topPanel.Parent:IsA("ScreenGui") do
        topPanel = topPanel.Parent
    end

    if topPanel:GetAttribute("__FloatingLogoV5Perfect") then return end

    local sz = topPanel.AbsoluteSize
    local pos = topPanel.AbsolutePosition
    if sz.X > 105 or sz.Y > 105 or sz.X < 28 or math.abs(sz.X - sz.Y) > 25 or pos.X > 350 then
        return
    end

    topPanel:SetAttribute("__FloatingLogoV5Perfect", true)
    local container = topPanel

    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("UIPadding") or child:IsA("UIAspectRatioConstraint") or child:IsA("UISizeConstraint") then
            if child.Name ~= "PerfectCircleAspect" then
                pcall(function() child:Destroy() end)
            end
        end
        if child:IsA("UIGradient") then
            child:Destroy()
        elseif (child:IsA("ImageLabel") or child:IsA("ImageButton")) and child.Name ~= "ZENCoverLogo" then
            child.ImageTransparency = 1
            child.BackgroundTransparency = 1
        elseif child:IsA("TextLabel") or child:IsA("TextButton") then
            child:SetAttribute("__HiddenVxLogo", true)
            child.TextTransparency = 1
            child.BackgroundTransparency = 1
        end
    end

    if container:IsA("ImageLabel") or container:IsA("ImageButton") then
        container.ImageTransparency = 1
    elseif container:IsA("TextLabel") or container:IsA("TextButton") then
        container:SetAttribute("__HiddenVxLogo", true)
        container.TextTransparency = 1
    end

    -- Preserve the original floating control hitbox if it is already compact.
    -- Resizing can shift touch targets away from their click listeners.
    local diameter = math.clamp(math.min(sz.X, sz.Y), 48, 64)
    container.Size = UDim2.new(0, diameter, 0, diameter)
    container.BackgroundColor3 = LOGO_BG_COLOR
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true

    local aspect = container:FindFirstChild("PerfectCircleAspect") or Instance.new("UIAspectRatioConstraint")
    aspect.Name = "PerfectCircleAspect"
    aspect.AspectRatio = 1
    aspect.Parent = container

    local cCorner = container:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = container

    if not container:GetAttribute("__SizeLocked") then
        container:SetAttribute("__SizeLocked", true)
        container:GetPropertyChangedSignal("Size"):Connect(function()
            if container.Size ~= UDim2.new(0, diameter, 0, diameter) then
                container.Size = UDim2.new(0, diameter, 0, diameter)
            end
        end)
    end

    local stroke = container:FindFirstChild("ZENBorder") or Instance.new("UIStroke")
    stroke.Name = "ZENBorder"
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = ZEN_THEME.OnAccent
    stroke.Transparency = 0.45
    stroke.Parent = container

    for _, effect in ipairs(stroke:GetChildren()) do
        if effect:IsA("UIGradient") then effect:Destroy() end
    end

    local coverLogo = container:FindFirstChild("ZENCoverLogo") or Instance.new("TextLabel")
    coverLogo.Name = "ZENCoverLogo"
    coverLogo.Size = UDim2.new(1, 0, 1, 0)
    coverLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    coverLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    coverLogo.BackgroundTransparency = 1
    coverLogo.Text = "Z"
    coverLogo.Font = Enum.Font.GothamBold
    coverLogo.TextSize = 30
    coverLogo.TextColor3 = ZEN_THEME.OnAccent
    coverLogo.Active = false
    coverLogo.ZIndex = container.ZIndex + 5
    coverLogo.Parent = container
end

local function patchHeaderLogoLeftOfTitle(headerContainer, titleLbl)
    if not headerContainer or not titleLbl then return end
    local headerY = titleLbl.AbsolutePosition.Y
    local titleX = titleLbl.AbsolutePosition.X

    -- Use a custom Z letterform in the original header logo slot (no overlays).
    for _, item in ipairs(headerContainer:GetDescendants()) do
        if item ~= titleLbl and item:IsA("GuiObject") and item.Name ~= "ZENHeaderLogo"
            and not item:FindFirstAncestor("ZENHeaderLogo") then
            local pos = item.AbsolutePosition
            local sz = item.AbsoluteSize
            if math.abs(pos.Y - headerY) < 35 and pos.X < titleX
                and sz.X >= 10 and sz.X <= 45
                and (item:IsA("TextLabel") or item:IsA("ImageLabel") or item:IsA("ImageButton")) then
                if not item:GetAttribute("__ZENHeaderIcon") then
                    item:SetAttribute("__ZENHeaderIcon", true)
                    if item:IsA("ImageLabel") or item:IsA("ImageButton") then
                        item.ImageTransparency = 1
                    else
                        item:SetAttribute("__HiddenVxLogo", true)
                        item.TextTransparency = 1
                    end
                    local mark = Instance.new("TextLabel")
                    mark.Name = "ZENHeaderLogo"
                    mark.Size = UDim2.new(1, 0, 1, 0)
                    mark.BackgroundTransparency = 1
                    mark.Text = "Z"
                    mark.Font = Enum.Font.GothamBold
                    mark.TextScaled = true
                    mark.TextColor3 = ZEN_THEME.Accent
                    mark.Active = false
                    mark.ZIndex = item.ZIndex + 1
                    mark.Parent = item
                end
                break
            end
        end
    end
end

-- ZENHUB | VIOLET & WHITE ---------------------------------------------------------
-- Native Roblox styling, no overlays on clickable controls and no glow.
-- Restyle only the imported hub window; core game and feature callbacks stay intact.
local ZEN_DECOR_PREFIX = "ZenHub_Fix4_"

local function zenRound(obj, px)
    local corner = obj:FindFirstChildOfClass("UICorner")
    if not corner then
        corner = Instance.new("UICorner")
        corner.Parent = obj
    end
    corner.CornerRadius = UDim.new(0, px)
end

-- A remote GUI can contain off-window canvas frames whose AbsoluteSize is
-- much bigger than the visible hub. Never put ZEN decorative strokes on them.
local function zenContainedInWindow(obj, mainWindow)
    if not mainWindow or obj == mainWindow then return true end
    local p, sz = obj.AbsolutePosition, obj.AbsoluteSize
    local wp, ws = mainWindow.AbsolutePosition, mainWindow.AbsoluteSize
    local inset = 12
    if sz.X <= 0 or sz.Y <= 0 or ws.X <= 0 or ws.Y <= 0 then return false end
    return p.X >= wp.X - inset and p.Y >= wp.Y - inset
        and p.X + sz.X <= wp.X + ws.X + inset
        and p.Y + sz.Y <= wp.Y + ws.Y + inset
end

local function zenStroke(obj, color, thickness, transparency, mainWindow)
    if not obj:IsA("GuiObject") then return end
    local existing = obj:FindFirstChild(ZEN_DECOR_PREFIX .. "Stroke")
    if not zenContainedInWindow(obj, mainWindow) then
        -- Remove only borders this styling wrapper itself created.
        if existing and existing:IsA("UIStroke") then existing:Destroy() end
        return
    end
    local stroke = existing
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = ZEN_DECOR_PREFIX .. "Stroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj
    end
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    return stroke
end

local function zenIsCompactDot(obj)
    local sz = obj.AbsoluteSize
    return sz.X > 0 and sz.X <= 28 and sz.Y > 0 and sz.Y <= 28
        and math.abs(sz.X - sz.Y) <= 6
end

local function zenIsToggleTrack(obj)
    if not (obj:IsA("Frame") or obj:IsA("ImageButton") or obj:IsA("TextButton")) then return false end
    local sz = obj.AbsoluteSize
    return sz.X >= 28 and sz.X <= 75 and sz.Y >= 13 and sz.Y <= 33
        and (sz.X / math.max(1, sz.Y)) >= 1.55
        and (sz.X / math.max(1, sz.Y)) <= 3.6
end

local function zenToneToggle(obj)
    if not obj or not obj.Parent or obj:GetAttribute(ZEN_DECOR_PREFIX .. "InPaint") then return end
    local original = obj.BackgroundColor3
    local _, sat, val = original:ToHSV()
    -- A changing upstream toggle is represented as active when its source is vivid.
    -- Do not infer state from our own violet theme colors.
    if original == ZEN_THEME.Active or original == ZEN_THEME.Control then return end
    local paint = (sat > 0.24 and val > 0.33) and ZEN_THEME.Active or ZEN_THEME.Control
    obj:SetAttribute(ZEN_DECOR_PREFIX .. "InPaint", true)
    obj.BackgroundColor3 = paint
    obj:SetAttribute(ZEN_DECOR_PREFIX .. "InPaint", false)
end

local function zenOnViolet(obj, mainWindow)
    -- Text inside active chips and the violet navigation rail must remain white.
    -- Stop at the nearest opaque parent: a white card overrides a purple ancestor.
    local parent = obj.Parent
    while parent and parent ~= mainWindow do
        if parent:IsA("GuiObject") and parent.BackgroundTransparency < 0.91 then
            local bg = parent.BackgroundColor3
            return bg == ZEN_THEME.Rail or bg == ZEN_THEME.Active or bg == ZEN_THEME.Accent
        end
        parent = parent.Parent
    end
    return false
end

local function zenTextTone(original)
    -- Keep meaningful danger/success/warning states instead of recoloring them.
    local hue, sat, value = original:ToHSV()
    if sat > 0.52 and value > 0.48 then
        if (hue >= 0.22 and hue <= 0.53) or hue <= 0.05 or hue >= 0.95 then
            return original
        end
    end
    return nil
end

-- Accessibility helpers: use actual relative luminance, not just HSV/value.
local function zenLuminance(color)
    local function linear(c)
        if c <= 0.04045 then return c / 12.92 end
        return ((c + 0.055) / 1.055) ^ 2.4
    end
    return 0.2126 * linear(color.R) + 0.7152 * linear(color.G)
        + 0.0722 * linear(color.B)
end

local function zenContrastRatio(a, b)
    local x, y = zenLuminance(a), zenLuminance(b)
    return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05)
end

local function zenReadableType(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    local size = obj.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end
    -- Short chip labels keep their existing compact sizes. Regular features
    -- should never be tiny on a desktop or a scaled phone.
    if not obj.TextScaled and size.Y >= 19 and size.X >= 74 then
        local minimum = (size.Y >= 26 and size.X >= 92) and 13 or 12
        if obj.TextSize < minimum then obj.TextSize = minimum end
    end
    if obj:IsA("TextLabel") and size.Y >= 42 and size.X >= 100
        and not obj.TextWrapped and #(obj.Text or "") >= 31 then
        obj.TextWrapped = true
    end
    if obj:IsA("TextBox") and obj.ClearTextOnFocus then
        -- Do not modify editable field behavior or obscure typed values.
        return
    end
    if obj:IsA("TextButton") and size.X >= 95 and size.Y >= 31
        and #(obj.Text or "") > 19 then
        obj.TextWrapped = true
    end
    -- Do not truncate feature names into unreadable ellipses.
end

local function zenNearestBackdrop(obj, gui)
    local ancestor = obj
    while ancestor and ancestor ~= gui do
        if ancestor:IsA("GuiObject") and ancestor.BackgroundTransparency <= 0.4 then
            return ancestor.BackgroundColor3
        end
        ancestor = ancestor.Parent
    end
    return nil
end

local function zenStyleObject(obj, mainWindow, withinRegion)
    if not obj or not obj.Parent then return end
    if not obj:IsDescendantOf(mainWindow) then
        -- Some remote GUIs put visible feature pages beside the header panel.
        -- Only style sibling controls spatially contained in our app window.
        if not withinRegion or not zenContainedInWindow(obj, mainWindow) then return end
    end
    if obj.Name:sub(1, #ZEN_DECOR_PREFIX) == ZEN_DECOR_PREFIX then return end
    if obj:FindFirstAncestor("ZEN_ExpandedIsland") or obj.Name == "ZENHeaderLogo" then return end
    if obj:IsA("UIGradient") then
        obj:Destroy() -- No moving gradients or glow effects.
        return
    end
    if obj:IsA("UIStroke") then
        if not obj:GetAttribute(ZEN_DECOR_PREFIX .. "StrokeDone") then
            obj.Color = ZEN_THEME.StrokeMuted
            obj.Thickness = math.min(obj.Thickness, 1)
            obj.Transparency = math.max(obj.Transparency, 0.25)
            obj:SetAttribute(ZEN_DECOR_PREFIX .. "StrokeDone", true)
        end
        return
    end
    if not obj:IsA("GuiObject") then return end
    if obj:GetAttribute(ZEN_DECOR_PREFIX .. "Done") then return end
    -- Some remote GUI controls first appear at 0x0; style them later after layout.
    if obj.AbsoluteSize.X <= 0 or obj.AbsoluteSize.Y <= 0 then return end
    obj:SetAttribute(ZEN_DECOR_PREFIX .. "Done", true)
    zenReadableType(obj)

    local size = obj.AbsoluteSize
    local fills = obj.BackgroundTransparency < 0.94
    local inHeader = (obj.AbsolutePosition.Y - mainWindow.AbsolutePosition.Y) <= 64
    local inRail = (obj.AbsolutePosition.X - mainWindow.AbsolutePosition.X) < 77
        and (obj.AbsolutePosition.Y - mainWindow.AbsolutePosition.Y) >= 55
    local _, saturation, brightness = obj.BackgroundColor3:ToHSV()
    local colored = saturation > 0.32 and brightness > 0.35

    if obj:IsA("ScrollingFrame") then
        obj.ScrollBarImageColor3 = ZEN_THEME.Accent
        obj.ScrollBarThickness = 6
    end

    if obj:IsA("TextLabel") then
        local semantic = zenTextTone(obj.TextColor3)
        local emphatic = (obj.Font == Enum.Font.GothamBold
            or obj.Font == Enum.Font.GothamSemibold or obj.TextSize >= 16)
        obj.TextColor3 = (inRail or zenOnViolet(obj, mainWindow)) and ZEN_THEME.OnAccent
            or semantic or (emphatic and ZEN_THEME.Text or ZEN_THEME.Text)
        if fills and size.X > 85 and size.Y > 23 then
            obj.BackgroundColor3 = inRail and ZEN_THEME.Rail
                or (inHeader and ZEN_THEME.Header or ZEN_THEME.Panel)
            zenRound(obj, 7)
        end
        return
    end

    if obj:IsA("TextBox") then
        obj.TextColor3 = ZEN_THEME.Text
        obj.PlaceholderColor3 = ZEN_THEME.Subtle
        obj.Font = Enum.Font.GothamMedium
        if fills then
            obj.BackgroundColor3 = ZEN_THEME.Control
            zenRound(obj, 9)
            zenStroke(obj, ZEN_THEME.Border, 1, 0.35, mainWindow)
        end
        return
    end

    if obj:IsA("TextButton") then
        -- Purple selected controls use white type; neutral/light controls use dark ink.
        -- Sidebar text stays white, including transparent nav-item buttons.
        obj.TextColor3 = (inRail or (fills and colored) or zenOnViolet(obj, mainWindow))
            and ZEN_THEME.OnAccent or ZEN_THEME.Text
        if size.X > 80 and size.Y >= 25 then
            obj.Font = Enum.Font.GothamMedium
        end
        if fills then
            if zenIsToggleTrack(obj) then
                zenRound(obj, 15)
                zenToneToggle(obj)
                obj:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                    zenToneToggle(obj)
                end)
            else
                obj.BackgroundColor3 = colored and ZEN_THEME.Active
                    or (inRail and ZEN_THEME.Rail or ZEN_THEME.Control)
                zenRound(obj, size.Y >= 35 and 10 or 8)
                if size.X >= 58 and size.Y >= 23 then
                    zenStroke(obj, ZEN_THEME.Border, 1, 0.38, mainWindow)
                end
            end
        end
        return
    end

    -- Small circular elements are usually toggle knobs, not content cards.
    -- Keep knobs pale so their on/off positions stay readable.
    if zenIsCompactDot(obj) then
        if fills then
            if saturation < 0.21 and brightness >= 0.73 then
                obj.BackgroundColor3 = ZEN_THEME.Knob
            elseif colored then
                obj.BackgroundColor3 = ZEN_THEME.Accent
            end
        end
        return
    end

    if zenIsToggleTrack(obj) then
        if fills then
            zenRound(obj, 16)
            zenToneToggle(obj)
            obj:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                zenToneToggle(obj)
            end)
        end
        return
    end

    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        -- Icons may contain game-specific artwork; do not recolor them.
        if fills and size.X >= 32 and size.Y >= 32 then
            obj.BackgroundColor3 = inRail and ZEN_THEME.Rail or ZEN_THEME.Surface
            zenRound(obj, 9)
        end
        return
    end

    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        if fills then
            if inRail and size.Y >= 125 and size.X <= 110 then
                obj.BackgroundColor3 = ZEN_THEME.Rail
            elseif inHeader and size.Y <= 70 and size.X >= 120 then
                obj.BackgroundColor3 = ZEN_THEME.Header
            elseif size.X >= 170 and size.Y >= 75 then
                obj.BackgroundColor3 = ZEN_THEME.Panel
                if size.X < mainWindow.AbsoluteSize.X * 0.8 then
                    zenStroke(obj, ZEN_THEME.StrokeMuted, 1, 0.24, mainWindow)
                end
            elseif size.X >= 60 and size.Y >= 28 then
                obj.BackgroundColor3 = colored and ZEN_THEME.Active
                    or (inRail and ZEN_THEME.Rail or ZEN_THEME.Surface)
            elseif inRail then
                obj.BackgroundColor3 = ZEN_THEME.Rail
            elseif colored then
                obj.BackgroundColor3 = ZEN_THEME.Active
            end
            if size.X >= 72 and size.Y >= 25 then
                zenRound(obj, (size.Y >= 95) and 12 or 9)
            end
        end
    end
end

local function zenDecorateWindow(mainWindow, titleLbl)
    if mainWindow:GetAttribute(ZEN_DECOR_PREFIX .. "Decorated") then return end
    mainWindow:SetAttribute(ZEN_DECOR_PREFIX .. "Decorated", true)
    local function strip(name, size, position, color, transparency, radius)
        local obj = mainWindow:FindFirstChild(ZEN_DECOR_PREFIX .. name)
        if not obj then
            obj = Instance.new("Frame")
            obj.Name = ZEN_DECOR_PREFIX .. name
            obj.BorderSizePixel = 0
            obj.Active = false
            obj.Selectable = false
            obj.Parent = mainWindow
        end
        obj.BackgroundColor3 = color
        obj.BackgroundTransparency = transparency or 0
        obj.Size = size
        obj.Position = position
        obj.ZIndex = math.max(1, titleLbl.ZIndex)
        if radius then zenRound(obj, radius) end
        return obj
    end
    -- ZenHub signature: short rounded violet brand stroke and whisper-light header edge.
    strip("BrandBar", UDim2.new(0, 48, 0, 4), UDim2.new(0, 22, 0, 2), ZEN_THEME.Accent, 0, 3)
    strip("HeaderRule", UDim2.new(1, -30, 0, 1), UDim2.new(0, 15, 0, 55), ZEN_THEME.Border, 0.28)
    if mainWindow.AbsoluteSize.X >= 550 then
        strip("NavDivider", UDim2.new(0, 1, 1, -79), UDim2.new(0, 76, 0, 66), ZEN_THEME.Border, 0.28)
    end
end

local function zenFitScreen(mainWindow)
    -- Only scale when the upstream panel would be clipped on a small device.
    -- Does not change the original frame's positions or feature hitboxes.
    local cam = workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local windowSize = mainWindow.AbsoluteSize
    if viewport.X <= 0 or viewport.Y <= 0 or windowSize.X <= 0 or windowSize.Y <= 0 then return end
    -- Reuse a UIScale left by the earlier ZenHub wrapper. Two nested scales
    -- can shrink just the header while the lower settings remain full size.
    local found = mainWindow:FindFirstChild(ZEN_DECOR_PREFIX .. "MobileScale")
        or mainWindow:FindFirstChild("ZenHub_Air_MobileScale")
    local currentScale = (found and found.Scale) or 1
    if currentScale <= 0 then currentScale = 1 end
    -- AbsoluteSize may already include UIScale: reverse the prior scale so
    -- rescans never shrink the window again and again.
    local originalX = windowSize.X / currentScale
    local originalY = windowSize.Y / currentScale
    local targetScale = math.clamp(math.min(1, (viewport.X - 24) / originalX,
        (viewport.Y - 30) / originalY), 0.40, 1)
    if not found and targetScale >= 0.995 then return end
    if not found then
        found = Instance.new("UIScale")
        found.Name = ZEN_DECOR_PREFIX .. "MobileScale"
        found.Parent = mainWindow
    end
    if math.abs(found.Scale - targetScale) > 0.005 then
        found.Scale = targetScale
    end
end

-- FIX: Some versions of the imported GUI place the lower Dashboard cards in
-- a late-rendered sibling layer or reapply their original gray backgrounds.
-- The normal one-shot ZenHub theme marks the objects "Done", so those original gray
-- surfaces can remain even while the header and navigation are violet/white.
-- Repair only structural backgrounds, never create overlays or touch controls,
-- values, input positions, events, transparency or ZIndex.
local function zenRepairGrayLowerDashboard(gui, mainWindow)
    if not gui or not gui.Parent or not mainWindow or not mainWindow.Parent then return end
    local pos = mainWindow.AbsolutePosition
    local size = mainWindow.AbsoluteSize
    if size.X < 350 or size.Y < 180 then return end

    -- The lower cards can be siblings of the identified main window. Only
    -- consider elements inside the same recognized hub ScreenGui rectangle.
    local left, right = pos.X + 8, pos.X + size.X - 8
    local top = pos.Y + math.min(230, size.Y * 0.43)
    local bottom = pos.Y + math.max(size.Y - 4, 620)
    local patched = 0
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("CanvasGroup"))
            and obj ~= mainWindow and obj.BackgroundTransparency < 0.93
            and not obj:FindFirstAncestor("ZEN_ExpandedIsland")
            and obj.Name:sub(1, #ZEN_DECOR_PREFIX) ~= ZEN_DECOR_PREFIX then

            local p, z = obj.AbsolutePosition, obj.AbsoluteSize
            local xOverlap = math.min(p.X + z.X, right) - math.max(p.X, left)
            local yOverlap = math.min(p.Y + z.Y, bottom) - math.max(p.Y, top)
            -- Structural panels only; intentionally leave buttons, sliders,
            -- toggle tracks, small chips, and all icon backgrounds untouched.
            if z.X >= 112 and z.Y >= 44 and xOverlap >= z.X * 0.76
                and yOverlap >= 24 and p.Y >= pos.Y - 6 then
                local h, sat, val = obj.BackgroundColor3:ToHSV()
                -- Repair only imported GREY cards, never already-white ZenHub cards.
                -- This also avoids repainting intentional soft-lilac controls.
                local r, g, b = obj.BackgroundColor3.R, obj.BackgroundColor3.G, obj.BackgroundColor3.B
                local isOldGray = sat < 0.095 and val < 0.78 and val > 0.17
                    and math.abs(r - g) < 0.045 and math.abs(g - b) < 0.045
                if isOldGray then
                    local target
                    if z.X >= size.X * 0.83 and z.Y >= size.Y * 0.45 then
                        target = ZEN_THEME.Back
                    elseif z.X >= 170 and z.Y >= 70 then
                        target = ZEN_THEME.Panel
                    else
                        target = ZEN_THEME.Surface
                    end
                    if obj.BackgroundColor3 ~= target then
                        obj.BackgroundColor3 = target
                        patched = patched + 1
                    end
                end
            end
        end
    end
    return patched
end

-- Hide ONLY oversized border outlines that leak outside the hub while
-- overlapping it. Do not destroy frames or change input hitboxes/callbacks.
-- This targets the 600px-tall purple rectangle seen at the right of the GUI.
local function zenSuppressLeakedOutlines(gui, mainWindow)
    local wp, ws = mainWindow.AbsolutePosition, mainWindow.AbsoluteSize
    if ws.X < 300 or ws.Y < 180 then return end
    local right = wp.X + ws.X
    local bottom = wp.Y + ws.Y
    for _, frame in ipairs(gui:GetDescendants()) do
        if frame:IsA("GuiObject") and frame ~= mainWindow
            and not frame:FindFirstAncestor("ZEN_ExpandedIsland") then
            local p, sz = frame.AbsolutePosition, frame.AbsoluteSize
            if sz.X >= 250 and sz.Y >= 150 then
                local overlapX = math.max(0, math.min(p.X + sz.X, right) - math.max(p.X, wp.X))
                local overlapY = math.max(0, math.min(p.Y + sz.Y, bottom) - math.max(p.Y, wp.Y))
                local spill = math.max(wp.X - p.X, wp.Y - p.Y,
                    p.X + sz.X - right, p.Y + sz.Y - bottom)
                -- Must substantially overlap our hub AND extend outside it by
                -- 60+ pixels. Small menus, tooltips and side launchers are safe.
                if spill > 60 and overlapX > 120 and overlapY > 120 then
                    for _, item in ipairs(frame:GetChildren()) do
                        if item:IsA("UIStroke") and item.ApplyStrokeMode == Enum.ApplyStrokeMode.Border then
                            -- Just hide the drawn border: the UI/frame stays usable.
                            if item.Enabled then
                                item.Enabled = false
                                item:SetAttribute("ZEN_HiddenOverflowStroke", true)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- The upstream GUI can separate its header from its lower page or put
-- both in sibling frames. Merely styling the title's ancestors creates
-- a white rectangle across a still-dark dashboard (the reported screenshot).
-- Paint *only* neutral, opaque-ish structural surfaces sharing the app region,
-- not buttons, game art, sliders, hitboxes, text or dropdown functionality.
local function zenRestyleWholeDashboard(gui, mainWindow)
    if not (gui and gui.Parent and mainWindow and mainWindow.Parent) then return end
    local wp, ws = mainWindow.AbsolutePosition, mainWindow.AbsoluteSize
    if ws.X < 300 or ws.Y < 150 then return end
    local left, right = wp.X - 18, wp.X + ws.X + 18
    local top = wp.Y - 42
    local bottom = wp.Y + math.max(ws.Y, 640)

    -- A larger, same-column frame often represents the imported dashboard,
    -- with the styled top/content frame in front of it.
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Visible
            and (obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("CanvasGroup"))
            and obj ~= mainWindow
            and not obj:FindFirstAncestor("ZEN_ExpandedIsland")
            and obj.Name:sub(1, #ZEN_DECOR_PREFIX) ~= ZEN_DECOR_PREFIX
            and obj.BackgroundTransparency < 0.94 then
            local p, z = obj.AbsolutePosition, obj.AbsoluteSize
            if z.X >= 110 and z.Y >= 38 and p.X >= left - 25
                and p.X + z.X <= right + 25 and p.Y >= top
                and p.Y < bottom and p.Y + z.Y >= wp.Y then
                local c = obj.BackgroundColor3
                local _, sat, val = c:ToHSV()
                -- Do not replace intentional violet controls, semantic color
                -- or already-white panels. This threshold catches legacy gray.
                if sat < 0.16 and val > 0.09 and val < 0.87 then
                    local target = ZEN_THEME.Surface
                    if z.X >= ws.X * 0.78 and z.Y >= 160 then
                        target = ZEN_THEME.Back
                    elseif z.X >= 180 and z.Y >= 67 then
                        target = ZEN_THEME.Panel
                    end
                    obj.BackgroundColor3 = target
                    -- Keep transparency and all original GUI input semantics.
                end
            end
        end
    end
end

-- Some originally white-on-dark labels become white-on-white after restyling.
-- Restore legible contrast based on the *actual* nearest solid parent.
local function zenFixTextContrast(gui, mainWindow)
    if not (gui and gui.Parent and mainWindow and mainWindow.Parent) then return end
    local wp, ws = mainWindow.AbsolutePosition, mainWindow.AbsoluteSize
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
            and obj.Visible and obj.TextTransparency < 0.70
            and not obj:GetAttribute("__HiddenVxLogo")
            and not obj:FindFirstAncestor("ZEN_ExpandedIsland") then
            local p, z = obj.AbsolutePosition, obj.AbsoluteSize
            if z.X >= 20 and z.Y >= 10
                and p.X >= wp.X - 12 and p.X < wp.X + ws.X + 12
                and p.Y >= wp.Y - 12 and p.Y < wp.Y + ws.Y + 12 then
                local bg = zenNearestBackdrop(obj, gui)
                if bg then
                    local ratio = zenContrastRatio(obj.TextColor3, bg)
                    local minimum = (obj.TextSize >= 18) and 3 or 4.5
                    if ratio < minimum then
                        local dark = ZEN_THEME.Text
                        local light = ZEN_THEME.OnAccent
                        obj.TextColor3 = (zenContrastRatio(dark, bg)
                            > zenContrastRatio(light, bg)) and dark or light
                    end
                end
                zenReadableType(obj)
            end
        end
    end
end

-- Resolve the full visible dashboard rectangle, not a smaller subpanel.
local function zenResolveHeaderFrame(gui, titleLbl)
    local best
    local curr = titleLbl
    while curr and curr.Parent and curr.Parent ~= gui do
        curr = curr.Parent
        if curr:IsA("GuiObject") and curr.AbsoluteSize.X >= 240
            and curr.AbsoluteSize.Y >= 145 then
            if not best or curr.AbsoluteSize.X * curr.AbsoluteSize.Y
                > best.AbsoluteSize.X * best.AbsoluteSize.Y then
                best = curr
            end
        end
    end
    return best
end

local function zenResolveWindow(gui, titleLbl)
    local headerFrame = zenResolveHeaderFrame(gui, titleLbl)
    if not headerFrame then return nil end
    local best = headerFrame
    local ap, az = headerFrame.AbsolutePosition, headerFrame.AbsoluteSize
    -- Find an outer dashboard layer, even if the imported header and page
    -- are siblings (the original reason for the white/gray double panel).
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Visible and obj ~= headerFrame
            and (obj:IsA("Frame") or obj:IsA("CanvasGroup") or obj:IsA("ScrollingFrame")) then
            local p, z = obj.AbsolutePosition, obj.AbsoluteSize
            if z.X >= math.max(320, az.X * 0.88) and z.X <= az.X * 1.20
                and z.Y >= az.Y * 1.08 and z.Y < 1600
                and math.abs(p.X - ap.X) <= 26
                and math.abs(p.Y - ap.Y) <= 28
                and obj.BackgroundTransparency < 0.98
                and z.X * z.Y > best.AbsoluteSize.X * best.AbsoluteSize.Y then
                best = obj
            end
        end
    end
    return best
end

-- Detect competing full hub ScreenGuis (for example S2r and ZenHub started
-- in the same server). Keep the latest visible hub interface, not both.
local function zenHubGuiTitle(gui)
    if not gui:IsA("ScreenGui") or not gui.Enabled or IGNORED_GUI_NAMES[gui.Name] then
        return nil
    end
    local winner
    for _, d in ipairs(gui:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton"))
            and d.Visible and d.AbsoluteSize.X >= 35
            and not d:FindFirstAncestorOfClass("ScrollingFrame") then
            local label = (d:GetAttribute("OrigRawText") or d.Text or ""):lower()
            label = label:match("^%s*(.-)%s*$") or label
            if label == "zenhub" or label == "s2r hub"
                or label == "venyx" or label == "venyxhub"
                or label == "venyx sae" or label == "ronnei hub"
                or label == "chilli hub" or label == "chilli hub v5" then
                winner = d
                break
            end
        end
    end
    return winner
end

local function zenRectOverlap(a, b)
    local ap, az, bp, bz = a.AbsolutePosition, a.AbsoluteSize, b.AbsolutePosition, b.AbsoluteSize
    local dx = math.max(0, math.min(ap.X+az.X, bp.X+bz.X) - math.max(ap.X,bp.X))
    local dy = math.max(0, math.min(ap.Y+az.Y, bp.Y+bz.Y) - math.max(ap.Y,bp.Y))
    local smallerArea = math.min(az.X*az.Y, bz.X*bz.Y)
    return (smallerArea > 0) and (dx*dy / smallerArea) or 0
end

local function zenHideDuplicateHubScreenGuis()
    local candidates = {}
    local seen = {}
    for _, root in ipairs(scanRoots) do
        for _, gui in ipairs(root:GetChildren()) do
            if not seen[gui] then
                seen[gui] = true
                local label = zenHubGuiTitle(gui)
                local window = label and zenResolveWindow(gui,label)
                if window and window.AbsoluteSize.X >= 320 and window.AbsoluteSize.Y >= 160 then
                    candidates[#candidates+1] = {gui=gui, window=window}
                end
            end
        end
    end
    if #candidates < 2 then return end
    -- GetChildren enumerates children in insertion order. The newest hub
    -- screen normally belongs to the most recently launched feature engine.
    -- Never disable separate windows which do not significantly overlap.
    for i=1,#candidates-1 do
        local old = candidates[i]
        for j=i+1,#candidates do
            local newer = candidates[j]
            if old.gui.Enabled and newer.gui.Enabled
                and zenRectOverlap(old.window, newer.window) > 0.72 then
                old.gui.Enabled = false -- reversible; don't destroy callbacks
                old.gui:SetAttribute("ZenHub_DisabledDuplicate",true)
                break
            end
        end
    end
end

local function zenStyleWindow(mainWindow, titleLbl, decorationEnabled, scaleEnabled)
    if not mainWindow or not mainWindow.Parent then return end
    mainWindow.BackgroundColor3 = ZEN_THEME.Back
    zenRound(mainWindow, 16)
    zenStroke(mainWindow, ZEN_THEME.Border, 1.2, 0.08, mainWindow)
    if not mainWindow:GetAttribute(ZEN_DECOR_PREFIX .. "Listening") then
        mainWindow:SetAttribute(ZEN_DECOR_PREFIX .. "Listening", true)
        mainWindow.DescendantAdded:Connect(function(desc)
            task.defer(function()
                if desc and desc.Parent then zenStyleObject(desc, mainWindow) end
            end)
        end)
    end
    for _, desc in ipairs(mainWindow:GetDescendants()) do
        zenStyleObject(desc, mainWindow)
    end
    if decorationEnabled ~= false then zenDecorateWindow(mainWindow, titleLbl) end
    if scaleEnabled ~= false then zenFitScreen(mainWindow) end
end

-- Paint actual content controls in sibling panel layers, not just their
-- parent backgrounds. This keeps the lower Farm/Steal/Sell pages readable.
local function zenStyleSiblingFeaturePages(gui, appWindow)
    if not appWindow or not appWindow.Parent then return end
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("GuiObject") or obj:IsA("UIStroke") or obj:IsA("UIGradient") then
            if not obj:IsDescendantOf(appWindow) and obj ~= appWindow
                and (obj:IsA("TextLabel") or obj:IsA("TextButton")
                    or obj:IsA("TextBox") or obj:IsA("ScrollingFrame")
                    or obj:IsA("Frame")) then
                zenStyleObject(obj, appWindow, true)
            end
        end
    end
end

-- Keep the status pill outside the window where there is a clear right gutter.
-- Otherwise do not force it across navigation or steal touch input from tabs.
local function zenDockStatusPill(gui, appWindow)
    if not appWindow or not appWindow.Parent then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local spareRight = camera.ViewportSize.X
        - (appWindow.AbsolutePosition.X + appWindow.AbsoluteSize.X)
    if spareRight < 215 then return end
    local expanded = gui:FindFirstChild("ZEN_ExpandedIsland")
    if not expanded then return end
    for _, child in ipairs(gui:GetChildren()) do
        if child:IsA("GuiObject") and child:FindFirstChild("IslandExpandHint")
            and not child:GetAttribute("__ZenDockV4") then
            child:SetAttribute("__ZenDockV4", true)
            child.AnchorPoint = Vector2.new(1, 0)
            child.Position = UDim2.new(1, -16, 0, 78)
            expanded.AnchorPoint = Vector2.new(1, 0)
            expanded.Position = child.Position
            break
        end
    end
end

-- ==================== 6. BỘ QUÉT BẤT TỬ (CHỐNG TRỄ KHI REJOIN & BẮT 100% FPS ẢO) ====================
local function patchZenHubDiscordInvite(gui)
    for _, item in ipairs(gui:GetDescendants()) do
        if item:IsA("TextButton") and (item.Text or ""):lower() == "copy invite"
            and not item:GetAttribute("ZenHub_InviteBound") then
            item:SetAttribute("ZenHub_InviteBound", true)
            item.MouseButton1Click:Connect(function()
                -- Deferred so the upstream button's original clipboard handler
                -- cannot leave its old invite in the clipboard.
                task.defer(function()
                    if type(setclipboard) == "function" then
                        pcall(setclipboard, "https://discord.gg/z5CSuSYzh")
                    end
                end)
            end)
        end
    end
end

local function patchBaseScreenGui(gui, titleLbl)
    patchZenHubDiscordInvite(gui)
    if titleLbl.Text ~= NEW_TITLE then
        titleLbl.Text = NEW_TITLE
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
    end
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = math.max(titleLbl.TextSize, 19)
    titleLbl.TextColor3 = ZEN_THEME.AccentHover

    local mainWindow = zenResolveWindow(gui, titleLbl)

    local headerY = titleLbl.AbsolutePosition.Y

    if mainWindow then
        local headerFrame = zenResolveHeaderFrame(gui, titleLbl)
        zenStyleWindow(mainWindow, titleLbl)
        if headerFrame and headerFrame ~= mainWindow then
            -- Sibling backgrounds can be larger than the header itself.
            -- A nested UIScale would shrink the header twice.
            zenStyleWindow(headerFrame, titleLbl, false, false)
        end
        zenRestyleWholeDashboard(gui, mainWindow)
        zenRepairGrayLowerDashboard(gui, mainWindow)
        zenStyleSiblingFeaturePages(gui, mainWindow)
        zenSuppressLeakedOutlines(gui, mainWindow)
        zenFixTextContrast(gui, mainWindow)
        patchHeaderLogoLeftOfTitle(headerFrame or mainWindow, titleLbl)
        zenDockStatusPill(gui, mainWindow)
        titleLbl.TextColor3 = ZEN_THEME.AccentHover
    end

    for _, topChild in ipairs(gui:GetChildren()) do
        if topChild:IsA("GuiObject")
        and topChild ~= mainWindow
        and topChild.Name ~= "ZEN_ExpandedIsland"
        and not topChild:FindFirstChild("IslandExpandHint") then
            setupUnclippedCircularLogo(topChild)
        end
    end

    local allDescendants = gui:GetDescendants()
    local pendingTextQueue = {}

    for i = 1, #allDescendants do
        local desc = allDescendants[i]
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            local txt = desc.Text or ""
            local origTxt = desc:GetAttribute("OrigRawText") or ""
            local isAlreadyMovedIdle = desc:GetAttribute("__IslandDone")

            local isStatusKeyword = txt:lower():find("idle", 1, true)
                or origTxt:lower():find("idle", 1, true)
                or txt == "Đang rảnh"

            local isHeaderIdle = (not gui:GetAttribute("__IslandLocked"))
                and (not desc:FindFirstAncestorOfClass("ScrollingFrame"))
                and desc.Parent
                and (not titleLbl:IsDescendantOf(desc.Parent))
                and math.abs(desc.AbsolutePosition.Y - headerY) < 35
                and desc.AbsolutePosition.X > titleLbl.AbsolutePosition.X + 60
                and isStatusKeyword

            if isHeaderIdle or isAlreadyMovedIdle then
                gui:SetAttribute("__IslandLocked", true)
                setupDynamicIslandFromStatus(desc, gui)
            elseif isFpsCounterText(txt) then
                hookFakeFpsCounter(desc)
            elseif not desc:GetAttribute("__TransHooked") then
                pendingTextQueue[#pendingTextQueue + 1] = desc
            end

        elseif (desc:IsA("ImageLabel") or desc:IsA("ImageButton"))
        and desc.Name ~= "ZENCoverLogo"
        and desc.Name ~= "ZENHeaderLogo"
        and desc.Name ~= "InnerZENLogo" then
            if not desc:FindFirstAncestorOfClass("ScrollingFrame") then
                if mainWindow and not desc:IsDescendantOf(mainWindow) then
                    setupUnclippedCircularLogo(desc)
                end
            end
        end
    end

    if #pendingTextQueue > 0 and not gui:GetAttribute("__BatchTranslating") then
        gui:SetAttribute("__BatchTranslating", true)
        task.spawn(function()
            for idx = 1, #pendingTextQueue do
                local item = pendingTextQueue[idx]
                if item and item.Parent then
                    hookTextForTranslation(item)
                end
                if idx % 45 == 0 then
                    task.wait()
                end
            end
            gui:SetAttribute("__BatchTranslating", false)
        end)
    end
end

local baseMainPatched = false

local function attachScreenGuiListeners(gui)
    if not gui:IsA("ScreenGui") or IGNORED_GUI_NAMES[gui.Name] then return end
    if gui:GetAttribute("__GlobalTextListener") then return end
    gui:SetAttribute("__GlobalTextListener", true)

    gui.DescendantAdded:Connect(function(newDesc)
        if newDesc:IsA("TextLabel") or newDesc:IsA("TextButton") or newDesc:IsA("TextBox") then
            task.defer(function()
                if not newDesc:IsA("TextBox") and isFpsCounterText(newDesc.Text) then
                    hookFakeFpsCounter(newDesc)
                else
                    hookTextForTranslation(newDesc)
                end
            end)
        end
    end)
end

local function isHubTitle(label)
    label = (label or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    return label == "venyx" or label == "venyxhub" or label == "venyx sae"
        or label == "ronnei" or label == "ronnei hub"
        or label == "chilli hub" or label == "chilli hub v5" or label == "chili hub"
        or label:match("^zen%s*hub") ~= nil
        or label:match("^zenhub") ~= nil
end

local function tryPatchBaseGui()
    zenHideDuplicateHubScreenGuis()
    for _, root in ipairs(scanRoots) do
        for _, gui in ipairs(root:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled
                and not IGNORED_GUI_NAMES[gui.Name] then
                local titleLbl = nil
                for _, d in ipairs(gui:GetDescendants()) do
                    if (d:IsA("TextLabel") or d:IsA("TextButton"))
                        and not d:FindFirstAncestorOfClass("ScrollingFrame")
                        and isHubTitle(d:GetAttribute("OrigRawText") or d.Text) then
                        -- Prefer a visible header label over offscreen legacy labels.
                        titleLbl = d
                        if d.Visible and d.AbsoluteSize.X >= 35 then break end
                    end
                end
                if titleLbl then
                    baseMainPatched = true
                    attachScreenGuiListeners(gui)
                    patchBaseScreenGui(gui, titleLbl)
                end
            end
        end
    end
end

-- Lắng nghe mọi ScreenGui mới được tạo ra bất kỳ lúc nào (Kể cả khi Rejoin tải chậm)
for _, root in ipairs(scanRoots) do
    if root then
        root.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and not IGNORED_GUI_NAMES[child.Name] then
                task.wait(0.15)
                pcall(tryPatchBaseGui)
            end
        end)
    end
end

-- Keep checking until the base UI is available (tối đa 60 giây cho trường hợp Rejoin mạng chậm)
-- Then continue light status checks thì duy trì kiểm tra nhẹ mỗi 1.5s để không bao giờ rớt FPS ảo
-- Start the GUI watcher before starting the imported feature engine.
-- This minimizes the delay before the imported UI receives ZenHub styling.
pcall(tryPatchBaseGui)
-- Start the upstream base GUI while preserving its original functionality
if not ZEN_ENV.__ZENBaseLoaded
    and not ZEN_ENV.__S2RBaseLoaded
    and not ZEN_ENV.__RdzBaseLoaded
    and not baseMainPatched then
    ZEN_ENV.__ZENBaseLoaded = true
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        -- Older GUI versions sometimes appear one frame after startup.
        task.wait(1.0)
        pcall(tryPatchBaseGui)
        if baseMainPatched then return end
        local ok, err = pcall(function()
            -- Required upstream feature engine. The ZEN theme is applied to
            -- its GUI below; do not start a second copy of the engine.
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()
        end)
        if not ok then
            ZEN_ENV.__ZENBaseLoaded = false -- Allow a manual retry after load failure.
            warn("[ZEN] Feature engine failed to start: " .. tostring(err))
        end
    end)
end

task.spawn(function()
    local elapsed = 0
    while ZEN_ENV.__ZenHubAirThemeRevision == ZEN_THEME_REVISION
        and not baseMainPatched and elapsed < 60 do
        task.wait(0.35)
        elapsed = elapsed + 0.35
        pcall(tryPatchBaseGui)
    end
    while ZEN_ENV.__ZenHubAirThemeRevision == ZEN_THEME_REVISION do
        task.wait(1.5)
        pcall(tryPatchBaseGui)
    end
end)
]===]

-- LƯU BẢN MỚI NHẤT VÀO MÁY NGAY LẬP TỨC ĐỂ KHI REJOIN LUÔN CHẠY BẢN MỚI NHẤT
if writefile then
    pcall(function()
        local selfReplicatingWrapper = "local ZEN_CORE_PAYLOAD = [===[" .. ZEN_CORE_PAYLOAD .. "]===]\n" .. [[
if writefile then
    pcall(function()
        writefile("ZenHub_AutoRun.lua", "local ZEN_CORE_PAYLOAD = [===[" .. ZEN_CORE_PAYLOAD .. "]===]\nloadstring(ZEN_CORE_PAYLOAD)()")
    end)
end
loadstring(ZEN_CORE_PAYLOAD)()
]]
        writefile(AUTO_RUN_FILE, selfReplicatingWrapper)
    end)
end

loadstring(ZEN_CORE_PAYLOAD)()
