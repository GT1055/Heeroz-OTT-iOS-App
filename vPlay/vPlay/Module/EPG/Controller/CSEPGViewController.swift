//
//  CSEPGViewController.swift
//  vPlay
//
//  Created by user on 31/01/20.
//  Copyright © 2020 user. All rights reserved.
//
import UIKit
import Foundation
import CoreData
class CSEPGViewController: CSParentViewController {
    @IBOutlet weak var collectionViewList: UICollectionView!
    var collectionViewEPGLayout: INSElectronicProgramGuideLayout!
    var fetchResults: NSFetchedResultsController<NSFetchRequestResult>!
    var backImg: UIImageView!
    var entry: Entry!
    var cellView: UICollectionReusableView!
    var epgList = [CSMovieData]()
    var epgCategory = [CSCategoryList]()
    
    var dateFilter = [Date]()
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backImg = UIImageView.init(frame: self.view.bounds)
        backImg.image = UIImage.init(named: "backgroundImage")
        //self.collectionView.backgroundColor = .black
        self.fetchResults = Entry.mr_fetchAllGrouped(by: "channel.iD", with: nil, sortedBy: "channel.iD,channel.name", ascending: true, delegate: self)
        self.collectionViewEPGLayout = (self.collectionViewList.collectionViewLayout as! INSElectronicProgramGuideLayout)
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionViewEPGLayout.dataSource = self;
        self.collectionViewEPGLayout.delegate = self;
        self.collectionViewEPGLayout.shouldResizeStickyHeaders = true;
        self.collectionViewEPGLayout.shouldUseFloatingItemOverlay = false;
        self.collectionViewEPGLayout.floatingItemOffsetFromSection = 10.0;
        self.collectionViewEPGLayout.currentTimeVerticalGridlineWidth = 4;
        self.collectionViewEPGLayout.sectionHeight = 60;
        self.collectionViewEPGLayout.sectionHeaderWidth = 110;
        self.view.backgroundColor = .black
        let timeRowHeaderStringClass = NSStringFromClass(ISHourHeader.self)
        self.collectionViewList.register(UINib.init(nibName: timeRowHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindHourHeader, withReuseIdentifier: timeRowHeaderStringClass)
        self.collectionViewList.register(UINib.init(nibName: timeRowHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindHalfHourHeader, withReuseIdentifier: timeRowHeaderStringClass)
        
        let cellStringClass = NSStringFromClass(ISFloatingCell.self)
        self.collectionViewList.register(UINib.init(nibName:cellStringClass , bundle: nil), forCellWithReuseIdentifier: cellStringClass)
        
        let dayColumnHeaderStringClass = NSStringFromClass(ISSectionHeader.self)
        self.collectionViewList.register(UINib.init(nibName: dayColumnHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindSectionHeader, withReuseIdentifier: dayColumnHeaderStringClass)
        
        self.collectionViewEPGLayout.register(ISCurrentTimeGridlineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline)
        self.collectionViewEPGLayout.register(ISGridlineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindVerticalGridline)
        self.collectionViewEPGLayout.register(ISHalfHourLineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindVerticalGridline)
        self.collectionViewEPGLayout.register(ISHeaderBackgroundView.self, forDecorationViewOfKind: INSEPGLayoutElementKindSectionHeaderBackground)
        self.collectionViewEPGLayout.register(ISHourHeaderBackgroundView.self, forDecorationViewOfKind: INSEPGLayoutElementKindHourHeaderBackground)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.collectionViewEPGLayout.scrollToCurrentTime(animated: true)
        }
        callApi()
        EPGApiModel.getCatogoryList(parentView: self, parameters: nil) { (response) in
            self.epgCategory = response.epgCategory.categoryList
        }
        
    }
    override func callApi() {
        EPGApiModel.getprogrameList(parentView: self, parameters: nil) { (response) in
            self.epgList = response.broadCastingChannel.data
            self.collectionViewEPGLayout.invalidateLayout()
            self.collectionViewEPGLayout.invalidateLayoutCache()
            self.collectionViewList.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addGradientBackGround()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.collectionViewList.collectionViewLayout = self.collectionViewEPGLayout
    }
    @IBAction func scrollToTime(_sender: UIButton){
        let xcoordinate = self.collectionViewEPGLayout.xCoordinate(for: self.epgList.last?.epgProgram.last?.start)
        
        self.collectionViewList.setContentOffset(CGPoint.init(x: xcoordinate, y: 0), animated: true)
        //        self.collectionViewEPGLayout.scrollToCurrentTime(animated: true)
    }
    @IBAction func categoryAction(_ sender: UIButton){
        let data = self.epgCategory.map({$0.categoryTitle})
        CSOptionDropDown.showDropDown(with: data, anchor: sender) { (index, value) in
            if index == 0 {self.callApi(); return}
            let param = ["categories": "music"]
            EPGApiModel.getFilteredEPGList(parentView: self, parameters: param) { (response) in
                self.epgList = response.filteredEpgList
                self.collectionViewEPGLayout.invalidateLayout()
                self.collectionViewEPGLayout.invalidateLayoutCache()
                self.collectionViewList.reloadData()
            }
        }
    }
    @IBAction func dateFilterAction(_ sender: UIButton){
        let data = ["2020-02-28", "2020-04-24"]
        CSOptionDropDown.showDropDown(with: data, anchor: sender) { (index, value) in
            if index == 0 {
                let xcoordinate = self.collectionViewEPGLayout.xCoordinate(for: self.epgList.first?.epgProgram.first?.start)
                
                self.collectionViewList.setContentOffset(CGPoint.init(x: xcoordinate, y: 0), animated: true)
            } else {
              let xcoordinate = self.collectionViewEPGLayout.xCoordinate(for: self.epgList.last?.epgProgram.last?.start)
                
                self.collectionViewList.setContentOffset(CGPoint.init(x: xcoordinate, y: 0), animated: true)
            }
        }
    }
}
extension CSEPGViewController: INSElectronicProgramGuideLayoutDelegate, INSElectronicProgramGuideLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView!, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout!, startTimeForItemAt indexPath: IndexPath!) -> Date! {
        return self.epgList[indexPath.section].epgProgram[indexPath.row].start
    }
    func collectionView(_ collectionView: UICollectionView!, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout!, endTimeForItemAt indexPath: IndexPath!) -> Date! {
        return self.epgList[indexPath.section].epgProgram[indexPath.row].end
    }
    func currentTime(for collectionView: UICollectionView!, layout collectionViewLayout: INSElectronicProgramGuideLayout!) -> Date! {
        return NSDate() as Date;
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.epgList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.epgList[section].epgProgram.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (NSStringFromClass(ISFloatingCell.self)), for: indexPath) as! ISFloatingCell
        cell.titleLabel.text = self.epgList[indexPath.section].epgProgram[indexPath.row].program
        cell.setDate(self.epgList[indexPath.section].epgProgram[indexPath.row].start)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == INSEPGLayoutElementKindSectionHeader {
            let dayColumnHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (NSStringFromClass(ISSectionHeader.self)), for: indexPath) as! ISSectionHeader
            entry = self.fetchResults.object(at: indexPath) as? Entry
            dayColumnHeader.dayLabel.text = self.epgList[indexPath.section].title
            cellView = dayColumnHeader;
        } else if (kind == INSEPGLayoutElementKindHourHeader) {
            let timeRowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (NSStringFromClass(ISHourHeader.self)), for: indexPath) as! ISHourHeader
            timeRowHeader.time = self.collectionViewEPGLayout.dateForHourHeader(at: indexPath)
            cellView = timeRowHeader
        } else if (kind == INSEPGLayoutElementKindHalfHourHeader) {
            let timeRowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (NSStringFromClass(ISHourHeader.self)), for: indexPath) as! ISHourHeader
            timeRowHeader.time = self.collectionViewEPGLayout.dateForHalfHourHeader(at: indexPath)
            cellView = timeRowHeader
        }
        return cellView;
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        entry = self.fetchResults.object(at: indexPath) as? Entry
        let alert = UIAlertController(title: "Alert", message: entry.title, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension CSEPGViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        self.collectionViewEPGLayout.invalidateLayoutCache()
        //        self.collectionViewList.reloadData()
    }
}


