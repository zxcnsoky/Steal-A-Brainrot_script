
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local FLY_SPEED = 50
local BOOST_MULTIPLIER = 2
local IsFlying = false
local BodyGyro, BodyVelocity

local function ToggleFlight()
    IsFlying = not IsFlying
    
    if IsFlying then
        -- Включаем полёт
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.D = 100
        BodyGyro.P = 10000
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = HumanoidRootPart.CFrame
        BodyGyro.Parent = HumanoidRootPart

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = HumanoidRootPart
        
        -- Плавный подъём
        BodyVelocity.Velocity = Vector3.new(0, FLY_SPEED/2, 0)
        wait(0.5)
    else
        -- Выключаем полёт
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
    end
end

local function UpdateFlight()
    if not IsFlying then return end
    
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- Обработка клавиш WASD
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    
    -- Обработка Space (вверх)
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    
    -- Нормализация направления
    moveDirection = moveDirection.Unit
    
    -- Ускорение при зажатом Shift
    local speed = FLY_SPEED
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
        speed = speed * BOOST_MULTIPLIER
    end
    
    -- Применение движения
    if BodyVelocity then
        BodyVelocity.Velocity = moveDirection * speed
    end
end

-- Обработка нажатия Q
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        ToggleFlight()
    end
end)

-- Постоянное обновление полёта
game:GetService("RunService").Heartbeat:Connect(UpdateFlight)

-- Автоматическое выключение при смерти
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
    if IsFlying then
        ToggleFlight()
    end
end)

print("Скрипт активирован, спасибо за использование! t.me/zxcnosky - вечный юзернейм телеграмм.")