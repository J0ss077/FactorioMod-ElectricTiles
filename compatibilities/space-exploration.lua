if not settings.startup["F077ET-comp-space-exploration"].value or not mods["space-exploration"] then return end

local tables = require("__factory077-lib__.modules.tables")

local spa_vars = require("__space-exploration__.data_util")

require("__factory077-lib__.modules.mod_data").edit("F077ET-data-carrier", function (payload)

    tables.combine_arrays(payload["list-allowed-tiles"], { spa_vars.mod_prefix .. "space-platform-scaffold", spa_vars.mod_prefix .. "space-platform-plating" })
    --
    --
end)
