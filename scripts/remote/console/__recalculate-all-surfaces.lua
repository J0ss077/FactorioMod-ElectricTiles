local dbug = require("__factory077-lib__.modules.debug")

local first_use = false

return function(_data_)
    --
    if not first_use then
        --
        dbug.print("WARNING!! refressing ALL SURFACES consumes a lot of computational power. continue at your own risk", true); first_use = true
        --
    else
        --
        remote.call("ElectricTilesControlInterface", "recalculateAllSurfaces")
        --
    end
end
