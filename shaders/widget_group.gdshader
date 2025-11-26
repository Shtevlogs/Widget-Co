shader_type canvas_item;

const int GRID_WIDTH = 20;

uniform vec4[9] BORDER_COLORS : source_color;
uniform int[GRID_WIDTH*GRID_WIDTH] blocks;
uniform float outline_width = 0.25;

void fragment() {
	vec2 uv = UV;
    
    float grid_width = float(GRID_WIDTH);

    int uv_grid_x = int(uv.x * grid_width);
    int uv_grid_y = int(uv.y * grid_width);

    int index = uv_grid_x + GRID_WIDTH * uv_grid_y;
    int block = blocks[index];
    vec4 color = BORDER_COLORS[block];

    vec4 base_color = texture(TEXTURE, UV);

    vec2 cell_uv = fract(uv * grid_width);
    float border_thickness = clamp(outline_width, 0.0, 1.0);
    bool is_border = false;
    
    if (cell_uv.x < border_thickness) {
        is_border = is_border || uv_grid_x == 0 || blocks[index - 1] != block;
    }
    if (cell_uv.x > 1.0 - border_thickness) {
        is_border = is_border || uv_grid_x == (GRID_WIDTH - 1) || blocks[index + 1] != block;
    }
    if (cell_uv.y < border_thickness) {
        is_border = is_border || uv_grid_y == 0 || blocks[index - GRID_WIDTH] != block;
    }
    if (cell_uv.y > 1.0 - border_thickness) {
        is_border = is_border || uv_grid_y == (GRID_WIDTH - 1) || blocks[index + GRID_WIDTH] != block;
    }

    if (is_border) {
        COLOR = color;
    } else {
        COLOR = base_color * vec4(1,1,1,0);
    }
}
