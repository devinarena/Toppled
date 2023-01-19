extends Node

enum ToolType {
    SWIPE,
    SHOOT,
    SPRAY,
}

const TOOLS = {
    "baseball": {
        "type": ToolType.SWIPE,
        "scene": "res://scenes/tools/Baseball.tscn",
        "icon": "res://assets/tools/baseball.png",
    },
    "bowlingball": {
        "type": ToolType.SWIPE,
        "scene": "res://scenes/tools/BowlingBall.tscn",
        "icon": "res://assets/tools/bowling_ball.png",
    },
    "bomb": {
        "type": ToolType.SWIPE,
        "scene": "res://scenes/tools/Bomb.tscn",
        "icon": "res://assets/tools/bomb.png",
    }
}

func _ready():
    pass