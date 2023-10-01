extends Node

func play_game_music():
	$MenuMusic.stop()
	$GameMusic.play()

func play_menu_music():
	$GameMusic.stop()
	$MenuMusic.play()

func play_hit_sound():
	$Hit.play()

func play_hole_sound():
	$Hole.play()
	
func play_rebound_sound(pitch: float):
	$Rebound.pitch_scale = pitch
	$Rebound.play()
