//
//  ViewController.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 22/12/21.
//

import UIKit
import MobileCoreServices
import PhotosUI
import MediaPlayer

private let reuseIdentifier = "MyCell123"

class HomeVC: UIViewController, UICollectionViewDelegate  {
    
  
    //MARK: - Calendar  and collection Properties
    private var sectionInsets = UIEdgeInsets(top: 70.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    private var itemsPerRow: CGFloat = 7
    
    let calendar = Calendar(identifier: .gregorian)
    
    var selectedIndexPath: IndexPath?
    
    var baseDate: Date = Date()
    
    //objects
    let dataManager = MyDataManger()
    let videoHelper = VideoHelper()

    var arrayDayCell: [DayCell] = [DayCell]()
    
    private lazy var footerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
            
            self.arrayDayCell = [DayCell]()
            self.selectedIndexPath = nil
            self.getCurrentMonthArray(of: self.baseDate)
            self.getImageInArrayDayCell()
            self.addOffsetPreviuosMonth()
            
            self.headerView.baseDate = self.baseDate
            
            self.collectionView.reloadData()
            
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
            
            self.arrayDayCell = [DayCell]()
            self.selectedIndexPath = nil
            
            self.getCurrentMonthArray(of: self.baseDate)
            self.getImageInArrayDayCell()
            self.addOffsetPreviuosMonth()
            
            self.headerView.baseDate = self.baseDate
            
            self.collectionView.reloadData()
        })
    
    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
      guard let self = self else { return }

      self.dismiss(animated: true)
    }
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(footerView)
        
        headerView.baseDate = baseDate
        
        loadTheData()
        
        print ("aaa" ,dataManager.arrayMyData.count)
        
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: (55.3 * 7) + 4 + sectionInsets.top ),
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 110),

            footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBAction func captureLifeBtn(_ sender: AnyObject) {
        
//        let url = URL(string: "/Users/riccardocarlotto/Library/Developer/CoreSimulator/Devices/EB802C77-E362-4B7A-AB48-582405143485/data/Containers/Data/Application/F38CF026-E63F-48A4-9510-44350A1E28C5/Documents/trim.E7789D18-6BEE-4100-8FDB-5F45CADAD92D.MOV")!
//
//        let image = dataManager.generateThumbnail(url: url)
//        print (image)
       
//        DispatchQueue.main.async {
//            VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
//        }
    }
    
    
    @IBAction func addVideoBtn(_ sender: UIButton) {
        
        if savedPhotosAvailable() {

            videoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
        
    }
    
    
}


// MARK: - UINavigationControllerDelegate

extension HomeVC: UINavigationControllerDelegate {
  
}


// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayDayCell.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCell
    
        cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)

        cell.layer.cornerRadius = 10.0
        
        let day = arrayDayCell[indexPath.row].day
        cell.label.text = day
        
        
        if let img: UIImage = arrayDayCell[indexPath.row].image {
            cell.imageView.image = img
            cell.label.backgroundColor = .gray
        } else {
            cell.imageView.image = nil
            cell.label.backgroundColor = nil
        }
        
        if indexPath == selectedIndexPath {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
        }
    
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC : UICollectionViewDelegateFlowLayout {
 
    // the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // here we need a calculation that guartee the size of the cells to be evenly placed in any screen otherwise simply return a Square CGSize
//        let totalGapSizeInOneRow = sectionInsets.left * (itemsPerRow + 1)
//        // the padding on the left four times ( because we have 7 cells so 8 gaps )
//        let availableWidthForAllCells = view.frame.width - totalGapSizeInOneRow
//        let widthPerCell = availableWidthForAllCells / itemsPerRow
        
        // get the cell all touching each other
        let width = collectionView.bounds.width/7.5
        let height = width
        
        
        return CGSize(width: width, height: height)
    }
    
    // the insets of the collectionView (the padding)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
//
//    //spacing from section to section
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//      return sectionInsets.left
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        var reloadIndexPaths = [indexPath]
        
        if let deselectIndexPath = selectedIndexPath {
            reloadIndexPaths.append(deselectIndexPath)
        }
        
        baseDate = arrayDayCell[indexPath.row].date
        
        selectedIndexPath = indexPath
        
        // reloadItems works with multiple indexpath so if you have 2 indexes it will reload them both
        print("basedate",baseDate)
        print ("img", arrayDayCell[indexPath.row].image)
        collectionView.reloadItems(at: reloadIndexPaths)

    }
    
    
}

// MARK: - CALENDAR DATA GENERATION
extension HomeVC {
    
        func loadTheData() {
            
            arrayDayCell = [DayCell]()
            
            getCurrentMonthArray(of: baseDate)
            getImageInArrayDayCell()
            addOffsetPreviuosMonth()
    //        getTodaySelected()
            collectionView.reloadData()
        }
    
