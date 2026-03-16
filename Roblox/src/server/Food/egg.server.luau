-- File: server/Food/egg.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local eggPart = foodFolder:WaitForChild("Egg")

eggPart.Anchored = false

-- DEFINIAMO I COLORI (Ora molto più visibili ed estremi!)
local COLOR_FRESH = Color3.fromRGB(255, 250, 240) -- Bianco/Panna (Fresco)
local COLOR_REC = Color3.fromRGB(200, 180, 100)   -- Giallo sporco/Senape (In scadenza)
local COLOR_SPOIL = Color3.fromRGB(50, 70, 50)    -- Verde scuro/Nero marcio (Avariato)

-- Impostiamo il colore e materiale iniziale (Fresco)
eggPart.Color = COLOR_FRESH
eggPart.Material = Enum.Material.SmoothPlastic

local egg = FoodBase.new(eggPart, 30, 60)

egg:setupPickup(eggPart, "Uovo")

function egg:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		-- Cambio colore netto
		eggPart.Color = COLOR_REC
		eggPart.Material = Enum.Material.Plastic 
		
		self.prompt.ActionText = "Raccogli (In scadenza - Cuoci bene!)"
		print("🥚 STATO CAMBIATO: L'uovo è in scadenza e ha cambiato colore!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		-- Cambio colore drastico
		eggPart.Color = COLOR_SPOIL
		eggPart.Material = Enum.Material.CorrodedMetal 
		
		self.prompt.ActionText = "Raccogli (Puzza/Galleggia!)"
		print("🥚 STATO CAMBIATO: L'uovo è marcio e scuro, buttalo nel compost!")
	end
end

egg:startAging()