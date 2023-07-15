//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int u_color;

vec3 hexColorToVec(int hexColor)
{
    float fHexColor = float(hexColor);
    vec3 color;
    color.b = floor(fHexColor / 65536.0);
    color.g = floor((fHexColor - color.b * 65536.0) / 256.0);
    color.r = floor(fHexColor - color.b * 65536.0 - color.g * 256.0);
    return color / 256.0;
}

void main()
{
    vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    color.rgb = hexColorToVec(u_color);
    gl_FragColor = color;
}
