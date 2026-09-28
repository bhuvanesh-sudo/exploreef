class_name PlayerRig
extends Node3D

signal mode_changed(xr_active: bool, camera: Camera3D)

@onready var _start_xr: XRToolsStartXR = $StartXR
@onready var _xr_origin: XROrigin3D = $XROrigin3D
@onready var _xr_camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var _desktop_player: DesktopPlayer = $DesktopPlayer

var xr_active := false
var active_camera: Camera3D


func _ready() -> void:
	_start_xr.xr_started.connect(_set_xr_active.bind(true))
	_start_xr.xr_failed_to_initialize.connect(_set_xr_active.bind(false))
	_set_xr_active(get_viewport().use_xr)


func _set_xr_active(active: bool) -> void:
	xr_active = active
	_xr_origin.visible = active
	_xr_origin.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
	_xr_origin.current = active
	_desktop_player.set_active(not active)
	active_camera = _xr_camera if active else _desktop_player.camera
	active_camera.current = true
	mode_changed.emit(active, active_camera)
