local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/turtle"))()

local w = library:Window("Nebula Hub")

local OwO = library:Window("Nebula Hub")

local gk = library:Window("Nebula Hub gk")

gk:Toggle("บอลใหญ่", false, function(go)
    gk = go
    if gk then
    local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Football = Workspace:WaitForChild("Football") -- รอให้ Football โหลดเข้ามาใน Workspace

if Football:IsA("MeshPart") then
    Football.Size = Vector3.new(10, 10, 10) -- เปลี่ยนขนาดของ Football
end

local Hitbox = Football:FindFirstChild("Hitbox") -- ค้นหา Hitbox ที่อยู่ภายใน Football
if Hitbox and Hitbox:IsA("Part") then
    Hitbox.Size = Vector3.new(15, 15, 15) -- เปลี่ยนขนาดของ Hitbox
end
    end
end)

-- กำหนดให้ selectedPosition เป็น nil ก่อน
local selectedPosition = nil

local dropdown = OwO:Dropdown("เลือกตำแหน่ง", {"CF", "LW", "RW"}, function(name)
    selectedPosition = name  -- อัปเดตค่าที่เลือกจาก Dropdown
end)

-- ให้ Toggle เริ่มต้นเป็น false
local homeToggle = false
local awayToggle = false

OwO:Toggle("ฝั่ง Home", false, function(bool)
    homeToggle = bool  -- อัปเดตสถานะของ Toggle
    
    if homeToggle then
        task.spawn(function()
            while homeToggle do
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer

                if LocalPlayer.Team.Name ~= "Home" and selectedPosition ~= nil then
                    local args = {
                        [1] = "Home",
                        [2] = selectedPosition  -- ใช้ค่าที่เลือกจาก Dropdown
                    }

                    game:GetService("ReplicatedStorage").Packages.Knit.Services.TeamService.RE.Select:FireServer(unpack(args))
                end
                wait(0.1)
            end
        end)
    end
end)

