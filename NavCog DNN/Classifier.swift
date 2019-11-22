//
//  Classifier.swift
//  NavCog DNN
//
//  Created by Vivek Roy on 11/22/19.
//  Copyright © 2019 Vivek Roy. All rights reserved.
//

import Foundation
import TensorFlowLite


func argmax(probs : [Float]) -> Int {
    var maxProb = Float(0.0)
    var maxInd = -1
    for i in 0..<probs.count {
        if probs[i] > maxProb {
            maxProb = probs[i]
            maxInd = i
        }
    }
    return maxInd
}

class Result {
    let number : Int
    let timeCost : Int
    let prob : Float

    init(probs : [Float], time: Float) {
        number = argmax(probs: probs)
        timeCost = Int(time)
        prob = probs[number]
    }
}


class Classifier {
    private var tflite : Interpreter?
    init() {
        do {
            tflite = try Interpreter(modelPath: Bundle.main.path(forResource: "mnist", ofType: ".tflite")!)
            try tflite?.allocateTensors()
        } catch let error {
            print("Failed to create the interpreter with error: \(error.localizedDescription)")
        }
    }
    
    func classify(image: UIImage) -> Result? {
        var pb : CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, 28, 28, kCVPixelFormatType_OneComponent8, nil, &pb)
        let cgImg = image.cgImage
        let ciImg = CIImage(cgImage: cgImg!)
        let context = CIContext()
        context.render(ciImg, to: pb!, bounds: CGRect(x: 0, y: 0, width: 28, height: 28), colorSpace: cgImg?.colorSpace)
        if let buffer = pb {
            if let data = bufferToData(buffer: buffer, byteCount: 28*28) {
                do {
                    try tflite?.copy(data, toInputAt: 0)
                } catch let error {
                    print("Failed to copy data. Error: \(error.localizedDescription)")
                }
                do {
                    let startDate = Date()
                    try tflite?.invoke()
                    let interval = Float(Date().timeIntervalSince(startDate) * 1000)
                    let outputTensor = try tflite?.output(at: 0)
                    if let outData = outputTensor?.data {
                        let results = outData.withUnsafeBytes { (pointer: UnsafePointer<Float32>) -> [Float32] in
                            let outBufferPointer = UnsafeBufferPointer(start: pointer, count: 10)
                            return Array<Float32>(outBufferPointer)
                        }
                        return Result(probs: results, time: interval)
                    }
                } catch let error {
                    print("Failed to run model. Error: \(error.localizedDescription)")
                }
            }
        }
        return nil
    }

    func bufferToData(buffer: CVPixelBuffer, byteCount : Int) -> Data? {
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        guard let mutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else { return nil }
        let count = CVPixelBufferGetDataSize(buffer)
        let bufferData = Data(bytesNoCopy: mutableRawPointer, count: count, deallocator: .none)
        var bytes = [UInt8](repeating: 0, count: byteCount)
        var index = 0
        var index2 = 0
        for component in bufferData.enumerated() {
          if index2 % 64 < 28 {
            bytes[index] = component.element
            index += 1
          }
          index2 += 1
        }
        return Data(bytes: bytes.map { Float($0) }, count: byteCount*4)
    }
}
