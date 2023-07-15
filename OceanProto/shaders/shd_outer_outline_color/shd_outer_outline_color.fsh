varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texelSize;
uniform vec3 u_color;

void main()
{
    vec2 offsetX = vec2(u_texelSize.x, 0.0);
    vec2 offsetY = vec2(0.0, u_texelSize.y);
    
    bool isBorder = 
        texture2D(gm_BaseTexture, v_vTexcoord).a <= 0.0
    && (texture2D(gm_BaseTexture, v_vTexcoord + offsetX).a > 0.0
     || texture2D(gm_BaseTexture, v_vTexcoord - offsetX).a > 0.0
     || texture2D(gm_BaseTexture, v_vTexcoord + offsetY).a > 0.0
     || texture2D(gm_BaseTexture, v_vTexcoord - offsetY).a > 0.0);
    
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
    if (isBorder) {
    	color.rgb = u_color;
    	color.a = v_vColour.a;
    }
    gl_FragColor = color;
}