OwO:Toggle("ฝั่ง Away", false, function(boo)
    awayToggle = boo  -- อัปเดตสถานะของ Toggle
    
    if awayToggle then
        task.spawn(function()
            while awayToggle do
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer

                if LocalPlayer.Team.Name ~= "Away" and selectedPosition ~= nil then
                    local args = {
                        [1] = "Away",
                        [2] = selectedPosition  -- ใช้ค่าที่เลือกจาก Dropdown
                    }

                    game:GetService("ReplicatedStorage").Packages.Knit.Services.TeamService.RE.Select:FireServer(unpack(args))
                end
                wait(0.1)
            end
        end)
    end
end)
w:Toggle("วาร์ปไปหาบอล", false,function(v)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local runService = game:GetService("RunService")
    local workspace = game:GetService("Workspace")

    local connection

    if v then
        connection = runService.RenderStepped:Connect(function()
            local football = workspace:FindFirstChild("Football")

            if football and hrp then
                -- วาร์ปไปที่ตำแหน่งของบอล
                hrp.CFrame = football.CFrame
            else
                print("บอลไม่ได้อยู่ใน Workspace")
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end)

w:Toggle("ออโต้ยิง ", false,function(ss)
while ss do wait(.1)
local workspace = game:GetService("Workspace")

-- ค้นหาวัตถุ Football
local football = workspace:FindFirstChild("Football", true)

if football then
    print("พบ Football ที่: " .. football:GetFullName())
    if football.Parent.Name == game.Players.LocalPlayer.Name then
        local args = {
    [1] = 100
}

game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot:FireServer(unpack(args))

    else
        print("Football ไม่ได้เป็นของผู้ใช้")
    end
else
    print("ไม่พบ Football ใน Workspace")
end
end
end)

local ToggleShoot = false -- เก็บสถานะ Toggle

w:Toggle("ยิงไกลแบบอาจจะเข้า 50%", false, function(state)
    ToggleShoot = state

    if not state then return end

    local TweenService = game:GetService("TweenService")
    local Football = game:GetService("Workspace"):FindFirstChild("Football", true)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot

    while ToggleShoot do
        local success, _ = pcall(function()
            remote.OnClientEvent:Wait()

            if not Football or not Football.Parent then return end

            local targetPosition
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Away" then
                targetPosition = Vector3.new(323.917, 18.334, -67.583)
            else
                targetPosition = Vector3.new(-243.060, 11.166, -31.342)
            end

            local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TweenService:Create(Football, tweenInfo, {Position = targetPosition})
            tween:Play()
            tween.Completed:Wait()
        end)

        if not success then break end
    end
end)

w:Toggle("ยิงไกลแบบเข้า 100%", false,function(stat)
    ToggleShoot = stat

    if not stat then return end

    local Football = game:GetService("Workspace"):FindFirstChild("Football", true)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local remote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot

    while ToggleShoot do
        local success, data = pcall(function()
            return remote.OnClientEvent:Wait()
        end)

        if not success or not Football or not Football.Parent then break end
        if not ToggleShoot then break end

        local targetPosition
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Away" then
            targetPosition = Vector3.new(323.917, 18.334, -67.583)
        else
            targetPosition = Vector3.new(-243.060, 11.166, -31.342)
        end

        Football.Position = targetPosition
    end

    if Football then
        Football.Position = Football.Position -- รีเซ็ตตำแหน่งให้เหมือนเดิม
    end
end)

w:Button("ลบบาเรีย", function()
    local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Barriers = Workspace:FindFirstChild("Barriers")

if not Barriers then
    warn("Barriers not found in Workspace")
    return
end

-- ตรวจสอบว่า Barriers มีทีมไหนอยู่บ้างไหม
local awayBarrier = Barriers:FindFirstChild("Away")
local homeBarrier = Barriers:FindFirstChild("Home")

-- ลูปตรวจสอบผู้เล่นในแต่ละทีม
while true do
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team then
            if player.Team.Name == "Away" and awayBarrier then
                awayBarrier:Destroy()  -- ลบ Barrier ของทีม Away
            elseif player.Team.Name == "Home" and homeBarrier then
                homeBarrier:Destroy()  -- ลบ Barrier ของทีม Home
            end
        end
    end
    wait(1)  -- ตรวจสอบทุก 1 วินาที
end
end)

w:Button("ขยายhitbox 20", function()
    local Football = game:GetService("Workspace"):FindFirstChild("Football")
if not Football then
    warn("ไม่พบวัตถุ Football ใน Workspace!")
    return
end

local Hitbox = Football:FindFirstChild("Hitbox")
if not Hitbox then
    warn("ไม่พบวัตถุ Hitbox ภายใน Football!")
    return
end

-- ปรับขนาด Hitbox
Hitbox.Size = Vector3.new(20, 20, 20)
-- ปรับค่าการมองเห็น
Hitbox.Transparency = 0.6  -- ค่าการมองเห็น 0.4
-- ปรับสีเป็นสีน้ำเงิน
Hitbox.Color = Color3.fromRGB(0, 0, 255)
-- ตั้งค่า Anchored และ CanCollide
Hitbox.Anchored = false
Hitbox.CanCollide = false

-- ลูปเพื่ออัปเดตตำแหน่งของ Hitbox ตาม Football
while true do
    if Football and Hitbox then
        Hitbox.Position = Football.Position
    end
    task.wait(0.1)  -- หน่วงเวลา 0.03 วินาที เพื่อลดภาระของ CPU
end
end)

w:Button("ขยายhitbox v2เหมาะกับประตู", function()
local workspace = game:GetService("Workspace")
local Football = workspace:FindFirstChild("Football")
local RunService = game:GetService("RunService")

-- ฟังก์ชันที่จะเปลี่ยนตำแหน่งของ Part ให้ตรงกับ Football
local function UpdatePartPosition(newPart, Football)
    if Football then
        -- เปลี่ยนตำแหน่งของ newPart ให้ตรงกับ Football
        newPart.CFrame = Football.CFrame 
    end
end

-- ฟังก์ชันที่จะเปลี่ยนตำแหน่งของ Football เมื่อสัมผัสกับ Part
local function UpdateFootballPositionOnTouch(player, Football)
    if Football and player and player.Character then
        -- เปลี่ยนตำแหน่งของ Football ให้ตรงกับตัวผู้เล่น
        Football.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 0)  -- ทำให้ Football อยู่เหนือตัวผู้เล่น
    end
end

if Football then
    local newPart = Instance.new("Part")
    newPart.Shape = Enum.PartType.Ball  -- เปลี่ยนให้เป็นทรงกลม
    newPart.Size = Vector3.new(20,20,20)  -- กำหนดขนาดของ Ball
    newPart.Anchored = true  -- ทำให้ Part ไม่เคลื่อนที่
    newPart.Parent = workspace  -- เพิ่ม Part ลงใน Workspace
    newPart.BrickColor = BrickColor.new("Bright red")  -- เปลี่ยนสีของ Part
    newPart.Material = Enum.Material.SmoothPlastic  -- กำหนดวัสดุของ Part
    newPart.CanCollide = false  -- เปิดใช้งานการชนกับ Part นี้

    -- ใช้ RunService.Heartbeat เพื่ออัปเดตตำแหน่งในทุกๆ frame
    RunService.Heartbeat:Connect(function()
        UpdatePartPosition(newPart, Football)
    end)
    
    -- เชื่อมต่อการสัมผัสกับ Part โดยให้ UpdateFootballPositionOnTouch ทำงานเมื่อผู้เล่นสัมผัสกับ newPart
    newPart.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = game:GetService("Players"):GetPlayerFromCharacter(character)
        
        if player then
            UpdateFootballPositionOnTouch(player, Football)
        end
    end)
