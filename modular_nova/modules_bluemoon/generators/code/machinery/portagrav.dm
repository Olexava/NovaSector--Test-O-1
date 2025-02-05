#define PORTAGRAV_ICON_FILE 'modular_nova/modules_bluemoon/generators/icons/gravity_generator.dmi'

/obj/machinery/power/portagrav
	icon = PORTAGRAV_ICON_FILE
	range = 5
	max_range = 50
	var/datum/looping_sound/gravgen/soundloop
	var/mutable_appearance/portagrav_overlay
	var/mutable_appearance/startup_overlay
	var/mutable_appearance/shutdown_overlay
	var/flick_timerid

	COOLDOWN_DECLARE(portagrav_toggle)

/obj/machinery/power/portagrav/Initialize()
	. = ..()
	soundloop = new(src, start_immediately = FALSE)
	portagrav_overlay = mutable_appearance(
		PORTAGRAV_ICON_FILE,
		"activated",
		appearance_flags = RESET_COLOR,
	)
	startup_overlay = mutable_appearance(
		PORTAGRAV_ICON_FILE,
		"startup",
		appearance_flags = RESET_COLOR,
	)
	shutdown_overlay = mutable_appearance(
		PORTAGRAV_ICON_FILE,
		"shutdown",
		appearance_flags = RESET_COLOR,
	)
	portagrav_overlay.pixel_y = 16
	startup_overlay.pixel_y = 16
	shutdown_overlay.pixel_y = 16
	SET_PLANE_EXPLICIT(portagrav_overlay, ABOVE_LIGHTING_PLANE, src)
	SET_PLANE_EXPLICIT(startup_overlay, ABOVE_LIGHTING_PLANE, src)
	SET_PLANE_EXPLICIT(shutdown_overlay, ABOVE_LIGHTING_PLANE, src)

/obj/machinery/power/portagrav/process()
	if(wire_mode)
		return
	if((((cell.charge / cell.maxcharge) * 100) % 4 == 0) && prob(75))
		playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

/obj/machinery/power/portagrav/update_icon()
	. = ..()
	icon_state = panel_open ? "portagrav_fix" : "portagrav"

/obj/machinery/power/portagrav/update_overlays()
	. = ..()
	if(panel_open || (wire_mode && !surplus()) || (!wire_mode && !cell?.charge))
		. += "portagrav_lights_fix"

/obj/machinery/power/portagrav/proc/finish_startup()
	add_overlay(portagrav_overlay)
	flick_timerid = null

/obj/machinery/power/portagrav/toggle_on(mob/user)
	if(!COOLDOWN_FINISHED(src, portagrav_toggle))
		return
	. = ..()
	COOLDOWN_START(src, portagrav_toggle, 2 SECONDS)

/obj/machinery/power/portagrav/turn_on(mob/user)
	. = ..()
	if(!on)
		return
	if(flick_timerid)
		deltimer(flick_timerid)
	flick_timerid = addtimer(CALLBACK(src, PROC_REF(finish_startup)), 15, TIMER_CLIENT_TIME | TIMER_DELETE_ME | TIMER_STOPPABLE)
	flick_overlay_view(startup_overlay, 15)
	soundloop.start()

/obj/machinery/power/portagrav/turn_off(mob/user)
	. = ..()
	if(on)
		return
	if(flick_timerid)
		deltimer(flick_timerid)
	cut_overlay(portagrav_overlay)
	flick_overlay_view(shutdown_overlay, 9)
	soundloop.stop()

/obj/machinery/power/portagrav/screwdriver_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, "portagrav_fix", base_icon_state, tool))
		return NONE
	if(on)
		turn_off(user)
	update_appearance(UPDATE_ICON)
	return ITEM_INTERACT_SUCCESS

#undef PORTAGRAV_ICON_FILE
