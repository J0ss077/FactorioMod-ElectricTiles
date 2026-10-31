local surface_utils = require("scripts.lib.surface-utils")

local dbug = require("__factory077-lib__.modules.debug")

return function(_data_)
    --
    dbug.print("recalculating all surfaces ...", true)

    for i0, surface in pairs(game.surfaces) do
        --
        surface_utils.recalculate_surface(surface)
        --
    end
end
