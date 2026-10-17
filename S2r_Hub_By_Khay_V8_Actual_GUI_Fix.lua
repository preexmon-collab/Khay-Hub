-- S2r Hub By Khay | V8 LIVE DASHBOARD FIX | VIOLET/BLACK | ENGLISH | NO GLOW
-- Restyles the existing hub GUI without replacing feature callbacks.
-- Upstream source URLs are functional dependencies, not displayed hub names.

local S2R_CORE_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "S2rHubByKhay_AutoRun.lua"
local LANG_SAVE_FILE = "S2rHubByKhay_Lang.txt"

local S2R_CORE_PAYLOAD = [===[
local NEW_TITLE = "S2r Hub By Khay"
local S2R_VERSION = "V8"
local LOGO_BG_COLOR = Color3.fromRGB(20, 16, 34)
local ISLAND_BLACK_BG = Color3.fromRGB(12, 9, 23)

local S2R_CORE_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "S2rHubByKhay_AutoRun.lua"
local LANG_SAVE_FILE = "S2rHubByKhay_Lang.txt"

-- Teleport autoload: queue only S2R's own file, never override other scripts' hooks.
-- Executing a wrapper again must not disable unrelated OnTeleport connections.
do
    local env = (getgenv and getgenv()) or _G
    local queue = env.queue_on_teleport or env.queueonteleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (delta and delta.queue_on_teleport)
    if type(queue) == "function" and not env.__S2RByKhayTeleportQueued then
        local bootstrap = [[
            task.spawn(function()
                if not game:IsLoaded() then game.Loaded:Wait() end
                if isfile and readfile and isfile("S2rHubByKhay_AutoRun.lua") then
                    local ok, err = pcall(function()
                        local loader = loadstring(readfile("S2rHubByKhay_AutoRun.lua"))
                        if loader then loader() end
                    end)
                    if not ok then warn("[S2r Hub By Khay] Teleport reload: " .. tostring(err)) end
                end
            end)
        ]]
        local ok = pcall(function() queue(bootstrap) end)
        if ok then env.__S2RByKhayTeleportQueued = true end
    end
end

-- Avoid creating duplicate input listeners and scanning threads on repeated execution.
local S2R_ENV = (getgenv and getgenv()) or _G
if S2R_ENV.__S2RByKhayV8Running then
    warn("[S2r Hub By Khay V8] This V8 patch is already active.")
    return
end
-- A previous version's guard must not prevent an updated GUI patch from starting.
S2R_ENV.__S2RByKhayV8Running = true

-- The base GUI is loaded separately; this script customizes it after creation.
if not S2R_ENV.__S2rByKhayBaseLoaded then
    S2R_ENV.__S2rByKhayBaseLoaded = true
    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        local ok, err = pcall(function()
            local source = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub")
            local fn, compileError = loadstring(source)
            if not fn then error(compileError) end
            fn()
        end)
        if not ok then
            S2R_ENV.__S2rByKhayBaseLoaded = false
            warn("[S2r Hub By Khay] Upstream GUI could not load: " .. tostring(err))
        end
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local scanRoots = {}
local function addScanRoot(root)
    if not root then return end
    for _, existing in ipairs(scanRoots) do
        if existing == root then return end
    end
    scanRoots[#scanRoots + 1] = root
end
if type(gethui) == "function" then
    local ok, hiddenGui = pcall(gethui)
    if ok then addScanRoot(hiddenGui) end
end
addScanRoot(CoreGui)
local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
addScanRoot(playerGui)

local IGNORED_GUI_NAMES = {
    ["RobloxGui"] = true, ["TopBarApp"] = true, ["TouchGui"] = true,
    ["Chat"] = true, ["BubbleChat"] = true, ["Freecam"] = true,
    ["BackpackGui"] = true, ["PlayerList"] = true, ["PurchasePrompt"] = true
}

-- Khay edition premium violet/black palette. No rainbow animation or glow.
local S2R_THEME = {
    Back = Color3.fromRGB(9, 8, 17),
    Rail = Color3.fromRGB(13, 10, 25),
    Header = Color3.fromRGB(19, 14, 36),
    Panel = Color3.fromRGB(24, 18, 43),
    Surface = Color3.fromRGB(35, 26, 57),
    Control = Color3.fromRGB(45, 33, 73),
    Active = Color3.fromRGB(104, 62, 189),
    Accent = Color3.fromRGB(158, 108, 241),
    AccentHover = Color3.fromRGB(208, 179, 255),
    Border = Color3.fromRGB(101, 76, 151),
    StrokeMuted = Color3.fromRGB(68, 49, 108),
    Text = Color3.fromRGB(250, 247, 255),
    Muted = Color3.fromRGB(188, 177, 210),
    Subtle = Color3.fromRGB(145, 132, 173),
    Knob = Color3.fromRGB(250, 247, 255),
}
local S2R_DISCORD_URL = "https://discord.gg/z5CSuSYzh"
local S2R_DISCORD_NAME = "Khay Discord"

-- FPS counters: display the values provided by the actual upstream UI unchanged.
-- The previous FPS text-spoofing daemon was an unnecessary persistent GUI hook.
local function isFpsCounterText(str)
    return type(str) == "string" and str:find("FPS", 1, true) ~= nil
        and str:find("%d+%s*FPS") ~= nil
end
-- No FPS spoofing or text rewriting: the core reports real values.

-- ==================== 3. ENGLISH LABEL COMPATIBILITY ====================
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
    ["Venyx Discord"] = "S2R Hub Discord",
    ["Updates, keys, support"] = "Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"] = "Chép Link Mời",
    ["Discord"] = "Discord",
    ["MONEY /S"] = "TIỀN /GIÂY",
    ["OPEN"] = "MỞ",
    ["Open"] = "Mở",
    ["Close"] = "Đóng",
    ["Welcome to Venyx 1.0.0! Join our Discord for updates and support"] = "Chào mừng tới S2R Hub! Tham gia Discord để cập nhật và nhận hỗ trợ",
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
    { pat = "Venyx(.-)(%d+) hours? ago", rep = "S2R Hub%1%2 giờ trước" },
    { pat = "Venyx(.-)(%d+) minutes? ago", rep = "S2R Hub%1%2 phút trước" },
    { pat = "Venyx(.-)(%d+) days? ago", rep = "S2R Hub%1%2 ngày trước" },
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
    if not cleanEn or cleanEn == "" then return "Idle" end
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

local function brandS2RText(input)
    if type(input) ~= "string" or input == "" then return input end
    local out = input
    if out:lower():find("venyx%s*discord") or out:lower():find("s2r%s*hub%s*by%s*khay%s*discord")
        or out:lower():find("chilli%s*hub%s*discord") then
        return S2R_DISCORD_NAME
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
    -- Normalize previous display names. Never modify source URLs or user inputs.
    out = out:gsub("S2R Hub%s+[Vv]%d+[%d%.]*", "S2R Hub")
    out = out:gsub("S2R HUB", NEW_TITLE):gsub("S2R Hub", NEW_TITLE)
    out = out:gsub("S2r Hub%s+[Vv]%d+[%d%.]*", NEW_TITLE)
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
local function s2rRecoverEnglish(raw)
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
        raw = raw:gsub("Venyx SAE", "Khay Edition")
    elseif raw == "VENYX" then
        raw = NEW_TITLE
    end

    if currentLanguage == "EN" then
        local english = s2rRecoverEnglish(raw)
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
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__FpsHooked") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("S2R_ExpandedIsland") then return end
    if inst:GetAttribute("S2RByKhayTranslating") then return end

    if inst:IsA("TextBox") then
        local origPh = inst:GetAttribute("S2RByKhayPlaceholder")
        if not origPh and inst.PlaceholderText ~= "" then
            origPh = inst.PlaceholderText
            inst:SetAttribute("S2RByKhayPlaceholder", origPh)
        end
        if origPh then
            inst.PlaceholderText = brandS2RText(translateBaseText(origPh))
        end

        -- Do not ever rewrite TextBox.Text. It may contain a server ID,
        -- webhook URL, quantity or a feature-specific editable value.
        return
    end

    local rawText = inst.Text
    if isFpsCounterText(rawText) then return end

    local original = inst:GetAttribute("S2RByKhayOriginalText")
    if not original then
        original = rawText
        inst:SetAttribute("S2RByKhayOriginalText", original)
    end

    local mapped = brandS2RText(translateBaseText(original))
    if original == "Updates, keys, support" then
        mapped = "Community, updates, support"
    end
    if inst.Text ~= mapped then
        inst:SetAttribute("S2RByKhayTranslating", true)
        inst:SetAttribute("S2RByKhayLastText", mapped)
        pcall(function() inst.Text = mapped end)
        inst:SetAttribute("S2RByKhayTranslating", false)
    else
        inst:SetAttribute("S2RByKhayLastText", mapped)
    end
end

local function hookTextForTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("S2R_ExpandedIsland") then return end
    if inst:IsA("TextBox") and inst:IsFocused() then return end

    if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
        return
    end

    applyElementTranslation(inst)

    if inst:GetAttribute("__S2RByKhayTransHooked") then return end
    inst:SetAttribute("__S2RByKhayTransHooked", true)
    table.insert(TrackedTexts, inst)

    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if inst:GetAttribute("S2RByKhayTranslating") or inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") then return end
        if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
            return
        end
        if inst:IsA("TextBox") then
            applyElementTranslation(inst)
            return
        end
        if inst.Text ~= inst:GetAttribute("S2RByKhayLastText") then
            inst:SetAttribute("S2RByKhayOriginalText", inst.Text)
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

-- Scale the WHOLE imported window, preserving the original click hitboxes.
-- Recalculate layout against the live viewport on mobile rotation.
local S2RMainWindow = nil
local S2RWindowZoom = setmetatable({}, {__mode="k"})
local S2RViewportBound = setmetatable({}, {__mode="k"})
local function s2rResizeWindow(mode)
    local win = S2RMainWindow
    local camera = workspace.CurrentCamera
    if not (win and win.Parent and camera) then return false end
    local viewport = camera.ViewportSize
    if viewport.X < 240 or viewport.Y < 180 then return false end

    local scaler = win:FindFirstChild("S2R_KHAY_WindowScale")
    if not scaler then
        scaler = Instance.new("UIScale")
        scaler.Name = "S2R_KHAY_WindowScale"
        scaler.Scale = 1
        scaler.Parent = win
    end
    local geom = S2RWindowZoom[win]
    if not geom then
        -- Read the unscaled design size once. A legacy UIScale may already exist.
        local current = math.max(0.1, scaler.Scale)
        geom = {
            w = math.max(260, win.AbsoluteSize.X / current),
            h = math.max(170, win.AbsoluteSize.Y / current),
        }
        S2RWindowZoom[win] = geom
    end

    local maxFit = math.max(0.10, math.min(3,
        (viewport.X - 36) / geom.w,
        (viewport.Y - 68) / geom.h))
    local target = scaler.Scale
    if mode == "reset" then
        -- Prefer a readable ~900 x 540 layout, but always fit smaller screens.
        target = math.min(1.7, 900 / geom.w, 540 / geom.h)
    elseif mode == "smaller" then
        target = target * 0.88
    elseif mode == "larger" then
        target = target * 1.12
    elseif mode ~= "fit" then
        return false
    end
    scaler.Scale = math.max(0.10, math.min(target, maxFit, 3))
    if mode == "reset" then
        win.AnchorPoint = Vector2.new(0.5, 0.5)
        win.Position = UDim2.fromScale(0.5, 0.52)
    end
    return true
end

-- ==================== 4. STANDALONE DISPLAY CONTROLS ====================
-- Deliberately separate from the imported hub; never reparent its status bar.
local S2ROverlay = nil
local function s2rCreateDisplayTools(hubGui)
    if S2ROverlay and S2ROverlay.Parent then return end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    local screen = Instance.new("ScreenGui")
    screen.Name = "S2R_KHAY_DisplayControls"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 150
    screen.Parent = pg
    S2ROverlay = screen

    local launch = Instance.new("TextButton")
    launch.Name = "OpenDisplay"
    launch.AnchorPoint = Vector2.new(0.5, 0)
    launch.Position = UDim2.new(0.5, 0, 0, 3)
    launch.Size = UDim2.fromOffset(170, 34)
    launch.BackgroundColor3 = Color3.fromRGB(20, 17, 31)
    launch.BorderSizePixel = 0
    launch.Text = "S2R  /  KHAY  /  DISPLAY"
    launch.TextColor3 = Color3.fromRGB(230, 213, 255)
    launch.TextSize = 11
    launch.Font = Enum.Font.GothamBold
    launch.ZIndex = 10
    launch.Parent = screen
    Instance.new("UICorner", launch).CornerRadius = UDim.new(0, 10)
    local border = Instance.new("UIStroke", launch)
    border.Color = Color3.fromRGB(100, 76, 152)
    border.Thickness = 1
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local panel = Instance.new("Frame")
    panel.Name = "DisplayPanel"
    panel.AnchorPoint = Vector2.new(0.5, 0)
    panel.Position = UDim2.new(0.5, 0, 0, 44)
    panel.Size = UDim2.fromOffset(312, 168)
    panel.BorderSizePixel = 0
    panel.BackgroundColor3 = Color3.fromRGB(18, 15, 27)
    panel.Visible = false
    panel.ZIndex = 20
    panel.Parent = screen
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Color3.fromRGB(89, 71, 119)
    panelStroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -28, 0, 28)
    title.Position = UDim2.fromOffset(14, 7)
    title.BackgroundTransparency = 1
    title.Text = "S2r Hub By Khay  /  Display"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextColor3 = Color3.fromRGB(248, 243, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 21
    title.Parent = panel

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -28, 0, 32)
    info.Position = UDim2.fromOffset(14, 39)
    info.BackgroundTransparency = 1
    info.Text = "ENGLISH  ·  OBSIDIAN VIOLET  ·  NO GLOW"
    info.Font = Enum.Font.GothamMedium
    info.TextColor3 = Color3.fromRGB(175, 163, 200)
    info.TextSize = 10
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.ZIndex = 21
    info.Parent = panel

    local function addButton(label, x, width, mode, isPrimary)
        local b = Instance.new("TextButton")
        b.Name = "S2RSize_" .. mode
        b.Position = UDim2.fromOffset(x, 85)
        b.Size = UDim2.fromOffset(width, 36)
        b.BorderSizePixel = 0
        b.BackgroundColor3 = isPrimary and Color3.fromRGB(105, 69, 190) or Color3.fromRGB(43, 35, 61)
        b.Text = label
        b.Font = Enum.Font.GothamSemibold
        b.TextColor3 = Color3.fromRGB(251, 249, 255)
        b.TextSize = 10
        b.ZIndex = 22
        b.Parent = panel
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
        b.Activated:Connect(function()
            if s2rResizeWindow(mode) and mode == "reset" then
                info.Text = "Window size restored  ·  Layout preserved"
            elseif mode == "smaller" or mode == "larger" then
                info.Text = "Adjust freely  ·  Use RESET to restore"
            end
        end)
    end
    addButton("- SMALL", 12, 88, "smaller", false)
    addButton("RESET SIZE", 108, 96, "reset", true)
    addButton("+ LARGE", 212, 88, "larger", false)

    local foot = Instance.new("TextLabel")
    foot.Size = UDim2.new(1, -20, 0, 18)
    foot.Position = UDim2.fromOffset(12, 138)
    foot.BackgroundTransparency = 1
    foot.Text = "Core feature callbacks remain in the original GUI."
    foot.Font = Enum.Font.Gotham
    foot.TextSize = 9
    foot.TextColor3 = Color3.fromRGB(137, 126, 162)
    foot.ZIndex = 21
    foot.Parent = panel
    launch.Activated:Connect(function()
        panel.Visible = not panel.Visible
    end)
    local function responsiveDisplayPanel()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local v = camera.ViewportSize
        local scale = panel:FindFirstChild("S2R_KHAY_MobileFit")
        if not scale then
            scale = Instance.new("UIScale")
            scale.Name = "S2R_KHAY_MobileFit"
            scale.Parent = panel
        end
        scale.Scale = math.max(0.6, math.min(1, (v.X - 26) / 312))
        panel.Size = UDim2.fromOffset(312, 168)
    end
    responsiveDisplayPanel()
    local viewportConn
    local function bindViewport()
        if viewportConn then viewportConn:Disconnect() end
        local camera = workspace.CurrentCamera
        if camera then
            viewportConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(responsiveDisplayPanel)
            responsiveDisplayPanel()
        end
    end
    bindViewport()
    local cameraConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport)
    screen.Destroying:Connect(function()
        if viewportConn then viewportConn:Disconnect() end
        if cameraConn then cameraConn:Disconnect() end
    end)
    hubGui.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if screen.Parent then screen:Destroy() end
            if S2ROverlay == screen then S2ROverlay = nil end
        end
    end)
