// TODO
//  - Audit variable creation. Instance vars omit a scope (e.g. "var", "global."), 
//    so make sure we're not creating extraneous instance variables.

// Notes
// The `global` namespace is per-mod. So it can be used for variables
//   that need to stay in scope in all of the functions here, even when the 
//   GML scope changes (like from player to enemy using the `with()` directive).

// All logic must be under a `#define` tag. For example, you can't define macros
// above `#define init`.


#define init
	// runs only once when the mod is loaded
	// it is in global scope (not player)

	#macro eatables [EnemyBullet1, EnemyBullet2, EnemyBullet3, EnemyBullet4, projectile, Cactus, RadChest, RadMaggotChest, CarThrow, Maggot, RadMaggot, Rad]
	
	#macro eat_radius					20
	#macro max_things_in_mouth_default	3
	#macro max_things_in_mouth_tb		6
	#macro max_things_in_mouth skill_get(mut_throne_butt) ? max_things_in_mouth_tb : max_things_in_mouth_default

    #macro are_things_in_mouth things_in_mouth_count > 0
	
	#macro bite_distance 10
	
	#macro min_spit_speed 7
	#macro charge_max_damage 4			// max extra damage from charged projectiles
	#macro charge_duration_frames 120	// length of charge
	#macro charge_delay_frames 15		// time before charge start increasing damage
	#macro charge_time clamp(other.time_things_spent_in_mouth - charge_delay_frames, 0, charge_duration_frames) / charge_duration_frames
	#macro bonus_damage floor(charge_time * charge_max_damage)
	
	#macro is_bite_button_pressed button_pressed(index, "spec")
	#macro is_smoke_button_pressed button_pressed(index, "horn")
	
	#macro ultra_invuln global.ultra[1]
	#macro ultra_charging_inhale global.ultra[2]
	
	#macro invuln_seconds 10
	
	#macro red "red"
	#macro red_instances instances_matching(Player, "race", red)
	
	global.spr_idle_r = sprite_add("askin/red_idle_right-Sheet.png", 8, 12, 12);
	global.spr_walk_r = sprite_add("askin/red_walking_right-Sheet.png", 6, 12, 12);
	global.spr_hurt_r = sprite_add("askin/red_hurt_right-Sheet.png", 3, 12, 12);
	global.spr_dead_r = sprite_add("askin/red_dead_right-Sheet.png", 6, 12, 12);
	
	global.spr_idle_l = sprite_add("askin/red_idle_left-Sheet.png", 8, 12, 12);
	global.spr_walk_l = sprite_add("askin/red_walking_left-Sheet.png", 6, 12, 12);
	global.spr_hurt_l = sprite_add("askin/red_hurt_left-Sheet.png", 3, 12, 12);
	global.spr_dead_l = sprite_add("askin/red_dead_left-Sheet.png", 6, 12, 12);
	
	global.spr_idle_r_big = sprite_add("askin/red_bloated_idle_right.png", 8, 12, 12);
	global.spr_idle_l_big = sprite_add("askin/red_bloated_idle_left.png", 8, 12, 12);
	global.spr_walk_r_big = sprite_add("askin/red_bloated_walking_right.png", 6, 12, 12);
	global.spr_walk_l_big = sprite_add("askin/red_bloated_walking_left.png", 6, 12, 12);
	global.spr_hurt_r_big = sprite_add("askin/red_bloated_hurt_right.png", 3, 12, 12);
	global.spr_hurt_l_big = sprite_add("askin/red_bloated_hurt_left.png", 3, 12, 12);

	global.spr_sit1[0] = sprite_add("askin/red_throne_sit-Sheet.png", 1, 12, 12);
	global.spr_sit2[0] = sprite_add("askin/red_throne_sit-Sheet.png", 1, 12, 12);

	global.spr_mapicon = sprite_add("askin/red_map_icon-Sheet.png", 1, 12, 12);
	global.mapicon  = sprite_add("askin/red_map_icon-Sheet.png", 1, 12, 12);
	
	
	// global.loadout  = sprite_add("loadout.png", 1, 16, 16);
	global.spr_portrait = sprite_add("askin/red_big_portrait.png", 1, 40, 243);
	global.spr_select = sprite_add("askin/red_menu_select_portrait-Sheet.png", 1, 0, 0);
	
	
	global.spr_ultra_choose = sprite_add("askin/ultras_choose.png", 2, 12, 16);
	global.spr_ultra_icons[1] = sprite_add("askin/ultra_icon_a.png", 1, 9, 9);
	global.spr_ultra_icons[2] = sprite_add("askin/ultra_icon_b.png", 1, 9, 9);
	
	#macro smoking_frames 38
	global.spr_smoke_r = sprite_add("askin/red_smoking_right-Sheet.png", smoking_frames, 12, 12)
	global.spr_smoke_l = sprite_add("askin/red_smoking_left-Sheet.png", smoking_frames, 12, 12)
	
	#macro bite_frames 8
	global.spr_bite = sprite_add("askin/red_bite.png", bite_frames, 12, 12)
	
	global.snd_select = sound_add("test_sounds/select.ogg");
	global.snd_laugh = sound_add("test_sounds/laugh.ogg");
	global.snd_start = sound_add("test_sounds/flashyn.ogg");
	global.snd_dead = sound_add("test_sounds/die.ogg");
	global.snd_hurt = sound_add("test_sounds/hurt1.ogg");
	global.snd_chst = sound_add("test_sounds/wow.ogg");
	global.snd_empty = sound_add("test_sounds/sad.ogg");
	
	global.snd_low_health = sound_add("test_sounds/low_h2.ogg");
	global.snd_low_ammo = sound_add("test_sounds/low_ammo.ogg");
	
	global.snd_bite = sound_add("test_sounds/bite.ogg");
	global.snd_spit = sound_add("test_sounds/spit.ogg");
	
	global.this_flag_is_incremented_on_create = 0

	global.ultra[1] = 0;
	global.ultra[2] = 0;

	global.red_invincible = false
	global.bite_frame = -1;

	global.level_loading = false

	while(true) {
		if(instance_exists(GenCont) || instance_exists(Menu)) {
			global.level_loading = true;
		}
		else if(global.level_loading) {
			global.level_loading = false;
			level_start();
		}
		wait(0);
	}


