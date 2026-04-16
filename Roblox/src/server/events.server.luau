-- Riferimenti agli oggetti nel Workspace
local liquido = game.Workspace.Pot.Liquido
local liquidoNorm = game.Workspace.Pot1.Liquido -- Torna normale
local liquidoSmall = game.Workspace.Pot2.Liquido -- Diventa piccolo

--- FUNZIONE GENERALE PER CAMBIARE SCALA
-- Usiamo una funzione per non ripetere lo stesso codice 3 volte
local function cambiaScala(humanoid, valore)
	humanoid.BodyWidthScale.Value = valore
	humanoid.BodyDepthScale.Value = valore 
	humanoid.BodyHeightScale.Value = valore 
	humanoid.HeadScale.Value = valore 
end

-- 1. LIQUIDO ORIGINALE (Ingrandisce - Scala 2)
liquido.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		cambiaScala(humanoid, 2)
	end
end)

-- 2. LIQUIDO POT1 (Normalizza - Scala 1)
liquidoNorm.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		cambiaScala(humanoid, 1)
	end
end)

-- 3. LIQUIDO POT2 (Rimpicciolisce - Scala 0.5)
-- Se l'originale raddoppia (x2), questo dimezza (0.5)
liquidoSmall.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		cambiaScala(humanoid, 0.5)
	end
end)