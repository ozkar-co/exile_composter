local composter = exile_composter

composter.max_level = 100
composter.worm_min_level = 51
composter.seconds_to_compost = 120

composter.outputs = {
    { name = "exile_composter:humus", chance = 10, min_level = 1, drain = 1 },
    { name = "exile_composter:vermicompost", chance = 5, min_level = 1, drain = 1 },
    { name = "animals:carcass_invert_small", chance = 4, min_level = 51, drain = 0 },
}

local function is_compostable_name(item_name)
    local def = minetest.registered_items[item_name]
    if not def then
        return false
    end

    local groups = def.groups or {}
    local foods = rawget(_G, "food_table")
    local is_plant = (groups.flora or 0) > 0
        or (groups.fibrous_plant or 0) > 0
        or (groups.woody_plant or 0) > 0
        or (groups.cane_plant or 0) > 0
        or (groups.mushroom or 0) > 0
    local is_animal = item_name:sub(1, 8) == "animals:"
    local is_edible = (groups.edible or 0) > 0
    local has_compost_group = (groups.compost or 0) > 0
    local is_fertilizer = (groups.fertilizer or 0) > 0
    local is_registered_food = type(foods) == "table" and foods[item_name] ~= nil

    return is_plant or is_animal or is_edible or has_compost_group
        or is_registered_food or is_fertilizer
end

composter.is_compostable_name = is_compostable_name

function composter.get_composter_formspec(compost)
    return "size[8,4.8]"
        .. "label[0,0;Composter: "
        .. compost
        .. "%]"
        .. "list[current_name;main;0,0.5;4,2]"
        .. "list[current_name;output;6,0.5;2,2]"
        .. "list[current_player;main;0,3;8,4;]"
        .. "listring[current_name;main]"
        .. "listring[current_name;output]"
        .. "listring[current_player;main]"
        .. "image[4.5,1;1,1;exile_composter_arrow.png;]"
end

function composter.absorb_inputs(inv, level)
    local slots = {}

    for index, item in ipairs(inv:get_list("main")) do
        if item and item:get_count() > 0 and is_compostable_name(item:get_name()) then
            slots[#slots + 1] = index
        end
    end

    for index = #slots, 2, -1 do
        local other = math.random(index)
        slots[index], slots[other] = slots[other], slots[index]
    end

    for _, slot_index in ipairs(slots) do
        if level >= composter.max_level then
            break
        end

        local stack = inv:get_stack("main", slot_index)
        if not stack:is_empty() and is_compostable_name(stack:get_name()) then
            stack:take_item(1)
            inv:set_stack("main", slot_index, stack)
            level = level + 1
            break
        end
    end

    return level
end

function composter.try_outputs(inv, level)
    if level <= 0 then
        return level
    end

    local candidates = {}

    for _, output in ipairs(composter.outputs) do
        if level >= output.min_level
            and math.random(1, 100) <= output.chance
            and inv:room_for_item("output", output.name)
        then
            candidates[#candidates + 1] = output
        end
    end

    if #candidates == 0 then
        return level
    end

    local picked = candidates[math.random(#candidates)]
    inv:add_item("output", picked.name)
    return level - picked.drain
end

-- Public API aliases
composter.generate_items = composter.outputs
composter.process_compostable_items = composter.absorb_inputs
composter.generate_compost = composter.try_outputs
