-- File: server/Food/honey.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = Workspace:WaitForChild("Food")
local jarModel = foodFolder:WaitForChild("HoneyJar")

-- Definiamo le parti basandoci sulla tua struttura
local handlePart = jarModel:WaitForChild("Handle")
local honeyPart = handlePart:WaitForChild("Honey") -- La parte interna da colorare

-- Impostiamo il barattolo come modello
jarModel.PrimaryPart = handlePart
handlePart.Anchored = false

-- Creiamo l'oggetto Miele (es: 30s per diventare scuro, 60s per marcire)
local honey = FoodBase.new(jarModel, 30, 60)

-- Colori per i vari stati
local COLORS = {
    FRESH = Color3.fromRGB(255, 170, 0),      -- Oro brillante
    RECOVERABLE = Color3.fromRGB(150, 75, 0), -- Ambra scuro/marrone
    SPOILED = Color3.fromRGB(50, 80, 50)      -- Verde scuro "muffa"
}

-- Gestiamo il cambiamento visivo
function honey:onStateChanged()
    if self.currentState == FoodBase.FoodState.FRESH then
        honeyPart.Color = COLORS.FRESH
        
    elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
        print("🍯 Il miele si sta cristallizzando/scurendo...")
        honeyPart.Color = COLORS.RECOVERABLE
        self.prompt.ActionText = "Collect Dark Honey"

    elseif self.currentState == FoodBase.FoodState.SPOILED then
        print("🤢 Il miele è andato a male!")
        honeyPart.Color = COLORS.SPOILED
        
        -- Aggiungiamo anche qui l'effetto puzza visto che è spoiled
        local particles = Instance.new("ParticleEmitter")
        particles.Color = ColorSequence.new(Color3.fromRGB(100, 150, 100))
        particles.Size = NumberSequence.new(0.2, 0.8)
        particles.Rate = 5
        particles.Lifetime = NumberRange.new(1, 2)
        particles.Parent = honeyPart
        
        self.prompt.ActionText = "Collect Spoiled Honey"
    end
end

-- Attiviamo la raccolta
honey:setupPickup(handlePart, "Honey Jar")

-- Avviamo l'invecchiamento
honey:startAging()