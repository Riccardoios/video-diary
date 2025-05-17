//
//  JournalVideo.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 01/01/22.
//

import UIKit
import AVFoundation

struct JournalVideo: Codable, Equatable, Identifiable {
    
    var id: UUID
    var date: Date
    var nameVideo: String
    
    init(date: Date, nameVideo: String) {
        self.id = UUID()
        self.date = date
        self.nameVideo = nameVideo
    }
    
    
}
