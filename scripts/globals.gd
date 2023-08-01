extends Node
## vars here are globally accesible through Globals.var


signal hunter_saw_player
signal hunter_lost_player

signal npc_healed
signal game_over


var interacting: bool = false

var used_controller: bool = false
