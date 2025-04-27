extends CanvasLayer

func change_scene_to_file(target : String):
	$AnimationPlayer.play("dıssolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dıssolve")
