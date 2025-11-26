shader_type canvas_item;

const int GRID_WIDTH = 20;
uniform int[GRID_WIDTH*GRID_WIDTH] blocks;

uniform vec4[9] BLOCK_COLORS : source_color;

void fragment() {
	vec2 uv = UV;
    
    int uv_grid_x = int(uv.x * float(GRID_WIDTH));
    int uv_grid_y = int(uv.y * float(GRID_WIDTH));

    int block = blocks[uv_grid_x + GRID_WIDTH * uv_grid_y];
    
    COLOR = texture(TEXTURE, UV) * BLOCK_COLORS[block];
}