#define race_name
	return "red";


#define race_menu_button
	sprite_index = global.spr_select;


#define race_menu_select
	return global.snd_select


#define race_menu_confirm
	return global.snd_laugh


#define race_text
	return "THICK SKIN#EATS OUCHIES#BIG TOOFUMS";


#define race_mapicon
	return global.spr_mapicon;


#define race_ttip
	return choose("HE'S BLUE", "HE'S RED");


#define race_ultra_name
	switch(argument0) {
	  case 1: return "CROCODILE TEARS";
	  case 2: return "BIG APPETITE";
	}


#define race_ultra_text
	switch(argument0) {
	  case 1: return "TAKE NO @rDAMAGE#@sFOR @w7 SECONDS#@sAT START OF EACH @pLEVEL";
	  case 2: return "PROJECTILES DO MORE @rDAMAGE#@sTHE @wLONGER @sTHEY'RE HELD";
	}


#define race_ultra_take
	global.ultra[argument0] = 1;
	if(instance_exists(mutbutton)) switch(argument0){
	  case 1:
	    sound_play(global.snd_empty);
	    break;
	  case 2:
	    sound_play(global.snd_empty);
	    break;
	}


#define race_ultra_button
	sprite_index = global.spr_ultra_choose;
	image_index = argument0 + 1;


#define race_ultra_icon
	return global.spr_ultra_icons[argument0];


#define race_tb_text
	return "EAT MORE PROJECTILES";


#define race_portrait
	return global.spr_portrait;


#define create
	// create happens when a new run begins
	// and it is already in player scope
	smoking = false
	things_in_mouth_count = 0
	things_in_mouth = [null, null, null, null, null, null]
	time_things_spent_in_mouth = 0
	
	face_right() // must go after things_in_mouth_count
	facing_right = true
	
	global.modify_damage_endstep = null

	spr_sit1 = global.spr_sit1;
	spr_sit2 = global.spr_sit2;
	
	snd_wrld = global.snd_start;
	// snd_valt = global.snd_empty;
	// snd_crwn = global.snd_empty;
	// snd_spch = global.snd_empty;
	// snd_idpd = global.snd_empty;
	// snd_cptn = global.snd_empty;
	snd_dead = global.snd_dead;
	snd_lowa = global.snd_low_ammo;
	snd_lowh = global.snd_low_health;
	snd_chst = global.snd_chst;
	snd_hurt = global.snd_hurt;
	
	global.bite_frame = -1;
	


