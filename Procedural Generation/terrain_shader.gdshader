shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_rock;
uniform sampler2D terrain_sand;

uniform float min_height = 0;
uniform float max_height = 1;

varying float vertex_y;
uniform vec2 uvscale = vec2(5);

void vertex() {
	vertex_y = VERTEX.y;
}

void fragment() {
	float height = vertex_y;
	vec3 grass = texture(terrain_grass,UV*uvscale).rgb;
	vec3 rock = texture(terrain_rock,UV*uvscale).rgb;
	
	float weight = smoothstep(min_height,max_height,height);
	
	vec3 color = mix(grass,rock,weight);
	
	ALBEDO = color;
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
