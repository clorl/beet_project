@tool
extends Node3D

@export_global_file("*.mcfunction") var export_path = ""

func _ready():
	if not export_path.is_absolute_path():
		print("Error: The provided file path is not an absolute path.")
		return
	var file = FileAccess.open(export_path, FileAccess.WRITE)

	if file:
		file.store_string(_serialize())
		file.close()
		print("Done")
		get_tree().quit()
	else:
		print("Error writing file. Could not open path: " + export_path)

func _serialize():
	var commands = ""

	for child in get_children():
		if not child is DisplayBlock:
			continue
		var command = "summon block_display ~ ~ ~ "
		command += nbt({
			"block_state": {
				"Name": _q("minecraft:" + child.block_id),
				},
			"transformation": {
					"translation": nbt([child.position.x, child.position.y, child.position.z], "f"),
					"right_rotation": nbt([child.quaternion.w,child.quaternion.x,child.quaternion.y,child.quaternion.z], "f"),
					"left_rotation": nbt([1, 0, 0, 0], "f"),
					"scale": nbt([child.scale.x, child.scale.y, child.scale.z], "f")
				}
		})
		commands += command + "\n"
	return commands

func nbt(thing, number_type=""):
	if thing is Dictionary:
		return _format(thing)
	if thing is Array:
		return _format(thing.map(func(num):
			if typeof(num) == TYPE_FLOAT:
				return str(snapped(num, 0.01)) + number_type
			return str(num) + number_type
		))
	return ""

func _q(text: String):
	return "\"" + text + "\""

func _format(thing):
	var text = str(thing)
	var regex = RegEx.new()
	regex.compile("(?<!\\\\)\"")
	text = regex.sub(text, "", true)
	text = text.replace("\\", "")
	text = text.replace(" ", "")
	text = text.replace("\n", "")
	text = text.replace("\r", "")
	return text