#define step 
	// step is in player scope
	// step happens once on the loading screen & every frame while in a level
	
	if (!smoking) {
		
		if (!right) {
			face_left()
			facing_right = false
		} else if (right) {
			face_right()
			facing_right = true
		}
		
		if (is_bite_button_pressed) {
			if (things_in_mouth_count == 0) {
				// try to grab projectiles out of the air

				var angle = arctan2(mouse_y - y, mouse_x - x);
				var bite_x = x + cos(angle) * bite_distance;
				var bite_y = y + sin(angle) * bite_distance;
				
				// Spawn bite sprite
				with (
					instance_create(
						0,
						0,
						CustomObject,
					)
				) {
					creator = other;
					offset_x = (other.right ? 3 : -3)
					offset_y = 0
					on_end_step = Bite__on_step
					image_xscale = other.right ? 1 : -1;
					direction = angle;
					with (instance_create(0, 0, RobotEat)) {
						creator = other;
	    				image_xscale = other.image_xscale;
						direction = other.direction
					}
					if (fork()) {
						for (var i = 0; i < bite_frames; i++) {
							wait 1
						}
						instance_destroy()
						exit;
					}
				}
				sound_play(global.snd_bite)
				
				with (instances_meeting_rectangle(
					bite_x - eat_radius,
					bite_y - eat_radius,
					bite_x + eat_radius,
					bite_y + eat_radius,
					eatables
				)) {
					if (other.things_in_mouth_count >= max_things_in_mouth) {
						break
					}
					
					if (object_index == RadChest || object_index == RadMaggotChest) { 
						// eat rads
						my_health = 0
						var rad_x = x
						var rad_y = y
						if (fork()) { 
							wait(1) // wait for the rads to spawn
							eat_rads(other, rad_x, rad_y)
							exit
						}
						exit
					} else if (object_index == Maggot || object_index == RadMaggot) {
						instance_create(other.x, other.y, Rad)
						instance_create(other.x, other.y, Rad)
						instance_destroy()
						exit
					} else if (object_index == Cactus) {
						sound_play(global.snd_hurt)
						instance_destroy()
						exit
					} else if (object_index == Rad) {
						if (fork()) { 
							eat_rads(other, x, y)
							exit
						}
						exit;
					}
					
					other.things_in_mouth[other.things_in_mouth_count++] = {
						obj: object_index,
						speed: max(speed, min_spit_speed)
					}
					
					instance_destroy()
					exit
				}
				time_things_spent_in_mouth = 0

			} else {
				// TODO: play spit sound
				sound_play(global.snd_spit)
				
				// try to spit projectiles out
				while (things_in_mouth_count > 0) {
					var thing_in_mouth = things_in_mouth[things_in_mouth_count - 1]
					if (thing_in_mouth == null) {
						things_in_mouth_count = clamp(things_in_mouth_count - 1, 0, max_things_in_mouth)
						continue;
					}
					
					with (instance_create(x, y, thing_in_mouth.obj)) {
						if ("damage" not in self) {
							// pass
						} else {
							var bonus_value = ultra_charging_inhale ? bonus_damage : 0
							motion_add(
								other.gunangle + (random(16) - 8) * other.accuracy,
								(other.things_in_mouth[other.things_in_mouth_count - 1].speed + bonus_value)
							);
							image_angle = direction;
							damage = damage + bonus_value
							team = other.team
						}
						creator = other;
					}
					
					
					things_in_mouth[things_in_mouth_count] = null
					
					things_in_mouth_count = clamp(things_in_mouth_count - 1, 0, max_things_in_mouth)
					
				}
				time_things_spent_in_mouth = 0

				weapon_post(0, -3, 3); // Parameters: weapon shift, camera shift, camera shake
			}

			
		} else if (is_smoke_button_pressed) {
			if (things_in_mouth_count > 0) {
				things_in_mouth_count = 0
				with (instance_create(x, y, Explosion)) {
					damage = 3
				}
			}
			
			smoking = true
			image_index = 0
			speed = 0
			if (right) {
				spr_idle = global.spr_smoke_r
				spr_walk = global.spr_smoke_r
			} else {
				spr_idle = global.spr_smoke_l
				spr_walk = global.spr_smoke_l
			}
		} else if (things_in_mouth_count > 0) {
			if (time_things_spent_in_mouth > charge_duration_frames) {
				with (instance_create(x, y, Explosion)) {
					damage = 3
				}
				time_things_spent_in_mouth = 0
				things_in_mouth_count = 0
			} else {
				time_things_spent_in_mouth += 1
			}
		} 
	} else { // red is smoking
		if (speed > 0) {
			// if the player moves, stop smoking
			stop_smoking()
		} else {
			// prevent flipping
			if (right)
				image_xscale = 1
			else 
				image_xscale = -1
	
			// leaving smoking state if done
			if (image_index + 1 > smoking_frames) {
				stop_smoking()
			}
		}
	}


#define draw_begin
	if (global.red_invincible) {
		draw_sprite_ext(
			sprite_index,
			image_index,
			x,
			y-0.5, // magic number to recenter the sprite after y-scale
			image_xscale * right ? 1.1 : -1.1,
			image_yscale * 1.2,
			image_angle,
			c_black,
			image_alpha * 1
		);
	}

