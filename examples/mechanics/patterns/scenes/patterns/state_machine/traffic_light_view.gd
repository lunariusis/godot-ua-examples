extends Control

@onready var red_light: ColorRect = %RedLight
@onready var yellow_light: ColorRect = %YellowLight
@onready var green_light: ColorRect = %GreenLight
@onready var arrow_indicator: Polygon2D = %ArrowIndicator

const COLOR_RED_ON: Color = Color(1, 0, 0, 1)
const COLOR_YELLOW_ON: Color = Color(1, 1, 0, 1)
const COLOR_GREEN_ON: Color = Color(0, 1, 0, 1)

const COLOR_RED_OFF: Color = Color(0.1, 0, 0, 1)
const COLOR_YELLOW_OFF: Color = Color(0.1, 0.1, 0, 1)
const COLOR_GREEN_OFF: Color = Color(0, 0.1, 0, 1)

func update_lights(red_on: bool, yellow_on: bool, green_on: bool, arrow_on: bool = false) -> void:
	red_light.color = COLOR_RED_ON if red_on else COLOR_RED_OFF
	yellow_light.color = COLOR_YELLOW_ON if yellow_on else COLOR_YELLOW_OFF
	green_light.color = COLOR_GREEN_ON if green_on else COLOR_GREEN_OFF
	
	arrow_indicator.color = COLOR_GREEN_ON if arrow_on else COLOR_GREEN_OFF
