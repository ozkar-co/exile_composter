local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Public namespace for this mod.
exile_composter = rawget(_G, "exile_composter") or {}

dofile(modpath .. "/common/composter.lua")
dofile(modpath .. "/items/composter.lua")
dofile(modpath .. "/nodes/composter.lua")
dofile(modpath .. "/crafts/composter.lua")
