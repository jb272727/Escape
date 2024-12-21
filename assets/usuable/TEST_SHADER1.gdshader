shader_type canvas_item;

uniform int color_levels : hint_range(2, 256) = 8;
uniform float luminance_threshold : hint_range(0.0, 1.0) = 0.5;
shader_type canvas_item;

uniform int color_levels : hint_range(2, 256) = 8;
uniform float luminance_threshold : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec4 screen_tex = texture(screen_texture, UV);
    float luminance = dot(screen_tex.rgb, vec3(0.299, 0.587, 0.114));

    float factor = mix(float(color_levels), 256.0, smoothstep(luminance_threshold, 1.0, luminance));
    COLOR.rgb = floor(screen_tex.rgb * factor) / factor;
    COLOR.a = screen_tex.a;
}


void fragment() {
    vec4 screen_tex = texture(screen_texture, SCREEN_UV);
    float luminance = dot(screen_tex.rgb, vec3(0.299, 0.587, 0.114));

    float factor = mix(float(color_levels), 256.0, smoothstep(luminance_threshold, 1.0, luminance));
    COLOR.rgb = floor(screen_tex.rgb * factor) / factor;
    COLOR.a = screen_tex.a;
}
