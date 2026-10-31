local tables = require("__factory077-lib__.modules.tables")

local defs = require("scripts.var.definitions")

local module = {}

function module.init()
    --
    module.check_storage_integrity() -- run integrity check on init
end

function module.load()
    --
    -- nothing for now ...
end

--- maintains the save integrity
---
function module.check_storage_integrity()

    local caching_template = {}

    for subdivision_code in pairs(defs.chunk_area_sizes) do caching_template[subdivision_code] = {} end

    module.set("base-caching-chunks", module.get("base-caching-chunks") or tables.combine_dictionaries(caching_template, {}, true))
    module.set("long-caching-chunks", module.get("long-caching-chunks") or tables.combine_dictionaries(caching_template, {}, true))
end

---------------------------------------------------------------
--------------------- CACHING METHOD --------------------------
---------------------------------------------------------------
---
--- cache = {
---     ["x8"] = {
---         ["{surface_name}/{chunk_x}/{chunk_y}"] = true,
---         ["{surface_name}/{chunk_x}/{chunk_y}"] = true,
---     },
---     ["x16"] = {
---         ["nauvis/1/1"] = true,
---         ["nauvis/2/2"] = true,
---     },
--- }
---
--- this method allows fast indexing of cached chunks based on chunk size:
---
---   x0 => chunk's X position: 0
---   y0 => chunk's Y position: 0
---
---------------------------------------------------------------
---------------------------------------------------------------

--- @param key string
---
--- @param value any
---
function module.set(key, value)
    --
    storage[key] = value
end

--- @param key string
---
--- @return any
---
function module.get(key)
    --
    return storage[key]
end

return module
