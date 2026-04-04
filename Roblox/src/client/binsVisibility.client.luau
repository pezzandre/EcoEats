-- File: client/binsVisibility.client.luau
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Funzione che controlla se stiamo tenendo del cibo
local function isHoldingFood()
    local character = player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    -- Controlliamo se il tool ha l'attributo FoodState che abbiamo settato nel FoodBase
    return tool and tool:GetAttribute("FoodState") ~= nil
end

-- Ogni frame (o quasi), aggiorniamo i prompt nel mondo
RunService.Heartbeat:Connect(function()
    local holdingFood = isHoldingFood()
    
    -- Cerchiamo tutti i ProximityPrompt che hanno a che fare con i cestini
    -- (Li troviamo cercando nel Workspace per nome o per cartella)
    for _, prompt in ipairs(game.Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and (prompt.ObjectText == "Generic Bin" or prompt.ObjectText == "Compost Bin") then
            -- Il prompt si abilita SOLO se il giocatore ha cibo in mano
            prompt.Enabled = holdingFood
        end
    end
end)