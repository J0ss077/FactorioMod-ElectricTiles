local definitions = {}

definitions.data_interface_version = "1.0.5"
definitions.control_interface_version = "1.0.5"

definitions.item_prefix = "F077ET-"
definitions.tile_prefix = "F077ET-"

definitions.chunk_subdivisions = {
    { code = "x32", area_size = 32 },
    { code = "x16", area_size = 16 },
    { code = "x8",  area_size = 08 },
}

definitions.chunk_area_sizes = {}

for i0, subdivision in ipairs(definitions.chunk_subdivisions) do
    --
    definitions.chunk_area_sizes[subdivision.code] = subdivision.area_size
end

--- @return string
---
function definitions.default_chunk_subdivision()
    --
    return definitions.chunk_subdivisions[1].code
end

--- @return string[]
---
function definitions.chunk_subdivision_choices()

    local choices = {}

    for i0, subdivision in ipairs(definitions.chunk_subdivisions) do
        --
        choices[i0] = subdivision.code
        --
    end

    return choices
end

return definitions
