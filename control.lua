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
            local priority_candidates = {}
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
                            if platform.space_location.object_name == planet.prototype.object_name then
                                table.insert(platform_candidates, platform)
                            end
                        end
                    end
                end
            end

            if count == 0 then
                if debug_mode then
                    game.print("Found no suitable platforms.")
                end
                return 
            end

            local target = platform_candidates[math.random(1, #platform_candidates)]

            if debug_mode then
                game.print("Spawning asteroid on platform " .. target.name)
            end

            target.surface.create_entity({name = "used-rocket-asteroid", position = {math.random(-40, 40), -500}})
        end
    end
)