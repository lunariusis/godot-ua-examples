shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0, 0.1) = 4.0;

void fragment() {
	vec2 offset_size = TEXTURE_PIXEL_SIZE * (outline_width / 2.0);
	vec4 color = texture(TEXTURE, UV);

	float dilated_alpha = 0.0;
	float eroded_alpha = 1.0;

	for (int i = -1; i <= 1; i++) {
		for (int j = -1; j <= 1; j++) {
			if (i == 0 && j == 0) {
				continue;
			}
			
			vec2 offset = normalize(vec2(float(i), float(j)));
			float sample_alpha = texture(TEXTURE, UV + offset_size * offset).a;
			
			dilated_alpha = max(dilated_alpha, sample_alpha);
			eroded_alpha = min(eroded_alpha, sample_alpha);
		}
	}

	float outline_alpha = dilated_alpha - eroded_alpha;
	vec4 final_color = mix(color, outline_color, outline_alpha);
	final_color.a = max(color.a, outline_alpha);

	COLOR = final_color;
}