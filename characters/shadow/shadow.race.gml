// Notes
// global.var means global across the entire game!

#define init
	// runs only once when the mod is loaded
	// it is in global scope (not player)
	
	trace("init")

	#macro shadow "shadow"
	#macro red_instances instances_matching(Player, "race", shadow)
	
	global.spr_idle = sprite_add("askin/red_idle_right-Sheet.png", 4, 12, 12);
	global.spr_walk = sprite_add("askin/red_idle_right-Sheet.png", 4, 12, 12);
	global.spr_hurt = sprite_add("askin/red_hurt_right-Sheet.png", 3, 12, 12);
	global.spr_dead = sprite_add("askin/red_dead_right-Sheet.png", 6, 12, 12);
	
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
	
	global.snd_select = sound_add("test_sounds/select.ogg");
	global.snd_laugh = sound_add("test_sounds/laugh.ogg");
	global.snd_start = sound_add("test_sounds/flashyn.ogg");
	global.snd_dead = sound_add("test_sounds/die.ogg");
	global.snd_hurt = sound_add("test_sounds/hurt1.ogg");
	global.snd_chst = sound_add("test_sounds/wow.ogg");
	global.snd_empty = sound_add("test_sounds/sad.ogg");
	
	global.snd_low_health = sound_add("test_sounds/low_h2.ogg");
	global.snd_low_ammo = sound_add("test_sounds/low_ammo.ogg");

	global.ultra[1] = 0;
	global.ultra[2] = 0;

	global.level_loading = false

	while(true){
		if(instance_exists(GenCont) || instance_exists(Menu)){
			global.level_loading = true;
		}
		else if(global.level_loading){
			global.level_loading = false;
			level_start();
		}
		wait(0);
	}


#define race_name
	return "shadow";


#define race_menu_button
	sprite_index = global.spr_select;


#define race_menu_select
	return global.snd_select


#define race_menu_confirm
	return global.snd_laugh


#define race_text
	return "very shadowy";


#define race_mapicon
	return global.spr_mapicon;


#define race_ttip
	return choose("shadow tooltip1", "shadow tooltip2");


#define race_ultra_name
	switch(argument0) {
	  case 1: return "A";
	  case 2: return "B";
	}


#define race_ultra_text
	switch(argument0) {
	  case 1: return "a";
	  case 2: return "b";
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
	return "more shadowier";


#define race_portrait
	return global.spr_portrait;


#define create
	// create happens when a new run begins
	// and it is already in player scope
	
	trace("create")

	spr_sit1 = global.spr_sit1;
	spr_sit2 = global.spr_sit2;
	
	spr_idle = global.spr_idle;
	spr_walk = global.spr_walk;
	spr_hurt = global.spr_hurt;
	spr_dead = global.spr_dead;
	
	spr_shadow = noone; // hide shadow
	
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
	


#define step // step is already set in player scope
	// step happens once on the loading screen & every frame while in a level


#define draw_begin



#define level_start
	// code here runs at the start of every level
	trace("level start!")
	


#define game_start
	// runs at the start of each run. not sure how it's different from "create"
	trace("game start")
	// sound_play(global.snd_empty);
	

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

