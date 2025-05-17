//
//  JournalVideoManger.swift
//
//
//  Created by Riccardo Carlotto on 21/03/2021.
//

import AVFoundation
import UIKit

let myFile_json = "myFile.json"

class JournalVideoManger {

    static var shared = JournalVideoManger()

    private(set) var journalVideos: [JournalVideo] = []

    private(set) var mergedVideos: [URL]? = []

    var startDate: Date!
    var endDate: Date!
    var isForMerging = false
    var arrSelection: [IndexPath] = []

    init() {
        loadArrayMyData()
        getMergedVideo()
    }

    func nameFileURL(_ name: String) -> URL {
        // url is a location of a source for a file it could be local as well
        let fileManager = FileManager.default  // this is the instance already available
        let documentDirectories = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask)
        // this method gets a directory that is on the disk .documentDirectory (not cache and is located in the computer or device .userDomainMask)
        // the return value is an array of Urls
        let myDocumentDirectory = documentDirectories.first!
        let fileURL = myDocumentDirectory.appendingPathComponent(name)
        print("file path in documets: \(fileURL)")
        return fileURL
    }

    func add(_ task: JournalVideo) {
        journalVideos.append(task)
        saveArrayMyData()
    }

    func remove(_ task: JournalVideo) {
        guard let index = journalVideos.firstIndex(of: task) else { return }
        journalVideos.remove(at: index)
        saveArrayMyData()
    }

    private func saveArrayMyData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(journalVideos)
            try data.write(to: nameFileURL(myFile_json))
            print(
                "Saved \(journalVideos.count) tasks to \(nameFileURL("").path)")
        } catch {
            print("could not save tasks, reason: \(error)")
        }
    }

    private func loadArrayMyData() {
        do {
            let data = try Data(contentsOf: nameFileURL(myFile_json))
            let decoder = JSONDecoder()
            journalVideos = try decoder.decode([JournalVideo].self, from: data)
            print(
                "Loaded \(journalVideos.count) tasks from \(nameFileURL("").path)"
            )
        } catch {
            print("Did not loaded any tasks. reason: \(error)")
        }
    }

    func saveVideoInDocuments(url: URL, date: Date) {

        let nameMovieWithExtension = url.lastPathComponent

        let fileURL = nameFileURL(nameMovieWithExtension)

        //target url creates the name of this file ( which is the video copied from the library) and it will be the place to save/load this video
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                print("the movie already exist it was repalced", fileURL)
                // if the video there is already in documents then delete that video
            }
            try FileManager.default.copyItem(at: url, to: fileURL)
            //copy video in the target url
            print("the movie is saved in \(fileURL.path)")

            DispatchQueue.main.async {

                print("aaa i'm saving this url to arraymydata \(fileURL)")

                self.remove(
                    JournalVideo(date: date, nameVideo: nameMovieWithExtension))
                self.add(
                    JournalVideo(date: date, nameVideo: nameMovieWithExtension))

            }
        } catch {
            print("error saving movie in documents \(error)")
        }

    }

    func generateThumbnail(
        fromMovie: String, orInMergedMovies: Bool = false,
        urlMergedVideo: String? = nil
    ) -> UIImage? {

        let url: URL

        if orInMergedMovies == false {
            url = nameFileURL(fromMovie)
        } else {

            let nameDir = nameFileURL("mergedVideos")
            guard let urlMergedV = urlMergedVideo else { return nil }
            let nameVideo = nameDir.appendingPathComponent(urlMergedV)

            url = nameVideo
        }

        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try imageGenerator.copyCGImage(
                at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error on generating Thumbnail \(error)")
            return nil
        }

    }

    func getUrlsVideo(start: Date, end: Date) -> [URL]? {

        var arrVideoUrls: [URL]? = []

        let documentDir = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)[0]

        for i in 0..<journalVideos.count {

            if journalVideos[i].date >= start && journalVideos[i].date <= end {
                let url = documentDir.appendingPathComponent(
                    journalVideos[i].nameVideo)
                arrVideoUrls?.append(url)
            }
        }

        return arrVideoUrls

    }

    func getMergedVideo() {

        let fileManager = FileManager.default
        let nameDir = nameFileURL("mergedVideos")

        do {
            // guard directory already exist
            if fileManager.fileExists(atPath: nameDir.path) {

                //                let videosStringsURL = try fileManager.contentsOfDirectory(atPath: nameDir.path)

                mergedVideos = try fileManager.contentsOfDirectory(
                    at: nameDir, includingPropertiesForKeys: nil,
                    options: .producesRelativePathURLs)

            } else {

                try fileManager.createDirectory(
                    at: nameDir, withIntermediateDirectories: true)
            }

        } catch {
            print(error)
        }

    }

}

#if DEBUG

    extension JournalVideoManger {
        static var sample: JournalVideoManger = {
            let sampleArray = [
                JournalVideo(
                    date: Date().addingTimeInterval(100), nameVideo: "adfafda"),
                JournalVideo(
                    date: Date().addingTimeInterval(100), nameVideo: "adfafda"),
                JournalVideo(
                    date: Date().addingTimeInterval(100), nameVideo: "adfafda"),
            ]

            let store = JournalVideoManger()
            store.journalVideos = sampleArray
            return store
        }()
    }

#endif  // ensure that your sample data does not accidentally ship if you distribute your app to the App Store, just for debug with simulator and canvas
