shader_type canvas_item;

const int GRID_WIDTH = 10;
const int DOUBLE_GRID_WIDTH = 20;

uniform vec3[9] BLOCK_COLORS : source_color;

uniform bool double_width = false;
uniform int[GRID_WIDTH*GRID_WIDTH] blocks;
uniform int[DOUBLE_GRID_WIDTH*DOUBLE_GRID_WIDTH] double_blocks;

void fragment() {
	vec2 uv = UV;
    
    float grid_width;
    if( double_width )
    {
        grid_width = float(DOUBLE_GRID_WIDTH);
    }
    else
    {
        grid_width = float(GRID_WIDTH);
    }

    int uv_grid_x = int(uv.x * grid_width);
    int uv_grid_y = int(uv.y * grid_width);

    int block = -1;
    if( double_width )
    {
        block = double_blocks[uv_grid_x + DOUBLE_GRID_WIDTH * uv_grid_y] + 1;
    }
    else
    {
        block = blocks[uv_grid_x + GRID_WIDTH * uv_grid_y] + 1;
    }
    vec3 color = BLOCK_COLORS[block];
    float alpha = 0.0;
    if( block > 0 ){
        alpha = 1.0;
    }

	COLOR = texture(TEXTURE, UV) * vec4(color.r, color.g, color.b, float(alpha));
}
