extends Node

var editor_refs : Dictionary = {}
var interface : XRInterface
var webxr_interface
var vr_supported = true

var local_uis:Array = []

var keyboard:StaticBody3D

var discord_world = 'loading'
var discord_login_status = 'not logged in'

const VRMC_node_constraint = preload("res://addons/vrm/1.0/VRMC_node_constraint.gd")
var VRMC_node_constraint_inst = VRMC_node_constraint.new()
const VRMC_springBone = preload("res://addons/vrm/1.0/VRMC_springBone.gd")
var VRMC_springBone_inst = VRMC_springBone.new()
const VRMC_materials_mtoon = preload("res://addons/vrm/1.0/VRMC_materials_mtoon.gd")
var VRMC_materials_mtoon_inst = VRMC_materials_mtoon.new()
const VRMC_materials_hdr_emissiveMultiplier = preload("res://addons/vrm/1.0/VRMC_materials_hdr_emissiveMultiplier.gd")
var VRMC_materials_hdr_emissiveMultiplier_inst = VRMC_materials_hdr_emissiveMultiplier.new()
const VRMC_vrm = preload("res://addons/vrm/1.0/VRMC_vrm.gd")
var VRMC_vrm_inst = VRMC_vrm.new()
const VRMC_vrm_animation = preload("res://addons/vrm/1.0/VRMC_vrm_animation.gd")
var VRMC_vrm_animation_inst = VRMC_vrm_animation.new()

@export_enum("PAUSED", "PLAYING", "TYPING") var player_state : int = 0:
	set(value):
		player_state = value
		if value != 2 and !vr_supported:
			playerreleaseuifocus.emit()
static var PLAYER_STATE_PAUSED := 0
static var PLAYER_STATE_PLAYING:= 1
static var PLAYER_STATE_TYPING := 2

@export_enum("EDITING", "PLAYING", "VIEWING") var world_state : int = 0
static var WORLD_STATE_EDITING := 0
static var WORLD_STATE_PLAYING := 1
static var WORLD_STATE_VIEWING := 2

signal playerinit(isvr: bool)
signal playerreleaseuifocus
signal clear_gizmos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vr_supported = ProjectSettings.get_setting('xr/openxr/enabled', false)
	Vector.user_logged_in.connect(func() -> void:
		discord_login_status = 'logged in'
	)
	Journaling.check_root()
	#get_tree().get_first_node_in_group('localroot').add_child(load('res://mainSystem/scenes/player/xrplayer.tscn').instantiate())
	#if OS.get_name() == "Android":
		#OS.request_permissions()

