shader_type canvas_item;

const int GRID_WIDTH = 10;

uniform vec3[9] BLOCK_COLORS : source_color;

uniform vec2 face_center = vec2(0.5, 0.5);
uniform float face_radius = 0.5;
uniform int[GRID_WIDTH*GRID_WIDTH] blocks;

void fragment() {
	vec2 uv = UV;
	float dist = distance(uv, face_center);
	float falloff = exp(-dist * dist * 6.0) - (1.0-face_radius);

    int uv_grid_x = int(uv.x * float(GRID_WIDTH));
    int uv_grid_y = int(uv.y * float(GRID_WIDTH));

    int block = blocks[uv_grid_x + GRID_WIDTH * uv_grid_y] + 1;
    vec3 color = BLOCK_COLORS[block];
    float alpha = 0.0;
    if( block > 0 ){
        alpha = 1.0;
    }

	COLOR = texture(TEXTURE, UV) * vec4(color.r, color.g, color.b, float(alpha));
}
