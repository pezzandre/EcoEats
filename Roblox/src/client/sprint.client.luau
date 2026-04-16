-- File: client/sprint.client.luau
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- COSTANTI VELOCITÀ
local NORMAL_SPEED = 30
local SPRINT_SPEED = 45

-- COSTANTI SALTO
local NORMAL_JUMP = 75
local SPRINT_JUMP = 100 


local function initializeCharacter(character)
    -- Aspettiamo che l'Humanoid esista nel personaggio
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Impostiamo i valori di base IMMEDIATAMENTE
    humanoid.UseJumpPower = true 
    humanoid.WalkSpeed = NORMAL_SPEED
    humanoid.JumpPower = NORMAL_JUMP
end

player.CharacterAdded:Connect(initializeCharacter)

if player.Character then
    initializeCharacter(player.Character)
end

-- ==========================================
-- LOGICA DEL TASTO SHIFT
-- ==========================================

-- Funzione semplificata (ora deve solo trovare l'Humanoid, senza impostare valori)
local function getHumanoid()
    local character = player.Character
    if character then
        return character:FindFirstChild("Humanoid")
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