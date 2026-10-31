local mod_data = require("__factory077-lib__.modules.mod_data")

local tables = require("__factory077-lib__.modules.tables")

local common_utils = require("scripts.lib.common-utils")

local temp_storage = require("scripts.var.temp-storage")

local definitions = require("scripts.var.definitions")

local module = {}

function module.load_startup_settings()
    ----
    temp_storage.debug_mode = settings.startup["F077ET-debug-mode"].value
end

function module.load_runtime_settings()
    -----
    local setting_001 = settings.global["F077ET-chunk-subdivision"].value

    temp_storage.chunk_area_size = definitions.chunk_area_sizes[setting_001]
    ----
    temp_storage.chunk_subdivision = setting_001 -- must always update this one
end

function module.load_temp_data()
    -----
    local carrier = mod_data.read("F077ET-data-carrier")
    -----
    local proxies_names = {}

    for range = 0.5, 16.0, 0.5 do
        --
        table.insert(proxies_names, common_utils.proxyName_from_supplyDistance(range))
    end

    temp_storage.dict_allowed_tiles = tables.to_set(carrier["list-allowed-tiles"])
    ----
    temp_storage.list_allowed_tiles = carrier["list-allowed-tiles"]
    ----
    temp_storage.proxies_names = proxies_names
end

return module
