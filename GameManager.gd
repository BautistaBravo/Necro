extends Node

signal souls_changed(new_amount)
signal day_advanced(new_day)

var souls: int = 100
var day: int = 1

func add_souls(amount: int) -> void:
	souls += amount
	souls_changed.emit(souls)

func try_spend_souls(amount: int) -> bool:
	if souls >= amount:
		souls -= amount
		souls_changed.emit(souls)
		return true
	return false

func advance_day() -> void:
	day += 1
	day_advanced.emit(day)
