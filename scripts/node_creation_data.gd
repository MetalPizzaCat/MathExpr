extends Resource
class_name NodeCreationData

@export var inputs : Array[InputData] = []
@export var output_count: int = 1

## Class to attach to the created node
@export var node_script : Script
## Full scene to spawn
@export var prefab_scene : PackedScene

## If true and `prefab_scene` is not null it will spawn full scene instead of object
@export var use_prefab : bool = false

## Used as the title for the node in the editor
@export var main_name : String
## Used for search in the toolbox
@export var additional_names : Array[String] = []

