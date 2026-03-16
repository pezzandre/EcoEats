-- File: server/Food/FoodBase.luau
local FoodBase = {}
FoodBase.__index = FoodBase

-- Definiamo gli stati (Come un Enum in Java)
local FoodState = {
	FRESH = 1,
	RECOVERABLE = 2,
	SPOILED = 3
}
FoodBase.FoodState = FoodState

-- Costruttore della nostra classe (equivalente a "public FoodBase(...)")
function FoodBase.new(model, recoverableTime, spoiledTime)
	local self = setmetatable({}, FoodBase)
	
	self.model = model
	self.recoverableTime = recoverableTime
	self.spoiledTime = spoiledTime
	
	self.currentState = FoodState.FRESH
	self.age = 0
	
	return self
end

-- Metodo per far partire l'invecchiamento
function FoodBase:startAging()
	-- Usiamo task.spawn per far girare il loop senza bloccare il resto del gioco
	task.spawn(function()
		while self.currentState ~= FoodState.SPOILED do
			task.wait(1)
			self.age += 1
			self:checkExpiration()
		end
	end)
end

-- Metodo interno per controllare i tempi
function FoodBase:checkExpiration()
	local previousState = self.currentState
	
	if self.age >= self.spoiledTime then
		self.currentState = FoodState.SPOILED
	elseif self.age >= self.recoverableTime then
		self.currentState = FoodState.RECOVERABLE
	end
	
	-- Se lo stato è cambiato, chiamiamo la funzione di aggiornamento visivo
	if self.currentState ~= previousState then
		self:onStateChanged()
	end
end

-- Metodo "vuoto" che andremo a sovrascrivere (Override) per ogni ingrediente specifico
function FoodBase:onStateChanged()
	warn("onStateChanged method not implemented for " .. self.model.Name)
end

return FoodBase