local datastores = game:GetService("DataStoreService")
local datastore = datastores:GetDataStore("CoinsDataStore") -- Database dedicato alle monete
local players = game:GetService("Players")

-- Funzione unica per gestire l'entrata del giocatore
players.PlayerAdded:Connect(function(player)
	-- 1. Creiamo la cartella leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- 2. Creiamo solo il valore Coins
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats

	-- 3. Carichiamo le monete salvate
	local success, savedCoins = pcall(function()
		return datastore:GetAsync("Coins_"..player.UserId)
	end)

	if success then
		if savedCoins then
			coins.Value = savedCoins
		end
	else
		warn("Errore nel caricamento monete per " .. player.Name)
	end
end)

-- Funzione per salvare
local function saveCoins(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			local success, err = pcall(function()
				datastore:SetAsync("Coins_"..player.UserId, coins.Value)
			end)
			if not success then
				warn("Errore nel salvataggio per " .. player.Name .. ": " .. err)
			end
		end
	end
end

-- Evento quando il giocatore esce
players.PlayerRemoving:Connect(saveCoins)

-- Evento quando il server si chiude (importante per Studio)
game:BindToClose(function()
	for _, player in ipairs(players:GetPlayers()) do
		saveCoins(player)
	end
end)