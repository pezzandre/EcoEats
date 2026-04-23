local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crea RemoteEvents
local shopFolder = Instance.new("Folder")
shopFolder.Name = "ShopEvents"
shopFolder.Parent = ReplicatedStorage

local buyEffect = Instance.new("RemoteEvent")
buyEffect.Name = "BuyEffect"
buyEffect.Parent = shopFolder

local getPlayers = Instance.new("RemoteFunction")
getPlayers.Name = "GetPlayers"
getPlayers.Parent = shopFolder

-- Ritorna lista players
getPlayers.OnServerInvoke = function(player)
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			table.insert(list, p.Name)
		end
	end
	return list
end

local COSTS = {
	explodeOne = 10,
	explodeAll = 10,
	bigOne = 10,
	speedOne = 10,
	smallOne = 10,
}

local function getCoins(player)
	local ls = player:FindFirstChild("leaderstats")
	return ls and ls:FindFirstChild("Coins")
end

local function explodePlayer(target)
	local character = target.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- Esplosione Roblox standard
	local explosion = Instance.new("Explosion")
	explosion.Position = rootPart.Position
	explosion.BlastRadius = 10
	explosion.BlastPressure = 500000
	explosion.DestroyJointRadiusPercent = 0
	explosion.Parent = workspace

	-- Uccidi
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end

local activeEffects = {}

local function applyTemporaryEffect(target, effectType)
	local character = target.Character
	if not character then return end
	local humanoid = character:FindFirstChild("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not rootPart then return end

	local userId = target.UserId

	-- Cancella effetto precedente dello stesso tipo se esiste
	if activeEffects[userId] and activeEffects[userId][effectType] then
		activeEffects[userId][effectType] = false
	end

	if not activeEffects[userId] then
		activeEffects[userId] = {}
	end
	activeEffects[userId][effectType] = true

	if effectType == "big" then
		local originalSize = {}
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				originalSize[part] = part.Size
				part.Size = part.Size * 3
			end
		end
		humanoid.HipHeight = humanoid.HipHeight * 3

		task.spawn(function()
			task.wait(30)
			if not activeEffects[userId] or not activeEffects[userId][effectType] then return end
			activeEffects[userId][effectType] = false
			local c = target.Character
			if not c then return end
			local h = c:FindFirstChild("Humanoid")
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") and originalSize[part] then
					part.Size = originalSize[part]
				end
			end
			if h then h.HipHeight = h.HipHeight / 3 end
		end)

	elseif effectType == "speed" then
		local originalSpeed = humanoid.WalkSpeed
		humanoid.WalkSpeed = 200

		task.spawn(function()
			task.wait(30)
			if not activeEffects[userId] or not activeEffects[userId][effectType] then return end
			activeEffects[userId][effectType] = false
			local c = target.Character
			if not c then return end
			local h = c:FindFirstChild("Humanoid")
			if h then h.WalkSpeed = originalSpeed end
		end)

	elseif effectType == "small" then
		local originalSize = {}
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				originalSize[part] = part.Size
				part.Size = part.Size / 3
			end
		end
		humanoid.HipHeight = humanoid.HipHeight / 3

		task.spawn(function()
			task.wait(30)
			if not activeEffects[userId] or not activeEffects[userId][effectType] then return end
			activeEffects[userId][effectType] = false
			local c = target.Character
			if not c then return end
			local h = c:FindFirstChild("Humanoid")
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") and originalSize[part] then
					part.Size = originalSize[part]
				end
			end
			if h then h.HipHeight = h.HipHeight * 3 end
		end)
	end
end

buyEffect.OnServerEvent:Connect(function(player, effectType, targetName)
	print("🛒 Acquisto richiesto da " .. player.Name .. " | Effetto: " .. tostring(effectType) .. " | Target: " .. tostring(targetName))

	local coins = getCoins(player)
	if not coins then 
		print("❌ Coins non trovate per " .. player.Name)
		return 
	end

	local cost = COSTS[effectType]
	if not cost then 
		print("❌ Effetto non valido: " .. tostring(effectType))
		return 
	end

	if coins.Value < cost then
		print("❌ Monete insufficienti: " .. coins.Value .. "/" .. cost)
		return
	end

	coins.Value -= cost
	print("✅ Pagato! Monete rimaste: " .. coins.Value)

	if effectType == "explodeOne" then
		local target = Players:FindFirstChild(targetName)
		if target then 
			print("💥 Esplodo: " .. target.Name)
			explodePlayer(target) 
		else
			print("❌ Target non trovato: " .. tostring(targetName))
		end

	elseif effectType == "explodeAll" then
		print("💣 Esplodo tutti!")
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				print("💥 Esplodo: " .. p.Name)
				explodePlayer(p)
			end
		end

	elseif effectType == "bigOne" then
		local target = Players:FindFirstChild(targetName)
		if target then 
			print("🔺 Ingrandisco: " .. target.Name)
			applyTemporaryEffect(target, "big") 
		else
			print("❌ Target non trovato: " .. tostring(targetName))
		end

	elseif effectType == "speedOne" then
		local target = Players:FindFirstChild(targetName)
		if target then 
			print("⚡ Velocità a: " .. target.Name)
			applyTemporaryEffect(target, "speed") 
		else
			print("❌ Target non trovato: " .. tostring(targetName))
		end

	elseif effectType == "smallOne" then
		local target = Players:FindFirstChild(targetName)
		if target then 
			print("🔻 Rimpicciolisco: " .. target.Name)
			applyTemporaryEffect(target, "small") 
		else
			print("❌ Target non trovato: " .. tostring(targetName))
		end
	end
end)