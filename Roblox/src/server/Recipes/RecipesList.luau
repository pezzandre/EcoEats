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
	}
}

return Recipes