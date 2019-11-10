//
//  ImageClassificationModel.swift
//  Core ML SwiftUI
//
//  Created by Dmitry Novosyolov on 10/11/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

final class ImageClassificationModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var classificationText: String = ""
    
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        
        do {
            let model = try VNCoreMLModel(for: Resnet50().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func updateClassification() {
        
        self.classificationText = "Classifying..."
        let orientation = CGImagePropertyOrientation(self.image!.imageOrientation)
        guard let ciImage = CIImage(image: self.image!) else { fatalError("Unable to create \(CIImage.self) from \(String(describing: image))!")}
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else { self.classificationText = "Unable to classify image.\n\(error!.localizedDescription)"; return }
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.classificationText = "Nothing recognized!"
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "%.2f %@", classification.confidence, classification.identifier)
                }
                self.classificationText = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
}

