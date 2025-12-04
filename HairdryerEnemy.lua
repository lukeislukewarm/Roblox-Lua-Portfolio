local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Enemy = script.Parent
local Attachment = Enemy:WaitForChild("BlowAttachment")
local Humanoid = Enemy:WaitForChild("Humanoid")

local MinDistance = 10
local SpeedReduction = 5
local TeleportDistance = 120
local BaseRotationSpeed = 1
local CloseRotationBoost = 6

local TargetPlayer = nil
local Follow = false

local function GetClosestPlayer()
    local closest = nil
    local shortest = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - Enemy.Position).Magnitude
            if distance < shortest then
                shortest = distance
                closest = player
            end
        end
    end

    return closest
end

local function FollowPlayer(player)
    if not player.Character then return end
    TargetPlayer = player
    Follow = true
end

local function StopFollowing()
    Follow = false
    TargetPlayer = nil
end

local function KillPlayer(player)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
        char.Humanoid.Health = 0
    end
end

local function MoveAI()
    RunService.Heartbeat:Connect(function(dt)
        if not Follow or not TargetPlayer then return end
        local char = TargetPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local root = char.HumanoidRootPart
        local distance = (root.Position - Enemy.Position).Magnitude

        if distance > TeleportDistance then
            Enemy.CFrame = root.CFrame * CFrame.new(0, 0, MinDistance + 2)
        end

        local targetPos = root.Position
        local moveDirection = (targetPos - Enemy.Position).Unit

        local speed = (char:FindFirstChild("Humanoid") and char.Humanoid.WalkSpeed or 16) - SpeedReduction
        Enemy.Velocity = moveDirection * speed

        local rotationSpeed = BaseRotationSpeed
        if distance < 25 then
            rotationSpeed = CloseRotationBoost
        end
        Enemy.Orientation += Vector3.new(0, rotationSpeed, 0) * dt * 60

        if distance <= MinDistance then
            KillPlayer(TargetPlayer)
            StopFollowing()
            task.wait(2)
        end
    end)
end

local function Start()
    task.wait(3)
    local player = GetClosestPlayer()
    if player then
        FollowPlayer(player)
    end
end

Start()
MoveAI()