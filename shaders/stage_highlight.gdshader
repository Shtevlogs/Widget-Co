shader_type canvas_item;

const int GRID_WIDTH = 20;
uniform int[GRID_WIDTH*GRID_WIDTH] blocks;

uniform vec4[9] BLOCK_COLORS : source_color;

// this will be set if we're hovering near a gridline
uniform int highlight_gridline_x = -1;
// this will be set if we're hovering near a gridline
uniform int highlight_gridline_y = -1;
uniform int grid_highlight_color = 1;

uniform float grid_thickness = 0.005;

void fragment() {
	vec2 uv = UV;
    
    int uv_grid_x = int(uv.x * float(GRID_WIDTH));
    int uv_grid_y = int(uv.y * float(GRID_WIDTH));

    int block = blocks[uv_grid_x + GRID_WIDTH * uv_grid_y];

    if (highlight_gridline_x != -1 && abs(uv.x - (float(highlight_gridline_x) / float(GRID_WIDTH))) < grid_thickness) {
        block = grid_highlight_color;
    }
    if (highlight_gridline_y != -1 && abs(uv.y - (float(highlight_gridline_y) / float(GRID_WIDTH))) < grid_thickness) {
        block = grid_highlight_color;
    }

    COLOR = texture(TEXTURE, UV) * BLOCK_COLORS[block];
}
