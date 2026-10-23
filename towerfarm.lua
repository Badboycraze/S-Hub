getgenv().AutoFarmActive = true
getgenv().KillAuraRange = 60

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getClosestEnemy()
    local closest = nil
    local shortestDistance = getgenv().KillAuraRange
    
    local targets = workspace:FindFirstChild("Zombies") or workspace:FindFirstChild("NPCs") or workspace
    
    for _, obj in pairs(targets:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj ~= LocalPlayer.Character then
            local root = obj:FindFirstChild("HumanoidRootPart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if root and myRoot then
                local distance = (root.Position - myRoot.Position).Magnitude
                if distance < shortestDistance then
                    closest = root
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while getgenv().AutoFarmActive and task.wait(0.1) do
        local target = getClosestEnemy()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

