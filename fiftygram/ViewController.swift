//
//  ViewController.swift
//  fiftygram
//
//  Created by Sanket singla on 28/08/20.
//  Copyright © 2020 Sanket singla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet var imageView : UIImageView!
    let context = CIContext()
    var original: UIImage?
    
    @IBAction func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate=self
            picker.sourceType = .photoLibrary
            navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        navigationController?.dismiss(animated: true , completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
    
    @IBAction func applyNoir() {
        if original == nil {
            return
        }
        let filter  = CIFilter(name: "CIPhotoEffectNoir")
        display(filter: filter!)
        
    }
    
    @IBAction func applyVintage() {
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        display(filter: filter!)
        
    }
    
    func display(filter:  CIFilter) {
        filter.setValue( CIImage(image: original!), forKey: kCIInputImageKey)
        let output = filter.outputImage
        imageView.image = UIImage(cgImage: self.context.createCGImage(output! , from: output!.extent)!)
    }
    
    @IBAction func applySepia() {
        if original == nil {
            return
        }
        
        let filter  = CIFilter(name: "CISepiaTone")
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }
    
    @IBAction func applyMonocrom() {
        if original == nil {
            return
        }
        
        let filter  = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(CIColor(red: 0, green: 0, blue: 1), forKey: kCIInputColorKey)
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }
    
    @IBAction func applyMono() {
        if original == nil {
            return
        }
        
        let filter  = CIFilter(name: "CIPhotoEffectMono")
        display(filter: filter!)
    }
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

