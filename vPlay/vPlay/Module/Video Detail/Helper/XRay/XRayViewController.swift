//
//  XRayViewController.swift
//  vPlay
//
//  Created by user on 26/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class XRayViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var castButton: UIButton!

    var xrayList = [XrayDetail]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    var parenController: CSVideoDetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
    }
    @IBAction func castAction(_ sender: UIButton) {
        
    }
    @IBAction func closeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) { self.parenController.xrayView.alpha = 0 }
    }
}

extension XRayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xrayList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XRayCollectionViewCell.identifier, for: indexPath) as? XRayCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureCell(with: xrayList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width/3 - 10
        if UIDevice.current.orientation.isLandscape {
            width = collectionView.frame.width/4 - 10
        }
        let height = width*1.25
        return CGSize.init(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "VideoDetail", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "XRayDetailViewController") as? XRayDetailViewController {
//            vc.xrayData = xrayList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
class XrayNavigationController: UINavigationController {
    override var tabBarController: UITabBarController? {
        return nil
    }
}
