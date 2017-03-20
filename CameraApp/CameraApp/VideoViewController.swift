//
//  VideoViewController.swift
//  CameraApp
//
//  Created by Rajesh Billakanti on 20/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
//import AVFoundation
import AVKit

class VideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var videoURL : URL?
    var videoController : AVPlayerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func captureVideo(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            //creating an UIImagePickerController and set its delegate to AppViewController class. Kind of image picker to show, the camera with UIImagePickerControllerSourceTypeCamera
            let picker : UIImagePickerController = UIImagePickerController.init()
            picker.delegate = self
            //Allows photo resizing
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //Depending on the media types, the picker displays different interface for photos or videos. By default the media type is set to kUTTypeImage, which designates the photo camera interface. As we need the picker to launch the video capture interface, we set the media type to kUTTypeMovie.
            picker.mediaTypes = [kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.videoURL = info[UIImagePickerControllerMediaURL] as? URL
        picker.dismiss(animated: true, completion: nil)
        
        self.videoController = AVPlayerViewController.init()
        let player = AVPlayer(url: self.videoURL!)
        self.videoController?.player = player
        self.videoController?.view.frame = CGRect(x: 0, y: 0, width: 320, height: 460)
        self.view.addSubview((self.videoController?.view)!)
        NotificationCenter.default.addObserver(self, selector:#selector(videoPlayBackDidFinish) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoController)
        player.play()
    }
    
    func videoPlayBackDidFinish(notification:NSNotification){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.videoController?.player?.pause()
        self.videoController?.player = nil
        self.videoController?.view.removeFromSuperview()
        let alertController = UIAlertController(title: "Video Playback", message: "Just finished the video playback. The video is now removed.", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
