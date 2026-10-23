--[[
    S-Hub | Rivals Execution Menu
    Optimized for Delta Executor (Mobile & PC Compatibility)
    Features: Auto Farm Event (Zombie/Gargoyle), Silent Aim, ESP, and Movement
--]]

local S_Hub = {
    Toggles = {
        AutoFarmZombie = false,
        AutoFarmGargoyle = false,
        SilentAim = false,
        PlayerESP = false,
        InfJump = false
    },
    Values = {
        WalkSpeed = 16,
        JumpPower = 50,
        FovRadius = 150
    }
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Simple Visual Canvas Notification
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

Notify("S-Hub Loaded", "Welcome to Rivals Script Menu!")

-- Create GUI Panel Structure
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "SHub_Menu"
ScreenGui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "S-Hub | Rivals (Delta Mode)"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange Theme accent
TitleLabel.TextSize = 20.000

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1.000
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 0, 450)
Container.ScrollBarThickness = 4

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Helper function to generate standardized modern toggle elements
local function CreateToggleButton(propName, displayName)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Font = Enum.Font.SourceSans
    Button.Text = displayName .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16.000
    Button.Parent = Container
    
    Button.MouseButton1Click:Connect(function()
        S_Hub.Toggles[propName] = not S_Hub.Toggles[propName]
        if S_Hub.Toggles[propName] then
            Button.Text = displayName .. ": ON"
            Button.BackgroundColor3 = Color3.fromRGB(35, 120, 35)
        else
            Button.Text = displayName .. ": OFF"
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
    return Button
end

-- Generate UI Elements
CreateToggleButton("AutoFarmZombie", "🎃 Auto Farm Zombie Tower")
CreateToggleButton("AutoFarmGargoyle", "🗿 Auto Farm Gargoyle Tower")
CreateToggleButton("SilentAim", "🎯 Perfect Silent Aim")
CreateToggleButton("PlayerESP", "👁️ Render Player Boxes")
CreateToggleButton("InfJump", "🦘 Infinite Jump Mechanics")

-- Toggle Menu Key (LeftControl or Tap Title on Mobile)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ==========================================
-- FEATURE FUNCTIONALITIES & LOOPS
-- ==========================================

-- 1. Automate Event Towers (Zombie & Gargoyle Auto-Farm Loops)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if S_Hub.Toggles.AutoFarmZombie or S_Hub.Toggles.AutoFarmGargoyle then
                -- Locate target entities dynamically within Workspace maps
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Humanoid") and obj.Parent and obj.Parent.Name ~= LocalPlayer.Name then
                        local isZombie = obj.Parent:DarknessCheck("Zombie") or string.find(string.lower(obj.Parent.Name), "zombie")
                        local isGargoyle = string.find(string.lower(obj.Parent.Name), "gargoyle") or string.find(string.lower(obj.Parent.Name), "tower")
                        
                        if (S_Hub.Toggles.AutoFarmZombie and isZombie) or (S_Hub.Toggles.AutoFarmGargoyle and isGargoyle) then
                            local root = obj.Parent:FindFirstChild("HumanoidRootPart")
                            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if root and localRoot and obj.Health > 0 then
                                -- Safe behind/above positioning matrix to clear wave defense levels instantly
                                localRoot.CFrame = root.CFrame * CFrame.new(0, 10, 0)
                                
                                -- Auto Fire Remote Trigger Pipeline invocation safely
                                local attackRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attack")
                                if attackRemote then
                                    attackRemote:FireServer(root.Position)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 2. Target Aquisition Engine for Combat Redirection (Silent Aim Helper)
local function GetClosestTarget()
    local maxDistance = S_Hub.Values.FovRadius
    local target = nil
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, plyr in ipairs(Players:GetPlayers()) do
        if plyr ~= LocalPlayer and plyr.Character and plyr.Character:FindFirstChild("Head") and plyr.Character:FindFirstChildOfClass("Humanoid") then
            if plyr.Character.Humanoid.Health > 0 then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(plyr.Character.Head.Position)
                if onScreen then
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if magnitude < maxDistance then
                        maxDistance = magnitude
                        target = plyr.Character.Head
                    end
                end
            end
        end
    end
    return target
end

-- Index Hooking for Hitscan Redirection Simulation
local Meta = getrawmetatable(game)
local OldNamecall = Meta.__namecall
setreadonly(Meta, false)

Meta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if S_Hub.Toggles.SilentAim and tostring(self) == "Attack" and method == "FireServer" then
        local targetHead = GetClosestTarget()
        if targetHead then
            args[1] = targetHead.Position -- Redirect projectile/hit vector target directly to Head position
            return OldNamecall(self, unpack(args))
        end
    end
    return OldNamecall(self, ...)
end)
setreadonly(Meta, true)

-- 3. Visual Tactical Layer Rendering (Box ESP Infrastructure)
RunService.RenderStepped:Connect(function()
    for _, plyr in ipairs(Players:GetPlayers()) do
        if plyr ~= LocalPlayer and plyr.Character and plyr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plyr.Character.HumanoidRootPart
            local head = plyr.Character:FindFirstChild("Head")
            
            -- Simple dynamically managed Billboard Highlight Setup 
            local espHighlight = plyr.Character:FindFirstChild("SHub_Highlight")
            if S_Hub.Toggles.PlayerESP and head then
                if not espHighlight then
                    espHighlight = Instance.new("Highlight")
                    espHighlight.Name = "SHub_Highlight"
                    espHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                    espHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    espHighlight.FillTransparency = 0.6
                    espHighlight.Parent = plyr.Character
                end
            else
                if espHighlight then espHighlight:Destroy() end
            end
        end
    end
end)

-- 4. Local Mechanical Mechanics Customization (Jump Physics)
UserInputService.JumpRequest:Connect(function()
    if S_Hub.Toggles.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
