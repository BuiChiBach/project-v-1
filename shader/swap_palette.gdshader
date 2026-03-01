shader_type canvas_item;

uniform sampler2D original_palette;
uniform sampler2D new_palette;
uniform int colors_count;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    bool found = false;
    vec2 new_uv = vec2(0.0, 0.5);
    
    if (color.a > 0.0) {
        for (int i = 0; i < colors_count; i++) {
            float u = (float(i) + 0.5) / float(colors_count);
            vec2 uv = vec2(u, 0.5);
            vec4 original_palette_color = texture(original_palette, uv);
            float dist = distance(color.rgb, original_palette_color.rgb);

            if (dist < 0.01) {
                new_uv = uv;
                found = true;
                break;
            }
        }
    }
    
    if (found) {
        COLOR = texture(new_palette, new_uv);
    } else {
        COLOR = color;
    }
}