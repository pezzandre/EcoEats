-- File: client/sprint.client.luau
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- COSTANTI VELOCITÀ
local NORMAL_SPEED = 16
local SPRINT_SPEED = 32 -- 2x Speed

-- COSTANTI SALTO
local NORMAL_JUMP = 50
local SPRINT_JUMP = 100 -- 2x Jump Power

-- Funzione sicura per trovare l'Humanoid
local function getHumanoid()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Ci assicuriamo che il sistema usi JumpPower e non JumpHeight
            humanoid.UseJumpPower = true 
            return humanoid
        end
    end
    return nil
end

-- Quando premi un tasto
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    
    -- Se premi Shift Sinistro
    if input.KeyCode == Enum.KeyCode.LeftShift then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = SPRINT_SPEED
            humanoid.JumpPower = SPRINT_JUMP -- Aumentiamo il salto!
        end
    end
end)

-- Quando rilasci il tasto
UserInputService.InputEnded:Connect(function(input, isTyping)
    -- Se rilasci Shift Sinistro
    if input.KeyCode == Enum.KeyCode.LeftShift then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = NORMAL_SPEED
            humanoid.JumpPower = NORMAL_JUMP -- Torniamo al salto normale
        end
    end
end)