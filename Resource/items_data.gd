extends Resource
class_name items_data

@export var id : String
@export var nombre : String
@export var descripcion : String

@export var icono: Texture2D 

@export var stackable : bool
@export var max_stack := 99

@export var item_behavior : ItemBehavior = null
