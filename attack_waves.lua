global.time_between_waves = 36000
-- valid biter names:
-- small-biter     small-spitter
-- medium-biter    medium-spitter
-- big-biter       big-spitter
-- behemoth-biter  behemoth-spitter

global.waves = {{ -- 1
	has_happened = false,
	trigger_tick = global.time_between_waves*2, -- 20min
	biter_to_spawn = "small-biter",
	nodes = 40,
	group_size = 6
},	{ -- 2
	has_happened = false,
	trigger_tick = global.time_between_waves*3, -- 30min
	biter_to_spawn = "small-biter",
	nodes = 5,
	group_size = 50
},	{ -- 3
	has_happened = false,
	trigger_tick = global.time_between_waves*4, -- 40min
	biter_to_spawn = "small-biter",
	nodes = 38,
	group_size = 9
},	{ -- 4
	has_happened = false,
	trigger_tick = global.time_between_waves*5, -- 50min
	biter_to_spawn = "medium-spitter",
	nodes = 38,
	group_size = 9
},	{ -- 5
	has_happened = false,
	trigger_tick = global.time_between_waves*6, -- 60min
	biter_to_spawn = "medium-biter",
	nodes = 22,
	group_size = 18	
},	{ -- 6
	has_happened = false,
	trigger_tick = global.time_between_waves*7, -- 70min
	biter_to_spawn = "big-spitter",
	nodes = 18,
	group_size = 18	
},	{ -- 7
	has_happened = false,
	trigger_tick = global.time_between_waves*8, -- 80min,
	biter_to_spawn = "big-biter",
	nodes = 14,
	group_size = 30	
},	{ -- 8
	has_happened = false,
	trigger_tick = global.time_between_waves*10, -- 100min,
	biter_to_spawn = "behemoth-biter",
	nodes = 8,
	group_size = 40	
},	{ -- 9
	has_happened = false,
	trigger_tick = global.time_between_waves*12, -- 120min,
	biter_to_spawn = "behemoth-biter",
	nodes = 3,
	group_size = 50	
}, 	{ -- 10
	has_happened = false,
	trigger_tick = global.time_between_waves*12.05, -- 120.5min,
	biter_to_spawn = "behemoth-biter",
	nodes = 6,
	group_size = 40	
}, 	{ -- 11
	has_happened = false,
	trigger_tick = global.time_between_waves*12.1, -- 121min,
	biter_to_spawn = "behemoth-spitter",
	nodes = 9,
	group_size = 30	
}, 	{ -- 12
	has_happened = false,
	trigger_tick = global.time_between_waves*12.15, -- 121.5min,
	biter_to_spawn = "behemoth-biter",
	nodes = 12,
	group_size = 20	
}, 	{ -- 13
	has_happened = false,
	trigger_tick = global.time_between_waves*12.2, -- 122min,
	biter_to_spawn = "behemoth-biter",
	nodes = 8,
	group_size = 20	
}, 	{ -- 14
	has_happened = false,
	trigger_tick = global.time_between_waves*12.25, -- 122.5min,
	biter_to_spawn = "behemoth-biter",
	nodes = 4,
	group_size = 20	
}, 	{ -- 15
	has_happened = false,
	trigger_tick = global.time_between_waves*12.3, -- 123min,
	biter_to_spawn = "behemoth-spitter",
	nodes = 3,
	group_size = 20	
}, 	{ -- 15
	has_happened = false,
	trigger_tick = global.time_between_waves*12.35, -- 123.5min,
	biter_to_spawn = "behemoth-spitter",
	nodes = 4,
	group_size = 20	
}, 	{ -- 16
	has_happened = false,
	trigger_tick = global.time_between_waves*12.4, -- 124min,
	biter_to_spawn = "behemoth-spitter",
	nodes = 3,
	group_size = 20	
}, 	{ -- 17
	has_happened = false,
	trigger_tick = global.time_between_waves*12.45, -- 124.5min,
	biter_to_spawn = "behemoth-spitter",
	nodes = 4,
	group_size = 20	
}}
function biter_poly_path(points)
	local list_of_commands = {}
	for i=1, #points do
		list_of_commands[i] = {
			type = defines.command.attack_area,
			destination = points[i],
			distraction = defines.distraction.by_anything,
			radius = 3 
		}
	end
	return list_of_commands
