shader_type spatial;
render_mode specular_schlick_ggx, cull_back, depth_draw_opaque;

// --- MATERIAL PROPERTIES ---
group_uniforms Material;
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float roughness : hint_range(0.0, 1.0) = 0.8;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;

// --- GLOBAL WIND PROPERTIES ---
group_uniforms Wind;
uniform vec2 wind_direction = vec2(1.0, 0.5);
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wind_strength : hint_range(0.0, 2.0) = 0.2;
uniform float wind_turbulence : hint_range(0.0, 5.0) = 1.0;
uniform float height_offset : hint_range(-5.0, 5.0) = 0.0;

// --- PER-INSTANCE VARIATION ---
instance uniform float instance_random_offset : hint_range(0.0, 100.0) = 0.0;

void vertex() {
    // 1. Ubah koordinat lokal ke World Space
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    vec2 norm_wind_dir = normalize(wind_direction);
    float time = TIME * wind_speed;
    
    // 2. Hitung offset gerakan angin
    float position_offset = (world_pos.x + world_pos.z + instance_random_offset) * wind_turbulence;
    float height_mask = max(0.0, VERTEX.y - height_offset);
    
    // 3. Gelombang angin
    float main_wave = sin(time + position_offset);
    float detail_wave = cos(time * 1.8 + position_offset * 2.5) * 0.3;
    float total_sway = (main_wave + detail_wave) * wind_strength * height_mask;
    
    // 4. Terapkan deformasi vertex
    VERTEX.x += norm_wind_dir.x * total_sway;
    VERTEX.z += norm_wind_dir.y * total_sway;
}

void fragment() {
    vec4 albedo_tex = texture(texture_albedo, UV);
    ALBEDO = albedo.rgb * albedo_tex.rgb;
    METALLIC = metallic;
    ROUGHNESS = roughness;
}