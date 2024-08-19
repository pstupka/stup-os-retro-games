extends Node


const LEADERBOARD_FILE: String = "user://leaderboard.json"
const MAX_ENTRIES: int = 20

var leaderboard_entry_template: Dictionary = {
	"player_name": "TEST",
	"score": 0
}

var leaderboard: Array = []


func _ready() -> void:
	load_data()


func save_data() -> void:
	var save_file: FileAccess = FileAccess.open(LEADERBOARD_FILE, FileAccess.WRITE)
	var json_string: String = JSON.stringify(leaderboard)
	save_file.store_line(json_string)
	save_file.close()


func load_data() -> void:
	if not FileAccess.file_exists(LEADERBOARD_FILE):
		print("Leaderboard file does not exist")
		return

	var save_file: FileAccess = FileAccess.open(LEADERBOARD_FILE, FileAccess.READ)
	var json_data: Array = JSON.parse_string(save_file.get_as_text()) as Array
	if not json_data:
		print("Cannot parse leaderboard file")
		return

	for entry in json_data:
		if not (entry as Dictionary):
			continue
		if not entry.has("player_name") or not entry.has("score"):
			if not (entry["player_name"] as String) and not (entry["player_name"] as int):
				print("Cannot parse entry. Skipping")
			continue
		leaderboard.push_back(entry)
	leaderboard.sort_custom(_custom_sort)
	print(json_data)


func is_score_valid(score: int) -> bool:
	if leaderboard.is_empty():
		return true

	if leaderboard.back()["score"] < score:
		return true

	if leaderboard.back()["score"] == score and leaderboard.size() < MAX_ENTRIES:
		return true

	return false


func add_score(player_name: String, score: int) -> void:
	var leaderboard_entry: Dictionary = {
		"player_name": "TEST",
		"score": 0
	}

	leaderboard_entry["player_name"] = player_name if player_name != "" else "???"
	leaderboard_entry["score"] = score
	leaderboard.push_back(leaderboard_entry)
	leaderboard.sort_custom(_custom_sort)
	save_data()


func get_high_score() -> int:
	if leaderboard.is_empty():
		return 0

	return leaderboard.front()["score"]


func _custom_sort(a: Dictionary, b: Dictionary):
	return a["score"] > b["score"]
