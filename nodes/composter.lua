local composter = exile_composter
local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("exile_composter:composter_bin", {
    description = S("Composter Bin"),
    tiles = {"exile_composter_bin_top.png",
    "exile_composter_bin.png",
    "exile_composter_bin.png",
    "exile_composter_bin.png",
    "exile_composter_bin.png"},
    drawtype = "nodebox",
    stack_max = 1,
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {dig_immediate = 3},
    sounds = nodes_nature.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            -- Base
            {-0.35, -0.5, -0.35, 0.35, 0.3, 0.35},
            -- Placa inferior
            {-0.4, -0.5, -0.4, 0.4, -0.4, 0.4},
            -- Placa intermedia 1
            {-0.4, -0.3, -0.4, 0.4, -0.2, 0.4},
            -- Placa intermedia 2
            {-0.4, -0.1, -0.4, 0.4, 0, 0.4},
            -- Placa intermedia 3
            {-0.4, 0.1, -0.4, 0.4, 0.2, 0.4},
            -- Placa superior (hueca)
            {-0.4, 0.3, -0.4, -0.312, 0.4, 0.4},
            {0.312, 0.3, -0.4, 0.4, 0.4, 0.4},
            {-0.312, 0.3, -0.4, 0.312, 0.4, -0.312},
            {-0.312, 0.3, 0.312, 0.312, 0.4, 0.4},
        },

    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.35, -0.5, -0.35, 0.35, 0.4, 0.35},
        },
    },

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_int("compost", 0)
        meta:set_string("infotext", "Composter (0% full)")
        meta:set_string("formspec", composter.get_composter_formspec(0))
        local inv = meta:get_inventory()
        inv:set_size('main', 8)
        inv:set_size('output', 4)
        local timer = minetest.get_node_timer(pos)
        timer:start(composter.seconds_to_compost)
    end,

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        local player_name = player:get_player_name()
        local compost = meta:get_int("compost")
        meta:set_string("infotext", "Composter ("..compost.."% full)")

        minetest.show_formspec(player_name, "exile_composter:composter_bin", composter.get_composter_formspec(compost))
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if to_list == "output" then
            return 0
        end
        local inv = minetest.get_meta(pos):get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        local item_name = stack:get_name()
        if composter.is_compostable_name(item_name) then
            return count
        else
            return 0
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "main" then
            if composter.is_compostable_name(stack:get_name()) then
                return stack:get_count()
            else
                return 0
            end
        elseif listname == "output" then
            return 0
        end
    end,

    on_timer = function(pos, elapsed)
        local timer = minetest.get_node_timer(pos)
        timer:start(composter.seconds_to_compost)

        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local compost = meta:get_int("compost")

        compost = composter.generate_compost(inv, compost)
        compost = composter.process_compostable_items(inv, compost)

        meta:set_int("compost", compost)
        meta:set_string("infotext", "Composter ("..compost.."% full)")
        meta:set_string("formspec", composter.get_composter_formspec(compost))
    end,

    on_destruct = function(pos)
        -- drops its contents when broken
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv then
            for _, item in ipairs(inv:get_list("main")) do
                if not item:is_empty() then
                    minetest.add_item(pos, item)
                end
            end
            for _, item in ipairs(inv:get_list("output")) do
                if not item:is_empty() then
                    minetest.add_item(pos, item)
                end
            end
        end
    end,
})