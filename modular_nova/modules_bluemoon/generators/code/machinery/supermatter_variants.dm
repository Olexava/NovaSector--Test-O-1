// Bluemoon edit - Quiet supermatter shard
/obj/machinery/power/supermatter_crystal/shard/Initialize(mapload)
	. = ..()
	qdel(soundloop)
	soundloop = new /datum/looping_sound/supermatter/shard(src, TRUE)
