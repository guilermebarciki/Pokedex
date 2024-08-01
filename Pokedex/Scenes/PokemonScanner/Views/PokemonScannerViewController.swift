//
//  PokemonScannerViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 30/07/24.
//

import UIKit
import AVFoundation

final class PokemonScannerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonScannerViewModel(delegate: self)
    
    private lazy var router: PokemonScannerRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonScannerRouter(with: navigationController)
    }()
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        captureSession.addOutput(capturePhotoOutput)
        return captureSession
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        return videoPreviewLayer
    }()
    
    private var capturePhotoOutput: AVCapturePhotoOutput = {
        let capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        return capturePhotoOutput
    }()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Capture", for: .normal)
        button.setImage(UIImage(named: "pokeball"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    
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
            captureSession.startRunning()
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
            captureButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCamera() {
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            showAlert(message: "Unable to access back camera!")
            return
        }
        captureSession.addInput(input)
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    
    // MARK: - Actions
    
    @objc private func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
}


// MARK: - PokemonScannerViewModelDelegate

extension PokemonScannerViewController: PokemonScannerViewModelDelegate {
    
    func didFinishClassification(identifier: String, confidence: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            let message = String(format: "It's a %@ with confidence %.2f%%", identifier, confidence * 100)
            self?.showAlert(title: "Match Found", message: message, action: {
                self?.viewModel.savePokemon(pokemonName: identifier)
            })
        }
    }
    
    func didFailClassification(error: PokemonScannerError) {
        hideLoadingIndicator()
        showAlert(message: error.localizedDescription)
    }
    
}


// MARK: - AVCapturePhotoCaptureDelegate

extension PokemonScannerViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        showLoadingIndicator()
        viewModel.updateClassifications(for: image)
    }
}

