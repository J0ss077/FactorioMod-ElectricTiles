local surface_utils = require("scripts.lib.surface-utils")

local dbug = require("__factory077-lib__.modules.debug")

return function(event_data)
    --
    if not event_data.surface_index then return end
    --
    local surface = game.surfaces[event_data.surface_index]

    -------------------------------------------------------
    -------------------------------------------------------

    dbug.print("recalculating surface '" .. surface.name .. "' ...", true)

    surface_utils.recalculate_surface(surface)
    --
    --
end
