extends Node

var next_level: String
@onready var background_player = $background
@onready var audiostream1 = $audio1
@onready var audiostream2 = $audio2

func play_audio(file_path, pitch=1.0, volume = 0):
	if not audiostream1.playing :
		audiostream1.volume_db=volume
		audiostream1.pitch_scale = pitch
		audiostream1.stream = load(file_path)
		audiostream1.play()
	else :
		audiostream2.volume_db=volume
		audiostream2.pitch_scale = pitch
		audiostream2.stream = load(file_path)
		audiostream2.play()

func play_audio_background(file_path, volume_db=0):
	if background_player.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(background_player, "volume_db", -10, 1)
		await get_tree().create_timer(1).timeout
		background_player.stop()
	background_player.volume_db=-10
	background_player.stream= load(file_path)
	background_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(background_player, "volume_db", volume_db, 1)
	await get_tree().create_timer(1).timeout
	background_player.volume_db=volume_db

func stop_audio_background():
	var tween = get_tree().create_tween()
	tween.tween_property(background_player, "volume_db", -10, 1)
	await get_tree().create_timer(1).timeout
	background_player.stop()
