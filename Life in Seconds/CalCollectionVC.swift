//
//  CalCollectionVC.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 26/12/21.
//

import UIKit

private let reuseIdentifier = "MyCell"

class CalCollectionVC: UICollectionViewController {

    private var sectionInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 30.0)
    
    private var itemsPerRow: CGFloat = 7
    
    var dayInMonth = Array(1...31)
    
    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
      guard let self = self else { return }

      self.dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        view.addSubview(headerView)
        headerView.backgroundColor = .red
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
          headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          headerView.topAnchor.constraint(equalTo: view.topAnchor),
          headerView.heightAnchor.constraint(equalToConstant: 85)
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
        return dayInMonth.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.backgroundColor = .blue
        
        cell.dayLabel.text = "\(dayInMonth[indexPath.row])"
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
        let totalGapSizeInOneRow = sectionInsets.left * (itemsPerRow + 1)
        // the padding on the left four times ( because we have 3 cells so 4 gaps )
        let availableWidthForAllCells = view.frame.width - totalGapSizeInOneRow
        let widthPerCell = availableWidthForAllCells / itemsPerRow
        
        return CGSize(width: widthPerCell, height: widthPerCell)
    }
    
    // the insets of the collectionView (the padding)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    //spacing from section to section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    
}