end

-- ==================== 5. S2R FLOATING LAUNCHER AND HEADER ====================
-- Floating launcher is retained unchanged to protect its click target.

-- Header monogram is added separately; no original icon is hidden.

-- KHAY V6 SIGNATURE -----------------------------------------------------------
-- Native Roblox styling, no overlays on clickable controls and no glow.
-- Restyle only the imported hub window; core game and feature callbacks stay intact.
local S2R_DECOR_PREFIX = "S2R_KHAY_"

local function s2rRound(obj, px)
    local corner = obj:FindFirstChildOfClass("UICorner")
    if not corner then
        corner = Instance.new("UICorner")
        corner.Parent = obj
    end
    corner.CornerRadius = UDim.new(0, px)
end

local function s2rStroke(obj, color, thickness, transparency)
    if not obj:IsA("GuiObject") then return end
    local stroke = obj:FindFirstChild(S2R_DECOR_PREFIX .. "Stroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = S2R_DECOR_PREFIX .. "Stroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj
    end
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    return stroke
end

local function s2rIsCompactDot(obj)
    local sz = obj.AbsoluteSize
    return sz.X > 0 and sz.X <= 28 and sz.Y > 0 and sz.Y <= 28
        and math.abs(sz.X - sz.Y) <= 6
end

local function s2rIsToggleTrack(obj)
    if not (obj:IsA("Frame") or obj:IsA("ImageButton") or obj:IsA("TextButton")) then return false end
    local sz = obj.AbsoluteSize
    return sz.X >= 28 and sz.X <= 75 and sz.Y >= 13 and sz.Y <= 33
        and (sz.X / math.max(1, sz.Y)) >= 1.55
        and (sz.X / math.max(1, sz.Y)) <= 3.6
end

local function s2rToneToggle(obj)
    if not obj or not obj.Parent or obj:GetAttribute(S2R_DECOR_PREFIX .. "InPaint") then return end
    local original = obj.BackgroundColor3
    local _, sat, val = original:ToHSV()
    -- A changing upstream toggle is represented as active when its source is vivid.
    -- Do not infer state from our own violet theme colors.
    if original == S2R_THEME.Active or original == S2R_THEME.Control then return end
    local paint = (sat > 0.24 and val > 0.33) and S2R_THEME.Active or S2R_THEME.Control
    obj:SetAttribute(S2R_DECOR_PREFIX .. "InPaint", true)
    obj.BackgroundColor3 = paint
    obj:SetAttribute(S2R_DECOR_PREFIX .. "InPaint", false)
end

local function s2rTextTone(original)
    -- Keep meaningful danger/success/warning states instead of making them white.
    local hue, sat, value = original:ToHSV()
    if sat > 0.52 and value > 0.48 then
        if (hue >= 0.22 and hue <= 0.53) or hue <= 0.05 or hue >= 0.95 then
            return original
        end
    end
    return nil
end

local function s2rStyleObject(obj, mainWindow)
    if not obj or not obj.Parent or not obj:IsDescendantOf(mainWindow) then return end
    if obj.Name:sub(1, #S2R_DECOR_PREFIX) == S2R_DECOR_PREFIX then return end
    if obj:FindFirstAncestor("S2R_ExpandedIsland") or obj.Name == "S2RHeaderLogo" then return end
    if obj:IsA("UIGradient") then
        -- Only recolor large decorative card gradients. Slider/toggle gradients remain untouched.
        local parent = obj.Parent
        if parent and parent:IsA("GuiObject") then
            local sz = parent.AbsoluteSize
            if sz.X >= 175 and sz.Y >= 60 then
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, S2R_THEME.Panel),
                    ColorSequenceKeypoint.new(0.55, S2R_THEME.Surface),
                    ColorSequenceKeypoint.new(1, S2R_THEME.Active)
                })
                obj.Rotation = 0
            end
        end
        return
    end
    if obj:IsA("UIStroke") then
        -- The upstream owns active/disabled state colors and transitions.
        return
    end
    if not obj:IsA("GuiObject") then return end
    if obj:GetAttribute(S2R_DECOR_PREFIX .. "Done") then return end
    obj:SetAttribute(S2R_DECOR_PREFIX .. "Done", true)

    local size = obj.AbsoluteSize
    local fills = obj.BackgroundTransparency < 0.94
    local inHeader = (obj.AbsolutePosition.Y - mainWindow.AbsolutePosition.Y) <= 64
    local inRail = (obj.AbsolutePosition.X - mainWindow.AbsolutePosition.X) < 77
    local _, saturation, brightness = obj.BackgroundColor3:ToHSV()
    local colored = saturation > 0.32 and brightness > 0.35

    if obj:IsA("ScrollingFrame") then
        obj.ScrollBarImageColor3 = S2R_THEME.Accent
        obj.ScrollBarThickness = 4
    end

    if obj:IsA("TextLabel") then
        local semantic = s2rTextTone(obj.TextColor3)
        local emphatic = (obj.Font == Enum.Font.GothamBold
            or obj.Font == Enum.Font.GothamSemibold or obj.TextSize >= 16)
        obj.TextColor3 = semantic or (emphatic and S2R_THEME.Text or S2R_THEME.Muted)
        if fills and size.X > 85 and size.Y > 23 then
            obj.BackgroundColor3 = inHeader and S2R_THEME.Header or S2R_THEME.Panel
            s2rRound(obj, 7)
        end
        return
    end

    if obj:IsA("TextBox") then
        obj.TextColor3 = S2R_THEME.Text
        obj.PlaceholderColor3 = S2R_THEME.Subtle
        obj.Font = Enum.Font.GothamMedium
        if fills then
            obj.BackgroundColor3 = S2R_THEME.Control
            s2rRound(obj, 9)
            s2rStroke(obj, S2R_THEME.Border, 1, 0.35)
        end
        return
    end

    if obj:IsA("TextButton") then
        obj.TextColor3 = S2R_THEME.Text
        if size.X > 80 and size.Y >= 25 then
            obj.Font = Enum.Font.GothamMedium
        end
        if fills then
            if s2rIsToggleTrack(obj) then
                s2rRound(obj, 15)
                -- Keep toggle state color under the original control's ownership.
                -- Only adjust corner radius; UI callbacks and state remain untouched.
            else
                -- Buttons keep dynamic source-owned colors to preserve disabled/active states.
                if obj.BackgroundColor3 == Color3.new(1,1,1) then
                    obj.BackgroundColor3 = S2R_THEME.Control
                end
                s2rRound(obj, size.Y >= 35 and 10 or 8)
                if size.X >= 58 and size.Y >= 23 then
                    s2rStroke(obj, S2R_THEME.Border, 1, 0.38)
                end
            end
        end
        return
    end

    -- Small circular elements are usually toggle knobs, not content cards.
    -- Keep knobs pale so their on/off positions stay readable.
    if s2rIsCompactDot(obj) then
        if fills then
            if saturation < 0.21 and brightness >= 0.73 then
                obj.BackgroundColor3 = S2R_THEME.Knob
            elseif colored then
                obj.BackgroundColor3 = S2R_THEME.Accent
            end
        end
        return
    end

    if s2rIsToggleTrack(obj) then
        if fills then
            s2rRound(obj, 16)
            -- Source code retains ownership of state and animations.
        end
        return
    end

    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        -- Icons may contain game-specific artwork; do not recolor them.
        if fills and size.X >= 32 and size.Y >= 32 then
            obj.BackgroundColor3 = S2R_THEME.Surface
            s2rRound(obj, 9)
        end
        return
    end

    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        if fills then
            -- Small progress fills and slider bars must retain live source colors.
            if size.Y < 12 or (size.X < 58 and size.Y < 58) then return end
            if inRail and size.Y >= 125 and size.X <= 100 then
                obj.BackgroundColor3 = S2R_THEME.Rail
            elseif inHeader and size.Y <= 70 and size.X >= 120 then
                obj.BackgroundColor3 = S2R_THEME.Header
            elseif size.X >= 170 and size.Y >= 75 then
                obj.BackgroundColor3 = S2R_THEME.Panel
                if size.X < mainWindow.AbsoluteSize.X * 0.8 then
                    s2rStroke(obj, S2R_THEME.StrokeMuted, 1, 0.24)
                end
            elseif size.X >= 60 and size.Y >= 28 then
                obj.BackgroundColor3 = colored and S2R_THEME.Active or S2R_THEME.Surface
            end
            if size.X >= 72 and size.Y >= 25 then
                s2rRound(obj, (size.Y >= 95) and 13 or 9)
            end
        end
    end
