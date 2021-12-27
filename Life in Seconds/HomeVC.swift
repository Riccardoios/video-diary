//
//  ViewController.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 22/12/21.
//

import UIKit
import MobileCoreServices

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    var selectedDate : ((Date) -> Void)
    
    
    @IBAction func calendarBtn(_ sender: UIButton) {
        let pickerController = CalendarPickerViewController(
          
          selectedDate: { [weak self] date in
          guard let self = self else { return }

         
          })

        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func captureLifeBtn(_ sender: AnyObject) {
       
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
}

extension HomeVC: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
  
    guard
      let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
      let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
      UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
    else {return }
    
    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
            
  }
  
  @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
    let title = (error == nil) ? "Success" : "Error"
    let message = (error == nil) ? "Video was saved" : "Video failed to save"
    
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    
    alert.view.layoutIfNeeded() // to make it faster to load
      
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
}

extension HomeVC: UINavigationControllerDelegate {
  
}




