crafting.register_recipe({
	type = "chopping_block",
	output = "exile_composter:composter_bin",
	items = {"group:fibrous_plant 8", "tech:stick 24", "nodes_nature:loam 4"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "exile_composter:bonemeal 3",
	items = {"bones:bones"},
	level = 1,
	always_known = true,
})
