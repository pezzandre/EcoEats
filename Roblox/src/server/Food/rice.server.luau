-- File: server/Food/rice.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = Workspace:WaitForChild("Food")
local riceObj = foodFolder:WaitForChild("Rice")

-- Supporta sia modelli complessi che pezzi singoli (MeshPart)
local ricePart = riceObj:IsA("Model") and (riceObj.PrimaryPart or riceObj:FindFirstChildWhichIsA("BasePart")) or riceObj

if ricePart then
    ricePart.Anchored = false
end

-- Creiamo l'oggetto Riso (es. 4s per diventare vecchio, 8s per marcire)
local rice = FoodBase.new(riceObj, 4, 8)

rice:setupPickup(ricePart, "Rice")

-- GESTIAMO GLI EFFETTI PARTICELLARI (Niente cambio colore)
function rice:onStateChanged()
    if self.currentState == FoodBase.FoodState.RECOVERABLE then
        print("🍚 Rice is getting old... emitting light smoke.")
        
        -- EFFETTO 1: Fumo verde chiaro e leggero
        local lightSmoke = Instance.new("ParticleEmitter")
        lightSmoke.Name = "StaleSmoke"
        lightSmoke.Color = ColorSequence.new(Color3.fromRGB(180, 255, 180)) -- Verde molto chiaro/pastello
        lightSmoke.Size = NumberSequence.new(0.3, 0.6) -- Particelle piccole
        lightSmoke.Rate = 4 -- Poca densità (4 al secondo)
        lightSmoke.Speed = NumberRange.new(0.5, 1) -- Lente
        lightSmoke.Lifetime = NumberRange.new(1, 2)
        lightSmoke.Parent = ricePart
        
        self.prompt.ActionText = "Collect Old Rice"

    elseif self.currentState == FoodBase.FoodState.SPOILED then
        print("🤢 Rice is spoiled! Emitting toxic smoke.")
        
        -- Puliamo il fumo vecchio se esiste
        local oldSmoke = ricePart:FindFirstChild("StaleSmoke")
        if oldSmoke then
            oldSmoke:Destroy()
        end
        
        -- EFFETTO 2: Fumo verde scuro e denso (Muffa tossica)
        local toxicSmoke = Instance.new("ParticleEmitter")
        toxicSmoke.Name = "ToxicSmoke"
        toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(30, 130, 30)) -- Verde scuro
        toxicSmoke.Size = NumberSequence.new(0.6, 1.2) -- Particelle più grandi
        toxicSmoke.Rate = 15 -- Alta densità (15 al secondo)
        toxicSmoke.Speed = NumberRange.new(1.5, 2.5) -- Più veloci verso l'alto
        toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
        toxicSmoke.Parent = ricePart
        
        self.prompt.ActionText = "Collect Spoiled Rice"
    end
end

-- Avviamo l'invecchiamento
rice:startAging()