extends Node

@export var tier_1_skeleton_scene: Resource = preload("res://tier1_skeleton.tres")

const MAX_SKELETONS = 16
const SKELETON_COST = 50

var grid_container: GridContainer
var buy_button: Button
var advance_day_button: Button
var souls_label: Label
var day_label: Label

var selected_skeleton_1: SkeletonUnit = null

func _ready() -> void:
	_setup_ui()
	GameManager.souls_changed.connect(_update_souls_label)
	GameManager.day_advanced.connect(_update_day_label)
	_update_souls_label(GameManager.souls)
	_update_day_label(GameManager.day)

	# Initial populate
	for i in range(MAX_SKELETONS):
		var unit = SkeletonUnit.new()
		unit.custom_minimum_size = Vector2(100, 100)
		unit.selected.connect(_on_skeleton_selected)
		grid_container.add_child(unit)

func _setup_ui() -> void:
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(PRESET_FULL_RECT)
	add_child(vbox)

	var hbox_top = HBoxContainer.new()
	vbox.add_child(hbox_top)

	souls_label = Label.new()
	hbox_top.add_child(souls_label)

	day_label = Label.new()
	hbox_top.add_child(day_label)

	var hbox_buttons = HBoxContainer.new()
	vbox.add_child(hbox_buttons)

	buy_button = Button.new()
	buy_button.text = "Comprar Esqueleto (50 Almas)"
	buy_button.pressed.connect(_on_buy_button_pressed)
	hbox_buttons.add_child(buy_button)

	advance_day_button = Button.new()
	advance_day_button.text = "Avanzar Dia"
	advance_day_button.pressed.connect(_on_advance_day_pressed)
	hbox_buttons.add_child(advance_day_button)

	grid_container = GridContainer.new()
	grid_container.columns = 4
	vbox.add_child(grid_container)

func _update_souls_label(souls: int) -> void:
	souls_label.text = "Almas: " + str(souls)

func _update_day_label(day: int) -> void:
	day_label.text = "Dia: " + str(day)

func _on_buy_button_pressed() -> void:
	# Check if there is an empty slot first
	var empty_slot: SkeletonUnit = null
	for child in grid_container.get_children():
		var unit = child as SkeletonUnit
		if unit and unit.data == null:
			empty_slot = unit
			break

	if empty_slot == null:
		print("No hay espacio en la catacumba!")
		return

	if GameManager.try_spend_souls(SKELETON_COST):
		empty_slot.set_data(tier_1_skeleton_scene.duplicate())
	else:
		print("No hay suficientes almas!")

func _on_advance_day_pressed() -> void:
	var total_souls_generated = 0
	for child in grid_container.get_children():
		var unit = child as SkeletonUnit
		if unit and unit.data:
			total_souls_generated += unit.data.souls_per_day

	GameManager.add_souls(total_souls_generated)
	GameManager.advance_day()

func _on_skeleton_selected(unit: SkeletonUnit) -> void:
	if selected_skeleton_1 == null:
		selected_skeleton_1 = unit
		print("Seleccionado 1: ", unit.data.skeleton_name)
	elif selected_skeleton_1 == unit:
		# Deseleccionar
		selected_skeleton_1 = null
		print("Deseleccionado")
	else:
		# Intentar merge
		var unit2 = unit
		if selected_skeleton_1.data.tier == unit2.data.tier:
			if selected_skeleton_1.data.next_tier:
				# Exito, mergear
				print("Merge existoso!")
				var next_tier_data = selected_skeleton_1.data.next_tier.duplicate()
				selected_skeleton_1.set_data(next_tier_data)
				unit2.set_data(null)
			else:
				print("Nivel maximo alcanzado")
		else:
			print("No son del mismo tier")
		selected_skeleton_1 = null
