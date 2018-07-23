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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePickerVC.delegate = self
            imagePickerVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerVC.allowsEditing = true
            vc.present(imagePickerVC, animated: true, completion: nil)
            
            self.completion = completionHandler
        }
    }
    
    func openCameraOnViewController(vc:UIViewController,completionHandler:@escaping (_ file:Any?)->()){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePickerVC.delegate = self
            imagePickerVC.sourceType = UIImagePickerControllerSourceType.camera
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        if let editedFile = info[UIImagePickerControllerEditedImage]{
            self.completion(editedFile)
        }
        else if let originalFile = info[UIImagePickerControllerOriginalImage]{
            self.completion(originalFile)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
