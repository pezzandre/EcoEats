-- File: client/itemVisibility.client.luau (Ex binsVisibility)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Controlla se abbiamo in mano un Tool che fa parte del nostro sistema Food
local function isHoldingFood()
    local character = player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    return tool and tool:GetAttribute("FoodState") ~= nil
end

-- Aggiorna la visibilità di tutti i bottoni in tempo reale
RunService.Heartbeat:Connect(function()
    local holdingFood = isHoldingFood()
    
    for _, prompt in ipairs(game.Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            
            -- Controlliamo se il bottone appartiene a un cestino o a una postazione cucina!
            if prompt.ObjectText == "Generic Bin" 
               or prompt.ObjectText == "Compost Bin" 
               or prompt.Name == "CookingPrompt" then -- Il nome che abbiamo aggiunto prima!
                
                -- Si accende solo se hai cibo in mano
                prompt.Enabled = holdingFood
            end
        end
    end
end)