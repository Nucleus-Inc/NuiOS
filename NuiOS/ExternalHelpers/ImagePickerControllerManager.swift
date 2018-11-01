//
//  ImagesGalleryManager.swift
//   
//
//  Created by Nucleus on 05/01/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit

class ImagePickerControllerManager: NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var imagePickerVC = UIImagePickerController()
    
    fileprivate var completion:((_ file:Any?)->())!
    
    func openPhotoLibraryOnViewController(vc:UIViewController,completionHandler:@escaping (_ file:Any?)->()){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePickerVC.delegate = self
            imagePickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerVC.allowsEditing = true
            vc.present(imagePickerVC, animated: true, completion: nil)
            
            self.completion = completionHandler
        }
    }
    
    func openCameraOnViewController(vc:UIViewController,completionHandler:@escaping (_ file:Any?)->()){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePickerVC.delegate = self
            imagePickerVC.sourceType = UIImagePickerController.SourceType.camera
            imagePickerVC.cameraCaptureMode = .photo
            imagePickerVC.allowsEditing = true
            
            vc.present(imagePickerVC, animated: true, completion: nil)
            
            self.completion = completionHandler
        }
    }

    
    
    //MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        //print(info)
        if let editedFile = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)]{
            self.completion(editedFile)
        }
        else if let originalFile = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
            self.completion(originalFile)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
