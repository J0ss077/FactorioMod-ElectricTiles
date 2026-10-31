local caching_controller = require("scripts.controller.cache-controller")

local geometry = require("__factory077-lib__.modules.geometry")

local temp_storage = require("scripts.var.temp-storage")

script.on_event(defines.events.script_raised_set_tiles, function(event_data)
    ---
    for i0, old_data in ipairs(event_data.tiles) do
        --
        caching_controller.cache_chunk("base", game.surfaces[event_data.surface_index].name, geometry.chunk_position(old_data.position, temp_storage.chunk_area_size))
        --
    end
    ---
end)
