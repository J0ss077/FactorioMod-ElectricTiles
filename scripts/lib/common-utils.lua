local module = {}

--- @param item table
---
--- @param clean? boolean
---
function module.parse_item_icons(item, clean)
    --
    clean = clean or false

    local new_icons = {}

    if item.icons then
        --
        new_icons = table.deepcopy(item.icons)
        --
    elseif item.icon then
        --
        table.insert(new_icons, {

            scale = 0.5,

            icon = item.icon,

            draw_background = true,

            icon_size = item.icon_size or 64
        })
        --
        --
    end

    item.icons = new_icons

    if clean then
        --
        item.icon = nil
        --
        item.icon_size = nil
    end
end

--- @param supply_distance number
---
--- @return string
---
function module.proxyName_from_supplyDistance(supply_distance)
    --
    return "F077ET-proxy-" .. string.format("%03d", math.floor(supply_distance * 2))
end

--- @param surface_name string
---
--- @param chunk_x integer
---
--- @param chunk_y integer
---
--- @return string
---
function module.chunkCacheAddress_from_chunkData(surface_name, chunk_x, chunk_y)
    --
    return string.format("%s/%d/%d", surface_name, chunk_x, chunk_y)
end

--- @param address string
---
--- @return string, integer, integer
---
function module.chunkData_from_chunkCacheAddress(address)
    --
    local surface_name, chunk_x, chunk_y = string.match(address, "^([^/]+)/(%-?%d+)/(%-?%d+)$")
    --
    return surface_name, tonumber(chunk_x, 10), tonumber(chunk_y, 10)
end

--- @param position MapPosition
---
--- @param area BoundingBox
---
--- @param poles (LuaEntity)[]
---
--- @return (LuaEntity)[]
---
function module.find_poles_on_contact_with_area(position, area, poles)
    --
    local valid_poles = {}

    for i0, pole in ipairs(poles) do
        --
        local supply_distance = pole.prototype.get_supply_area_distance()

        if
            (pole.position.x + supply_distance >= position.x + area[1][1]) and
            (pole.position.x - supply_distance <= position.x + area[2][1]) and
            (pole.position.y + supply_distance >= position.y + area[1][2]) and
            (pole.position.y - supply_distance <= position.y + area[2][2])
        then
            --
            table.insert(valid_poles, pole)
            --
        end
    end

    return valid_poles
    --
    --
end

--- @param pole01 LuaEntity
---
--- @param pole02 LuaEntity
---
--- @param force? boolean
---
--- @param wire_type? any
---
function module.connect_poles(pole01, pole02, force, wire_type)
    --
    wire_type = wire_type or defines.wire_connector_id.pole_copper
    --
    force = force or false

    local origin_connector = pole01.get_wire_connector(wire_type, force)

    local target_connector = pole02.get_wire_connector(wire_type, force)

    if origin_connector and target_connector and not origin_connector.is_connected_to(target_connector) then
        --
        origin_connector.connect_to(target_connector, not force)
        --
    end
end

return module
