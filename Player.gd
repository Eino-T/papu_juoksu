extends KinematicBody

var run_speed: float
var sidestep_speed := 5.0
var velocity := Vector3()

var time: float = 0.0
var step_freq: float = 2.0
var step_height: float = 0.2
var step_tilt: float = 8.0

var gravity: float
var jump_speed: float


onready var body_hinge = $BodyHinge


func _physics_process(delta):
	body_hinge.translation.y = step_height * (1 + sin(2.0 * PI * step_freq * time))
	body_hinge.rotation_degrees.z = step_tilt * sin(PI * step_freq * time)
	time += delta
	
	var sideways: float = 0.0
	
	if Input.is_action_pressed("move_right"):
		sideways += 1.0
	
	if Input.is_action_pressed("move_left"):
		sideways -= 1.0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	
	velocity.y -= gravity * delta
	velocity.x = sideways * sidestep_speed
	velocity.z = -run_speed
	velocity = move_and_slide(velocity, Vector3.UP)
	for index in range (get_slide_count()):
		var collision = get_slide_collision(index)
		var collision_object =collision.collider as CollisionObject

func setup_jump(length: float, height: float, speed: float):
	run_speed = speed
	gravity = 8.0 * height * speed * speed / (length * length)
	jump_speed = 4.0 * height * speed / length