end
end)


w:Button("Fake Nameปุ่ม", function()
-- Pepsi Was Here
-- Pepsi's Name Spoofer
-- Settings
local new_name = "Nebulahub" -- I'm not Pepsi. ^_^
local new_id = 90123 -- I'm not 26346. ^_^
local clear_avatar = true -- So no one can reverse search by your outfit
local flush_body_colors = true -- So no one can reverse search by your bodycolors
local rename_instances = false -- Rename any instances that holds your name. (Not recomended unless you can see your name above your character)
local change_id = false -- Change your player ID (not visually)
local deep_scan = true -- Can get a bit laggy if there is a mass wave of new instances
local filter_httpget = { -- Didn't seem like this would be helpful, but requested.
    enabled = false, -- Turn on
    result = true, -- Filter the results of the request
    request = true -- Filter the url before requesting
}


local Players = assert(assert(game, "game missing?"):FindService("Players") or game:GetService("Players"), "Players missing?")
local LocalPlayer = assert(Players.LocalPlayer, "LocalPlayer missing?")
local CoreGui = game:FindService("CoreGui") or game:GetService("CoreGui")
local PlayerGui = assert(LocalPlayer:FindFirstChild("PlayerGui"), "PlayerGui mising?")
local RunService = assert(game:FindService("RunService") or game:GetService("RunService"), "RunService missing?")
local replaces_str = {
    Players.LocalPlayer.Name
}
local replaces_num = {
    tostring(Players.LocalPlayer.UserId)
}
new_name, new_id = tostring(new_name), tostring(new_id)
local function casepatt(pattern)
    return string.gsub(pattern, "(%%?)(.)", function(percent, letter)
        if percent ~= "" or not string.match(letter, "%a") then
            return percent .. letter
        else
            return string.format("[%s%s]", string.lower(letter), string.upper(letter))
        end
    end)
end
function replace(item, fast)
    for replacewith, data in pairs({
        [new_name] = replaces_str,
        [new_id] = replaces_num
    }) do
        if not fast then
            RunService.RenderStepped:Wait()
        end
        for _, v in pairs(data) do
            if not fast then
                RunService.RenderStepped:Wait()
            end
            for _, t in pairs({
                "Text",
                "Message",
                "ToolTip",
                "Value"
            }) do
                pcall(function()
                    if string.find(item[t], v, nil, true) then
                        item[t] = string.gsub(item[t], v, replacewith)
                    elseif string.find(item[t], string.lower(v), nil, true) then
                        item[t] = string.gsub(item[v], string.lower(v), string.lower(replacewith))
                    elseif string.find(item[t], string.upper(v), nil, true) then
                        item[t] = string.gsub(item[v], string.upper(v), string.upper(replacewith))
                    elseif string.find(string.lower(item[t]), string.lower(v), nil, true) then
                        item[t] = string.gsub(item[v], casepatt(v), replacewith)
                    end
                end)
                if not fast then
                    RunService.RenderStepped:Wait()
                end
            end
            if not fast then
                RunService.RenderStepped:Wait()
            end
            if rename_instances then
                pcall(function()
                    if string.find(item.Name, v, nil, true) then
                        item.Name = string.gsub(item.Name, v, replacewith)
                    elseif string.find(item.Name, string.lower(v), nil, true) then
                        item.Name = string.gsub(item.Name, string.lower(v), string.lower(replacewith))
                    elseif string.find(item.Name, string.upper(v), nil, true) then
                        item.Name = string.gsub(item.Name, string.lower(v), string.upper(replacewith))
                    elseif string.find(string.lower(item.Name), string.lower(v), nil, true) then
                        item.Name = string.gsub(item.Name, casepatt(v), replacewith)
                    end
                end)
            end
        end
    end
end
shared.rep = replace
local function scan_and_replace(fast)
    local scan_que = {
        CoreGui:GetDescendants(),
        PlayerGui:GetDescendants(),
        workspace:GetDescendants()
    }
    local last_break = 0
    for _, items in pairs(scan_que) do
        if not fast then
            RunService.RenderStepped:Wait()
        end
        for _, gui in pairs(assert(type(items) == "table" and items, "scan_que does not hold a table")) do
            last_break = 1 + last_break
            if last_break >= 6000 then
                RunService.RenderStepped:Wait()
                last_break = 0
            end
            if not fast then
                RunService.RenderStepped:Wait()
            end
            replace(gui, fast)
        end
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if not fast then
            RunService.RenderStepped:Wait()
        end
        replace(obj)
    end
end
function fixchar(Character)
    if not Character then
        return 
    end
    wait(0.2)
    RunService.RenderStepped:Wait()
    if rename_instances then
        Character.Name = new_name
    end
    if clear_avatar then
        Players.LocalPlayer:ClearCharacterAppearance()
    end
    wait(0.1)
    if flush_body_colors then
        local bc = Character:FindFirstChildOfClass("BodyColors")
        if bc then
            for _, c in pairs({
                "HeadColor",
                "LeftArmColor",
                "LeftLegColor",
                "RightArmColor",
                "RightLegColor",
                "TorsoColor"
            }) do
                bc[c] = (typeof(bc[c]) == "BrickColor" and BrickColor.Random()) or bc[c]
            end
        else
            local h = Character:FindFirstChildOfClass("Humanoid")
            if h then
                for _, limb in pairs(Character:GetChildren()) do
                    if limb:IsA("BasePart") and pcall(h.GetLimb, h, limb) then
                        limb.BrickColor = BrickColor.Random()
                    end
                end
            end
        end
    end
end
fixchar(Players.LocalPlayer.Character)
Players.LocalPlayer.CharacterAppearanceLoaded:Connect(fixchar)
Players.LocalPlayer.CharacterAdded:Connect(fixchar)
if deep_scan then
    game.ItemChanged:Connect(function(obj, property)
        if not rename_instances and "Name" == property then
            return 
        end
        local s, v = pcall(function()
            return obj[property]
        end) 
        if s then
            if "string" == type(v) then
                for _, c in pairs(replaces_str) do
                    RunService.RenderStepped:Wait()
                    if string.find(obj[property], c, nil, true) then
                        obj[property] = string.gsub(tostring(obj[property] or v), c, new_name)
                    elseif string.find(obj[property], string.lower(c)) then
                        obj[property] = string.gsub(tostring(obj[property] or v), string.lower(c), string.lower(new_name))
                    elseif string.find(obj[property], string.upper(c), nil, true) then
                        obj[property] = string.gsub(tostring(obj[property] or v), string.upper(c), string.upper(new_name))
                    elseif string.find(string.upper(obj[property]), string.upper(c), nil, true) then
                        obj[property] = string.gsub(tostring(obj[property] or v), casepatt(c), new_name)
                    end
                end
                RunService.RenderStepped:Wait()
                for _, c in pairs(replaces_num) do
                    RunService.RenderStepped:Wait()
                    if string.find(obj[property], new_id) then
                        obj[property] = string.gsub(tostring(obj[property] or v), c, new_id)
                    end
                end
            elseif "number" == type(v) then
                v = tostring(obj[property] or v)
                for _, c in pairs(replaces_num) do
                    RunService.RenderStepped:Wait()
                    if string.find(v, c) then
                        obj[property] = tonumber(tonumber(string.gsub(v, c, new_id) or obj[property]) or obj[property])
                    end
                end
            end
        end
    end)
    CoreGui.DescendantAdded:Connect(replace)
    PlayerGui.DescendantAdded:Connect(replace)
end
local function filterstr(s)
    for _, data in pairs({
        [new_name] = replaces_str,
        [new_id] = replaces_num
    }) do
        for c, v in pairs(data) do
            if string.find(s, v, nil, true) then
                s = string.gsub(s, v, c)
            elseif string.find(s, string.lower(v), nil, true) then
                s = string.gsub(s, string.lower(v), string.lower(c))
            elseif string.find(s, string.upper(v), nil, true) then
                s = string.gsub(s, string.upper(v), string.upper(c))
            elseif string.find(string.upper(s), string.upper(v), nil, true) then
                s = string.gsub(s, casepatt(v), c)
            end
        end
    end
    return s
end
if filter_httpget.enabled and type(hookfunc or hookfunction or detour_function) == "function" then
    local hget
    hget = assert(hookfunction or hookfunc or detour_function, "Hook function required for filter_httpget")(assert(game.HttpGet, "HttpGet required for filter_httpget"), function(shelf, u, ...)
        if filter_httpget.request then
            local x, e = pcall(filterstr, u)
            if x and e then
                u = e
            end
        end
        if filter_httpget.result then
            local result = hget(shelf, u, ...)
            local x, e = pcall(filterstr, result)
            if x and e then
                return e
            end
        end
        return hget(shelf, u, ...)
    end)
end
scan_and_replace(true)
while wait(1) do
    if rename_instances then
        Players.LocalPlayer.Name = new_name
        if Players.LocalPlayer.Character then
            Players.LocalPlayer.Character.Name = new_name
        end
    end
    if change_id then
        Players.LocalPlayer.UserId = tonumber(tonumber(new_id or 1) or 1)
    end
    scan_and_replace()
end
end)

w:Button("สเตมิน่าไม่จำกัด", function()
local args = {
    [1] = 0/0
}

game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("StaminaService"):WaitForChild("RE"):WaitForChild("DecreaseStamina"):FireServer(unpack(args))
end)

w:Button("วิ่งเร็ว", function()
    local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local runService = game:GetService("RunService")

local baseSpeed = 0.1 -- ความเร็วต่ำสุด (ตอน 1%)
local maxSpeed = 1 -- ความเร็วสูงสุด (ตอน 100%)
local speedPercent = 60 -- ปรับได้ระหว่าง 1 - 100

-- คำนวณความเร็วตามเปอร์เซ็นต์
local speed = baseSpeed + ((maxSpeed - baseSpeed) * (speedPercent / 100))

runService.RenderStepped:Connect(function()
    if hrp and humanoid.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * speed
    end
end)
end)
