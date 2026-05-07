local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_craftitem("exile_composter:humus", {
    description = S("Humus"),
    inventory_image = "exile_composter_humus.png",
    stack_max = minimal.stack_max_large,
    groups = { fertilizer = 1 },
})

minetest.register_craftitem("exile_composter:vermicompost", {
    description = S("Vermicompost"),
    inventory_image = "exile_composter_vermicompost.png",
    stack_max = minimal.stack_max_large,
    groups = { fertilizer = 1 },
})

minetest.register_craftitem("exile_composter:bonemeal", {
    description = S("Bonemeal"),
    inventory_image = "exile_composter_bonemeal.png",
    stack_max = minimal.stack_max_large,
    groups = { fertilizer = 1 },
})
