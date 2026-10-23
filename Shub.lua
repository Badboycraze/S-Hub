--[[
    S-Hub | Rivals Premium Universal Edition
    Optimized for Delta, Solara, Wave, and Mobile Executors
    Features: UI Menu, Auto Farm Event Towers, Silent Aim with FOV Ring, Visual ESP, and Physics Hacks
--]]

-- Cache Framework Core
local S_Hub = {
    Toggles = {
        AutoFarmZombie = false,
        AutoFarmGargoyle = false,
        SilentAim = false,
        PlayerESP = false,
        InfJump = false,
        VisibleFOV = false
    },
    Values = {
        WalkSpeed = 16,
        JumpPower = 50,
        FovRadius = 120,
        FovColor = Color3.fromRGB(255, 165, 0)
    }
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- Runtime Visual Canvas Interface Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Radius = S_Hub.Values.FovRadius
FOVCircle.Filled = false
FOVCircle.Color = S_Hub.Values.FovColor
FOVCircle.Visible = false

-- Interface Engine (Modern UI Panel Implementation)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftNavbar = Instance.new("Frame")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local TitleLabel = Instance.new("TextLabel")

ScreenGui.Name = "SHub_Premium"
ScreenGui.Parent = (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

LeftNavbar.Name = "LeftNavbar"
LeftNavbar.Parent = MainFrame
LeftNavbar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
LeftNavbar.Size = UDim2.new(0, 140, 1, 0)

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = LeftNavbar
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 10, 0, 15)
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "S-HUB V2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
TitleLabel.TextSize = 22.000
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle/Game Tag Info
local GameLabel = Instance.new("TextLabel")
GameLabel.Parent = LeftNavbar
GameLabel.BackgroundTransparency = 1.000
GameLabel.Position = UDim2.new(0, 10, 0, 40)
GameLabel.Size = UDim2.new(1, -20, 0, 20)
GameLabel.Font = Enum.Font.SourceSansItalic
GameLabel.Text = "Game: Rivals [Halloween]"
GameLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
GameLabel.TextSize = 12.000
GameLabel.TextXAlignment = Enum.TextXAlignment.Left

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1.000
Container.Position = UDim2.new(0, 150, 0, 15)
Container.Size = UDim2.new(1, -160, 1, -30)
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Container.ScrollBarThickness = 3

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Element Factory functions
local function CreateNewToggle(flag, text)
    local Frame = Instance.new("Frame")
    local Button = Instance.new("TextButton")
    local StatusIndicator = Instance.new("Frame")
    
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Frame.Parent = Container
    
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1.000
    Button.Font = Enum.Font.SourceSansSemibold
    Button.Text = "   " .. text
    Button.TextColor3 = Color3.fromRGB(230, 230, 235)
    Button.TextSize = 15.000
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Frame
    
    StatusIndicator.Size = UDim2.new(0, 8, 0, 18)
    StatusIndicator.Position = UDim2.new(1, -18, 0, 10)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    StatusIndicator.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        S_Hub.Toggles[flag] = not S_Hub.Toggles[flag]
        if S_Hub.Toggles[flag] then
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        else
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end)
end

local function CreateNewSlider(flag, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Fill = Instance.new("Frame")
    local Trigger = Instance.new("TextButton")
    local ValDisp = Instance.new("TextLabel")

    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Frame.Parent = Container

    Title.Size = UDim2.new(0.6, 0, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1.000
    Title.Font = Enum.Font.SourceSans
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(200, 200, 205)
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    ValDisp.Size = UDim2.new(0.3, 0, 0, 20)
    ValDisp.Position = UDim2.new(0.7, -10, 0, 5)
    ValDisp.BackgroundTransparency = 1.000
    ValDisp.Font = Enum.Font.SourceSansSemibold
    ValDisp.Text = tostring(default)
    ValDisp.TextColor3 = Color3.fromRGB(255, 140, 0)
    ValDisp.TextSize = 14.000
    ValDisp.TextXAlignment = Enum.TextXAlignment.Right
    ValDisp.Parent = Frame

    Trigger.Size = UDim2.new(1, -20, 0, 8)
    Trigger.Position = UDim2.new(0, 10, 0, 30)
    Trigger.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Trigger.Text = ""
    Trigger.Parent = Frame

    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    Fill.BorderSizePixel = 0
    Fill.Parent = Trigger

    local function update(input)
        local delta = math.clamp((input.Position.X - Trigger.AbsolutePosition.X) / Trigger.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (delta * (max - min)))
        Fill.Size = UDim2.new(delta, 0, 1, 0)
        ValDisp.Text = tostring(val)
        S_Hub.Values[flag] = val
        if callback then callback(val) end
    end

    local sliding = false
    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

-- Assemble GUI Array Panel Setup
CreateNewToggle("AutoFarmZombie", "🎃 Auto Farm Zombie Waves")
CreateNewToggle("AutoFarmGargoyle", "🗿 Auto Farm Gargoyle Tower Boss")
CreateNewToggle("SilentAim", "🎯 Method-Hooked Silent Aim")
CreateNewToggle("VisibleFOV", "⭕ Display Aim FOV Boundary")
CreateNewSlider("FovRadius", "Combat FOV Range Radius", 30, 400, 120, function(v) FOVCircle.Radius = v end)
CreateNewToggle("PlayerESP", "👁️ Full Box Hitbox Highlights")
CreateNewToggle("InfJump", "🦘 Flight Physics (Infinite Jump)")

-- Toggle Framework Hiding Key (Left Control / Free Tap Area)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- =========================================================
-- HIGH PERFORMANCE EXECUTION MATRICES (LOOPS)
-- =========================================================

-- 1. FOV Dynamic Update Track
RunService.RenderStepped:Connect(function()
    if S_Hub.Toggles.VisibleFOV and ScreenGui.Enabled then
        FOVCircle.Visible = true
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end
end)

-- 2. Tower Automation Framework (Zombie Wave Defense & Gargoyle Meta Sweeper)
task.spawn(function()
    while task.wait(0.1) do
        if S_Hub.Toggles.AutoFarmZombie or S_Hub.Toggles.AutoFarmGargoyle then
            pcall(function()
                for _, object in ipairs(Workspace:GetDescendants()) do
                    if object:IsA("Humanoid") and object.Parent and object.Parent ~= LocalPlayer.Character then
                        local labelName = string.lower(object.Parent.Name)
                        local isValidZombie = S_Hub.Toggles.AutoFarmZombie and (string.find(labelName, "zombie") or object.Parent:FindFirstChild("DarknessCheck"))
                        local isValidGargoyle = S_Hub.Toggles.AutoFarmGargoyle and (string.find(labelName, "gargoyle") or string.find(labelName, "boss"))
                        
                        if (isValidZombie or isValidGargoyle) and object.Health > 0 then
                            local enemyRoot = object.Parent:FindFirstChild("HumanoidRootPart") or object.Parent:FindFirstChild("Head")
                            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if enemyRoot and myRoot then
                                -- Safe-Position Matrix Vector (Locks character 11 studs safely above target vectors)
                                myRoot.CFrame = enemyRoot.CFrame * CFrame.new(0, 11, 0)
                                myRoot.Velocity = Vector3.new(0, 0, 0)
                  end
else
if liveHighlight then liveHighlight:Destroy() end
end
end
end
end)
-- 6. Player Control Hooks (Infinite Double Jump Handling)
UserInputService.JumpRequest:Connect(function()
if S_Hub.Toggles.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end
end)  
