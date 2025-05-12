extends Camera3D

@export var player_node: CharacterBody3D 
@export var fade_alpha: float = 0.3 # Quão transparente o objeto ficará (0.0 = invisível, 1.0 = opaco)
@export var max_occluders_to_check: int = 10 # Para evitar loops infinitos ou processamento excessivo

# Para rastrear paredes que estão atualmente esmaecidas
var currently_faded_walls: Array = []
# Para guardar o estado original do material (opcional, mas bom para restauração precisa)
var original_material_states: Dictionary = {} # Key: MeshInstance3D, Value: Dictionary {alpha, transparency_mode}

func _physics_process(_delta: float):
	if not player_node or not is_instance_valid(player_node):
		return
	var space_state := get_world_3d().direct_space_state
	var new_faded_walls_this_frame: Array[MeshInstance3D] = []
	var exclude_array: Array[RID] = [] # RIDs dos colisionadores a serem ignorados nos raycasts subsequentes

	var camera_pos: Vector3 = global_position
	var player_pos: Vector3 = player_node.global_position
	var direction_to_player: Vector3 = (player_pos - camera_pos).normalized()
	var distance_to_player: float = camera_pos.distance_to(player_pos)

	# Lança raios repetidamente para encontrar todos os obstáculos entre a câmera e o jogador
	for i in range(max_occluders_to_check):
		var query := PhysicsRayQueryParameters3D.create(camera_pos, player_pos, 1, exclude_array) # Usar máscara de colisão se necessário
		var result: Dictionary = space_state.intersect_ray(query)
		if result.is_empty():
			break # Nenhum obstáculo encontrado ou todos já processados
		var collider = result.collider
		# Se o raio atingiu o jogador primeiro, não há mais obstáculos no caminho
		# Verifica se o colisor é uma MeshInstance3D e está no grupo de paredes
		# Ou se o colisor tem um MeshInstance3D como filho (caso o StaticBody3D seja o pai)
		var mesh_instance = null
		if collider is StaticBody3D: # Ou CollisionObject3D
			mesh_instance = collider
		if mesh_instance:
			if not new_faded_walls_this_frame.has(mesh_instance.get_parent()):
				new_faded_walls_this_frame.append(mesh_instance.get_parent())
			# Adiciona o RID do colisor à lista de exclusão para o próximo raycast nesta iteração
			exclude_array.append(collider.get_rid())
			# Se a distância do hit for maior ou igual à distância do jogador, paramos.
			# Isso pode acontecer se o colisor estiver atrás do jogador, mas o raycast
			# tem um comprimento máximo que ainda assim o atinge.
			var hit_pos: Vector3 = result.position
			if camera_pos.distance_to(hit_pos) >= distance_to_player:
				break
		else:
			# Atingiu algo que não é uma parede ou o jogador, adiciona à exclusão e continua
			# ou simplesmente para, dependendo da sua lógica.
			if collider: # Evita erro se collider for null por algum motivo (não deveria acontecer com result não vazio)
				exclude_array.append(collider.get_rid())
			else:
				break # Algo estranho, melhor parar
	# 1. Restaurar paredes que não estão mais obstruindo
	var walls_to_restore: Array[MeshInstance3D] = []
	for faded_wall in currently_faded_walls:
		if not new_faded_walls_this_frame.has(faded_wall):
			walls_to_restore.append(faded_wall)
	for wall_to_restore in walls_to_restore:
		_restore_wall_material(wall_to_restore)
		currently_faded_walls.erase(wall_to_restore)
		if original_material_states.has(wall_to_restore):
			original_material_states.erase(wall_to_restore)
	# 2. Esmaecer novas paredes obstruindo
	for wall_to_fade in new_faded_walls_this_frame:
		if not currently_faded_walls.has(wall_to_fade):
			_fade_wall_material(wall_to_fade)
			currently_faded_walls.append(wall_to_fade)


func _fade_wall_material(wall_mesh: MeshInstance3D):# Função auxiliar para esmaecer o material da parede
	# É crucial que cada parede tenha seu próprio material ou uma override de material
	# para que a modificação não afete outras paredes que usam o mesmo recurso de material.
	var material_override: StandardMaterial3D = wall_mesh.get_surface_override_material(0) if wall_mesh.get_surface_override_material_count() > 0 else null

	if not material_override:
		var base_material = wall_mesh.get_active_material(0) # Pega material do mesh se não houver override
		if base_material is StandardMaterial3D:
			material_override = base_material.duplicate() # DUPLICAR para não afetar outros
			wall_mesh.set_surface_override_material(0, material_override)
		else:
			# Se não houver material ou não for StandardMaterial3D, crie um novo (ou logue um erro)
			material_override = StandardMaterial3D.new()
			wall_mesh.set_surface_override_material(0, material_override)
			# Configure propriedades básicas do material novo aqui se necessário
			material_override.albedo_color = Color.GRAY # Cor padrão

	if material_override is StandardMaterial3D:
		var std_mat: StandardMaterial3D = material_override

		# Guarda o estado original antes de modificar
		if not original_material_states.has(wall_mesh.get_parent()):
			original_material_states[wall_mesh.get_parent()] = {
				"alpha": std_mat.albedo_color.a,
				"transparency": std_mat.transparency,
				"blend_mode": std_mat.blend_mode,
				#"depth_draw_mode": std_mat.depth_draw_mode,
				"cull_mode": std_mat.cull_mode 
			}

		std_mat.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
		std_mat.blend_mode = StandardMaterial3D.BLEND_MODE_MIX # Importante para alpha funcionar bem
		std_mat.depth_draw_mode = StandardMaterial3D.DEPTH_DRAW_OPAQUE_ONLY # Ajuda com ordenação de transparência
		std_mat.cull_mode = StandardMaterial3D.CULL_DISABLED # Opcional, se quiser ver a parte de trás da parede transparente

		var current_color: Color = std_mat.albedo_color
		current_color.a = fade_alpha
		std_mat.albedo_color = current_color

# Função auxiliar para restaurar o material da parede
func _restore_wall_material(wall_mesh: MeshInstance3D):
	var material_override: StandardMaterial3D = wall_mesh.get_surface_override_material(0) if wall_mesh.get_surface_override_material_count() > 0 else null
	
	if material_override is StandardMaterial3D:
		var std_mat: StandardMaterial3D = material_override
		
		if original_material_states.has(wall_mesh.get_parent()):
			var original_state = original_material_states[wall_mesh.get_parent()]
			var restored_color: Color = std_mat.albedo_color
			restored_color.a = original_state.alpha
			std_mat.albedo_color = restored_color
			std_mat.transparency = original_state.transparency
			std_mat.blend_mode = original_state.blend_mode
			# std_mat.depth_draw_mode = original_state.depth_draw_mode
			# std_mat.cull_mode = original_state.cull_mode
		else:
			# Fallback se o estado original não foi guardado (restaurar para totalmente opaco)
			var restored_color: Color = std_mat.albedo_color
			restored_color.a = 1.0
			std_mat.albedo_color = restored_color
			std_mat.transparency = StandardMaterial3D.TRANSPARENCY_DISABLED
			std_mat.blend_mode = StandardMaterial3D.BLEND_MODE_MIX # Ou o padrão que você usa
			std_mat.depth_draw_mode = StandardMaterial3D.DEPTH_DRAW_OPAQUE_ONLY
