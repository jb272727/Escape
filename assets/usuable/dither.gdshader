shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;
uniform sampler2D DITHER_TEXTURE; // Dither texture uniform

uniform float depth_range: hint_range(0.1, 100.0, 0.1);
uniform int dither_bit_depth = 4; // Bit depth for dithering
uniform float dither_contrast = 1.0; // Contrast adjustment for dithering
uniform float dither_offset = 0.0; // Offset adjustment for dithering
uniform int dither_size = 8; // Dither size for pixelation

void vertex() {
    POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Sample the color texture
    vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
    
    // Sample the dither texture
    vec2 dither_uv = UV * float(dither_size); // Adjust UV for dither texture
    float threshold = texture(DITHER_TEXTURE, dither_uv).r;
    
    // Calculate pixel luminosity from screen color
    float lum = (screen_color.r * 0.299) + (screen_color.g * 0.587) + (screen_color.b * 0.114);
    
    // Adjust with contrast and offset parameters
    lum = (lum - 0.5 + dither_offset) * dither_contrast + 0.5;
    lum = clamp(lum, 0.0, 1.0);
    
    // Reduce luminosity bit depth
    float bits = float(dither_bit_depth);
    lum = floor(lum * bits) / bits;
    
    // Apply dithering
    float final_lum = lum < threshold ? 0.0 : 1.0;
    
    // Output the final color by mixing original color with dithered effect
    vec3 final_color = mix(vec3(final_lum), screen_color, 1.0);
    
    ALBEDO = final_color;
}
