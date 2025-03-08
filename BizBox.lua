local CoreGui = game:GetService("CoreGui")

-- ตรวจสอบและสร้าง UI ถ้ายังไม่มี
if CoreGui:FindFirstChild("GlowToggleUI") then
    CoreGui:FindFirstChild("GlowToggleUI"):Destroy()
end

local ToggleUI = Instance.new("ScreenGui")
ToggleUI.Name = "GlowToggleUI"
ToggleUI.Parent = CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10) -- มุมซ้ายบน
ToggleButton.Text = "Toggle UI"
ToggleButton.Parent = ToggleUI
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 2
ToggleButton.AutoButtonColor = true
ToggleButton.Draggable = true -- ทำให้ลากได้
ToggleButton.Active = true
ToggleButton.Selectable = true

-- ตัวแปรเก็บสถานะปัจจุบัน
local uiVisible = true

-- ฟังก์ชันเปลี่ยนค่า Visible ของทุกองค์ประกอบใน ScreenGui
ToggleButton.MouseButton1Click:Connect(function()
    local screenGui = CoreGui:FindFirstChild("ScreenGui")
    if screenGui then
        for _, v in pairs(screenGui:GetChildren()) do
            if v:IsA("GuiObject") then
                v.Visible = not uiVisible
            end
        end
        uiVisible = not uiVisible
        ToggleButton.Text = "UI: " .. (uiVisible and "Visible" or "Hidden")
        print("UI is now:", uiVisible and "Visible" or "Hidden")
    else
        print("ไม่พบ ScreenGui ใน CoreGui")
    end
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Nebula Hub", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

    Tabs.Main:AddParagraph({  
        Title = "Paragraph",  
        Content = "This is a paragraph.\nSecond line!"  
    })  

    Tabs.Main:AddButton({  
        Title = "Button",  
        Description = "Very important button",  
        Callback = function()  
            Window:Dialog({  
                Title = "Title",  
                Content = "This is a dialog",  
                Buttons = {  
                    {  
                        Title = "Confirm",  
                        Callback = function()  
                            print("Confirmed the dialog.")  
                        end  
                    },  
                    {  
                        Title = "Cancel",  
                        Callback = function()  
                            print("Cancelled the dialog.")  
                        end  
                    }  
                }  
            })  
        end  
    })  

  -- ตัวแปร global เพื่อจัดการ task
    _G.autoFarmTasks = {}
    _G.isAutoFarming = false
    _G.hasActiveQuest = false  -- เพิ่มตัวแปรเพื่อตรวจสอบว่ามีเควสต์อยู่หรือไม่

    local Toggle = Tabs.Main:AddToggle("AutoFarm", {Title = "AutoFarm 1-350", Default = false })  
    Toggle:OnChanged(function(state)  
        local workspace = game:GetService("Workspace")  
        local players = game:GetService("Players")  
        local replicatedStorage = game:GetService("ReplicatedStorage")  
        local localPlayer = players.LocalPlayer  
        local chr = localPlayer.Character or localPlayer.CharacterAdded:Wait()  
        local enemies = workspace:FindFirstChild("Enemies")  

        -- ฟังก์ชันสำหรับหยุด task ทั้งหมด  
        local function stopAllTasks()  
            for _, t in ipairs(_G.autoFarmTasks) do  
                if typeof(t) == "thread" then
                    task.cancel(t)
                end
            end  
            table.clear(_G.autoFarmTasks) -- ล้างรายการ  
            _G.isAutoFarming = false
            _G.hasActiveQuest = false
        end  

        -- ฟังก์ชันเลือกเควสต์ตามเลเวล  
        function chlv()  
            local level = localPlayer:FindFirstChild("Level") and localPlayer.Level.Value or 0  
            if level <= 14 then  
                QName = "Thug [Level 5]"  
                MonName = "Thug [Level 5]"  
                NameText = "10,926XP"  
            elseif level <= 19 then  
                QName = "HumonUser [Level 15]"  
                MonName = "HumonUser [Level 15]"  
                NameText = "15,656XP"  
            elseif level <= 29 then  
                QName = "Gryphon [Level 30]"  
                MonName = "Gryphon [Level 30]"  
                NameText = "26,144XP"  
            elseif level <= 39 then  
                QName = "Vampire [Level 40]"  
                MonName = "Vampire [Level 40]"  
                NameText = "38,166XP"  
            elseif level <= 54 then  
                QName = "Snow Thug [Level 50]"  
                MonName = "Snow Thug [Level 50]"  
                NameText = "59,582XP"  
            elseif level <= 69 then  
                QName = "Snowman [Level 65]"  
                MonName = "Snowman [Level 65]"  
                NameText = "85,867XP"  
            elseif level <= 169 then  
                QName = "Wammu"   
                MonName = "Wammu"  
                NameText = "500,000XP"  
            elseif level <= 249 then  
                QName = "Dio Royal Guard [Level  180]"   
                MonName = "Dio Royal Guard [Level  180]"  
                NameText = "782,107XP"  
            elseif level <= 274 then  
                QName = "School Bully  [Level 270]"   
                MonName = "School Bully  [Level 270]"  
                NameText = "1,603,616XP"  
            elseif level <= 299 then  
                QName = "City Criminal [Level 280]"   
                MonName = "City Criminal [Level 280]"  
                NameText = "3,230,348XP"  
            elseif level <= 349 then  
                QName = "Criminal Master [Level 300]"   
                MonName = "Criminal Master [Level 300]"  
                NameText = "6,451,549XP"  
            end  
        end  

        -- ฟังก์ชันค้นหามอนสเตอร์  
        local function findTargetMonster()  
            if enemies then  
                for _, monster in pairs(enemies:GetChildren()) do  
                    if monster.Name == MonName and monster:FindFirstChild("Humanoid") then  
                        local humanoid = monster.Humanoid  
                        if humanoid.Health > 0 then  
                            return monster  
                        end  
                    end  
                end  
            end  
            return nil  
        end  

        -- ฟังก์ชันตรวจสอบสถานะเควสต์
        local function checkQuestStatus()
            if not localPlayer or not localPlayer.PlayerGui then
                return false
            end
            
            local questGui = localPlayer.PlayerGui:FindFirstChild("QuestGui")
            if questGui and questGui:FindFirstChild("QuestTag") and questGui.QuestTag.Visible then
                if questGui.QuestTag.EXP.Text == NameText then
                    return true -- มีเควสต์ที่ถูกต้อง
                else
                    -- มีเควสต์ที่ไม่ถูกต้อง ต้องยกเลิก
                    replicatedStorage.Remote.GameEvent:FireServer("QuestCancel")
                    task.wait(1) -- รอให้การยกเลิกเสร็จสิ้น
                    return false
                end
            end
            return false -- ไม่มีเควสต์
        end

        -- ฟังก์ชันหลักในการทำงาน
        local function mainFarmLoop()
            while _G.isAutoFarming do
                task.wait(0.1)
                if not _G.isAutoFarming then break end
                
                chr = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                if not chr or not chr:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    continue
                end
                
                -- ตรวจสอบเควสต์ปัจจุบัน
                chlv() -- อัพเดตข้อมูลเควสต์ตามเลเวล
                
                -- ตรวจสอบว่ามีเควสต์อยู่หรือไม่
                _G.hasActiveQuest = checkQuestStatus()
                
                -- ถ้าไม่มีเควสต์ ให้ไปรับก่อน
                if not _G.hasActiveQuest then
                    
                    if QName == "" then 
                        task.wait(1)
                        continue 
                    end
                    
                    -- ตรวจสอบว่า NPC มีอยู่
                    if not workspace:FindFirstChild("HitboxClick") or not workspace.HitboxClick:FindFirstChild(QName) then
                        task.wait(1)
                        continue
                    end
                    
                    -- วาร์ปไปหา NPC
                    chr.HumanoidRootPart.CFrame = workspace.HitboxClick[QName].CFrame
                    task.wait(1) -- รอเพื่อให้โหลดเสร็จสิ้น
                    
                    -- รับเควสต์
                    replicatedStorage.Remote.GameEvent:FireServer("Quest", QName)
                    task.wait(1) -- รอให้การรับเควสต์เสร็จสิ้น
                    
                    -- ตรวจสอบว่ารับเควสต์สำเร็จหรือไม่
                    _G.hasActiveQuest = checkQuestStatus()
                    if not _G.hasActiveQuest then
                        task.wait(1)
                        continue
                    end
                end
                
                -- ถ้ามีเควสต์แล้ว ให้ไปหามอนสเตอร์
                if _G.hasActiveQuest then
                    -- ค้นหามอนสเตอร์
                    local target = findTargetMonster()
                    
                    if target then
                        local targetPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                        if targetPart then
                            chr.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, 5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end
        end

        -- ถ้าเปิด Toggle ให้รัน  
        if state then  
            _G.isAutoFarming = true
            _G.hasActiveQuest = false
            -- ใช้เพียง task เดียวในการทำงานทั้งหมด
            table.insert(_G.autoFarmTasks, task.spawn(mainFarmLoop))
        else  
            stopAllTasks() -- ถ้าปิด Toggle ให้หยุดทุก task ทันที  
        end  
    end)  

    Options.AutoFarm:SetValue(false)
      
    -- สร้างตัวแปร global สำหรับ AutoClick
    _G.autoClickEnabled = false
    _G.autoClickTask = nil
    
    local Toggle1 = Tabs.Main:AddToggle("AutoClick", {Title = "AutoClick", Default = false })  

    Toggle1:OnChanged(function(click)  
        _G.autoClickEnabled = click  -- กำหนดสถานะตาม Toggle  
        local vu = game:GetService("VirtualUser")  
        
        if _G.autoClickTask and typeof(_G.autoClickTask) == "thread" then
            task.cancel(_G.autoClickTask)
            _G.autoClickTask = nil
        end
        
        if _G.autoClickEnabled then  
            _G.autoClickTask = task.spawn(function()  
                while _G.autoClickEnabled do  
                    vu:Button1Down(Vector2.new(0, 1)) -- คลิกเมาส์ซ้าย  
                    task.wait(0.1)  
                    vu:Button1Up(Vector2.new(0, 1)) -- ปล่อยคลิก  
                    task.wait(0.1) -- ป้องกันการทำงานเร็วเกินไป  
                    
                    if not _G.autoClickEnabled then
                        break
                    end
                end  
            end)  
        end  
    end)  

    Options.AutoClick:SetValue(false)  

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {    
    Title = "Dropdown",    
    Values = {"Strength", "Health", "Stamina"},    
    Multi = false,    
    Default = "Strength",    
})    

