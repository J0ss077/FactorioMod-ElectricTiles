local update_daemon = require("scripts.unique.update-daemon")

local data_loader = require("scripts.unique.data-loader")

script.on_event(defines.events.on_runtime_mod_setting_changed, function (event_data)

    data_loader.load_runtime_settings()

    if  event_data.setting == "F077ET-base-update-delay" or
        event_data.setting == "F077ET-long-update-delay"

    then update_daemon.apply_settings() end

    if event_data.setting == "F077ET-chunk-subdivision" then remote.call("ElectricTilesControlInterface", "recalculateAllSurfaces") end

end)
