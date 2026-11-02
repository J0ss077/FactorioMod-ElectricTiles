if not settings.startup["F077ET-comp-dectorio-fixes"].value or
   ---
   not mods["dectorio-fixes"] or not DECT.ENABLED["painted-concrete"]
   ---
then return end

local definitions = require("scripts.var.definitions")

--// options shared by every variant this file generates

local others = { use_default_recipe = true, technologies = { "dect-concrete-paint" } }

local terrain_subgroup = data.raw["item-subgroup"][definitions.item_prefix .. "terrain"]

--// subgroups

--- Builds one Dectorio subgroup next to the terrain one.
---
--- @param suffix string
---
--- @param order_suffix string
---
--- @return table
---
local function make_subgroup(suffix, order_suffix)
    --
    return {
        --
        type = "item-subgroup",
        --
        name = terrain_subgroup.name .. suffix,
        --
        group = DECT.ITEM_GROUP,
        --
        order = terrain_subgroup.order .. order_suffix,
    }
end

local colord_subgroup = make_subgroup("-dect-colored", "-aa03[dect-colored]")

local hazard_subgroup = make_subgroup("-dect-hazards", "-aa01[dect-hazards]")

local rf_haz_subgroup = make_subgroup("-dect-refined-hazards", "-aa02[dect-refined-hazards]")

data:extend({ hazard_subgroup, rf_haz_subgroup, colord_subgroup })

--// hazard tiles

local hazard_families = {
    --
    { subgroup = hazard_subgroup.name, paint_prefix = "dect-paint-" },
    --
    { subgroup = rf_haz_subgroup.name, paint_prefix = "dect-paint-refined-" },
}

--- Registers one left/right hazard pair for a paint variant.
---
--- @param family table
---
--- @param variant table
---
local function add_hazard_variant(family, variant)

    local left = table.deepcopy(data.raw.tile[family.paint_prefix .. variant.name .. "-left"])
    local righ = table.deepcopy(data.raw.tile[family.paint_prefix .. variant.name .. "-right"])

    left.next_direction = definitions.tile_prefix .. righ.name
    righ.next_direction = definitions.tile_prefix .. left.name

    local item = table.deepcopy(data.raw.item[family.paint_prefix .. variant.name])
    item.subgroup = family.subgroup

    righ.placeable_by = { item = definitions.item_prefix .. item.name, count = 1 }
    righ.minable.result = righ.placeable_by.item

    ElectricTilesDataInterface.modTilePrototypes({ { tile = left, item = item, others = others }, { tile = righ } })
    --
    --
end

for i0, variant in pairs(DECT.CONFIG.PAINT_VARIANTS) do
    --
    for i1, family in ipairs(hazard_families) do
        --
        add_hazard_variant(family, variant)
    end
end

--// colored refined concretes

--- Registers the electric variant of one Dectorio color. The tile is only read;
--- the item is copied so its subgroup can move to the colored group.
---
--- @param color table
---
local function add_colored_variant(color)

    local tile = data.raw.tile[color.name .. "-refined-concrete"]

    local item = table.deepcopy(data.raw.item["dect-" .. color.name .. "-refined-concrete"])

    item.subgroup = colord_subgroup.name

    ElectricTilesDataInterface.modTilePrototypes({ { tile = tile, item = item, others = others } })
    --
    --
end

for i0, color in pairs(DECT.CONFIG.BASE_COLORS) do
    --
    add_colored_variant(color)
end
