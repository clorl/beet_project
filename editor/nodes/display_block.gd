@tool
class_name DisplayBlock
extends MeshInstance3D

const TEX_PATH = "res://mc/current/assets/minecraft/textures/block/"
const ERR_COLOR = Color.MAGENTA

@export var block_id: String:
	set(value):
		_set_block_texture(value)
		block_id = value

func _ready():
	_set_block_texture(block_id)

func _set_block_texture(id: String):
	var texture_path = TEX_PATH + id + ".png"
	_set_texture(texture_path)

func _set_texture(path: String):
	if not mesh:
		mesh = BoxMesh.new()
	var mat = StandardMaterial3D.new()
	set_surface_override_material(0, mat)
	if not FileAccess.file_exists(path):
		mat.albedo_texture = null
		mat.albedo_color = ERR_COLOR
		return
	var image = Image.load_from_file(path)
	var tex = ImageTexture.create_from_image(image)
	mat.albedo_color = Color.WHITE
	mat.albedo_texture = tex
	mat.uv1_scale = Vector3(2,2,2)
	mat.texture_filter = BaseMaterial3D.TextureFilter.TEXTURE_FILTER_NEAREST
