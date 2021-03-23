//
//  ViewController.swift
//  DirectAPI-sample-Swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Microblink. All rights reserved.
//

import UIKit
import BlinkInput
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBINScanningRecognizerRunnerDelegate {
    
    var recognizerRunner: MBINRecognizerRunner?
    var pdf417Recognizer: MBINPdf417Recognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecognizerRunner()
    }

    @IBAction func openImagePicker(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        
        // Displays a control that allows the user to choose only photos
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        // Hides the controls for moving & scaling pictures, or for trimming movies.
        imagePicker.allowsEditing = false
        
        // Shows default camera control overlay over camera preview.
        imagePicker.showsCameraControls = true
        
        // set delegate
        imagePicker.delegate = self
        present(imagePicker, animated: true) {() -> Void in }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        
        if CFStringCompare(mediaType as CFString?, kUTTypeImage, CFStringCompareFlags(rawValue: 9)) == .compareEqualTo {
            let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            processImageRunner(originalImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func setupRecognizerRunner() {
        var recognizers = [MBINRecognizer]()
        pdf417Recognizer = MBINPdf417Recognizer()
        recognizers.append(pdf417Recognizer!)
        let recognizerCollection = MBINRecognizerCollection(recognizers: recognizers)
        recognizerRunner = MBINRecognizerRunner(recognizerCollection: recognizerCollection)
        recognizerRunner?.scanningRecognizerRunnerDelegate = self
    }
    
    func processImageRunner(_ originalImage: UIImage?) {
        var image: MBINImage? = nil
        if let anImage = originalImage {
            image = MBINImage(uiImage: anImage)
        }
        image?.cameraFrame = true
        image?.orientation = MBINProcessingOrientation.left
        let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
        _serialQueue.async(execute: {() -> Void in
            self.recognizerRunner?.processImage(image!)
        })
    }
    
    func recognizerRunner(_ recognizerRunner: MBINRecognizerRunner, didFinishScanningWith state: MBINRecognizerResultState) {
        DispatchQueue.main.async(execute: {() -> Void in
            let title = "PDF417"
            // Save the string representation of the code
            let message = self.pdf417Recognizer?.result.stringData
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.dismiss(animated: true) {() -> Void in }
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true) {() -> Void in }
        })
    }
}
