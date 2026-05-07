extends Node

@onready var score: Label = $Score
var save_data:SaveData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_data = SaveData.load_or_create()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
