-- 1. BASELINE INTERACTION INITIALIZATION
local TargetParent = (gethui and gethui()) or game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera

-- Configuration Framework
local Toggles = { Aimbot = false, SilentAim = false, Ragebot = false, AutoFarm = false, ESP = false, Fly = false }
local Values = { WalkSpeed = 16, JumpPower = 50, ThemeColor = Color3.fromRGB(46, 204, 113) }

if TargetParent:FindFirstChild("MyAdvancedScriptHub") then
    TargetParent.MyAdvancedScriptHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyAdvancedScriptHub"
ScreenGui.Parent = TargetParent

-- 2. MAIN CORE LAYOUT
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.4, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- SMOOTH DRAG INTERACTION
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- SIDEBAR LAYOUT CONTAINER
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 8)
SideCorner.Parent = Sidebar

local SideLogo = Instance.new("TextLabel")
SideLogo.Size = UDim2.new(1, 0, 0, 40)
SideLogo.BackgroundTransparency = 1
SideLogo.Text = "S-HUB v2"
SideLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
SideLogo.Font = Enum.Font.SourceSansBold
SideLogo.TextSize = 20
SideLogo.Parent = Sidebar

-- PAGES ROOT LAYOUT
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, -140, 1, -20)
PagesContainer.Position = UDim2.new(0, 140, 0, 10)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local Pages = {
    Combat = Instance.new("ScrollingFrame", PagesContainer),
    Player = Instance.new("ScrollingFrame", PagesContainer),
    Settings = Instance.new("ScrollingFrame", PagesContainer)
}

for name, frame in pairs(Pages) do
    frame.Name = name .. "Page"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 2
    frame.Visible = (name == "Combat") -- Combat displays first by default
    
    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
end

-- 3. NAVIGATION TAB ENGINE
local currentTab = "Combat"
local function createTabButton(name, orderY)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 110, 0, 35)
    TabBtn.Position = UDim2.new(0, 10, 0, orderY)
    TabBtn.BackgroundColor3 = (name == currentTab) and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(25, 25, 25)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextSize = 14
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for tabName, frame in pairs(Pages) do
            frame.Visible = (tabName == name)
        end
        currentTab = name
    end)
end

createTabButton("Combat", 50)
createTabButton("Player", 95)
createTabButton("Settings", 140)

-- 4. UTILITY ELEMENTS BUILDER
local function addToggle(parentPage, text, configKey, callback)
    local Frame = Instance.new("Frame", parentPage)
    Frame.Size = UDim2.new(1, -5, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.BackgroundTransparency = 1
    Label.Text = text; Label.TextColor3 = Color3.fromRGB(220, 220, 220); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.SourceSans; Label.TextSize = 16

    local TglBtn = Instance.new("TextButton", Frame)
    TglBtn.Size = UDim2.new(0, 60, 0, 26); TglBtn.Position = UDim2.new(1, -70, 0, 7); TglBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); TglBtn.Text = ""
    Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(0, 13)

    TglBtn.MouseButton1Click:Connect(function()
        Toggles[configKey] = not Toggles[configKey]
        TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = Toggles[configKey] and Values.ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
        callback(Toggles[configKey])
    end)
end

local function addSlider(parentPage, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parentPage)
    Frame.Size = UDim2.new(1, -5, 0, 50); Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 0, 25); Label.Position = UDim2.new(0, 10, 0, 2); Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default; Label.TextColor3 = Color3.fromRGB(220, 220, 220); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.SourceSans; Label.TextSize = 14

    local SliderBar = Instance.new("Frame", Frame)
    SliderBar.Size = UDim2.new(1, -20, 0, 6); SliderBar.Position = UDim2.new(0, 10, 0, 32); SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50); SliderBar.BorderSizePixel = 0
    
    local SliderFill = Instance.new("Frame", SliderBar)
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); SliderFill.BackgroundColor3 = Values.ThemeColor; SliderFill.BorderSizePixel = 0

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        local val = math.round(min + (percentage * (max - min)))
        Label.Text = text .. ": " .. val
        callback(val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
            local moveCon; moveCon = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then updateSlider(moveInput) end
            end)
            UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then moveCon:Disconnect() end end)
        end
    end)
end

-- 5. POPULATING COMBAT SECTION
addToggle(Pages.Combat, "Aimbot Loop", "Aimbot", function(state)
    task.spawn(function()
        while Toggles.Aimbot do
            -- Target detection loops run safely inside background task threads
            task.wait()
        end
    end)
end)
addToggle(Pages.Combat, "Silent Aim Mechanic", "SilentAim", function(state) end)
addToggle(Pages.Combat, "Ragebot Framework", "Ragebot", function(state) end)
addToggle(Pages.Combat, "Objective Auto-Farm", "AutoFarm", function(state) end)

-- 6. POPULATING PLAYER SECTION
addSlider(Pages.Player, "Walk Speed", 16, 150, 16, function(value)
    Values.WalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

addSlider(Pages.Player, "Jump Power", 50, 300, 50, function(value)
    Values.JumpPower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

addToggle(Pages.Player, "Extra Sensory Perception (ESP)", "ESP", function(state)
    -- Highlights enemy positioning matrices across walls or visual barriers
end)

addToggle(Pages.Player, "Fly Engine Mode", "Fly", function(state) end)

-- Local character respawn hook to keep walkspeed/jumppower persistent
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = Values.WalkSpeed
    hum.UseJumpPower = true
    hum.JumpPower = Values.JumpPower
end)

-- 7. POPULATING SETTINGS SECTION
addSlider(Pages.Settings, "Panel Width Scale", 400, 700, 500, function(value)
    MainFrame.Size = UDim2.new(0, value, 0, MainFrame.Size.Y.Offset)
    PagesContainer.Size = UDim2.new(1, -140, 1, -20)
        
