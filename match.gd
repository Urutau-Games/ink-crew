extends Control

enum MatchState {Menu, Countdown, Playing, Finished}

class MatchData:
	var score: Dictionary[Constants.PlayerTag, int] = {
		Constants.PlayerTag.Player1: 0,
		Constants.PlayerTag.RedNpc: 0,
		Constants.PlayerTag.OrangeNpc: 0,
		Constants.PlayerTag.PurpleNpc: 0
	}
	
	var state: MatchState = MatchState.Menu

@export_category("Match Control")
## Match time in seconds
@export var match_time: float = 90
## Countdown to start in seconds
@export var match_countdown: float = 3

@onready var time_label = %TimeLabel
@onready var player_area = %PlayerArea
@onready var red_npc_area = %RedNpcArea
@onready var orange_npc_area = %OrangeNpcArea
@onready var purple_npc_area = %PurpleNpcArea
@onready var arena = %Arena
@onready var countdown_timer: Timer = $CountdownTimer
@onready var match_timer: Timer = $MatchTimer

@onready var countdown: CanvasLayer = $Countdown
@onready var results: CanvasLayer = $Results
@onready var menu: CanvasLayer = $Menu
@onready var countdown_label = $Countdown/Control/Panel/CountdownLabel
@onready var results_table: VBoxContainer = $Results/Control/Panel/VBoxContainer/ResultsTable
@onready var exit_button: Button = $Menu/Control/Panel/VBoxContainer/VBoxContainer/ExitButton
@onready var exit_button_results: Button = $Results/Control/Panel/VBoxContainer/VBoxContainer/ExitButton

const AREA_TEMPLATE := "%dm²"
const TIME_TEMPLATE: String = "%02d:%02d"
const COUNTDOWN_TEMPLATE: String = "%d"
const MINUTE_IN_SECONDS: float = 60

const PLAYER_NAMES = ['Player', 'Cherry', 'Orange', 'Grape']

var _match_data: MatchData

var result_entry_scene: PackedScene = preload("res://result_entry.tscn")

func _ready() -> void:
	arena.process_mode = Node.PROCESS_MODE_DISABLED
	EventBus.tile_painted.connect(_on_title_painted)
	exit_button.visible = not OS.has_feature("web")
	exit_button_results.visible = not OS.has_feature("web")
	_match_data = MatchData.new()

func _process(_delta: float) -> void:
	match _match_data.state:
		MatchState.Playing:
			_set_timer_label()
			player_area.text = AREA_TEMPLATE % _match_data.score[Constants.PlayerTag.Player1]
			red_npc_area.text = AREA_TEMPLATE % _match_data.score[Constants.PlayerTag.RedNpc]
			orange_npc_area.text = AREA_TEMPLATE % _match_data.score[Constants.PlayerTag.OrangeNpc]
			purple_npc_area.text = AREA_TEMPLATE % _match_data.score[Constants.PlayerTag.PurpleNpc]
		
		MatchState.Countdown:
			countdown_label.text = COUNTDOWN_TEMPLATE % (countdown_timer.time_left + 1)
			
		_:
			return

func _set_timer_label():
	var time_left = match_timer.time_left
	var minutes: float = time_left / MINUTE_IN_SECONDS
	var seconds: float = fmod(time_left, MINUTE_IN_SECONDS)
	time_label.text = TIME_TEMPLATE % [minutes, seconds]

func _on_title_painted(who: Constants.PlayerTag, previousOwner: Constants.PlayerTag):
	_match_data.score[who] += 1
	if not previousOwner == Constants.PlayerTag.None:
		_match_data.score[previousOwner] -= 1

func _restart_scene():
	get_tree().reload_current_scene()

func _on_countdown_timer_timeout() -> void:
	countdown.hide()
	_match_data.state = MatchState.Playing
	arena.process_mode = Node.PROCESS_MODE_ALWAYS
	match_timer.start(match_time)

func _on_match_timer_timeout() -> void:
	arena.process_mode = Node.PROCESS_MODE_DISABLED
	_match_data.state = MatchState.Finished
	_build_and_show_results()
	
func _build_and_show_results():
	var score_array = _match_data.score.keys().map(func (key): return [PLAYER_NAMES[key], _match_data.score[key]])
	
	score_array.sort_custom(_sort_result_descending)
	
	for result in score_array:
		var entry = result_entry_scene.instantiate()
		results_table.add_child(entry)
		entry.player = result[0]
		entry.area = AREA_TEMPLATE % result[1]
		
	results.show()

func _sort_result_descending(a: Array, b: Array):
	return a[1] > b[1]

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	menu.hide()
	_match_data.state = MatchState.Countdown
	countdown.show()
	countdown_timer.start(match_countdown)

func _on_restart_button_pressed() -> void:
	_restart_scene()