end

local function s2rDecorateWindow(mainWindow, titleLbl)
    if mainWindow:GetAttribute(S2R_DECOR_PREFIX .. "Decorated") then return end
    mainWindow:SetAttribute(S2R_DECOR_PREFIX .. "Decorated", true)
    local function strip(name, size, position, color, transparency, radius)
        local obj = mainWindow:FindFirstChild(S2R_DECOR_PREFIX .. name)
        if not obj then
            obj = Instance.new("Frame")
            obj.Name = S2R_DECOR_PREFIX .. name
            obj.BorderSizePixel = 0
            obj.Active = false
            obj.Selectable = false
            obj.Parent = mainWindow
        end
        obj.BackgroundColor3 = color
        obj.BackgroundTransparency = transparency or 0
        obj.Size = size
        obj.Position = position
        obj.ZIndex = 1
        if radius then s2rRound(obj, radius) end
        return obj
    end
    -- Restored S2R logo mark, using visual-only labels (does not intercept clicks).
    local emblem = mainWindow:FindFirstChild(S2R_DECOR_PREFIX .. "Monogram")
    if not emblem then
        emblem = Instance.new("TextLabel")
        emblem.Name = S2R_DECOR_PREFIX .. "Monogram"
        emblem.Size = UDim2.fromOffset(38, 27)
        emblem.Position = UDim2.fromOffset(8, 13)
        emblem.BackgroundColor3 = S2R_THEME.Back
        emblem.BorderSizePixel = 0
        emblem.Text = "S2R"
        emblem.Font = Enum.Font.GothamBold
        emblem.TextSize = 13
        emblem.TextColor3 = S2R_THEME.AccentHover
        emblem.ZIndex = titleLbl.ZIndex + 10
        emblem.Active = false
        emblem.Selectable = false
        emblem.Parent = mainWindow
        s2rRound(emblem, 7)
        s2rStroke(emblem, S2R_THEME.Border, 1, 0.12)
    end

    -- Suppress only the old Vx artwork in the top-left header region.
    -- Do not disable existing buttons or modify gameplay icons in the navigation rail.
    for _, icon in ipairs(mainWindow:GetDescendants()) do
        if icon:IsA("GuiObject") and icon.Name:sub(1, #S2R_DECOR_PREFIX) ~= S2R_DECOR_PREFIX then
            local pos = icon.AbsolutePosition - mainWindow.AbsolutePosition
            local size = icon.AbsoluteSize
            if pos.X >= 0 and pos.X < 53 and pos.Y >= 0 and pos.Y < 58
                and size.X <= 48 and size.Y <= 48 then
                if (icon:IsA("TextLabel") or icon:IsA("TextButton"))
                    and (icon.Text:lower():match("^v[x]?$")) then
                    icon.TextTransparency = 1
                elseif (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) then
                    icon.ImageTransparency = 1
                end
            end
        end
    end

    -- Static violet, no bloom or gradient.
    strip("TopAccent", UDim2.new(1, -26, 0, 2), UDim2.new(0, 13, 0, 0), S2R_THEME.Accent, 0, 2)
    strip("HeaderRule", UDim2.new(1, -26, 0, 1), UDim2.new(0, 13, 0, 55), S2R_THEME.Border, 0.48)
    if mainWindow.AbsoluteSize.X >= 550 then
        strip("NavDivider", UDim2.new(0, 1, 1, -79), UDim2.new(0, 72, 0, 66), S2R_THEME.Border, 0.60)
    end
end

local function s2rFitScreen(mainWindow)
    local camera = workspace.CurrentCamera
    if not camera then return end
    local vp, actual = camera.ViewportSize, mainWindow.AbsoluteSize
    if vp.X < 200 or vp.Y < 170 or actual.X < 160 or actual.Y < 120 then return end
    -- First launch: make a tiny imported GUI readable, but remember the choice.
    if not mainWindow:GetAttribute(S2R_DECOR_PREFIX .. "InitialFit") then
        mainWindow:SetAttribute(S2R_DECOR_PREFIX .. "InitialFit", true)
        local targetWidth = math.min(820, vp.X * 0.60)
        if actual.X < targetWidth * 0.76 and actual.Y < vp.Y * 0.79 then
            s2rResizeWindow("reset")
        end
    elseif actual.X > vp.X - 24 or actual.Y > vp.Y - 50 then
        s2rResizeWindow("fit")
    end
    if not S2RViewportBound[mainWindow] then
        S2RViewportBound[mainWindow] = true
        local boundCamera, viewportConn
        local function bindCamera()
            local newCamera = workspace.CurrentCamera
            if newCamera == boundCamera then return end
            if viewportConn then viewportConn:Disconnect() end
            boundCamera = newCamera
            if newCamera then
                viewportConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                    if mainWindow.Parent and S2RMainWindow == mainWindow then
                        s2rResizeWindow("fit")
                    end
                end)
                if mainWindow.Parent then s2rResizeWindow("fit") end
            end
        end
        bindCamera()
        local camConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
        mainWindow.Destroying:Connect(function()
            if viewportConn then viewportConn:Disconnect() end
            if camConn then camConn:Disconnect() end
        end)
    end
