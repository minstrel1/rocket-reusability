debug_mode = settings.global["debug-mode"].value

script.on_init(verify_whitelist)

function verify_whitelist ()
    storage.platform_type_whitelist = storage.platform_type_whitelist or {player = {}}
    storage.platform_type_whitelist["player"]["space-platform-starter-pack"] = true
end

remote.add_interface("rocket-reusability",
{
    add_whitelist = function (starter_pack_name, force_name) storage.platform_type_whitelist[force_name or "player"][starter_pack_name] = true end,
    remove_whitelist = function (starter_pack_name, force_name) table.remove(storage.platform_type_whitelist[force_name or "player"][starter_pack_name]) end,
    is_whitelisted = function (starter_pack_name, force_name) if storage.platform_type_whitelist[force_name or "player"][starter_pack_name] then return true else return false end end
})

commands.add_command("reset-whitelist", "Resets the whitelist for space platform starter packs. Can cause unpredictable behavior with other mods, but useful for removing mods.", function (command)
    storage.platform_type_whitelist = {player = {"space-platform-starter-pack"}}
end)


script.on_event(
    {
        defines.events.on_rocket_launched
    },
    function (event)
        if event.rocket_silo and event.rocket_silo.valid then

            verify_whitelist()

            debug_mode = settings.global["debug-mode"].value

            if debug_mode then
                game.print("A rocket has been launched")
            end

            local surface = event.rocket_silo.surface
            local planet
            for index, test_planet in pairs(game.planets) do
                if test_planet.surface == surface then
                    planet = test_planet
                    break
                end
            end
            if not planet then 
                if debug_mode then
                    game.print("Couldn't find associated planet for rocket launch.")
                end
                return 
            else
                if debug_mode then
                    game.print("Launched from planet ".. planet.prototype.name)
                end
            end
            ---@type LuaForce
            local force = event.rocket_silo.force

            if debug_mode then
                game.print("Initial conditions OK")
            end

            if not force.is_space_platforms_unlocked() then return end
            if not force.technologies["rocket-chunk-processing"].researched then return end

            local whitelist = storage.platform_type_whitelist[force.name]

            local platform_candidates = {}
            local platform_count = 0
            local priority_candidates = {}
            local priority_count = 0
            for index, platform in pairs(force.platforms) do
                -- game.print(platform.name)
                -- if platform.starter_pack then
                --     game.print(platform.starter_pack.name.name)
                -- else
                --     game.print("there is no starter pack for this one!")
                -- end
                if true then
                    if platform.surface then
                        if platform.space_location then
                            if platform.space_location.name == planet.prototype.name then

                                table.insert(platform_candidates, platform)
                                platform_count = platform_count + 1
                                
                                local candidates = platform.surface.find_entities_filtered({name = "remnant-beacon"})
                                if #candidates > 0 then
                                    if debug_mode then
                                        game.print("we got a priority candidate")
                                    end
                                    ---@type LuaEntity
                                    local remnant_beacon = candidates[1]
                                    if remnant_beacon and remnant_beacon.valid then
                                        -- if debug_mode then
                                        --     game.print(remnant_beacon.name)
                                        --     game.print(remnant_beacon.status)
                                        -- end
                                        if remnant_beacon.status == defines.entity_status.working or remnant_beacon.status == defines.entity_status.low_power then
                                            if debug_mode then
                                                game.print("adding priority")
                                            end
                                            table.insert(priority_candidates, platform)
                                            priority_count = priority_count + 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if #platform_candidates == 0 then
                if debug_mode then
                    game.print("Found no suitable platforms.")
                end
                return 
            end

            local target
            if priority_count > 0 then
                if debug_mode then
                    game.print("We got a priority candidate!")
                end
                target = priority_candidates[math.random(1, priority_count)]
            else
                if debug_mode then
                    game.print("There is no priority.")
                end
                target = platform_candidates[math.random(1, platform_count)]
            end

            if debug_mode then
                game.print("Spawning asteroid on platform " .. target.name)
            end

            target.surface.create_entity({name = "used-rocket-asteroid", position = {math.random(-40, 40), -500}})
        end
    end
)