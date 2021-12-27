//
//  CalCollectionVC.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 26/12/21.
//

import UIKit

private let reuseIdentifier = "MyCell"

class CalCollectionVC: UICollectionViewController {

    private var sectionInsets = UIEdgeInsets(top: 70.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    private var itemsPerRow: CGFloat = 7
    
    var dayInMonth = Array(1...31)
    
    private var baseDate: Date = Date() {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        view.addSubview(footerView)
        view.addSubview(headerView)
        headerView.backgroundColor = .red
        headerView.baseDate = baseDate
        
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
          headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          headerView.topAnchor.constraint(equalTo: view.topAnchor),
          headerView.heightAnchor.constraint(equalToConstant: 110),
          
          footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
          footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
          footerView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
          footerView.heightAnchor.constraint(equalToConstant: 160)
          
          
          
          ])
        
        NSLayoutConstraint.activate(constraints)
          
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return days.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell
    
        cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
//        cell.layer.borderColor = UIColor.gray.cgColor
//        cell.layer.borderWidth = 1.0
        let day = days[indexPath.row]
        cell.dayLabel.text = day.number
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension CalCollectionVC : UICollectionViewDelegateFlowLayout {
 
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
    
    
}

private extension CalCollectionVC {
    
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
