shader_type canvas_item;

uniform sampler2D color_texture: hint_default_black;
uniform vec2 scroll1 = vec2(0.0, 0.1);
uniform vec2 scroll2 = vec2(0.1, 0.2);

void fragment() {
	float texture_color_1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float texture_color_2 = texture(TEXTURE, UV + scroll2 * TIME).r;
	float energy = texture_color_1 * texture_color_2 - (1.0 - UV.y) * 0.7 + 0.1;
	vec4 final_color = texture(color_texture, vec2(energy));
	COLOR = final_color;
}
