shader_type canvas_item;


uniform float pixel_size : hint_range(1.0, 128.0) = 1.0;
uniform float fade : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {

	vec2 screen_res = vec2(textureSize(screen_texture, 0));
	vec2 size = screen_res / max(pixel_size, 1.0);
	

	vec2 grid_uv = floor(SCREEN_UV * size) / size;
	

	vec4 color = texture(screen_texture, grid_uv);
	

	COLOR = mix(color, vec4(0.0, 0.0, 0.0, 1.0), fade);
}