end

function spawn_biters_with_path(points, biter_type, group_size)
	local groups = game.surfaces[1].create_unit_group({
		position = points[1]})

	for i = 0, group_size do
		location = {x = points[1].x, y = points[1].y}
		groups.add_member(game.surfaces[1].create_entity{
			name = biter_type,
			position = game.surfaces[1].find_non_colliding_position(biter_type, location, 10, 0.3, false)})
	end
	groups.set_command{
		type = defines.command.compound,
		structure_type = defines.compound_command.return_last,
		commands = biter_poly_path(points)
	}
end

function spawn_biters(biter_type, nodes, group_size)
	local map_size = {x = 2000, y = 4000} -- maybe get from map-gen settings?
	local points = {
		{
			start = {x = 0 - map_size.x/2.2, y = 0 - map_size.y/3},
			stop  = {x = map_size.x/2.2,     y = 0 - map_size.y/3}
		},{
			start = {x = 0 - map_size.x/2.2, y = map_size.y/2.1},
			stop  = {x = map_size.x/2.2,     y = map_size.y/2.1}
		},{
			start = {x = map_size.x/40,     y = map_size.y/2.2},
			stop  = {x = 0 - map_size.x/40, y = map_size.y/2.2}
		}
	}
	local step_size = {
		{ 
			x = (points[1].stop.x - points[1].start.x)/nodes,
			y = (points[1].stop.y - points[1].start.y)/nodes
		},{
			x = (points[2].stop.x - points[2].start.x)/nodes,
			y = (points[2].stop.y - points[2].start.y)/nodes
		},{
			x = (points[3].stop.x - points[3].start.x)/nodes,
			y = (points[3].stop.y - points[3].start.y)/nodes
		}
	}
	for i=0, nodes do
		spawn_biters_with_path(
			{{
				x = (points[1].start.x + (step_size[1].x * i)),
				y = (points[1].start.y + (step_size[1].y * i))
			},{
				x = (points[2].start.x + (step_size[2].x * i)),
				y = (points[2].start.y + (step_size[2].y * i))
			},{
				x = (points[3].start.x + (step_size[3].x * i)),
				y = (points[3].start.y + (step_size[3].y * i))
			}},
		biter_type, 
		group_size)
	end
end

function attack_waves_core()
	-- game.force.player.
	local spawn_point = {x = 0, y = 1818}
	game.forces["player"].set_spawn_position(spawn_point, 1)
	local tick = game.tick
	if tick < 1000 then
		game.print("Attack waves loaded! Running " .. #global.waves .. " waves. Stand by for first wave!")
	end
	for i = 1, #global.waves do
		if tick >= global.waves[i].trigger_tick and not global.waves[i].has_happened then
			spawn_biters(global.waves[i].biter_to_spawn, global.waves[i].nodes, global.waves[i].group_size)
			global.waves[i].has_happened = true
			if (i ~= #global.waves) then 
				local time_until_next_wave = global.waves[i + 1].trigger_tick - global.waves[i].trigger_tick
				game.print("Wave number " .. i .. " has spawned! Next wave in " .. ((time_until_next_wave/60)/60) .. "min!")
			else
				game.print("The final wave has spawned!")
			end
		end
	end
end

local attack_waves_init = {}

local script_events = {
	--place the here what you would normaly use Event.register for
	-- Event.register(defines.events.on_player_created, testfunction)
	-- is the same as 
	-- [defines.events.on_player_created] = testfunction,
	-- where testfunction is | local function testfunction() { }
	--[Event] = function, 
	--put stuff here
 
}

attack_waves_init.on_nth_ticks = {
	--place the here what you would normaly use 
    --[tick] = function,
    --put stuff here
    [240] = attack_waves_core,
}

attack_waves_init.on_init = function() -- this runs when Event.core_events.init
    log("attack_waves init")
	--put stuff here

    global.attack_waves_data = global.attack_waves_data or script_data  -- NO TOUCHY

end

attack_waves_init.on_load = function() -- this runs when Event.core_events.load
    log("attack_waves load")
	--put stuff here

    script_data = global.attack_waves_data or script_data  -- NO TOUCHY
end

attack_waves_init.get_events = function()
    return script_events
end

return attack_waves_init