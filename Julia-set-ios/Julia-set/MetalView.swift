//
//
//  MetalView.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 04/10/2021.
//

import MetalKit

class MetalView: MTKView {
    var commandQueue: MTLCommandQueue?
    var cps: MTLComputePipelineState?
    var compute: Julia?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
        

            self.framebufferOnly = false
            self.autoResizeDrawable = false
            self.contentMode = .scaleAspectFit
        
        render()
    }
    
    func render() {
        commandQueue = device!.makeCommandQueue()!
        compute = Julia(device: device!)
        
        guard let  library = device!.makeDefaultLibrary() else
        {
            print ("no metal")
            
            return
        }
        let kernel_func = library.makeFunction(name: "kernel_func")!
        cps = try! device!.makeComputePipelineState(function: kernel_func)
        self.framebufferOnly = false
    }
    
    override func draw() {
        super.draw()
        if let drawable = currentDrawable {
            compute!.uniform.a_i += i_delta
            compute!.uniform.a_r += r_delta
            r_delta = 0
            i_delta = 0
            compute!.compute(commandQueue: commandQueue!, pipelineState: cps!, drawable: drawable)
            
        }
    }
    
    var r_delta : Float = 0.0
    var i_delta : Float = 0.0
    
}

