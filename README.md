# exile_composter

A standalone composter module for Exile focused on recycling organic waste into fertilizer byproducts and, when kept full, a steady source of invertebrates.

## Dependencies

- `tech`
- `animals`
- `nodes_nature`

## Gameplay Goal

The composter is designed to:

- Accept organic garbage, generic plants, rotten food, and excess fertilizer as input.
- Fill slowly (0–100%) as items are consumed.
- Produce humus and vermicompost slowly; each unit drains **1%** of the fill level.
- Produce worms (`animals:carcass_invert_small`) only while **above 50% full**, with **no fill drain** — a mid/late-game reward for keeping the bin fed.
- Act as a secondary fertilizer source; wood ash from fires remains the main fertilizer most players rely on.

## What Is Compostable

An item is accepted if it is at least one of:

- A plant item (for example `flora`, `fibrous_plant`, `woody_plant`, `cane_plant`, `mushroom` groups).
- An animal item (item name in the `animals:` namespace).
- An edible item (group `edible`).
- A food registered by Exile's public `health` system (`food_table`).
- Any item tagged with group `compost`.
- Any item tagged with group `fertilizer` (humus, vermicompost, bonemeal, mulch, wood ash, etc.) — useful for recycling excess fertilizer to maintain worm production.

Note for related mods: the `compost` group is an optional integration hook. If your mod adds custom organic items, set `groups = { compost = 1 }` to make them compostable.

This also covers public Exile foods such as `nodes_nature:maraka_nut` and `nodes_nature:tangkal_fruit`, which are edible through `health` even if they do not expose the `edible` group directly.

## How To Use

1. Craft `exile_composter:composter_bin` from the `chopping_block` recipe.
2. Put compostable items into the input inventory.
3. Wait for timer cycles (default: **120 seconds**).
4. Each cycle consumes **one** input item and adds **+1** to the fill level (capped at 100).
5. If conditions are met, **at most one** output is generated per cycle into the output inventory.

## Internal Logic

### Inventories

- `main`: input.
- `output`: generated products.

Manual insertion into `output` is blocked.

### Fill Level

- Ranges from 0 to 100 (shown as percent in the UI).
- Each consumed input item adds **+1**.
- Humus and vermicompost production subtract **-1** per unit produced.
- Worm production subtracts **nothing**.

### Output Table

| Output | Chance / cycle | Min fill | Drain |
|--------|----------------|----------|-------|
| `exile_composter:humus` | 10% | 1 | 1 |
| `exile_composter:vermicompost` | 5% | 1 | 1 |
| `animals:carcass_invert_small` | 4% | 51 | 0 |

At most **one** output is chosen per cycle (random among all outputs that passed their chance roll).

Bonemeal is intentionally not produced by the composter.

### Bonemeal and Mulch Recipes

- `mortar_and_pestle`: `bones:bones` -> `exile_composter:bonemeal 3`
- `mortar_and_pestle`: `nodes_nature:sasaran_cone` -> `exile_composter:mulch`

All four composter fertilizer items use `group:fertilizer`:

- `exile_composter:humus`
- `exile_composter:vermicompost`
- `exile_composter:bonemeal`
- `exile_composter:mulch`

## Textures

This mod ships its own fertilizer textures:

- `exile_composter_humus.png`
- `exile_composter_vermicompost.png`
- `exile_composter_bonemeal.png`
- `exile_composter_mulch.png`
- `exile_composter_bin.png`
- `exile_composter_bin_top.png`
- `exile_composter_arrow.png`

## Public API

This mod exposes its internal state through the `exile_composter` namespace:

- `exile_composter.seconds_to_compost` — timer interval (120 s).
- `exile_composter.max_level` — fill cap (100).
- `exile_composter.worm_min_level` — minimum fill for worms (51).
- `exile_composter.outputs` — output definition table.
- `exile_composter.is_compostable_name(item_name)`
- `exile_composter.get_composter_formspec(compost)`
- `exile_composter.absorb_inputs(inv, level)` — consume one input item per call.
- `exile_composter.try_outputs(inv, level)` — attempt up to one output per call.

Legacy aliases (same functions/tables):

- `exile_composter.generate_items` → `outputs`
- `exile_composter.process_compostable_items` → `absorb_inputs`
- `exile_composter.generate_compost` → `try_outputs`
