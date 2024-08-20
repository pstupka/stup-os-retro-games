shader_type canvas_item;

uniform vec4 color: source_color;
uniform float mix_intensity: hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
		COLOR.rgb = mix(COLOR.rgb, color.rgb, mix_intensity);

}