end

local function s2rStyleWindow(mainWindow, titleLbl)
    if not mainWindow or not mainWindow.Parent then return end
    mainWindow.BackgroundColor3 = S2R_THEME.Back
    s2rRound(mainWindow, 17)
    s2rStroke(mainWindow, S2R_THEME.Border, 1.1, 0.10)
    if not mainWindow:GetAttribute(S2R_DECOR_PREFIX .. "Listening") then
        mainWindow:SetAttribute(S2R_DECOR_PREFIX .. "Listening", true)
        mainWindow.DescendantAdded:Connect(function(desc)
            task.defer(function()
                if desc and desc.Parent then
                    local ok, err = pcall(s2rStyleObject, desc, mainWindow)
                    if not ok then warn("[S2R Theme] " .. tostring(err)) end
                end
            end)
        end)
        for _, desc in ipairs(mainWindow:GetDescendants()) do
            local ok, err = pcall(s2rStyleObject, desc, mainWindow)
            if not ok then warn("[S2R Theme] " .. tostring(err)) end
        end
    end
    s2rDecorateWindow(mainWindow, titleLbl)
    s2rFitScreen(mainWindow)
end

-- S2R KHAY V7: restore the recognizable circular S2R launch icon.
-- Only changes its visuals. Original button, drag connections and bounds remain in place.
local function s2rRestoreFloatingLogo(gui, mainWindow)
    if not (gui and mainWindow) then return end
    local windowX = mainWindow.AbsolutePosition.X
    for _, candidate in ipairs(gui:GetDescendants()) do
        if candidate:IsA("GuiObject") and not candidate:IsDescendantOf(mainWindow)
            and not candidate:GetAttribute("S2R_KHAY_RestoredLogo") then
            local size = candidate.AbsoluteSize
            local pos = candidate.AbsolutePosition
            local nearLeft = pos.X >= 0 and pos.X + size.X < windowX - 5
            local square = size.X >= 53 and size.X <= 126
                and size.Y >= 53 and size.Y <= 126
                and math.abs(size.X - size.Y) < 24
            -- The original launcher is a square graphic near the top-left.
            if nearLeft and square and pos.Y >= 35 and pos.Y < 450 then
                local isLauncher = candidate:IsA("ImageButton") or candidate:IsA("ImageLabel")
                if not isLauncher then
                    for _, child in ipairs(candidate:GetDescendants()) do
                        if child:IsA("ImageButton") or child:IsA("ImageLabel")
                            or ((child:IsA("TextLabel") or child:IsA("TextButton"))
                                and child.Text:lower():match("^v[x]?$")) then
                            isLauncher = true
                            break
                        end
                    end
                end
                if isLauncher then
                    candidate:SetAttribute("S2R_KHAY_RestoredLogo", true)
                    -- Hide only the old icon art; do not hide or disable the click target.
                    if candidate:IsA("ImageButton") or candidate:IsA("ImageLabel") then
                        candidate.ImageTransparency = 1
                    end
                    for _, child in ipairs(candidate:GetDescendants()) do
                        if (child:IsA("ImageLabel") or child:IsA("ImageButton")) then
                            child.ImageTransparency = 1
                        elseif (child:IsA("TextLabel") or child:IsA("TextButton"))
                            and child.Text:lower():match("^v[x]?$") then
                            child.TextTransparency = 1
                        end
                    end
                    local cover = Instance.new("Frame")
                    cover.Name = "S2R_KHAY_RestoredBadge"
                    cover.Size = UDim2.fromScale(1, 1)
                    cover.BackgroundColor3 = S2R_THEME.Back
                    cover.BorderSizePixel = 0
                    cover.Active = false
                    cover.Selectable = false
                    cover.ZIndex = candidate.ZIndex + 15
                    cover.Parent = candidate
                    Instance.new("UICorner", cover).CornerRadius = UDim.new(1, 0)
                    local stroke = Instance.new("UIStroke")
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Thickness = 2
                    stroke.Color = S2R_THEME.Accent
                    stroke.Parent = cover
                    local label = Instance.new("TextLabel")
                    label.Name = "S2R_KHAY_BadgeLettering"
                    label.Size = UDim2.fromScale(1, 1)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.GothamBold
                    label.Text = "S2R"
                    label.TextScaled = true
                    label.TextColor3 = S2R_THEME.AccentHover
                    label.ZIndex = cover.ZIndex + 1
                    label.Active = false
                    label.Selectable = false
                    label.Parent = cover
                    local padding = Instance.new("UIPadding", label)
                    padding.PaddingLeft = UDim.new(0.16, 0)
                    padding.PaddingRight = UDim.new(0.16, 0)
                    -- Only one launcher icon should be replaced.
                    return
                end
            end
        end
    end
