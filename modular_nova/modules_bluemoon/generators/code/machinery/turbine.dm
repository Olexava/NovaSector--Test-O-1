// Bluemoon addition - Turbine sound effects
/obj/machinery/power/turbine/core_rotor
	var/datum/looping_sound/turbine/soundloop

/obj/machinery/power/turbine/core_rotor/Initialize(mapload)
	. = ..()
	soundloop = new(src, active)

/obj/machinery/power/turbine/core_rotor/Destroy()
	QDEL_NULL(soundloop)
	return ..()
