local item = table.deepcopy(data.raw["item"]["radar"])

item.name = "remnant-beacon"
item.place_result = "remnant-beacon"
item.order = "g"
item.icon = "__rocket-reusability__/graphics/icons/remnant-beacon.png"
item.icon_size = 64
item.weight = 1000

data:extend{item}

local entity = table.deepcopy(data.raw["radar"]["radar"])

entity.name = "remnant-beacon"
entity.icon = "__rocket-reusability__/graphics/icons/remnant-beacon.png"

entity.minable = {mining_time = 1.0, result = "remnant-beacon"}

entity.fast_replaceable_group = nil

entity.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
entity.selection_box = {{-2.0, -2.0}, {2.0, 2.0}}

entity.energy_usage = "500kW"
entity.energy_per_sector = "100GW"
entity.max_distance_of_nearby_sector_revealed = 1
entity.max_distance_of_sector_revealed = 1
entity.energy_per_nearby_scan = "250kW"

entity.integration_patch = nil

entity.pictures = {
    layers = {
        {
            filename = "__rocket-reusability__/graphics/entity/remnant-beacon/remnant-beacon.png",
            priority = "low",
            width = 294,
            height = 407,
            apply_projection = false,
            direction_count = 1,
            shift = util.by_pixel(0.0, -30.0),
            scale = 0.45
        },
        {
            filename = "__rocket-reusability__/graphics/entity/remnant-beacon/remnant-beacon-shadow.png",
            priority = "low",
            width = 424,
            height = 246,
            apply_projection = false,
            direction_count = 1,
            shift = util.by_pixel(24.0, 3.0),
            draw_as_shadow = true,
            scale = 0.5
        }
    }
}

entity.water_reflection = nil

entity.circuit_connector = nil

entity.surface_conditions = {
  {
    property = "gravity",
    min = 0,
    max = 0
  }
},

data:extend{entity}

local recipe = {
    type = "recipe",
    name = "remnant-beacon",
    enabled = true,
    energy_required = 20,
    ingredients = {{"processing-unit", 50}, {"low-density-structure", 25}, {"steel", 100},},
    result = "remnant-beacon",
    requester_paste_multiplier = 5
}