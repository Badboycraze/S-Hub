-- 1. BASELINE INTERACTION INITIALIZATION
-- Using gethui() falls back to CoreGui safely if the executor requires it
local TargetParent = (gethui and gethui()) or game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Prevents interface duplicates during continuous debugging executions
if TargetParent:FindFirstChild("MyCustomScriptHub") then
    TargetParent.MyCustomScriptHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomScriptHub"
ScreenGui.Parent = TargetParent

-- 2. MAIN HUB VISUAL CONTAINER
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- MODERN SMOOTH DRAG IMPLEMENTATION (Replaces MainFrame.Draggable)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- HUB CONTAINER TITLE BANNER
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "S-HUB COMPILATION MULTI-PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- 3. INTERACTIVE FUNCTIONAL DESIGN OPERATIONS
local function createScriptButton(name, positionY, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 310, 0, 40)
    Button.Position = UDim2.new(0, 20, 0, positionY)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16
    Button.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Visual interaction handler
    Button.MouseButton1Click:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        task.wait(0.1)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        callback()
    end)
end

-- 4. ATTACHING TARGET LOADSTRINGS AND SOURCE CODES TO BUTTONS
-- REMINDER: Replace the placeholder links below with your absolute RAW GitHub links!
createScriptButton("Execute Custom Tower Auto-Farm", 60, function()
    print("Launching Custom Tower Engine...")
    -- Replace with actual link like: "https://githubusercontent.com"
    loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

createScriptButton("Launch Baza Hub Bypass", 110, function()
    print("Launching Baza Framework...")
    loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

-- Option 3: Safely closes down the visual interface layout elements
createScriptButton("Close Script Hub UI", 180, function()
    ScreenGui:Destroy()
end)