#define draw_end 
    if (global.bite_frame >= 0) {
    	draw_sprite_ext(
    		global.spr_bite,
    		global.bite_frame,
    		x,
    		y,
    		right ? 1 : -1,
    		1,
    		image_angle,
    		noone,
    		1,
    	)
    }

#define face_left
    if (are_things_in_mouth) {
		spr_idle = global.spr_idle_l_big;
		spr_walk = global.spr_walk_l_big;
		spr_hurt = global.spr_hurt_l_big;
    } else {
		spr_idle = global.spr_idle_l;
		spr_walk = global.spr_walk_l;
		spr_hurt = global.spr_hurt_l;
    }
	spr_dead = global.spr_dead_l;
	image_xscale = -1
	
	
#define face_right
    if (are_things_in_mouth) {
		spr_idle = global.spr_idle_r_big;
		spr_walk = global.spr_walk_r_big;
		spr_hurt = global.spr_hurt_r_big;
    } else {
		spr_idle = global.spr_idle_r;
		spr_walk = global.spr_walk_r;
		spr_hurt = global.spr_hurt_r;
    }
	spr_dead = global.spr_dead_r;
	image_xscale = 1


#define stop_smoking
	smoking = false
	if (right) {
		face_right()
		facing_right = true
	} else {
		face_left()
		facing_right = false
	}


#define modify_damage
	with (red_instances) if (my_health < lsthealth) {
		if (ultra_invuln && nexthurt > current_frame) {
			trace("negated non-nexthurt damage")
			my_health = lsthealth
		} else if (my_health < lsthealth - 1) {
			// if we've taken more than 1 point of damage, give us 1 point back
			my_health += 1
			lsthealth = my_health
		}
	}


#define eat_rads(player, rad_x, rad_y)
	with (player) {
		with(instances_meeting_rectangle(rad_x-30, rad_y-30, rad_x+30, rad_y+30, Rad)) {
			// hide the rads
			x = -100
			y = -100
			speed = 0
		}
		
		with(instances_meeting_point(-100, -100, Rad)) {
			// eat the rads one by one
			x = other.x
			y = other.y
			speed = 0.1
			wait 1
		}
	}


#define level_start
	// code here runs at the start of every level
	
	with (red_instances) {
		stop_smoking() // also sets look direction
		
		// damage reduction check
		if (global.modify_damage_endstep != null) {
			trace("deleting old endstep")
			instance_delete(global.modify_damage_endstep)
			global.modify_damage_endstep = null
		}
		global.modify_damage_endstep = script_bind_end_step(modify_damage, 1)
		trace("bound endstep")
		
		var player = self
		// be invuln for first 7 seconds
		if (ultra_invuln && fork()) {
			with (player) {
				global.red_invincible = true
				var invuln_elapsed_frames = 0
				
				while (invuln_elapsed_frames++ < 30 * invuln_seconds) {
					nexthurt = current_frame + 15
					trace('invuln')
					wait 1
				}
				global.red_invincible = false
				trace('no longer invincible')
			}
			exit
		}
	}


#define game_start
	// runs at the start of each run. not sure how it's different from "create"
	trace("game start")
	// sound_play(global.snd_empty);
	
	
#define Bite__on_step
    if (!instance_exists(creator)) {
    	exit;
    } else {
	    x = creator.x + offset_x
	    y = creator.y + offset_y
	    image_xscale = creator.right ? 1 : -1;
    }
	

#define instances_meeting_point(_x, _y, _obj)
	/*
		Returns all instances of the given object whose bounding boxes overlap the given position
		Much better performance than checking 'position_meeting()' on every instance
		
		Args:
			x/y - The position to search
			obj - The object(s) to search
	*/
	
	return (
		instances_matching_le(
		instances_matching_le(
		instances_matching_ge(
		instances_matching_ge(
		_obj,
		"bbox_right",  _x),
		"bbox_bottom", _y),
		"bbox_left",   _x),
		"bbox_top",    _y)
	);


#define instances_meeting_rectangle(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all instances of the given object whose bounding boxes overlap the given rectangle
		Much better performance than checking 'collision_rectangle()' on every instance
		
		Args:
			x1/y1/x2/y2 - The rectangular area to search
			obj         - The object(s) to search
	*/
	
	return (
		instances_matching_le(
		instances_matching_le(
		instances_matching_ge(
		instances_matching_ge(
		_obj,
		"bbox_right",  _x1),
		"bbox_bottom", _y1),
		"bbox_left",   _x2),
		"bbox_top",    _y2)
	);

