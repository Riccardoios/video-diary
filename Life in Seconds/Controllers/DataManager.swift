//
//  DataManager.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 04/01/22.
//

import UIKit
import AVFoundation

class DataManager: NSObject {
    
    private(set) var arrayMyData : [MyData] = []
    
    private let fileURL: URL = { // url is a location of a source for a file it could be local as well
            let fileManager = FileManager.default // this is the instance already available
            let documentDirectories = fileManager.urls(for: .documentDirectory,
                                                       in: .userDomainMask)
        // this method gets a directory that is on the disk .documentDirectory (not cache and is located in the computer or device .userDomainMask)
        // the return value is an array of Urls
            let myDocumentDirectory = documentDirectories.first!
            let data = myDocumentDirectory.appendingPathComponent("data.json")
            print("Data file is \(data)")
            return data
    }()
    
    
    private func saveData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(arrayMyData)
            try data.write(to: fileURL)
            print ("Saved \(data.count) tasks to \(fileURL.path)")
        } catch {
            print ("could not save tasks, reason: \(error)")
        }
    }
    
    override init() {
        super.init()
        
        self.loadData()
    }
    
    func add(_ data: MyData) {
            arrayMyData.append(data)
            saveData()
    }
    
    func loadData(){
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            arrayMyData = try decoder.decode([MyData].self, from: data)
            print ("Loaded \(arrayMyData.count) tasks from \(fileURL.path)")
        } catch {
            print ("Did not loaded any tasks. reason: \(error)")
        }
    }

    
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
}