        func getCurrentMonthArray(of dateInput: Date) {
            
           //get number of days in the month
            guard

            let numberOfDaysInMonth = calendar.range(
              of: .day,
              in: .month,
              for: dateInput)?.count,

            let firstDayOfMonth = calendar.date(
              from: calendar.dateComponents([.year, .month], from: dateInput))

            else {
                fatalError("calendar generation fatal error")
            }
            for i in 0...numberOfDaysInMonth {
                
                let nextDate = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth)!
                
                let element = DayCell(date: nextDate, image: nil)

                arrayDayCell.append(element)
            }

        }

        func getImageInArrayDayCell() {
            for x in 0..<arrayDayCell.count {
                let date1 = arrayDayCell[x].date
                
                for y in 0..<dataManager.arrayMyData.count {
                    let date2 = dataManager.arrayMyData[y].date
                    
                    let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
                    
                    switch order {
                    case .orderedSame:
//                        let url = dataManager.arrayMyData[y].urlVideo
//                        let image = self.dataManager.generateThumbnail(path: url)
//                        arrayDayCell[x].image = image
                        let nameVideo = dataManager.arrayMyData[y].nameVideo
                        
                        let image =  self.dataManager.generateThumbnail(fromMovie: nameVideo)
                        arrayDayCell[x].image = image
                        
//                        loadTheData()
                        
                    default: break
                    }
                }
            }
        }

        func getTodaySelected() {
            let today = Date()

            let dF = DateFormatter()

            dF.dateFormat = "dd"
            let day = dF.string(from: today)

            dF.dateFormat = "MMMM"
            let month = dF.string(from: today)

            dF.dateFormat = "yyyy"
            let year = dF.string(from: today)


            if
            arrayDayCell.isEmpty == false &&
                arrayDayCell[0].year == year &&
                arrayDayCell[0].month == month &&
                arrayDayCell[(Int(day)!-1)].day == day {
                
                //find the index where
//                let rightIndex: IndexPath = IndexPath(row: (Int(day)!-1)+additionalDays, section: 0)
//
//                selectedIndexPath = rightIndex
//                collectionView.reloadItems(at: [rightIndex])
            }
            
            
            

        }


        func addOffsetPreviuosMonth() {
            guard !arrayDayCell.isEmpty else {return}
            
            let dateInput = arrayDayCell.first!.date
            
            let firstDayOfMonth = calendar.date(
              from: calendar.dateComponents([.year, .month], from: dateInput))
            
            let additionalDays = calendar.component(.weekday, from: firstDayOfMonth!) - 1
            print (additionalDays, "additionalDays")
            // we want to get this
            // S M T W T F S
            // 0 1 2 3 4 5 6
            
            // get one month less and the last day
            if additionalDays >= 1 {
                
                for i in 1..<additionalDays {
                    let datesPreviuosMonth = calendar.date(byAdding: .day, value: -(i), to: dateInput)!
                    var dayCell = DayCell(date: datesPreviuosMonth, image: nil)
                    dayCell.isGrayedout = true
                    
                    arrayDayCell.insert(dayCell, at: 0)
                }
            }
           
        }
    
    
}


//MARK: - savedPhotosAvailable
extension HomeVC {
    
    func savedPhotosAvailable() -> Bool {
      guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        else { return true }

      let alert = UIAlertController(
        title: "Not Available",
        message: "No Saved Album found",
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
      present(alert, animated: true, completion: nil)
      return false
    }
}

//MARK: - MyData Generation
extension HomeVC {
    
//    func generateThumbnail(path: URL) -> UIImage? {
//        do {
//            let asset = AVURLAsset(url: path, options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
}

//MARK: UIImagePickerControllerDelegate
extension HomeVC: UIImagePickerControllerDelegate {
  
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    dismiss(animated: true, completion: nil)
//
//    guard
//      let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
//      let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
//      UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
//    else {return }
//
//    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
//
//  }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      dismiss(animated: true, completion: nil)

      guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
        mediaType == (kUTTypeMovie as String),
        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }

//      let avAsset = AVAsset(url: url)
      var message = "yo"
        
        
        if selectedIndexPath != nil {
            
            //save video in file manager and the new url in the array
            dataManager.saveVideoInDocuments(url: url, date: baseDate)
            
            
            
            
            
        }
//      if loadingAssetOne {
//        message = "Video one loaded"
//        firstAsset = avAsset
//      } else {
//        message = "Video two loaded"
//        secondAsset = avAsset
//      }
      let alert = UIAlertController(
        title: "Asset Loaded",
        message: message,
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
        
        print ("dataManager.arrayMyData", dataManager.arrayMyData)
      present(alert, animated: true, completion: loadTheData)
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
