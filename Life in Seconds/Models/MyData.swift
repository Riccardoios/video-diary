//
//  MyData.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 01/01/22.
//

import UIKit

struct MyData: Codable {
    
    var date: Date
    var urlVideo: URL
    
    init(date: Date, urlVideo: URL) {
        self.date = date
        self.urlVideo = urlVideo
    }
    
    
}
