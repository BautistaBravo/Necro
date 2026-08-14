class_name SkeletonUnit
extends Control

signal selected(unit)

var data: SkeletonData

func _init() -> void:
	# Add a button so it can be clicked
	var button = Button.new()
	button.text = "Empty"
	button.set_anchors_preset(PRESET_FULL_RECT)
	button.pressed.connect(_on_button_pressed)
	add_child(button)

func set_data(new_data: SkeletonData) -> void:
	data = new_data
	var button = get_child(0)
	if data:
		button.text = data.skeleton_name + " (T" + str(data.tier) + ")"
	else:
		button.text = "Empty"

func _on_button_pressed() -> void:
	if data:
		selected.emit(self)
