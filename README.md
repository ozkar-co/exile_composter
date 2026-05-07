# exile_composter

A standalone composter module for Exile focused on recycling biological leftovers into fertilizer materials.

## Dependencies

- `tech`
- `animals`
- `nodes_nature`

## Gameplay Goal

The composter is designed to:

- Slowly produce worms (very rare).
- Produce fertilizer materials at a higher rate.
- Keep most outputs useful for restoring crop soils.

## What Is Compostable

An item is accepted if it is at least one of:

- A plant item (for example `flora`, `fibrous_plant`, `woody_plant`, `cane_plant`, `mushroom` groups).
- An animal item (item name in the `animals:` namespace).
- An edible item (group `edible`).
- Any item tagged with group `compost`.

Note for related mods: the `compost` group is an optional integration hook. If your mod adds custom organic items, set `groups = { compost = 1 }` to make them compostable.

## How To Use

1. Craft `exile_composter:composter_bin` from the `chopping_block` recipe.
2. Put compostable items into the input inventory.
3. Wait for timer cycles (default: 60 seconds).
4. The machine consumes items and increases compost level.
5. Generated outputs appear in the output inventory.

## Internal Logic

### Inventories

- `main`: input.
- `output`: generated products.

Manual insertion into `output` is blocked.

### Compost Accumulation

- Compost increases by quantity.
- Each consumed item adds `+1` compost.
- Compost is capped at 100.

### Generation Table

- `exile_composter:humus`: chance 25, cost 3
- `exile_composter:vermicompost`: chance 8, cost 2
- `animals:carcass_invert_small`: chance 1, cost 8

Bonemeal is intentionally not produced by the composter.

### Bonemeal Recipe

- `mortar_and_pestle`: `bones:bones` -> `exile_composter:bonemeal 3`

All three new items are fertilizers (`group:fertilizer`):

- `exile_composter:humus`
- `exile_composter:vermicompost`
- `exile_composter:bonemeal`

## Textures

This mod ships its own fertilizer textures:

- `exile_composter_humus.png`
- `exile_composter_vermicompost.png`
- `exile_composter_bonemeal.png`

## Public API

This mod exposes its internal state through the `exile_composter` namespace:

- `exile_composter.seconds_to_compost`
- `exile_composter.generate_items`
- `exile_composter.is_compostable_name(item_name)`
- `exile_composter.get_composter_formspec(compost)`
- `exile_composter.generate_compost(inv, compost)`
- `exile_composter.process_compostable_items(inv, compost)`
