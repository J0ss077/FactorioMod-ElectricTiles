local indexs = {
    debug_mode         = true,
    proxies_names      = true,
    chunk_area_size    = true,
    chunk_subdivision  = true,
    list_allowed_tiles = true,
    dict_allowed_tiles = true,
}

local values = {}

local module = setmetatable({}, {

    __index = function (_, key)
        --
        if indexs[key] then return values[key]
        --
        else
            error("(custom error) key not found")
        end
    end,

    __newindex = function (_, key, value)
        --
        if indexs[key] then values[key] = value
        --
        else
            error("(custom error) setting new values is forbidden")
        end
    end,

    __pairs = function ()
        -----
        local function loop(_, K)
            -----
            local KK = next(indexs, K)
            --
            if KK then return KK, values[KK] end
            --
        end return loop, nil, nil
    end,
})

return module
