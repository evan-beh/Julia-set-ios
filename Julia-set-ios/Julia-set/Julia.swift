//
//
//  Julia.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 04/10/2021.
//


import MetalKit

struct Uniforms : Codable{
    var cx, cy, scale, loop, a_r, a_i : Float;
    
    func floatBuffer() -> [Float] {
        return [cx, cy, scale, loop, a_r, a_i, 0.0, 0.0]
    }
};

class Julia {
    let threadGroups: MTLSize
    let threadGroupCount: MTLSize
    let N = 1536
    let device: MTLDevice
    var uniform: Uniforms
    
    init(device: MTLDevice) {
        self.device = device
        threadGroupCount = MTLSizeMake(8, 8, 1)
        threadGroups = MTLSizeMake(N / 8, N / 8, 1)
        self.uniform = Uniforms(cx: 0, cy: 0, scale: scale, loop: loop, a_r:0 , a_i: 0)
    }
    
    func compute(commandQueue: MTLCommandQueue, pipelineState: MTLComputePipelineState, drawable: CAMetalDrawable) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeComputeCommandEncoder()!
        let uniformBuffer = device.makeBuffer(bytes: uniform.floatBuffer(), length: 8 * MemoryLayout<Float>.size)!
        renderEncoder.setComputePipelineState(pipelineState)
        renderEncoder.setBuffer(uniformBuffer, offset: 0, index: 0)
        renderEncoder.setTexture(drawable.texture, index: 0)
        renderEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
