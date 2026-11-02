if not settings.startup["F077ET-comp-space-platform-for-ground"].value or not mods["space-platform-for-ground"] then return end

local definitions = require("scripts.var.definitions")

local stile_name = "space-platform-for-ground"

ElectricTilesDataInterface.modTilePrototypes({
    {
        tile = data.raw.tile[stile_name],
        --
        item = data.raw.item[stile_name],
        --
        recipe = { enabled = true, ingredients = { { type = "item", name = stile_name, amount = 1 } } }
    }
})

local recycling_recipe = data.raw.recipe[definitions.item_prefix .. stile_name .. "-recycling"]

if recycling_recipe then
    --
    recycling_recipe.results = { { type = "item", name = stile_name, amount = 1 } }
    --
end