end

-- Brand Discord in the imported dashboard and make the invite action correct.
-- A visual replacement button covers the original Copy Invite callback so it cannot
-- silently copy the upstream author's invite. No other feature buttons are touched.
local function s2rPatchDiscordCard(mainWindow)
    if not (mainWindow and mainWindow.Parent) then return end
    local discordTitle, copyButton = nil, nil
    for _, node in ipairs(mainWindow:GetDescendants()) do
        if node:IsA("TextLabel") or node:IsA("TextButton") then
            local raw = (node.Text or ""):lower()
            if (raw:find("discord", 1, true) and
                (raw:find("venyx", 1, true) or raw:find("khay", 1, true)
                 or raw:find("chilli", 1, true))) then
                discordTitle = node
            elseif node:IsA("TextButton") and raw:find("copy invite", 1, true) then
                copyButton = node
            end
        end
    end
    if discordTitle then
        if discordTitle.Text ~= S2R_DISCORD_NAME then discordTitle.Text = S2R_DISCORD_NAME end
        if not discordTitle:GetAttribute("S2R_KHAY_DiscordTitleLocked") then
            discordTitle:SetAttribute("S2R_KHAY_DiscordTitleLocked", true)
            local busy = false
            discordTitle:GetPropertyChangedSignal("Text"):Connect(function()
                if busy or not discordTitle.Parent or discordTitle.Text == S2R_DISCORD_NAME then return end
                busy = true
                discordTitle.Text = S2R_DISCORD_NAME
                busy = false
            end)
        end
    end
    if not (copyButton and copyButton.Parent) then return end
    if copyButton.Parent:FindFirstChild("S2R_KHAY_DiscordCopy") then return end
    local newButton = Instance.new("TextButton")
    newButton.Name = "S2R_KHAY_DiscordCopy"
    newButton.Position = copyButton.Position
    newButton.Size = copyButton.Size
    newButton.AnchorPoint = copyButton.AnchorPoint
    newButton.ZIndex = copyButton.ZIndex + 20
    newButton.BackgroundColor3 = S2R_THEME.Active
    newButton.BorderSizePixel = 0
    newButton.Font = Enum.Font.GothamBold
    newButton.TextSize = math.max(12, copyButton.TextSize)
    newButton.TextColor3 = S2R_THEME.Text
    newButton.Text = "Copy Khay Invite"
    newButton.AutoButtonColor = true
    newButton.Parent = copyButton.Parent
    Instance.new("UICorner", newButton).CornerRadius = UDim.new(0, 10)
    newButton.Activated:Connect(function()
        local clipboard = setclipboard or toclipboard
        local copied = false
        if type(clipboard) == "function" then
            copied = pcall(function() clipboard(S2R_DISCORD_URL) end)
        end
        if copied then
            newButton.Text = "Invite Copied!"
        else
            -- Clipboard support varies by executor; display an editable link instead.
            local linkBox = newButton.Parent:FindFirstChild("S2R_KHAY_InviteLink")
            if not linkBox then
                linkBox = Instance.new("TextBox")
                linkBox.Name = "S2R_KHAY_InviteLink"
                linkBox.AnchorPoint = newButton.AnchorPoint
                linkBox.Position = UDim2.new(newButton.Position.X.Scale, newButton.Position.X.Offset,
                    newButton.Position.Y.Scale, newButton.Position.Y.Offset - 32)
                linkBox.Size = UDim2.new(newButton.Size.X.Scale, newButton.Size.X.Offset,
                    newButton.Size.Y.Scale, newButton.Size.Y.Offset)
                linkBox.Text = S2R_DISCORD_URL
                linkBox.ClearTextOnFocus = false
                linkBox.TextEditable = false
                linkBox.TextScaled = true
                linkBox.TextColor3 = S2R_THEME.Text
                linkBox.BackgroundColor3 = S2R_THEME.Control
                linkBox.ZIndex = newButton.ZIndex + 1
                linkBox.Parent = newButton.Parent
                Instance.new("UICorner", linkBox).CornerRadius = UDim.new(0, 8)
            end
            linkBox.Visible = not linkBox.Visible
            newButton.Text = "Show Invite Link"
        end
    end)
end

