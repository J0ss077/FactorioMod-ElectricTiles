--// dependencies

local common_utils = require("scripts.lib.common-utils")

local game_storage = require("scripts.var.game-storage")

local temp_storage = require("scripts.var.temp-storage")

local module = {}

--// constants

local CACHE_KEYS = {
    --
    base = "base-caching-chunks",
    --
    long = "long-caching-chunks",
}

local OTHER_MODES = {
    --
    base = "long",
    --
    long = "base",
}

--// internals

--- @param mode "base" | "long"
---
--- @return table
---
local function cache_of(mode)

    local cache = game_storage.get(CACHE_KEYS[mode])

    if not cache then
        --
        error("(custom error) unknown cache mode '" .. tostring(mode) .. "'")
        --
    end

    return cache
end

--- @param mode "base" | "long"
---
--- @param subdivision string
---
--- @param address string
---
--- @return boolean
---
local function is_cached(mode, subdivision, address)
    --
    local subdivision_cache = cache_of(mode)[subdivision]
    --
    return subdivision_cache ~= nil and subdivision_cache[address] ~= nil
end

--- @param mode "base" | "long"
---
--- @param subdivision string
---
--- @param address string
---
local function insert(mode, subdivision, address)
    --
    if is_cached(OTHER_MODES[mode], subdivision, address) then return end
    --
    cache_of(mode)[subdivision][address] = true
end

--- @param mode "base" | "long"
---
--- @param subdivision string
---
--- @param address string
---
local function remove(mode, subdivision, address)
    --
    cache_of(mode)[subdivision][address] = nil
end

--// module functions

--- Tracks a chunk in one cache for the given subdivision; no-op when the other cache already tracks it.
---
--- @param mode "base" | "long"
---
--- @param surface_name string
---
--- @param chunk_position ChunkPosition
---
--- @param chunk_subdivision? string
---
function module.cache_chunk(mode, surface_name, chunk_position, chunk_subdivision)

    chunk_subdivision = chunk_subdivision or temp_storage.chunk_subdivision

    local address = common_utils.chunkCacheAddress_from_chunkData(surface_name, chunk_position.x, chunk_position.y)

    insert(mode, chunk_subdivision, address)
end

--- Stops tracking a chunk in one cache; the address alone identifies it.
---
--- @param mode "base" | "long"
---
--- @param address string
---
--- @param chunk_subdivision? string
---
function module.clear_chunk(mode, address, chunk_subdivision)
    --
    remove(mode, chunk_subdivision or temp_storage.chunk_subdivision, address)
end

return module
