//
//  PhotoViewController.swift
//  CameraApp
//
//  Created by Rajesh Billakanti on 20/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            //creating an UIImagePickerController and set its delegate to AppViewController class. Kind of image picker to show, the camera with UIImagePickerControllerSourceTypeCamera
            let picker : UIImagePickerController = UIImagePickerController.init()
            picker.delegate = self
            //Allows photo resizing
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
    }

    @IBAction func selectPhoto(_ sender: UIButton) {
        print("Inside Select Photo")
        //creating an UIImagePickerController and set its delegate to AppViewController class. Kind of image picker to show, the camera with UIImagePickerControllerSourceTypePhotoLibrary
        let picker : UIImagePickerController = UIImagePickerController.init()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    //When the user takes a photo with the camera and resizes the image the didFinishPickingMediaWithInfo method is called. As the first argument we have the picker who called the method, something very useful if we have more than one image picker. The second argumentis a NSDictionary which contains, among other things, the original image and the edited image (accessible through the tag UIImagePickerControllerEditedImage).
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imageView.image = choosenImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

}
