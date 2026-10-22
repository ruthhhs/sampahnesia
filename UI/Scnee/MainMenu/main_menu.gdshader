shader_type canvas_item;

uniform float blur_strength : hint_range(0.0, 1.0) = 0.25;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

    vec4 color = vec4(0.0);

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_strength, -blur_strength) * pixel_size);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -blur_strength) * pixel_size);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_strength, -blur_strength) * pixel_size);

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_strength, 0.0) * pixel_size);
    color += texture(SCREEN_TEXTURE, SCREEN_UV);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_strength, 0.0) * pixel_size);

    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_strength, blur_strength) * pixel_size);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, blur_strength) * pixel_size);
    color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_strength, blur_strength) * pixel_size);

    COLOR = color / 9.0;
}