extends Control

@onready var label : Label = $Label
@onready var label2 : Label = $Label2

func _ready():
	
	TimeManagers.minutes_changed.connect(actualizar_hora)
	TimeManagers.day_changed.connect(actualizar_dia)
	actualizar_dia()
func actualizar_dia():
	label.text = str(TimeManagers.day)

func actualizar_hora():
	label2.text = str(TimeManagers.hour,":",TimeManagers.minutes)
