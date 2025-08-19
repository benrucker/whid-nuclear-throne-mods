// TODO
//  - Audit variable creation. Instance vars omit a scope (e.g. "var", "global."), 
//    so make sure we're not creating extraneous instance variables.

// Notes
// The `global` namespace is per-mod. So it can be used for variables
//   that need to stay in scope in all of the functions here, even when the 
//   GML scope changes (like from player to enemy using the `with()` directive).

// All logic must be under a `#define` tag. For example, you can't define macros
// above `#define init`.


// TODO: 
// Swap hurt sprite to one with eye when entering a portal
// 

#define init
    // runs only once when the mod is loaded
    // it is in global scope (not player)


    #macro near_radius	70


    #macro is_right_click_pressed button_pressed(index, "spec")
    #macro is_taunt_button_pressed button_pressed(index, "horn")
    
    #macro ultra_a global.ultra[1]
    #macro ultra_b global.ultra[2]
    
    global.spr_idle = sprite_add("askin/Sabbath_idle_noeye_01.png", 1, 12, 12);
    global.spr_walk = sprite_add("askin/Sabbath_Running_01.png", 6, 12, 12);
    global.spr_walk_eye_offset = [0, 1, 2, 2, 1, 0];
    global.spr_hurt = sprite_add("askin/Sabbath_hurt_noeye.png", 3, 12, 12);
    global.spr_dead = sprite_add("askin/Sabbath_idle_noeye_01.png", 1, 12, 12);
    
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

    global.spr_eye = sprite_add("askin/sabbath eye sheet.png", 5, 7, 7);

    global.snd_select = sound_add("test_sounds/select.ogg");
    global.snd_laugh = sound_add("test_sounds/laugh.ogg");
    global.snd_start = sound_add("test_sounds/flashyn.ogg");
    global.snd_dead = sound_add("test_sounds/die.ogg");
    global.snd_hurt = sound_add("test_sounds/hurt1.ogg");
    global.snd_chst = sound_add("test_sounds/wow.ogg");
    global.snd_empty = sound_add("test_sounds/sad.ogg");
    
    global.snd_low_health = sound_add("test_sounds/low_h2.ogg");
    global.snd_low_ammo = sound_add("test_sounds/low_ammo.ogg");
    
    global.gesture_start_location = noone // “near” or “far”
    global.gesture_current_location = noone
    global.gesture_hold_duration = noone // number

    global.ultra[1] = 0;
    global.ultra[2] = 0;

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
    return "mage";


#define race_menu_button
    sprite_index = global.spr_select;


#define race_menu_select
    return global.snd_select


#define race_menu_confirm
    return global.snd_laugh


#define race_text
    return "USES PROFANE POWER#GOOP NOOKUM";


#define race_mapicon
    return global.spr_mapicon;


#define race_ttip
    return choose("EROTIC MAGE", "NEUROTIC MAGE", "NECROTIC MAGE");


#define race_ultra_name
    switch(argument0) {
      case 1: return "XXX";
      case 2: return "XXX";
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
    return "XXX";


#define race_portrait
    return global.spr_portrait;


#define create
    // create happens when a new run begins
    // and it is already in player scope
    
    spr_sit1 = global.spr_sit1;
    spr_sit2 = global.spr_sit2;
    
    spr_idle = global.spr_idle;
    spr_walk = global.spr_walk;
    spr_hurt = global.spr_hurt;

    spr_dead = global.spr_dead;
    
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

    spr_eye = global.spr_eye

    created = true
    casting_circle = noone
    
    mask_surface = noone;
    clip_surface = noone;
    


#define step 
    // step is in player scope
    // step happens once on the loading screen & every frame while in a level
    if ("created" not in self) {
        create()
    }

    if ("casting_circle" not in self || casting_circle == noone || !instance_exists(casting_circle)) {
        trace("Creating casting circle")
        with(instance_create(x, y, CustomObject)) {
            depth = -10
            creator = other;
            other.casting_circle = self;
            on_end_step = CastingCircle__on_step
            on_draw = CastingCircle__on_draw
            image_xscale = 1
        }
    }

    draw_eye();

    var casting_state = get_interaction_state()



#define get_interaction_state
    var gesture_current_location = get_distance_from_char(mouse_x, mouse_y) > near_radius ? "far" : "near"

    if (is_right_click_pressed) {
        if (global.gesture_hold_duration == noone) {
            global.gesture_hold_duration = 0
        } else {
            global.gesture_hold_duration += 1
        }
        
        if (global.gesture_start_location == noone) {
            global.gesture_start_location = gesture_current_location
        }
        
        return {
            action: "holding",
            from: global.gesture_start_location,
            to: global.gesture_current_location,
            duration: global.gesture_hold_duration,
        }
    }
    
    if (global.gesture_hold_duration != noone) {
        global.gesture_start_location = noone
        global.gesture_hold_duration = noone
        
        return {
            action: "casting",
            from: global.gesture_start_location,
            to: global.gesture_current_location,
            duration: global.gesture_hold_duration,
        }
    }
    
    return {
        action: "nothing",
    }


#define get_distance_from_char(_x, _y)
    return point_distance(_x, _y, self.x, self.y)


#define draw_begin



#define draw
    draw_eye();


#define draw_end 



#define draw_eye
    var eye_spr_index = get_eye_direction_spr_index();

    eye_offset_x = right ? 4 : -4
    eye_offset_y = 3 - global.spr_walk_eye_offset[sprite_index]
    eye_xscale = right ? 1 : -1
    
    draw_sprite_ext(spr_eye, eye_spr_index, x+eye_offset_x, y+eye_offset_y, eye_xscale, 1, 0, noone, 1)


#define level_start
    // code here runs at the start of every level
    


#define game_start
    // runs at the start of each run. not sure how it's different from "create"
    trace("game start")
    // sound_play(global.snd_empty);
    

#define CastingCircle__on_step


#define CastingCircle__on_draw
    if (!instance_exists(creator)) {
        exit;
    } else {
        x = creator.x
        y = creator.y
    }

    draw_set_blend_mode(bm_subtract);
    draw_set_alpha(0.1)
    draw_circle_color(x, y, near_radius, c_black, $051511, false)
    draw_set_blend_mode(bm_normal);
    draw_set_alpha(1)
    


#define get_eye_direction_degrees
    var direction = 0;

    if (mouse_x != x || mouse_y != y) {
        direction = point_direction(x, y, mouse_x, mouse_y);
    }

    if (direction < 0) {
        direction += 360;
    }

    return direction;


#define get_eye_direction_spr_index
    var spr_index_by_direction = {
        top_middle:     0,
        top_right:      1,
        bottom_right:   2,
        bottom_middle:  3,
    }
    
    var direction_degrees = get_eye_direction_degrees()
    
    if (direction_degrees >= 0 && direction_degrees < 60) {
        // Top right
        return spr_index_by_direction.top_right
    } else if (direction_degrees >= 60 && direction_degrees < 120) {
        // Top middle
        return spr_index_by_direction.top_middle
    } else if (direction_degrees >= 120 && direction_degrees < 180) {
        // Top left
        return spr_index_by_direction.top_right
    } else if (direction_degrees >= 180 && direction_degrees < 240) {
        // Bottom left
        return spr_index_by_direction.bottom_right
    } else if (direction_degrees >= 240 && direction_degrees < 300) {
        // Bottom middle
        return spr_index_by_direction.bottom_middle
    } else if (direction_degrees >= 300 && direction_degrees < 360) {
        // Bottom right
        return spr_index_by_direction.bottom_right
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

