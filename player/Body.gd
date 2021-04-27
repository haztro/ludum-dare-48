extends Node2D

export(float, -1, 1.0) var leg_colour = -1
export(float, -1, 1.0) var body_colour = -1
export(float, -1, 1.0) var head_colour = -1
export(float, -1, 1.0) var hair_colour = -1
export(float, -1, 1.0) var accessory_colour = -1
export(float, -1, 1.0) var hat_colour = -1

export(int, -1, 3) var hair_type = -1
export(int, -1, 3) var accessory_type = -1
export(int, -1, 3) var hat_type = -1

var walking = 0
var old_direction = Vector2.ZERO
var anim_state

var colour_shader = preload("res://npc/Body.tres")
var skin_palette = preload("res://assets/art/skin_palette.png")
var rainbow_palette = preload("res://assets/art/rainbow_palette.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_state = $AnimationTree.get("parameters/playback")
	
	randomize()
	
	if hair_type == -1:
		hair_type = int(rand_range(0, 3))
	if accessory_type == -1:
		accessory_type = int(rand_range(0, 3))
	if hat_type == -1:
		hat_type = int(rand_range(0, 3))
		
	$HairSprite.region_rect.position.y = 18.0 * hair_type
	$AccessoriesSprite.region_rect.position.y = 18.0 * accessory_type
	$HatSprite.region_rect.position.y = 18.0 * hat_type

	set_sprite_material($LegSprite, leg_colour, rand_range(0.3, 1), rainbow_palette)
	set_sprite_material($BodySprite, body_colour, rand_range(0.3, 1), rainbow_palette)
	set_sprite_material($HeadSprite, head_colour, 1.0, skin_palette)
	set_sprite_material($HairSprite, hair_colour, rand_range(0.3, 1), rainbow_palette)
	set_sprite_material($HatSprite, hat_colour, rand_range(0.3, 1), rainbow_palette)
	
func set_sprite_material(sprite, sample_pos, brightness, palette):
	if sample_pos == -1:
		sample_pos = rand_range(0, 1.0)
	sprite.set_material(colour_shader.duplicate())
	sprite.get_material().set_shader_param("palette", palette)
	sprite.get_material().set_shader_param("sample_pos", sample_pos)
	sprite.get_material().set_shader_param("brightness", brightness)

func _process(delta):
	pass

func update_body(dir):
	if dir != Vector2(0, 0):
		walking = 1
	else:
		walking = 0
		
	$AnimationTree["parameters/conditions/walking"] =  walking
	$AnimationTree["parameters/conditions/not_walking"] = !walking
	
	if dir.x > 0:
		flip(0)
	elif dir.x < 0:
		flip(1)
		
	old_direction = dir
		
func flip(val):
	$AccessoriesSprite.flip_h = val
	$HairSprite.flip_h = val
	$HeadSprite.flip_h = val
	$BodySprite.flip_h = val
	$LegSprite.flip_h = val

