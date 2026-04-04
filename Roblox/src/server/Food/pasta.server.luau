-- File: server/Food/pasta.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

-- Troviamo la cartella e il pezzo singolo della pasta
local foodFolder = Workspace:WaitForChild("Food")
local pastaPart = foodFolder:WaitForChild("Pasta")

-- Opzionale: sblocchiamo la fisica per non farla fluttuare
pastaPart.Anchored = false

-- Creiamo l'oggetto Pasta. 
-- Passiamo pastaPart come primo argomento visto che non c'è un modello!
local pasta = FoodBase.new(pastaPart, 9999, 9999)

-- Attiviamo la raccolta usando sempre pastaPart
pasta:setupPickup(pastaPart, "Pasta")

-- NESSUN startAging() -> La pasta non scadrà mai e resterà FRESH