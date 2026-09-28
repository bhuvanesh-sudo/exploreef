extends GutTest

# Scaffold: adjust path once the actual script exists.
const TeleportLocomotion = preload("res://scripts/teleport_locomotion.gd")

var locomotion

func before_each():
	locomotion = TeleportLocomotion.new()
	add_child_autofree(locomotion)

func test_teleport_target_within_valid_range():
	var origin = Vector3.ZERO
	var target = Vector3(2, 0, 3)
	var result = locomotion.is_valid_teleport(origin, target)
	assert_true(result, "Teleport within reef bounds should be valid")

func test_teleport_rejects_out_of_bounds_target():
	var origin = Vector3.ZERO
	var target = Vector3(500, 0, 500)
	var result = locomotion.is_valid_teleport(origin, target)
	assert_false(result, "Teleport outside reef bounds should be rejected")

func test_desktop_fallback_raycasts_from_mouse_camera():
	locomotion.xr_active = false
	var source = locomotion.get_raycast_origin()
	assert_eq(source, locomotion.desktop_camera, "Should raycast from desktop camera when XR is inactive")

func test_xr_raycasts_from_xr_camera_when_active():
	locomotion.xr_active = true
	var source = locomotion.get_raycast_origin()
	assert_eq(source, locomotion.xr_camera, "Should raycast from XR camera when XR is active")
