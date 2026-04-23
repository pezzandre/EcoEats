local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local quizFolder = ReplicatedStorage:WaitForChild("QuizEvents")
local rewardEvent = quizFolder:WaitForChild("QuizReward")

local QUIZ_COOLDOWN = 240 -- 4 minuti
local lastQuizTime = -QUIZ_COOLDOWN
local currentLanguage = "IT"

local questions = {
	{
		IT = {
			question = "Qual è la temperatura ideale per conservare il cibo in frigo?",
			answers = {"0-4°C", "10-15°C", "20-25°C", "5-8°C"},
			correct = 1
		},
		EN = {
			question = "What is the ideal temperature to store food in the fridge?",
			answers = {"0-4°C", "10-15°C", "20-25°C", "5-8°C"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quanto cibo viene sprecato ogni anno nel mondo?",
			answers = {"1/3 della produzione", "1/10 della produzione", "1/2 della produzione", "1/20 della produzione"},
			correct = 1
		},
		EN = {
			question = "How much food is wasted every year in the world?",
			answers = {"1/3 of production", "1/10 of production", "1/2 of production", "1/20 of production"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa significa FIFO nella gestione del cibo?",
			answers = {"Prima entra, prima esce", "Fresco in, fresco fuori", "Freddo in, freddo fuori", "Nessuna delle precedenti"},
			correct = 1
		},
		EN = {
			question = "What does FIFO mean in food management?",
			answers = {"First In, First Out", "Fresh In, Fresh Out", "Frozen In, Frozen Out", "None of the above"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale settore spreca più cibo?",
			answers = {"Famiglie domestiche", "Ristoranti", "Supermercati", "Agricoltura"},
			correct = 1
		},
		EN = {
			question = "Which sector wastes the most food?",
			answers = {"Households", "Restaurants", "Supermarkets", "Agriculture"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa puoi fare con gli avanzi di cibo?",
			answers = {"Compostaggio", "Buttarli subito", "Lasciarli fuori dal frigo", "Niente"},
			correct = 1
		},
		EN = {
			question = "What can you do with food leftovers?",
			answers = {"Composting", "Throw them away immediately", "Leave them outside the fridge", "Nothing"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è il modo migliore per conservare il pane?",
			answers = {"In un sacchetto di carta o paniera", "In frigo", "In un sacchetto di plastica chiuso", "All'aperto"},
			correct = 1
		},
		EN = {
			question = "What is the best way to store bread?",
			answers = {"In a paper bag or bread box", "In the fridge", "In a sealed plastic bag", "In the open air"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa significa 'da consumarsi entro'?",
			answers = {"Il cibo potrebbe essere pericoloso dopo", "Il cibo è ancora buono dopo", "È solo un consiglio", "Non ha importanza"},
			correct = 1
		},
		EN = {
			question = "What does 'use by date' mean?",
			answers = {"Food may be unsafe after this date", "Food is still good after", "It's just a suggestion", "It doesn't matter"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale frutto produce gas etilene che fa maturare altri frutti?",
			answers = {"Banana", "Mela", "Arancia", "Uva"},
			correct = 1
		},
		EN = {
			question = "Which fruit produces ethylene gas that ripens other fruits?",
			answers = {"Banana", "Apple", "Orange", "Grape"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Come si chiama l'app che connette ristoranti con cibo in eccesso ai clienti?",
			answers = {"Too Good To Go", "Food Waste App", "Save My Food", "Eco Eats"},
			correct = 1
		},
		EN = {
			question = "What is the app that connects restaurants with excess food to customers?",
			answers = {"Too Good To Go", "Food Waste App", "Save My Food", "Eco Eats"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quante tonnellate di cibo vengono sprecate in Italia ogni anno?",
			answers = {"Circa 9 milioni", "Circa 1 milione", "Circa 50 milioni", "Circa 500mila"},
			correct = 1
		},
		EN = {
			question = "How many tons of food are wasted in Italy every year?",
			answers = {"About 9 million", "About 1 million", "About 50 million", "About 500 thousand"},
			correct = 1
		}
	},
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuizGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 0
screenGui.Parent = player.PlayerGui

-- Quiz button
local quizButton = Instance.new("TextButton")
quizButton.Size = UDim2.new(0, 70, 0, 70)
quizButton.Position = UDim2.new(1, -86, 1, -326)
quizButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
quizButton.Text = "❓"
quizButton.TextSize = 32
quizButton.Font = Enum.Font.GothamBold
quizButton.BorderSizePixel = 0
quizButton.Parent = screenGui

local qc = Instance.new("UICorner")
qc.CornerRadius = UDim.new(0, 18)
qc.Parent = quizButton

local qs = Instance.new("UIStroke")
qs.Color = Color3.fromRGB(40, 120, 200)
qs.Thickness = 2
qs.Parent = quizButton

-- Cooldown label sul bottone
local cooldownLabel = Instance.new("TextLabel")
cooldownLabel.Size = UDim2.new(1, 0, 0.5, 0)
cooldownLabel.Position = UDim2.new(0, 0, 0.5, 0)
cooldownLabel.BackgroundTransparency = 1
cooldownLabel.Text = ""
cooldownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
cooldownLabel.TextSize = 16
cooldownLabel.Font = Enum.Font.GothamBold
cooldownLabel.Parent = quizButton

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 400, 0, 500)
panel.Position = UDim2.new(0.5, -200, 0.5, -250)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 10
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 20)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(80, 180, 255)
panelStroke.Thickness = 2
panelStroke.Parent = panel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "❓  FOOD QUIZ"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Language toggle
local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 60, 0, 36)
langBtn.Position = UDim2.new(1, -106, 0, 8)
langBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
langBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
langBtn.Text = "🇮🇹 IT"
langBtn.TextSize = 13
langBtn.Font = Enum.Font.GothamBold
langBtn.BorderSizePixel = 0
langBtn.ZIndex = 11
langBtn.Parent = titleBar

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 8)
langCorner.Parent = langBtn

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 11
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Reward info
local rewardInfo = Instance.new("TextLabel")
rewardInfo.Size = UDim2.new(1, -20, 0, 30)
rewardInfo.Position = UDim2.new(0, 10, 0, 58)
rewardInfo.BackgroundTransparency = 1
rewardInfo.Text = "✅ Risposta giusta: +100 🪙   ❌ Risposta sbagliata: -25 🪙"
rewardInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
rewardInfo.TextSize = 12
rewardInfo.Font = Enum.Font.Gotham
rewardInfo.ZIndex = 10
rewardInfo.Parent = panel

-- Question label
local questionLabel = Instance.new("TextLabel")
questionLabel.Size = UDim2.new(1, -20, 0, 80)
questionLabel.Position = UDim2.new(0, 10, 0, 94)
questionLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
questionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
questionLabel.TextSize = 15
questionLabel.Font = Enum.Font.GothamBold
questionLabel.TextWrapped = true
questionLabel.ZIndex = 10
questionLabel.Parent = panel

local qCorner = Instance.new("UICorner")
qCorner.CornerRadius = UDim.new(0, 12)
qCorner.Parent = questionLabel

local qStroke = Instance.new("UIStroke")
qStroke.Color = Color3.fromRGB(80, 180, 255)
qStroke.Thickness = 1
qStroke.Parent = questionLabel

-- Answer buttons
local answerButtons = {}
local answerPositions = {
	UDim2.new(0, 10, 0, 190),
	UDim2.new(0, 10, 0, 250),
	UDim2.new(0, 10, 0, 310),
	UDim2.new(0, 10, 0, 370),
}

for i = 1, 4 do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 50)
	btn.Position = answerPositions[i]
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.TextWrapped = true
	btn.BorderSizePixel = 0
	btn.ZIndex = 10
	btn.Parent = panel

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 12)
	bc.Parent = btn

	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(60, 60, 60)
	bs.Thickness = 1
	bs.Parent = btn

	answerButtons[i] = {btn = btn, stroke = bs}
end

-- Result label
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -20, 0, 40)
resultLabel.Position = UDim2.new(0, 10, 0, 440)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.TextSize = 16
resultLabel.Font = Enum.Font.GothamBold
resultLabel.ZIndex = 10
resultLabel.Parent = panel

local currentQuestion = nil
local answered = false
local shuffledIndexes = {} -- salva l'ordine mescolato

local function loadQuestion()
	answered = false
	resultLabel.Text = ""
	shuffledIndexes = {}

	local q = questions[math.random(1, #questions)]
	currentQuestion = q

	local lang = q[currentLanguage]
	questionLabel.Text = lang.question

	-- Crea ordine mescolato degli indici
	local indexes = {1, 2, 3, 4}
	for i = #indexes, 2, -1 do
		local j = math.random(i)
		indexes[i], indexes[j] = indexes[j], indexes[i]
	end
	shuffledIndexes = indexes

	for i, data in ipairs(answerButtons) do
		local answerIndex = shuffledIndexes[i]
		data.btn.Text = lang.answers[answerIndex]
		data.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		data.btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		data.stroke.Color = Color3.fromRGB(60, 60, 60)
		data.btn.Active = true

		data.btn.MouseButton1Click:Connect(function()
			if answered then return end
			answered = true

			local isCorrect = shuffledIndexes[i] == currentQuestion[currentLanguage].correct

			if isCorrect then
				data.btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
				data.stroke.Color = Color3.fromRGB(50, 180, 50)
				resultLabel.Text = "✅ Correct! +100 🪙"
				resultLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
			else
				data.btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
				data.stroke.Color = Color3.fromRGB(180, 50, 50)
				resultLabel.Text = "❌ Wrong! -25 🪙"
				resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
				for j, d in ipairs(answerButtons) do
					if shuffledIndexes[j] == currentQuestion[currentLanguage].correct then
						d.btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
						d.stroke.Color = Color3.fromRGB(50, 180, 50)
					end
				end
			end

			rewardEvent:FireServer(isCorrect)
			lastQuizTime = tick()
			task.delay(2, function()
				panel.Visible = false
			end)
		end)
	end
end

-- Aggiorna solo testi quando cambia lingua
local function updateLanguageTexts()
	if not currentQuestion then return end
	local lang = currentQuestion[currentLanguage]
	questionLabel.Text = lang.question
	for i, data in ipairs(answerButtons) do
		local answerIndex = shuffledIndexes[i]
		if answerIndex then
			data.btn.Text = lang.answers[answerIndex]
		end
	end
end

-- Lingua
langBtn.MouseButton1Click:Connect(function()
	if currentLanguage == "IT" then
		currentLanguage = "EN"
		langBtn.Text = "🇬🇧 EN"
		rewardInfo.Text = "✅ Correct answer: +100 🪙   ❌ Wrong answer: -25 🪙"
	else
		currentLanguage = "IT"
		langBtn.Text = "🇮🇹 IT"
		rewardInfo.Text = "✅ Risposta giusta: +100 🪙   ❌ Risposta sbagliata: -25 🪙"
	end
	if panel.Visible then
		updateLanguageTexts() -- aggiorna solo i testi, non la domanda!
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	panel.Visible = false
end)

-- Cooldown timer
task.spawn(function()
	while true do
		task.wait(1)
		local elapsed = tick() - lastQuizTime
		local remaining = QUIZ_COOLDOWN - elapsed

		if remaining > 0 then
			local mins = math.floor(remaining / 60)
			local secs = math.floor(remaining % 60)
			cooldownLabel.Text = string.format("%d:%02d", mins, secs)
			quizButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			quizButton.Active = false
		else
			cooldownLabel.Text = "READY!"
			quizButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
			quizButton.Active = true
		end
	end
end)

-- Apri quiz
quizButton.MouseButton1Click:Connect(function()
	local elapsed = tick() - lastQuizTime
	if elapsed < QUIZ_COOLDOWN then return end

	panel.Visible = not panel.Visible
	if panel.Visible then
		loadQuestion()
	end
end)