local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local quizFolder = ReplicatedStorage:WaitForChild("QuizEvents")
local rewardEvent = quizFolder:WaitForChild("QuizReward")

local QUIZ_COOLDOWN = 240 -- 4 minuti
local lastQuizTime = -QUIZ_COOLDOWN
local currentLanguage = "IT"

local questions = {
	-- ... (Le tue 10 domande originali rimangono qui, ne aggiungo una come esempio e poi le nuove)
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
	-- NUOVE DOMANDE SDG 12.3
	{
		IT = {
			question = "Qual è l'obiettivo dell'SDG 12.3?",
			answers = {"Dimezzare lo spreco alimentare entro il 2030", "Raddoppiare la produzione mondiale", "Eliminare gli imballaggi", "Vietare il cibo importato"},
			correct = 1
		},
		EN = {
			question = "What is the goal of SDG 12.3?",
			answers = {"Cut food waste in half by 2030", "Double food production worldwide", "Eliminate all packaging waste", "Ban imported food"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quanto cibo viene sprecato globalmente ogni anno?",
			answers = {"Circa il 33%", "Circa il 10%", "Circa il 25%", "Circa il 50%"},
			correct = 1
		},
		EN = {
			question = "How much food is wasted globally each year?",
			answers = {"About 33%", "About 10%", "About 25%", "About 50%"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale di questi alimenti è il più sprecato al mondo?",
			answers = {"Frutta e verdura", "Riso", "Uova", "Formaggio"},
			correct = 1
		},
		EN = {
			question = "Which of these foods is wasted the most worldwide?",
			answers = {"Fruits and vegetables", "Rice", "Eggs", "Cheese"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Buttare il cibo spreca anche acqua ed energia.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Throwing away food also wastes water and energy.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa significa solitamente 'da consumarsi preferibilmente entro'?",
			answers = {"Qualità ottimale, non sicurezza", "Cibo pericoloso dopo la data", "Da buttare immediatamente", "Illegale da mangiare dopo"},
			correct = 1
		},
		EN = {
			question = "What does 'best by' usually mean?",
			answers = {"Best quality, not safety", "Unsafe after this date", "Food must be thrown away immediately", "Illegal to eat after"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale azione aiuta di più a ridurre lo spreco?",
			answers = {"Pianificare i pasti", "Comprare più spesa", "Buttare gli avanzi", "Ignorare le scadenze"},
			correct = 1
		},
		EN = {
			question = "Which action helps reduce food waste the most?",
			answers = {"Planning meals ahead", "Buying more groceries", "Throwing away leftovers", "Ignoring expiration dates"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Lo spreco alimentare nelle discariche crea gas serra nocivi.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Food waste in landfills creates harmful greenhouse gases.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale gas viene rilasciato dal cibo che marcisce in discarica?",
			answers = {"Metano", "Ossigeno", "Azoto", "Elio"},
			correct = 1
		},
		EN = {
			question = "What gas is commonly released when food rots in landfills?",
			answers = {"Methane", "Oxygen", "Nitrogen", "Helium"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è il modo migliore per ridurre lo spreco in casa?",
			answers = {"Conservare il cibo correttamente", "Comprare cibo extra", "Buttare l'umido ogni settimana", "Evitare gli avanzi"},
			correct = 1
		},
		EN = {
			question = "Which of these is the best way to reduce food waste at home?",
			answers = {"Store food properly", "Buy extra food", "Throw out old food weekly", "Avoid leftovers"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Frutta e verdura 'brutta' ha lo stesso sapore di quella perfetta.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Ugly fruits and vegetables taste the same as perfect-looking ones.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è un buon utilizzo per gli scarti alimentari?",
			answers = {"Compost", "Solo spazzatura", "Bruciarli", "Nasconderli"},
			correct = 1
		},
		EN = {
			question = "What is one good use for food scraps?",
			answers = {"Compost", "Trash only", "Burn them", "Hide them"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale paese si è impegnato a dimezzare lo spreco entro il 2030?",
			answers = {"Svizzera", "Brasile", "Egitto", "Islanda"},
			correct = 1
		},
		EN = {
			question = "Which country has also committed to cutting food waste in half by 2030?",
			answers = {"Switzerland", "Brazil", "Egypt", "Iceland"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: La maggior parte dello spreco avviene prima che il cibo arrivi nei negozi.",
			answers = {"Falso", "Vero", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Most food waste happens before food reaches stores.",
			answers = {"False", "True", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Come possono i ristoranti ridurre lo spreco?",
			answers = {"Offrire porzioni più piccole", "Servire porzioni giganti", "Buttare gli avanzi subito", "Usare più imballaggi"},
			correct = 1
		},
		EN = {
			question = "What is a simple way restaurants can reduce food waste?",
			answers = {"Offer smaller portion options", "Serve larger portions", "Throw away leftovers faster", "Use more packaging"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa crea il compostaggio degli scarti alimentari?",
			answers = {"Fertilizzante", "Plastica", "Fumo", "Olio"},
			correct = 1
		},
		EN = {
			question = "What does composting food scraps create?",
			answers = {"Fertilizer", "Plastic", "Smoke", "Oil"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Lo spreco alimentare costa denaro alle famiglie.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Food waste costs households money.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è un'abitudine di spesa intelligente?",
			answers = {"Controllare cosa hai già", "Fare la spesa senza lista", "Comprare sempre all'ingrosso", "Comprare snack a caso"},
			correct = 1
		},
		EN = {
			question = "Which of these is a smarter shopping habit?",
			answers = {"Checking what you already have first", "Shopping without a list", "Buying in bulk every time", "Buying random snacks"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Perché sprecare carne è particolarmente dannoso?",
			answers = {"Usa più terra, acqua ed energia", "Scade prima", "Ha un sapore peggiore", "È difficile da cucinare"},
			correct = 1
		},
		EN = {
			question = "Why is wasting meat especially harmful?",
			answers = {"It uses more land, water, and energy to produce", "It spoils faster", "It tastes worse later", "It is harder to cook"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Congelare il cibo può aiutare a ridurre lo spreco.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Freezing food can help reduce waste.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa significa SDG?",
			answers = {"Obiettivo di Sviluppo Sostenibile", "Obiettivo Dieta Sicura", "Spesa Giornaliera Standard", "Guida Dieta Sostenibile"},
			correct = 1
		},
		EN = {
			question = "What does SDG stand for?",
			answers = {"Sustainable Development Goal", "Safe Diet Goal", "Standard Daily Grocery", "Sustainable Diet Guide"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Lo spreco alimentare contribuisce al cambiamento climatico.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Food waste contributes to climate change.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale di questi cibi dura solitamente di più?",
			answers = {"Riso", "Latte", "Pane", "Frutti di bosco"},
			correct = 1
		},
		EN = {
			question = "Which of these foods usually lasts the longest?",
			answers = {"Rice", "Milk", "Bread", "Berries"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è l'idea principale dietro EcoEats?",
			answers = {"Usare il cibo saggiamente e ridurre gli sprechi", "Cucinare il cibo più costoso", "Sprecare il più possibile", "Comprare ingredienti illimitati"},
			correct = 1
		},
		EN = {
			question = "What is the main idea behind EcoEats?",
			answers = {"Use food wisely and reduce waste", "Cook the most expensive food", "Waste as much as possible", "Buy unlimited ingredients"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Gli avanzi possono essere riutilizzati in nuovi pasti.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Leftovers can be reused in new meals.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è un motivo per cui il cibo viene sprecato nei negozi?",
			answers = {"Sembra 'brutto' esteticamente", "È troppo perfetto", "È troppo economico", "Cresce troppo piano"},
			correct = 1
		},
		EN = {
			question = "What is one reason food gets wasted in stores?",
			answers = {"It looks 'ugly'", "It is too perfect", "It is too cheap", "It grows too slowly"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa consuma più acqua per essere prodotto?",
			answers = {"Carne bovina", "Pomodori", "Patate", "Pane"},
			correct = 1
		},
		EN = {
			question = "Which uses more water to produce?",
			answers = {"Beef", "Tomatoes", "Potatoes", "Bread"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Vero o Falso: Il compostaggio è meglio che mandare il cibo in discarica.",
			answers = {"Vero", "Falso", "-", "-"},
			correct = 1
		},
		EN = {
			question = "True or False: Composting is better than sending food waste to a landfill.",
			answers = {"True", "False", "-", "-"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Qual è il primo passo migliore prima di fare la spesa?",
			answers = {"Controllare cosa hai già", "Buttare via tutto", "Comprare prima il dolce", "Andare quando hai fame"},
			correct = 1
		},
		EN = {
			question = "What is the best first step before buying groceries?",
			answers = {"Check what food you already have", "Throw everything away", "Buy dessert first", "Go when hungry"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Quale di questi fa parte dell'SDG 12?",
			answers = {"Consumo responsabile", "Costruire più strade", "Più produzione di plastica", "Spedizioni più veloci"},
			correct = 1
		},
		EN = {
			question = "Which of these is part of SDG 12?",
			answers = {"Responsible consumption", "Building more roads", "More plastic production", "Faster shipping"},
			correct = 1
		}
	},
	{
		IT = {
			question = "Cosa succede quando il cibo viene sprecato?",
			answers = {"Si perdono cibo, acqua, soldi ed energia", "Si perde solo il cibo", "Non succede nulla di importante", "I negozi guadagnano di più"},
			correct = 1
		},
		EN = {
			question = "What happens when food is wasted?",
			answers = {"Food, water, money, and energy are wasted", "Only food is lost", "Nothing important happens", "Stores make more money"},
			correct = 1
		}
	},
}

-- Il resto del tuo script GUI rimane identico...
-- (ScreenGui, Panels, Buttons, loadQuestion logic, etc.)

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