-- Do not disturb live controls: refresh only the stationary large layout surfaces.
local function s2rRefreshDashboard(mainWindow)
    if not (mainWindow and mainWindow.Parent) then return end
    mainWindow.BackgroundColor3 = S2R_THEME.Back
    for _, obj in ipairs(mainWindow:GetDescendants()) do
        if (obj:IsA("Frame") or obj:IsA("ScrollingFrame"))
            and obj.Name:sub(1, 9) ~= "S2R_KHAY_" and obj.BackgroundTransparency < 0.94 then
            local size = obj.AbsoluteSize
            if size.X >= 165 and size.Y >= 65 then
                local dx = obj.AbsolutePosition.X - mainWindow.AbsolutePosition.X
                local dy = obj.AbsolutePosition.Y - mainWindow.AbsolutePosition.Y
                if dx <= 76 and size.X < 104 then
                    obj.BackgroundColor3 = S2R_THEME.Rail
                elseif dy < 57 and size.Y < 88 then
                    obj.BackgroundColor3 = S2R_THEME.Header
                else
                    obj.BackgroundColor3 = S2R_THEME.Panel
                end
            end
        end
        if obj:IsA("UIGradient") and obj.Parent and obj.Parent:IsA("GuiObject") then
            local sz = obj.Parent.AbsoluteSize
            if sz.X >= 175 and sz.Y >= 60 then
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, S2R_THEME.Panel),
                    ColorSequenceKeypoint.new(0.55, S2R_THEME.Surface),
                    ColorSequenceKeypoint.new(1, S2R_THEME.Active)
                })
            end
        end
    end
end

