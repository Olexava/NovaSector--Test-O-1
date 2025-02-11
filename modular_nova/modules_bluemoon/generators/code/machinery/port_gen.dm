/obj/machinery/power/port_gen/pacman/bluespace/Initialize()
	. = ..()
	qdel(soundloop)
	soundloop = new /datum/looping_sound/generator/portable(src, active)

/obj/machinery/power/port_gen/pacman/bluespace
	name = "\improper G.H.O.S.T.-type portable generator"
	base_icon_state = "portgen2"
	icon_state = "portgen2_0"
	circuit = /obj/item/circuitboard/machine/pacman/bluespace
	sheet_path = /obj/item/stack/sheet/bluespace_crystal
	power_gen = 40000
	time_per_sheet = 1800
