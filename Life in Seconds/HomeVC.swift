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
    
//    var dayInMonth = Array(1...31)
    
    private var baseDate: Date = Date() {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            myCollectionView.reloadData()
            
            self.headerView.monthLabel.text = monthYearFormatter.string(from: baseDate)
            
        }
        
        
    }
    
    private let calendar: Calendar = Calendar(identifier: .gregorian)
    
    private lazy var days = generateDaysInMonth(for: baseDate)
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private lazy var monthYearFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.locale = Locale.autoupdatingCurrent
      dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
      return dateFormatter
    }()
    
    private var selectedDate: Date = Date()
    // MARK: - SUBVIEWS
    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
      guard let self = self else { return }

      self.dismiss(animated: true)
    }
    
    private lazy var footerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        })
    
    
    
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        view.addSubview(headerView)
        view.addSubview(footerView)
        
        headerView.backgroundColor = .red
        headerView.baseDate = baseDate
        
        myCollectionView.backgroundColor = .green
        
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
            
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            myCollectionView.heightAnchor.constraint(equalToConstant: (55.3 * 7) + 4 + sectionInsets.top ),
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 110),
            
            footerView.leadingAnchor.constraint(equalTo: myCollectionView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: myCollectionView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        
    }
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    @IBAction func captureLifeBtn(_ sender: AnyObject) {
        DispatchQueue.main.async {
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
        }
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
        return days.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCell
    
        cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
//        cell.layer.borderColor = UIColor.gray.cgColor
//        cell.layer.borderWidth = 1.0
        let day = days[indexPath.row]
        cell.label.text = day.number
        
        if day.number == "5" && headerView.monthLabel.text == "December 2021"{
            cell.label.backgroundColor = .yellow
            
        }
        // Configure the cell
    
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
        print (days[indexPath.row].number + " was selected")
        
    }
    
    
}

// MARK: - CALENDAR DATA GENERATING
extension HomeVC {
    
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
        
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    
    
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("an Error has occured when generating the metadata for base date")
        }
        
        let numberOfdaysInaMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfdaysInaMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate)
        ?? baseDate
        
        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
        
    }
    
    // 1
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        // 2
        guard
            let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth)
        else {
            return []
        }
        
        // 3
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        // 4
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
            }
        
        return days
    }

}