Dropdown:OnChanged(function(Value)    
    print("Dropdown changed:", Value)    
    _G.SelectedStat = Value  -- เก็บค่า dropdown ไว้ใช้งาน
end)    

local Toggle2 = Tabs.Main:AddToggle("AutoStatus", {Title = "AutoStatus", Default = false })  

Toggle2:OnChanged(function(Status)  
    _G.Status = Status  

    if _G.Status then  
        while _G.Status do  
            if _G.SelectedStat then
                local args = {  
                    [1] = _G.SelectedStat,  
                    [2] = "up",  
                    [3] = 1  
                }

                game:GetService("Players").LocalPlayer.PlayerGui.UiService.StatsFrame.upstats:InvokeServer(unpack(args))
            end
            task.wait(0.1) -- เพิ่มหน่วงเวลาเพื่อไม่ให้สคริปต์ทำงานเร็วเกินไป
        end  
    end  
end)  

Options.AutoStatus:SetValue(false)
    
    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {  
        Title = "Colorpicker",  
        Default = Color3.fromRGB(96, 205, 255)  
    })  

    Colorpicker:OnChanged(function()  
        print("Colorpicker changed:", Colorpicker.Value)  
    end)  
      
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))  

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {  
        Title = "Colorpicker",  
        Description = "but you can change the transparency.",  
        Transparency = 0,  
        Default = Color3.fromRGB(96, 205, 255)  
    })  

    TColorpicker:OnChanged(function()  
        print(  
            "TColorpicker changed:", TColorpicker.Value,  
            "Transparency:", TColorpicker.Transparency  
        )  
    end)  

    local Keybind = Tabs.Main:AddKeybind("Keybind", {  
        Title = "KeyBind",  
        Mode = "Toggle", -- Always, Toggle, Hold  
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)  

        -- Occurs when the keybind is clicked, Value is `true`/`false`  
        Callback = function(Value)  
            print("Keybind clicked!", Value)  
        end,  

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum  
        ChangedCallback = function(New)  
            print("Keybind changed!", New)  
        end  
    })  

    -- OnClick is only fired when you press the keybind and the mode is Toggle  
    -- Otherwise, you will have to use Keybind:GetState()  
    Keybind:OnClick(function()  
        print("Keybind clicked:", Keybind:GetState())  
    end)  

    Keybind:OnChanged(function()  
        print("Keybind changed:", Keybind.Value)  
    end)  

    task.spawn(function()  
        while true do  
            wait(1)  

            -- example for checking if a keybind is being pressed  
            local state = Keybind:GetState()  
            if state then  
                print("Keybind is being held down")  
            end  

            if Fluent.Unloaded then break end  
        end  
    end)  

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold  

    local Input = Tabs.Main:AddInput("Input", {  
        Title = "Input",  
        Default = "Default",  
        Placeholder = "Placeholder",  
        Numeric = false, -- Only allows numbers  
        Finished = false, -- Only calls callback when you press enter  
        Callback = function(Value)  
            print("Input changed:", Value)  
        end  
    })  

    Input:OnChanged(function()  
        print("Input updated:", Input.Value)  
    end)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()


workspace = game:GetService("Workspace")
players = game:GetService("Players")
local enemies = workspace:FindFirstChild("Enemies")

if enemies then
    task.spawn(function()
        while true do
            for _, enemy in pairs(enemies:GetChildren()) do
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health / humanoid.MaxHealth <= 0.7 then
                    humanoid.Health = 0
                    
                    -- เพิ่ม SimulationRadius ถ้าใช้ exploit
                    local player = players.LocalPlayer
                    if sethiddenproperty and player then
                        sethiddenproperty(player, "SimulationRadius", math.huge)
                    end
                end
            end
            task.wait(0.1) -- ลดการใช้ทรัพยากร
        end
    end)
end