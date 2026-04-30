crafting.register_recipe({
	type = "chopping_block",
	output = "tech:composter_bin",
	items = {"group:fibrous_plant 8", "tech:stick 24", "nodes_nature:loam 4"},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "grinding_stone",
	output = "tech:bonemeal",
	items = {"bones:bones"},
	level = 1,
	always_known = true,
})
