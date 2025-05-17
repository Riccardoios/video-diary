//
//  MergingButton.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 13/01/22.
//

import UIKit

class MergingButton: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var wheel: UIActivityIndicatorView!
    
    let merger = MergeExport.shared
    let dataManager = JournalVideoManger.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        //this init is used to load this view programmatically
        super.init(coder: coder)
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        
        dataManager.isForMerging = true
        
        NotificationCenter.default.post(name: .setLabelToSelectStart, object: nil)
        
//        guard let urls = dataManager.getUrlsVideo(start: dataManager.startDate, end: dataManager.endDate) else {return}

//        icon.isHidden = true
//        wheel.startAnimating()

//        merger.videoURLS = urls
        
//        dataManager.isForMerging = false
        
//        merger.mergeAndExportVideo()
        
        
        
    }
    
    
    
    
    
    
}
