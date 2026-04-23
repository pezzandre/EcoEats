-- References
local liquido = game.Workspace.Pot.Liquido
local liquidoNorm = game.Workspace.Pot1.Liquido -- Torna normale
local liquidoSmall = game.Workspace.Pot2.Liquido -- Diventa piccolo
local liquidoBig = game.Workspace.Pot3.Liquido -- Gigante x10 per 40s
local liquidoTiny = game.Workspace.Pot4.Liquido -- Minuscolo x0.1 per 1 minuto

--- FUNZIONE GENERALE PER CAMBIARE SCALA
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
liquidoSmall.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		cambiaScala(humanoid, 0.5)
	end
end)

-- 4. LIQUIDO POT3 (Gigante x10 per 40 secondi + speed boost)
liquidoBig.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.BodyWidthScale.Value = 10
		humanoid.BodyDepthScale.Value = 10
		humanoid.BodyHeightScale.Value = 10
		humanoid.HeadScale.Value = 10
		humanoid.WalkSpeed = 60
		task.wait(40)
		humanoid.BodyWidthScale.Value = 1
		humanoid.BodyDepthScale.Value = 1
		humanoid.BodyHeightScale.Value = 1
		humanoid.HeadScale.Value = 1
		humanoid.WalkSpeed = 16
	end
end)

-- 5. LIQUIDO POT4 (Minuscolo x0.1 per 1 minuto)
liquidoTiny.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.BodyWidthScale.Value = 0.1
		humanoid.BodyDepthScale.Value = 0.1
		humanoid.BodyHeightScale.Value = 0.1
		humanoid.HeadScale.Value = 0.1
		humanoid.HipHeight = 0.5
		humanoid.WalkSpeed = 8
		task.wait(60)
		humanoid.BodyWidthScale.Value = 1
		humanoid.BodyDepthScale.Value = 1
		humanoid.BodyHeightScale.Value = 1
		humanoid.HeadScale.Value = 1
		humanoid.HipHeight = 0
		humanoid.WalkSpeed = 16
	end
end)