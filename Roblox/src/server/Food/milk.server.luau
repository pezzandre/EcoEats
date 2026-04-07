-- File: server/Food/milk.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = Workspace:WaitForChild("Food")

local milkPart = foodFolder:WaitForChild("Milk")
milkPart.Anchored = false

-- Mettendo lo stesso numero (es. 40, 40), salta lo stato RECOVERABLE!
local milk = FoodBase.new(milkPart, 10, 10)

milk:setupPickup(milkPart, "Milk")

-- GESTIAMO IL CAMBIO DI STATO
function milk:onStateChanged()
    if self.currentState == FoodBase.FoodState.SPOILED then
        print("🥛 Milk is spoiled! Emitting green gas...")
        
        milkPart.Color = Color3.fromRGB(150, 200, 150)
        
        -- Creiamo l'effetto fumo/puzza verde!
        local stinkEffect = Instance.new("ParticleEmitter")
        stinkEffect.Name = "StinkParticles"
        
        -- Colore verde tossico
        stinkEffect.Color = ColorSequence.new(Color3.fromRGB(50, 200, 50)) 
        
        -- Impostazioni per farlo sembrare fumo maleodorante
        stinkEffect.Size = NumberSequence.new(0.5, 1.5) -- Parte piccolo e si ingrandisce
        stinkEffect.Rate = 12 -- 12 particelle al secondo
        stinkEffect.Speed = NumberRange.new(1, 2) -- Fluttua lentamente verso l'alto
        stinkEffect.Lifetime = NumberRange.new(1.5, 2.5) -- Quanto durano le particelle
        stinkEffect.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),   -- Inizia invisibile
            NumberSequenceKeypoint.new(0.2, 0.5), -- Diventa mezzo visibile
            NumberSequenceKeypoint.new(1, 1)    -- Scompare alla fine
        })
        
        -- Attacchiamo l'effetto al latte
        stinkEffect.Parent = milkPart
        
        self.prompt.ActionText = "Collect Spoiled Milk"
    end
end

-- Avviamo il timer del decadimento
milk:startAging()