-- File: server/Food/bread.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")

-- Visto che è un pezzo unico, il "Modello" e la "Parte Principale" sono la stessa cosa!
local breadPart = foodFolder:WaitForChild("Bread")

-- Sblocchiamo la fisica per farlo cadere a terra
breadPart.Anchored = false

--FIXME I COLORI NON CAMBIANO, CAMBIA PANE!!

-- DEFINIAMO I COLORI
local COLOR_FRESH = Color3.fromRGB(245, 222, 179)  -- Dorato/Beige (Pane fresco)
local COLOR_REC = Color3.fromRGB(180, 140, 100)    -- Marrone scuro/Opaco (Pane raffermo)
local COLOR_SPOIL = Color3.fromRGB(80, 140, 80)    -- Verde scuro (Muffa verde)

-- Impostiamo il colore e materiale iniziale (Fresco)
breadPart.Color = COLOR_FRESH
breadPart.Material = Enum.Material.Sand -- "Sand" dà un bell'effetto ruvido tipo crosta di pane

-- Creiamo il pane (es. diventa raffermo a 25s, ammuffisce a 50s)
-- Passiamo breadPart sia come modello che come parte principale
local bread = FoodBase.new(breadPart, 25, 50)

-- Attiviamo il pickup
bread:setupPickup(breadPart, "Pane")

-- GESTIAMO IL CAMBIO DI STATO
function bread:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		breadPart.Color = COLOR_REC
		
		-- Cambiamo materiale per farlo sembrare duro come il legno!
		breadPart.Material = Enum.Material.Wood 
		
		self.prompt.ActionText = "Raccogli (Raffermo)"
		print("🍞 STATO CAMBIATO: Il pane è duro (ottimo per pangrattato/crostini)!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		breadPart.Color = COLOR_SPOIL
		
		-- Usiamo Grass per simulare la consistenza pelosa della muffa verde
		breadPart.Material = Enum.Material.Grass 
		
		self.prompt.ActionText = "Raccogli (Ammuffito)"
		print("🍞 STATO CAMBIATO: Il pane ha la muffa verde, buttalo nel compost!")
	end
end

-- Avviamo il timer!
bread:startAging()