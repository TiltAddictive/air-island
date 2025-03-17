shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_size : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 sum = vec4(0.0);

    // Размер одного пикселя (текселя), зависящий от blur_size
    vec2 texel_size = vec2(blur_size) / vec2(textureSize(SCREEN_TEXTURE, 0));

    // Простая 9-семпловая матрица размытия
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2(-1.0, -1.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 0.0, -1.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 1.0, -1.0));

    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2(-1.0,  0.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 0.0,  0.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 1.0,  0.0));

    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2(-1.0,  1.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 0.0,  1.0));
    sum += texture(SCREEN_TEXTURE, uv + texel_size * vec2( 1.0,  1.0));

    // Усреднение
    COLOR = sum / 9.0;
}
