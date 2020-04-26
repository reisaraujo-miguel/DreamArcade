extends CanvasLayer

onready var score_display: Label = $ScoreDisplay/Value


func _ready() -> void:
	var errors: int = Game.connect("score_changed", self, "_on_Game_score_changed")
	
	_on_Game_score_changed()
	assert(errors == OK)


func _on_Game_score_changed():
	score_display.text = str(Game.score)