//- (void)scrollToCurrentTimeAnimated:(BOOL)animated
//{
//    if (self.collectionView.numberOfSections > 0) {
//        CGRect currentTimeHorizontalGridlineattributesFrame = [self.currentTimeVerticalGridlineAttributes[[NSIndexPath indexPathForItem:0 inSection:0]] frame];
//        CGFloat xOffset;
//        if (!CGRectEqualToRect(currentTimeHorizontalGridlineattributesFrame, CGRectZero)) {
//            xOffset = nearbyintf(CGRectGetMinX(currentTimeHorizontalGridlineattributesFrame) - (CGRectGetWidth(self.collectionView.frame) / 2.0));
//        } else {
//            xOffset = 0.0;
//        }
//        CGPoint contentOffset = CGPointMake(xOffset, self.collectionView.contentOffset.y - self.collectionView.contentInset.top);
//
//        // Prevent the content offset from forcing the scroll view content off its bounds
//        if (contentOffset.y > (self.collectionView.contentSize.height - self.collectionView.frame.size.height)) {
//            contentOffset.y = (self.collectionView.contentSize.height - self.collectionView.frame.size.height);
//        }
//        if (contentOffset.y < -self.collectionView.contentInset.top) {
//            contentOffset.y = -self.collectionView.contentInset.top;
//        }
//        if (contentOffset.x > (self.collectionView.contentSize.width - self.collectionView.frame.size.width)) {
//            contentOffset.x = (self.collectionView.contentSize.width - self.collectionView.frame.size.width);
//        }
//        if (contentOffset.x < 0.0) {
//            contentOffset.x = 0.0;
//        }
//
//        [self.collectionView setContentOffset:contentOffset animated:animated];
//    }
//}
