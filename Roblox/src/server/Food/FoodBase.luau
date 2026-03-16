-- File: server/Food/FoodBase.luau
local FoodBase = {}
FoodBase.__index = FoodBase

local FoodState = {
	FRESH = 1,
	RECOVERABLE = 2,
	SPOILED = 3
}
FoodBase.FoodState = FoodState

function FoodBase.new(model, recoverableTime, spoiledTime)
	local self = setmetatable({}, FoodBase)
	
	self.model = model
	self.recoverableTime = recoverableTime
	self.spoiledTime = spoiledTime
	
	self.currentState = FoodState.FRESH
	self.age = 0
	
	return self
end


--FIXME da cambiare: non invecchia il cibo ma spunta random già scaduto o da buttare.
function FoodBase:startAging()
	task.spawn(function()
		while self.currentState ~= FoodState.SPOILED do
			task.wait(1)
			self.age += 1
			self:checkExpiration()
		end
	end)
end

function FoodBase:checkExpiration()
	local previousState = self.currentState
	
	if self.age >= self.spoiledTime then
		self.currentState = FoodState.SPOILED
	elseif self.age >= self.recoverableTime then
		self.currentState = FoodState.RECOVERABLE
	end
	
	if self.currentState ~= previousState then
		self:onStateChanged()
	end
end

function FoodBase:onStateChanged()
	-- Questa funzione viene sovrascritta (Override) dal file del cibo specifico
end

-- ==========================================
-- NUOVO: SISTEMA DI RACCOLTA UNIVERSALE
-- ==========================================

-- Chiama questa funzione dallo script del cibo per attivare la raccolta
function FoodBase:setupPickup(mainPart, nomeBase)
	self.mainPart = mainPart
	self.nomeBase = nomeBase or self.model.Name
	
	-- Creiamo il pulsante "E"
	self.prompt = Instance.new("ProximityPrompt")
	self.prompt.ActionText = "Raccogli " .. self.nomeBase
	self.prompt.ObjectText = self.nomeBase
	self.prompt.HoldDuration = 0.5
	self.prompt.MaxActivationDistance = 8
	self.prompt.Parent = self.mainPart
	
	-- Quando premi "E", avvia la funzione pickup qui sotto
	self.prompt.Triggered:Connect(function(player)
		self:pickup(player)
	end)
end

-- La logica per raccogliere, dare monete e creare il Tool
function FoodBase:pickup(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins = leaderstats and leaderstats:FindFirstChild("Coins")
	
	local reward = 0
	local nomeTool = self.nomeBase
	
	-- Controlliamo lo stato per assegnare monete e nome
	if self.currentState == FoodState.FRESH then
		reward = 3
		nomeTool = self.nomeBase .. " Fresca"
	elseif self.currentState == FoodState.RECOVERABLE then
		reward = 2
		nomeTool = self.nomeBase .. " Macchiata"
	elseif self.currentState == FoodState.SPOILED then
		reward = 1
		nomeTool = self.nomeBase .. " Avariata"
	end
	
	if coins then 
		coins.Value += reward 
		print("Hai raccolto " .. nomeTool .. "! +" .. reward .. " Coins.")
	end
	
	-- Creiamo il Tool
	local tool = Instance.new("Tool")
	tool.Name = nomeTool
	tool.RequiresHandle = true
	tool.CanBeDropped = true
	
	-- 1. Creiamo l'Handle (il pezzo principale che si tiene in mano)
	local handle = self.mainPart:Clone()
	handle.Name = "Handle"
	handle:ClearAllChildren() -- Rimuove vecchi pulsanti o saldature
	handle.Anchored = false
	handle.Parent = tool
	
	-- 2. Troviamo TUTTI gli altri pezzi del cibo e li saldiamo all'Handle in automatico!
	for _, pezzo in ipairs(self.model:GetDescendants()) do
		if pezzo:IsA("BasePart") and pezzo ~= self.mainPart then
			local pezzoClone = pezzo:Clone()
			pezzoClone:ClearAllChildren()
			pezzoClone.Anchored = false
			
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = pezzoClone
			weld.Parent = handle
			
			pezzoClone.Parent = tool
		end
	end
	
	-- Mettiamo il Tool nello zaino del giocatore
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		tool.Parent = backpack
	end
	
	-- Distruggiamo il modello per terra
	self.model:Destroy()
end

return FoodBase