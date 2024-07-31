//  
//  PokemonScannerViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import UIKit
import AVFoundation

final class PokemonScannerViewController: UIViewController, ClassificationControllerDelegate {
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonScannerViewModel(delegate: self)
    
    private lazy var router: PokemonScannerRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonScannerRouter(with: navigationController)
    }()
    
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var capturePhotoOutput: AVCapturePhotoOutput!
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Capture", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var classificationController = ClassificationController(delegate: self)
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupInterface()
        setupConstraints()
        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().async { [captureSession] in
            captureSession?.startRunning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Setup Methods
    
    private func setupInterface() {
        view.addSubview(captureButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 100),
            captureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("Unable to access back camera!")
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        
        captureSession.addInput(input)
        captureSession.addOutput(capturePhotoOutput)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    // MARK: - Actions
    
    @objc private func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: - ClassificationControllerDelegate
    
    func didFinishClassification(_ classification: (String, Float)) {
        let message = String(format: "It's a %@ with confidence %.2f%%", classification.0, classification.1 * 100)
        #warning("aqui persiste")
        caughtPokemons.insert(classification.0.lowercased())
        let alertController = UIAlertController(title: "Match Found", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension PokemonScannerViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        classificationController.updateClassifications(for: image)
    }
}

// MARK: - PokemonScannerDelegate

extension PokemonScannerViewController: PokemonScannerDelegate {}

// MARK: - Navigation

extension PokemonScannerViewController {
    
    func prepareForNavigation(with navigationData: PokemonScannerNavigationData) {
        viewModel.prepareForNavigation(with: navigationData)
    }
}


import UIKit
import CoreML
import Vision
import ImageIO

class ClassificationController {
    
    let delegate: ClassificationControllerDelegate!
    
    init(delegate: ClassificationControllerDelegate) {
        self.delegate = delegate
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // Use the generated swift file from CoreML of Pokemon Classifier
            let model = try VNCoreMLModel(for: PokemonClassifier2().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to Load Pokemon ML Model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("UNABLE TO CLASSIFY IMAGE \n \(error!.localizedDescription)")
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                print("NOTHING RECOGNIZED")
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                let description = (classifications.first!.identifier, classifications.first!.confidence)
                print("Classification: \(descriptions.joined(separator: "\n"))")
                self.delegate.didFinishClassification(description)
            }
        }
    }

}

protocol ClassificationControllerDelegate {
    func didFinishClassification(_ classification: (String, Float))
}


#warning("temporario")

var caughtPokemons: Set<String> = []
