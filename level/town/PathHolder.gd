extends Node2D


const move_speed := 4.0


func _physics_process(delta):
	return
	$Mann1Path/Mann1PathFollow.progress += move_speed * delta
	$MetzgerPath/MetzgerPathFollow.progress += move_speed * delta
	$AltFrauMannPath/AltFrauMannPathFollow.progress += move_speed * delta
	$WaisenPath/WaisenPathFollow.progress += move_speed * delta
	$OmaKindPath/OmaKindPathFollow.progress += move_speed * delta
	$"2FrauenKindPath/2FrauenKindPathFollow".progress += move_speed * delta
	$FamielieKindPath/FamilieKindPathFollow.progress += move_speed * delta
