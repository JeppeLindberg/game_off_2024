extends Node3D


signal puzzle_complete()

func emit_puzzle_complete():
	puzzle_complete.emit()
