shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_rock;
uniform sampler2D terrain_sand;

uniform float min_rock_slope:hint_range(0.0,1.0) = 0.5;
uniform float max_grass_slope:hint_range(0.0, 1.0) = 0.9;
uniform float min_rockgrass_height = -8.0;
uniform float max_sand_height = -6.0;

varying float normal_y;
varying float vertex_y;



void vertex() {
	normal_y = NORMAL.y;	
	vertex_y = VERTEX.y;
}

void fragment() {
		
	vec3 grass_albedo = texture(terrain_grass,UV*4.0).xyz;
	vec3 rock_albedo = texture(terrain_rock,UV*4.0).xyz;
	vec3 sand_albedo = texture(terrain_sand,UV*4.0).xyz;
	
	float rock_grass_weight = (INV_VIEW_MATRIX*vec4(NORMAL,0.0)).y;
	float sand_rockgrass_weight = vertex_y;
	
	rock_grass_weight = max(min_rock_slope,rock_grass_weight);
	rock_grass_weight = min(max_grass_slope,rock_grass_weight);
	rock_grass_weight -= min_rock_slope;
	rock_grass_weight /= max_grass_slope - min_rock_slope;
	
	sand_rockgrass_weight = max(min_rockgrass_height,sand_rockgrass_weight);
	sand_rockgrass_weight = min(max_sand_height,sand_rockgrass_weight);
	sand_rockgrass_weight -= min_rockgrass_height;
	sand_rockgrass_weight /= max_sand_height - min_rockgrass_height;	
	
	vec3 rockgrass_albedo = mix(rock_albedo,grass_albedo,rock_grass_weight);
	ALBEDO = mix(sand_albedo,rockgrass_albedo,sand_rockgrass_weight);
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