-- ==================== 6. BỘ QUÉT BẤT TỬ (CHỐNG TRỄ KHI REJOIN & BẮT 100% FPS ẢO) ====================
local function patchBaseScreenGui(gui, titleLbl)
    if titleLbl.Text ~= NEW_TITLE then
        titleLbl.Text = NEW_TITLE
        -- Keep the original title layout geometry intact.
    end
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = math.clamp(titleLbl.TextSize, 13, 16)
    titleLbl.TextColor3 = S2R_THEME.AccentHover
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local mainWindow = nil
    local camera = workspace.CurrentCamera
    local vp = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local curr = titleLbl.Parent
    while curr and curr ~= gui do
        if curr:IsA("GuiObject") then
            local size = curr.AbsoluteSize
            local fillsViewport = size.X >= vp.X * 0.985 and size.Y >= vp.Y * 0.985
            if size.X >= 125 and size.Y >= 78
                and size.X <= math.max(vp.X * 1.7, 1100)
                and size.Y <= math.max(vp.Y * 1.7, 800)
                and not fillsViewport
                and curr.BackgroundTransparency < 0.99 then
                mainWindow = curr
            end
        end
        curr = curr.Parent
    end

    local headerY = titleLbl.AbsolutePosition.Y

    if mainWindow then
        S2RMainWindow = mainWindow
        local ok, err = pcall(s2rStyleWindow, mainWindow, titleLbl)
        if not ok then warn("[S2R Hub] Style patch: " .. tostring(err)) end
        pcall(s2rRestoreFloatingLogo, gui, mainWindow)
        pcall(s2rRefreshDashboard, mainWindow)
        titleLbl.TextColor3 = S2R_THEME.AccentHover
    end

    if mainWindow then
        s2rCreateDisplayTools(gui)
        pcall(s2rPatchDiscordCard, mainWindow)
        task.delay(0.7, function()
            if mainWindow and mainWindow.Parent then
                pcall(s2rPatchDiscordCard, mainWindow)
            end
        end)
    end

    local pendingTextQueue = {}
    for _, desc in ipairs(mainWindow and mainWindow:GetDescendants() or {}) do
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            if not desc:GetAttribute("__S2RByKhayTransHooked") and not isFpsCounterText(desc.Text) then
                pendingTextQueue[#pendingTextQueue + 1] = desc
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
    if gui:GetAttribute("S2R_KHAY_GlobalTextListener") then return end
    gui:SetAttribute("S2R_KHAY_GlobalTextListener", true)

    gui.DescendantAdded:Connect(function(newDesc)
        if (newDesc:IsA("TextLabel") or newDesc:IsA("TextButton") or newDesc:IsA("TextBox"))
            and not newDesc:FindFirstAncestor("S2R_KHAY_DisplayControls") then
            task.defer(function()
                if newDesc.Parent and S2RMainWindow and newDesc:IsDescendantOf(S2RMainWindow)
                    and not isFpsCounterText(newDesc.Text) then
                    hookTextForTranslation(newDesc)
                end
            end)
        end
    end)
end

local function tryPatchBaseGui()
    for _, root in ipairs(scanRoots) do
        if root then
            for _, gui in ipairs(root:GetChildren()) do
                if gui:IsA("ScreenGui") and not IGNORED_GUI_NAMES[gui.Name] and gui.Name ~= "S2R_KHAY_DisplayControls" then
                    local titleLbl = nil
                    local descendants = gui:GetDescendants()

                    for i = 1, #descendants do
                        local d = descendants[i]
                        if d:IsA("TextLabel") or d:IsA("TextButton") then
                            local t = d.Text
                            if not isFpsCounterText(t) and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                                local label = (t or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
                                if label == "venyx" or label == "venyxhub"
                                    or label:match("^venyx%s*hub")
                                    or label == "ronnei" or label:match("^ronnei%s*hub")
                                    or label:match("^chilli%s*hub") or label:match("^chili%s*hub")
                                    or label:match("^s2r%s*hub") then
                                    titleLbl = d
                                    break
                                end
                            end
                        end
                    end

                    if titleLbl then
                        attachScreenGuiListeners(gui)
                        patchBaseScreenGui(gui, titleLbl)
                        if S2RMainWindow and S2RMainWindow.Parent then
                            baseMainPatched = true
                        end
                    end
                end
            end
        end
    end
end

-- Diagnostics: do not silently swallow GUI patching errors.
local lastPatchError = nil
local function safePatchBaseGui()
    local ok, err = pcall(tryPatchBaseGui)
    if not ok then
        if err ~= lastPatchError then
            warn("[S2r Hub By Khay] GUI styling error: " .. tostring(err))
            lastPatchError = err
        end
        return false
    end
    lastPatchError = nil
    return true
end

-- Retry when the upstream creates or replaces its UI.
for _, root in ipairs(scanRoots) do
    if root then
        root.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and not IGNORED_GUI_NAMES[child.Name] then
                task.wait(0.15)
                safePatchBaseGui()
            end
        end)
    end
end

-- Keep waiting for the base GUI for 60 seconds, then re-check on reloads.
safePatchBaseGui()
task.spawn(function()
    local elapsed = 0
    while not baseMainPatched and elapsed < 90 do
        task.wait(1)
        elapsed = elapsed + 1
        safePatchBaseGui()
    end
    while true do
        task.wait(8)
        if not (S2RMainWindow and S2RMainWindow.Parent) then
            baseMainPatched = false
            safePatchBaseGui()
        else
            pcall(s2rRefreshDashboard, S2RMainWindow)
            pcall(s2rPatchDiscordCard, S2RMainWindow)
        end
    end
end)

-- ================================================================
-- V8 LIVE DASHBOARD RECOVERY
-- Why: the imported dashboard, header and launcher may be in separate
-- GUI containers. Relying on the header label's immediate ancestors
-- can style only the header and leave the dashboard gray.
-- This pass finds the actual dashboard by its content, not by name.
-- ================================================================
local V8 = {
    Window = nil,
    Screen = nil,
    WarnedMissing = false,
    PatchedOnce = false,
    LastLogo = nil,
}
local V8BrandNames = {
    {"Venyx Discord", "Khay Discord"},
    {"Venyx SAE", "S2r Edition"},
    {"Chilli Hub", NEW_TITLE},
    {"Chili Hub", NEW_TITLE},
    {"Ronnei Hub", NEW_TITLE},
    {"VenyxHub", NEW_TITLE},
}
local function v8Brand(source)
    if type(source) ~= "string" or source == "" then return source end
    local s = source
    for _, pair in ipairs(V8BrandNames) do
        s = s:gsub(pair[1], pair[2])
    end
    s = s:gsub("Venyx%s+Discord", "Khay Discord")
    -- News items are inherited from upstream: do not present them as Khay-authored.
    s = s:gsub("Welcome to Venyx", "Welcome to the hub")
    s = s:gsub("Welcome to Chilli Hub", "Welcome to the hub")
    if s == "Venyx" then return NEW_TITLE end
    if s == "Chilli Hub V5" then return NEW_TITLE end
    return s
end

local function v8IsHubScreen(screen)
    if not screen:IsA("ScreenGui") or IGNORED_GUI_NAMES[screen.Name] or screen.Name == "S2R_KHAY_DisplayControls" then
        return false, nil, nil
    end
    local count, anyDashboard, anyInvite, anyTitle, preferred = 0, false, false, false, nil
    for _, item in ipairs(screen:GetDescendants()) do
        if item:IsA("TextLabel") or item:IsA("TextButton") then
            local t = (item.Text or ""):lower()
            if t == "dashboard" then
                anyDashboard = true
                preferred = preferred or item
            elseif t:find("copy invite", 1, true) or t:find("copy khay invite", 1, true) then
                anyInvite = true
                preferred = preferred or item
            elseif t:find("s2r hub by khay", 1, true) or t:find("s2r hub", 1, true)
                or t:find("venyx discord", 1, true) then
                anyTitle = true
                preferred = preferred or item
            elseif t == "rejoin" or t == "server hop" or t == "unload hub" then
                count = count + 1
            end
        end
    end
    local matched = (anyDashboard and (anyInvite or count >= 2 or anyTitle))
        or (anyInvite and anyTitle and count >= 1)
    return matched, preferred, anyDashboard
end

local function v8FindWindow(screen, anchor)
    local camera = workspace.CurrentCamera
    local vp = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local best, area = nil, 0
    local function consider(part)
        if not part:IsA("GuiObject") then return end
        local z = part.AbsoluteSize
        if z.X < 250 or z.Y < 175 then return end
        if z.X > vp.X * 1.4 or z.Y > vp.Y * 1.4 then return end
        local fullscreen = z.X >= vp.X * 0.96 and z.Y >= vp.Y * 0.96
        if fullscreen or part.BackgroundTransparency >= 0.98 then return end
        local val = z.X * z.Y
        if val > area then best, area = part, val end
    end
    local parent = anchor and anchor.Parent
    while parent and parent ~= screen do
        consider(parent)
        parent = parent.Parent
    end
    -- If the preferred label lives in an embedded surface, fall back to the
    -- top-level GUI object whose content has a visible Dashboard label.
    if not best then
        for _, child in ipairs(screen:GetChildren()) do
            consider(child)
            if child:IsA("GuiObject") then
                for _, sub in ipairs(child:GetDescendants()) do
                    if sub:IsA("TextLabel") and sub.Text:lower() == "dashboard" then
                        consider(child)
                        break
                    end
                end
            end
        end
    end
    return best
end

local function v8PaintStatic(obj, window)
    if not obj or not obj.Parent or not obj:IsDescendantOf(window) then return end
    if obj.Name:sub(1, 9) == "S2R_KHAY_" or obj.Name:sub(1, 7) == "S2R_V8_" then return end
    if obj:IsA("UIGradient") then
        local p = obj.Parent
        if p and p:IsA("GuiObject") and p.AbsoluteSize.X >= 165 and p.AbsoluteSize.Y >= 56 then
            -- Static violet tonal gradient on decorative cards only. No glow.
            obj.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, S2R_THEME.Panel),
                ColorSequenceKeypoint.new(1, S2R_THEME.Active)
            })
            obj.Rotation = 0
        end
        return
    end
    if not obj:IsA("GuiObject") then return end
    local z = obj.AbsoluteSize
    if obj:IsA("ScrollingFrame") then
        obj.ScrollBarImageColor3 = S2R_THEME.Accent
    end
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("CanvasGroup") then
        if obj.BackgroundTransparency >= 0.94 or z.X < 52 or z.Y < 23 then return end
        local dx = obj.AbsolutePosition.X - window.AbsolutePosition.X
        local dy = obj.AbsolutePosition.Y - window.AbsolutePosition.Y
        if z.X >= window.AbsoluteSize.X * 0.80 and z.Y >= window.AbsoluteSize.Y * 0.65 then
            obj.BackgroundColor3 = S2R_THEME.Back
        elseif dx <= 71 and z.X <= 90 and z.Y > 100 then
            obj.BackgroundColor3 = S2R_THEME.Rail
        elseif dy <= 60 and z.X > 150 and z.Y <= 75 then
            obj.BackgroundColor3 = S2R_THEME.Header
        elseif z.X >= 175 and z.Y >= 65 then
            obj.BackgroundColor3 = S2R_THEME.Panel
        elseif z.X >= 100 and z.Y >= 34 then
            obj.BackgroundColor3 = S2R_THEME.Surface
        elseif z.X >= 52 and z.Y >= 23 then
            -- Treat pills/cards; keep tiny dynamic toggle parts untouched.
            obj.BackgroundColor3 = S2R_THEME.Control
        end
        if z.X >= 100 and z.Y >= 32 then
            s2rRound(obj, z.Y >= 90 and 12 or 9)
        end
    elseif obj:IsA("TextButton") then
        if obj.BackgroundTransparency < 0.95 and z.X > 80 and z.Y >= 25 then
            local _, sat, val = obj.BackgroundColor3:ToHSV()
            -- Source-owned vivid color can mark selected/disabled state.
            if sat < 0.19 or val < 0.24 then
                obj.BackgroundColor3 = S2R_THEME.Control
            end
            s2rRound(obj, 9)
        end
    elseif obj:IsA("TextLabel") then
        if obj.BackgroundTransparency < 0.94 and z.X > 110 and z.Y >= 29 then
            obj.BackgroundColor3 = S2R_THEME.Surface
        end
    elseif obj:IsA("TextBox") then
        if obj.BackgroundTransparency < 0.94 and z.X >= 70 and z.Y >= 20 then
            obj.BackgroundColor3 = S2R_THEME.Control
        end
        obj.PlaceholderColor3 = S2R_THEME.Muted
    end
end

local function v8BrandTextObject(node)
    if not (node:IsA("TextLabel") or node:IsA("TextButton")) then return end
    if not node.Parent or node.Name:sub(1, 7) == "S2R_V8_" then return end
    local function update()
        if not node.Parent or node:GetAttribute("S2R_V8_BrandBusy") then return end
        local original = node.Text or ""
        local rewritten = v8Brand(original)
        if original ~= rewritten then
            node:SetAttribute("S2R_V8_BrandBusy", true)
            node.Text = rewritten
            node:SetAttribute("S2R_V8_BrandBusy", false)
        end
    end
    update()
    if node:GetAttribute("S2R_V8_BrandListen") then return end
    node:SetAttribute("S2R_V8_BrandListen", true)
    node:GetPropertyChangedSignal("Text"):Connect(update)
end

