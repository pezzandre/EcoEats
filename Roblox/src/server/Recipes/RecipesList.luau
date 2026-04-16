local Recipes = {}

Recipes.List = {
	{
		Name = "Cake", -- Questa è sulla Pan, quindi non confligge
		Station = "Pan",
		Ingredients = {"Apple", "Banana"}
	},
	{
		Name = "Recipe1", -- Cambia il nome!
		Station = "KitchenBoard",
		Ingredients = {"Egg", "Rice"}
	},
	{
		Name = "FastFood", -- Cambia il nome!
		Station = "KitchenBoard",
		Ingredients = {"Bread", "Water"}
	},
	{
		Name = "Omelette", -- Cambia il nome!
		Station = "KitchenBoard",
		Ingredients = {"Egg", "Eggplant"}
	},
	{
		Name = "FrenchFries", -- Cambia il nome!
		Station = "KitchenBoard",
		Ingredients = {"Potato"}
	},
	{
		Name = "FrenchFriesCooked", -- Cambia il nome!
		Station = "Fryer",
		Ingredients = {"OliveOil", "Potato"}
	}
}

return Recipes