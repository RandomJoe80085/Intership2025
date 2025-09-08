extends GPUParticles2D
class_name DeathParticles
func emit_particles(pos: Vector2):
	global_position = pos
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
