class_name GameMode

var mode: String = ""
var score: int = 0
var level: Node
var one_star_score: int = 0
var two_star_score: int = 0
var three_star_score: int = 0


func _init(level_: Node, one_star_score_: int, two_star_score_: int, three_star_score_: int):
	self.level = level_
	self.one_star_score = one_star_score_
	self.two_star_score = two_star_score_
	self.three_star_score = three_star_score_


func update_gui(_gui: Node) -> void:
	pass


# returns the number of stars awarded, 0 if lost, -1 if still playing
func check_win_condition() -> int:
	return -1


# returns the number of stars awarded, 0 if lost, -1 if still playing
func check_final_result() -> int:
	if score >= three_star_score:
		return 3
	elif score >= two_star_score:
		return 2
	elif score >= one_star_score:
		return 1
	else:
		return 0


func award_points(points: int) -> void:
	score += points


func get_mode() -> String:
	return mode


func get_score() -> int:
	return score
