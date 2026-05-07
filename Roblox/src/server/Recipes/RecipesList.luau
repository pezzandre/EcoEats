local Recipes = {}
Recipes.List = {
	-- KitchenBoard
	{
		Name = "CutApple",
		Station = "KitchenBoard",
		Ingredients = {"Apple", "Apple"}
	},
	{
		Name = "SlicedTomato",
		Station = "KitchenBoard",
		Ingredients = {"Tomato", "Tomato"}
	},
	{
		Name = "FrenchFries",
		Station = "KitchenBoard",
		Ingredients = {"Potato", "Potato"}
	},
	{
		Name = "Salad",
		Station = "KitchenBoard",
		Ingredients = {"Tomato", "Carrot", "OliveOil"}
	},
	{
		Name = "Burger",
		Station = "KitchenBoard",
		Ingredients = {"Bread", "Pork", "Cheese"}
	},
	{
		Name = "FishBurger", 
		Station = "KitchenBoard",
		Ingredients = {"Bread", "Fish", "Cheese"}
	},

	-- Pan
	{
		Name = "Omelette",
		Station = "Pan",
		Ingredients = {"Egg", "OliveOil"}
	},

	-- Fryer
	{
		Name = "FrenchFriesCooked",
		Station = "Fryer",
		Ingredients = {"FrenchFries", "OliveOil"}
	},
	{
		Name = "ChickenNuggets",
		Station = "Fryer",
		Ingredients = {"chicken_nugget", "OliveOil"}
	},

	-- Mixer
	{
		Name = "MilkShakeChocolate",
		Station = "Mixer",
		Ingredients = {"Chocolate", "Milk"}
	},
	{
		Name = "MilkShakeApple",
		Station = "Mixer",
		Ingredients = {"Apple", "Milk"}
	},
	{
		Name = "MilkShakeCherry",
		Station = "Mixer",
		Ingredients = {"Cherry", "Milk"}
	},
	{
		Name = "MilkShakeBanana",
		Station = "Mixer",
		Ingredients = {"Banana", "Milk"}
	},
	{
		Name = "CookieDough",
		Station = "Mixer",
		Ingredients = {"Flour", "Chocolate", "Sugar", "Egg", "Milk"}
	},
	{
		Name = "CakeDough",  -- impasto prima di cuocere
		Station = "Mixer",
		Ingredients = {"Flour", "Egg", "Milk", "Sugar", "HoneyJar"}
	},

	-- Microwave / Oven
	{
		Name = "Cookies",
		Station = "Microwave",
		Ingredients = {"CookieDough"}
	},
	{
		Name = "Cake",
		Station = "Microwave",
		Ingredients = {"CakeDough"}
	},

	-- Pot
	{
		Name = "SpaghettiPomodoro",
		Station = "Pot",
		Ingredients = {"Pasta", "Tomato", "Water", "OliveOil"}
	},

	-- Assemblaggi finali (KitchenBoard)
	{
		Name = "FastFood",
		Station = "KitchenBoard",
		Ingredients = {"Burger", "FrenchFriesCooked"}
	},
}
return Recipes