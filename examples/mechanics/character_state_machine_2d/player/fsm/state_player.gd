class_name StatePlayer extends State


func _ready() -> void:
	player = owner as Player

func debug_label_update(text:String = "") -> void:
	if not player.debug:
		%Debug.visible = player.debug
		return
	text = name as String if text == "" else text
	%State.set_text(text)
