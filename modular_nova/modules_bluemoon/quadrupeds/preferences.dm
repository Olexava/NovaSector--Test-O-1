// Bluemoon edit - Quadrupedal crew
/datum/preference/toggle/quadruped
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "taur_quadruped_toggle"
	default_value = FALSE

/datum/preference/toggle/quadruped/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/old_value = target.quadruped
	target.quadruped = value
	if(old_value != value)
		target.regenerate_icons()

/datum/preference/toggle/quadruped/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	var/part_enabled = preferences.read_preference(/datum/preference/toggle/mutant_toggle/taur)
	if(passed_initial_check || part_enabled)
		return TRUE
