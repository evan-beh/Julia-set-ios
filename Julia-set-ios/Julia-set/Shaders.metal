//
//
//  Shaders.metal
//  Julia-set-ios
//
//  Created by Evan Beh on 04/10/2021.
//


#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float cx, cy, scale, loop, a_r, a_i;
};

#define LINEAR(x, s, e) ((s) + ((e) - (s)) * (x))

kernel void kernel_func(texture2d<float, access::write> outTexture [[texture(0)]],
                        constant Uniforms &uniforms [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    int width = outTexture.get_width(), height = outTexture.get_height();
    float z_r = (float(gid.x) / width * 2.0 - 1.0 - uniforms.cx) / uniforms.scale;
    float z_i = (float(gid.y) / height * 2.0 - 1.0 - uniforms.cy) / uniforms.scale;
    int iter = 0;
    for (iter = 0; iter < uniforms.loop; iter++) {
        if (z_r * z_r + z_i * z_i > 4.0) break;
        // z * z + k
        float _r = z_r, _i = z_i;
        z_r = _r * _r - _i * _i + uniforms.a_r;
        z_i = 2 * _r * _i + uniforms.a_i;
    }
    float _color = (float)iter / uniforms.loop;
    float color = _color >= 1.0 ? 1.0 : _color;
    
    rint (_color);
    outTexture.write(float4(color,
                           0.00,
                            0.00,
                            1.0), gid);
    
    
}