local function v8PatchDiscord(window)
    local titleNode, originalCopy = nil, nil
    for _, node in ipairs(window:GetDescendants()) do
        if node:IsA("TextLabel") or node:IsA("TextButton") then
            local value = (node.Text or ""):lower()
            if value:find("discord", 1, true) and
                (value:find("venyx", 1, true) or value:find("khay", 1, true)) then
                titleNode = node
            elseif node:IsA("TextButton") and value:find("copy invite", 1, true) then
                originalCopy = node
            end
        end
    end
    if titleNode then
        titleNode.Text = S2R_DISCORD_NAME
        v8BrandTextObject(titleNode)
    end
    if not originalCopy then return end
    -- V7's sibling button may be displaced by UIListLayout. Keep it hidden
    -- so its guard prevents recreation; attach V8 directly onto the real button.
    local old = originalCopy.Parent:FindFirstChild("S2R_KHAY_DiscordCopy")
    if old then old.Visible = false end
    originalCopy.Active = false  -- disable the upstream invite callback
    originalCopy.AutoButtonColor = false
    if originalCopy:FindFirstChild("S2R_V8_CopyOverlay") then return end
    local overlay = Instance.new("TextButton")
    overlay.Name = "S2R_V8_CopyOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.AnchorPoint = Vector2.new(0, 0)
    overlay.ZIndex = originalCopy.ZIndex + 3
    overlay.Text = "Copy Khay Invite"
    overlay.Active = true
    overlay.Selectable = true
    overlay.Font = Enum.Font.GothamBold
    overlay.TextSize = math.max(11, originalCopy.TextSize)
    overlay.TextColor3 = S2R_THEME.Text
    overlay.BackgroundColor3 = S2R_THEME.Active
    overlay.BorderSizePixel = 0
    overlay.Parent = originalCopy
    s2rRound(overlay, 9)
    overlay.Activated:Connect(function()
        local clip = setclipboard or toclipboard
        if type(clip) == "function" and pcall(function() clip(S2R_DISCORD_URL) end) then
            overlay.Text = "Invite copied"
        else
            overlay.Text = S2R_DISCORD_URL
            overlay.TextScaled = true
        end
    end)
end

local function v8RestyleLauncher(window)
    if V8.LastLogo and V8.LastLogo.Parent then return end
    local leftX = window.AbsolutePosition.X
    for _, root in ipairs(scanRoots) do
        if root then
            for _, screen in ipairs(root:GetChildren()) do
                if screen:IsA("ScreenGui") and not IGNORED_GUI_NAMES[screen.Name]
                    and screen.Name ~= "S2R_KHAY_DisplayControls" then
                    for _, node in ipairs(screen:GetDescendants()) do
                        if node:IsA("GuiObject") then
                            local z = node.AbsoluteSize
                            local p = node.AbsolutePosition
                            local square = z.X >= 60 and z.X <= 135 and z.Y >= 60 and z.Y <= 135
                                and math.abs(z.X - z.Y) <= 26
                            if square and p.X >= 35 and p.X + z.X < leftX - 8
                                and p.Y >= 55 and p.Y <= 380
                                and not node:GetAttribute("S2R_V8_LauncherDone") then
                                local nameMatch = node.Name:lower():find("logo",1,true) or node.Name:lower():find("venyx",1,true)
                                local oldMark = false
                                for _, sub in ipairs(node:GetDescendants()) do
                                    if sub:IsA("TextLabel") or sub:IsA("TextButton") then
                                        local text = (sub.Text or ""):lower()
                                        if text == "vx" or text == "v" or text == "venyx" then oldMark = true end
                                    end
                                end
                                -- The original Vx logo is sometimes an image asset,
                                -- so its artwork has no searchable TextLabel.
                                local imageArtwork = node:IsA("ImageLabel") or node:IsA("ImageButton")
                                if not imageArtwork then
                                    for _, sub in ipairs(node:GetDescendants()) do
                                        if sub:IsA("ImageLabel") or sub:IsA("ImageButton") then
                                            imageArtwork = true
                                            break
                                        end
                                    end
                                end
                                local locationMatchesLauncher = p.Y >= 105 and p.Y <= 255
                                    and p.X >= 60 and z.X >= 70 and z.X <= 125
                                if nameMatch or oldMark or (locationMatchesLauncher and imageArtwork) then
                                    node:SetAttribute("S2R_V8_LauncherDone", true)
                                    local cover = Instance.new("Frame")
                                    cover.Name = "S2R_V8_LauncherCover"
                                    cover.Size = UDim2.fromScale(1, 1)
                                    cover.BackgroundColor3 = S2R_THEME.Back
                                    cover.BorderSizePixel = 0
                                    cover.ZIndex = node.ZIndex + 12
                                    cover.Active = false
                                    cover.Selectable = false
                                    cover.Parent = node
                                    s2rRound(cover, math.floor(z.X * 0.5))
                                    s2rStroke(cover, S2R_THEME.Accent, 2, 0)
                                    local mark = Instance.new("TextLabel")
                                    mark.Name = "S2R_V8_Monogram"
                                    mark.BackgroundTransparency = 1
                                    mark.Size = UDim2.fromScale(1, 1)
                                    mark.Text = "S2R"
                                    mark.TextColor3 = S2R_THEME.AccentHover
                                    mark.TextScaled = true
                                    mark.Font = Enum.Font.GothamBold
                                    mark.ZIndex = cover.ZIndex + 1
                                    mark.Active = false
                                    mark.Selectable = false
                                    mark.Parent = cover
                                    local pad = Instance.new("UIPadding", mark)
                                    pad.PaddingLeft = UDim.new(0.15, 0)
                                    pad.PaddingRight = UDim.new(0.15, 0)
                                    V8.LastLogo = node
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function v8PatchWindow(screen, window)
    if not window or not window.Parent then return end
    V8.Window, V8.Screen = window, screen
    window.BackgroundColor3 = S2R_THEME.Back
    s2rRound(window, 16)
    s2rStroke(window, S2R_THEME.Border, 1, 0)
    for _, item in ipairs(window:GetDescendants()) do
        v8PaintStatic(item, window)
        v8BrandTextObject(item)
    end
    v8PatchDiscord(window)
    v8RestyleLauncher(window)
    if not window:GetAttribute("S2R_V8_DescendantListener") then
        window:SetAttribute("S2R_V8_DescendantListener", true)
        window.DescendantAdded:Connect(function(item)
            task.defer(function()
                if item and item.Parent and item:IsDescendantOf(window) then
                    v8PaintStatic(item, window)
                    v8BrandTextObject(item)
                end
            end)
        end)
    end
    if not V8.PatchedOnce then
        V8.PatchedOnce = true
        warn("[S2r Hub By Khay V8] Dashboard detected; applied violet/black theme and Discord patch")
    end
end

local function v8ScanAll()
    local processed = {}
    for _, root in ipairs(scanRoots) do
        if root then
            for _, screen in ipairs(root:GetChildren()) do
                if not processed[screen] then
                    processed[screen] = true
                    local matched, anchor = v8IsHubScreen(screen)
                    if matched then
                        local window = v8FindWindow(screen, anchor)
                        if window then
                            local ok, err = pcall(v8PatchWindow, screen, window)
                            if not ok then warn("[S2r Hub By Khay V8] Live patch error: " .. tostring(err)) end
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    local elapsed = 0
    while true do
        v8ScanAll()
        if elapsed >= 16 and not V8.PatchedOnce and not V8.WarnedMissing then
            V8.WarnedMissing = true
            warn("[S2r Hub By Khay V8] Dashboard not found yet. Send a screenshot of the Roblox console if the gray GUI persists.")
        end
        local waitSeconds = elapsed < 24 and 0.8 or 5
        task.wait(waitSeconds)
        elapsed = elapsed + waitSeconds
    end
end)

]===]

-- Optional local copy for rejoin; core remains sourced from the same upstream.
if writefile then
    pcall(function()
        local selfReplicatingWrapper = "local S2R_CORE_PAYLOAD = [===[" .. S2R_CORE_PAYLOAD .. "]===]\n" .. [[
if writefile then
    pcall(function()
        writefile("S2rHubByKhay_AutoRun.lua", "local S2R_CORE_PAYLOAD = [===[" .. S2R_CORE_PAYLOAD .. "]===]\nloadstring(S2R_CORE_PAYLOAD)()")
    end)
end
loadstring(S2R_CORE_PAYLOAD)()
]]
        writefile(AUTO_RUN_FILE, selfReplicatingWrapper)
    end)
end

loadstring(S2R_CORE_PAYLOAD)()
