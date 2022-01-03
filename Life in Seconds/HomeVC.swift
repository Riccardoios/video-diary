//
//  ViewController.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 22/12/21.
//

import UIKit
import MobileCoreServices

private let reuseIdentifier = "MyCell123"

class HomeVC: UIViewController, UICollectionViewDelegate {

    //MARK: - Calendar  and collection Properties
    private var sectionInsets = UIEdgeInsets(top: 70.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    private var itemsPerRow: CGFloat = 7
    
    let calendar = Calendar.current
    
    var selectedIndexPath: IndexPath?
    
    var baseDate: Date = Date()
    
    //objects
    var arrayMyData: [MyData] = [
        MyData(image: UIImage(systemName: "circle")!, date: Calendar.current.date(byAdding: .day, value: +1, to: Date())!),
        MyData(image: UIImage(systemName: "square")!, date: Calendar.current.date(byAdding: .day, value: +4, to: Date())!)
    ]

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
            self.getCurrentMonthArray(of: self.baseDate)
            self.getImageInArrayDayCell()
            self.addOffsetPreviuosMonth()
            
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
            self.getCurrentMonthArray(of: self.baseDate)
            self.getImageInArrayDayCell()
            self.addOffsetPreviuosMonth()
            
            self.collectionView.reloadData()
        })
    
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
//        view.addSubview(headerView)
        view.addSubview(footerView)
        
//        headerView.backgroundColor = .red
//        headerView.baseDate = baseDate
       
        
        getCurrentMonthArray(of: baseDate)
        getImageInArrayDayCell()
        addOffsetPreviuosMonth()
//        getTodaySelected()
        collectionView.reloadData()
        
        collectionView.backgroundColor = .green
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: (55.3 * 7) + 4 + sectionInsets.top ),
            
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 110),
//
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
        collectionView.reloadData()
        
//        DispatchQueue.main.async {
//            VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
//        }
    }
    
}

//MARK: UIImagePickerControllerDelegate
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
//        cell.layer.borderColor = UIColor.gray.cgColor
//        cell.layer.borderWidth = 1.0
        let day = arrayDayCell[indexPath.row].day
        cell.label.text = day
        
        
        if indexPath == selectedIndexPath {
            cell.label.textColor = .red
        } else {
            cell.label.textColor = .black
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
        
        selectedIndexPath = indexPath
        
        // reloadItems works with multiple indexpath so if you have 2 indexes it will reload them both
        
        collectionView.reloadItems(at: reloadIndexPaths)

    }
    
    
}

// MARK: - CALENDAR DATA GENERATION
extension HomeVC {
    
        func getCurrentMonthArray(of dateInput: Date) {
            
            func startOfDay(_ date: Date) -> Date {
                return calendar.startOfDay(for: date)
            }

            func endOfDay(_ date: Date) -> Date {
                let sD = startOfDay(date)
                return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: sD)!
            }
            
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
            for i in 0..<numberOfDaysInMonth {
                
                let nextDate = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth)!
                
                let element = DayCell(date: nextDate, image: nil)
                

                arrayDayCell.append(element)
            }

        }

        func getImageInArrayDayCell() {
            for x in 0..<arrayDayCell.count {
                let date1 = arrayDayCell[x].date
                
                for y in 0..<arrayMyData.count {
                    let date2 = arrayMyData[y].date
                    
                    let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
                    
                    switch order {
                    case .orderedSame:
                        arrayDayCell[x].image = arrayMyData[y].image
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
            // S M T W T F S
            // 0 1 2 3 4 5 6
            
            // get one month less and the last day
            if additionalDays >= 1 {
                
                for i in 1...additionalDays {
                    let datesPreviuosMonth = calendar.date(byAdding: .day, value: -(i), to: dateInput)!
                    var dayCell = DayCell(date: datesPreviuosMonth, image: nil)
                    dayCell.isGrayedout = true
                    
                    arrayDayCell.insert(dayCell, at: 0)
                }
            }
           
        }
    
    
}


