extends CanvasLayer

var next_level
# Called when the node enters the scene tree for the first time.
func _ready():
	next_level = GameManager.next_level
	%ProgressBar.value = 0
	ResourceLoader.load_threaded_request(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p =[]
	ResourceLoader.load_threaded_get_status(next_level,p)
	var progres = p[0]*100
	%ProgressBar.value = progres
	if progres==100:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_level))
