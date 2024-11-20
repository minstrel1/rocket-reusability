local item = table.deepcopy(data.raw["item"]["radar"])

item.name = "remnant-beacon"
item.place_result = "remnant-beacon"
item.order = "g"
item.icon = "__rocket-reusability__/graphics/icons/remnant-beacon.png"
item.icon_size = 64

data:extend{item}

local entity = table.deepcopy(data.raw["radar"]["radar"])

entity.name = "remnant-beacon"
entity.icon = "__rocket-reusability__/graphics/icons/remnant-beacon.png"

entity.minable = {mining_time = 1.0, result = "remnant-beacon"}

entity.fast_replaceable_group = nil

entity.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
entity.selection_box = {{-2.0, -2.0}, {2.0, 2.0}}

entity.energy_usage = "500kW"
entity.energy_per_sector = "100gW"
entity.max_distance_of_nearby_sector_revealed = 1
entity.max_distance_of_sector_revealed = 1
entity.energy_per_nearby_scan = "250kW"

entity.integration_patch = nil

entity.pictures = {
    layers = {
        {
            filename = "__base__/graphics/entity/radar/radar.png",
            priority = "low",
            width = 196,
            height = 254,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(1.0, -16.0),
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/radar/radar-shadow.png",
            priority = "low",
            width = 336,
            height = 170,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = util.by_pixel(39.0, 6.0),
            draw_as_shadow = true,
            scale = 0.5
        }
    }
}