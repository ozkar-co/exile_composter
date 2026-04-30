minetest.register_node("tech:composter_bin", {
    description = S("Composter Bin"),
    tiles = {"tech_composter_bin_top.png",
    "tech_composter_bin.png",
    "tech_composter_bin.png",
    "tech_composter_bin.png",
    "tech_composter_bin.png"},
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
         meta:set_string("formspec", get_composter_formspec(0))
        local inv = meta:get_inventory()
        inv:set_size('main', 4)
        inv:set_size('output', 8)
        local timer = minetest.get_node_timer(pos)
        timer:start(seconds_to_compost)
    end,

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        local player_name = player:get_player_name()
        local compost = meta:get_int("compost")
        meta:set_string("infotext", "Composter ("..compost.."% full)")

        minetest.show_formspec(player_name, "tech:composter_bin", get_composter_formspec(compost))
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if to_list == "output" then
            return 0
        end
        local inv = minetest.get_meta(pos):get_inventory()
        -- Check if the item being moved has the 'compostable' group
        local stack = inv:get_stack(from_list, from_index)
        local item_name = stack:get_name()
        local item_def = minetest.registered_items[item_name]
        if item_def and item_def.groups.compostable then
            -- Allow the item to be moved to the specified inventory list
            return count
        else
            -- Deny the item from being moved to the specified inventory list
            return 0
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "main" then
            local def = stack:get_definition()
            if def.groups and def.groups.compostable then
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
        timer:start(seconds_to_compost)

        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local compost = meta:get_int("compost")

        compost = generate_compost(inv, compost)
        compost = process_compostable_items(inv, compost)

        meta:set_int("compost", compost)
        meta:set_string("infotext", "Composter ("..compost.."% full)")
        meta:set_string("formspec", get_composter_formspec(compost))
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