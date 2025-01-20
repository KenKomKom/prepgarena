extends Node

var next_level: String
#
#func play_audio(file_path, pitch=1.0, volume = 0):
	#if not audiostream2.playing :
		#audiostream2.volume_db=volume
		#audiostream2.pitch_scale = pitch
		#audiostream2.stream = load(file_path)
		#audiostream2.play()
	#else :
		#audiostream3.volume_db=volume
		#audiostream3.pitch_scale = pitch
		#audiostream3.stream = load(file_path)
		#audiostream3.play()
#
#func play_audio_background(file_path, volume_db=0):
	#if audiostream1.playing:
		#var tween = get_tree().create_tween()
		#tween.tween_property(audiostream1, "volume_db", -10, 1)
		#await get_tree().create_timer(1).timeout
		#audiostream1.stop()
	#audiostream1.volume_db=-10
	#audiostream1.stream= load(file_path)
	#audiostream1.play()
	#var tween = get_tree().create_tween()
	#tween.tween_property(audiostream1, "volume_db", volume_db, 1)
	#await get_tree().create_timer(1).timeout
	#audiostream1.volume_db=volume_db
#
#func stop_audio_background():
	#var tween = get_tree().create_tween()
	#tween.tween_property(audiostream1, "volume_db", -10, 1)
	#await get_tree().create_timer(1).timeout
	#audiostream1.stop()
