local caching_controller = require("scripts.controller.cache-controller")

local geometry = require("__factory077-lib__.modules.geometry")

local temp_storage = require("scripts.var.temp-storage")

script.on_event(defines.events.script_raised_destroy, function(event_data)
    -----
    -----
    local surface = event_data.entity.surface

    local position = event_data.entity.position

    local tile = surface.get_tile(position.x, position.y)

    if tile and temp_storage.dict_allowed_tiles[tile.name] then
        --
        caching_controller.cache_chunk("base", surface.name, geometry.chunk_position(position, temp_storage.chunk_area_size))
        --
    end
    ---
    ---
end, { { filter = "type", type = "deconstructible-tile-proxy" } })
