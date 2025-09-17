//
//  XRayDetailViewController.swift
//  vPlay
//
//  Created by user on 26/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import WebKit
class XRayDetailViewController: CSParentViewController {

    @IBOutlet weak var webContainerView: UIView!
    let webView = WKWebView.init()
    var pageUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        setUpWebView()
        setupNavigation()
        if let url = pageUrl {
            webView.load(URLRequest.init(url: url))
        }
//        let url = "https://en.wikipedia.org/wiki/Dwayne_Johnson"
    }
    
    func setUpWebView() {
        webContainerView.addSubview(webView)
        webView.frame = webContainerView.bounds
    }
    func setupNavigation() {
        addGradientBackGround()
        controllerTitle = "Vplayed"
        addLeftBarButton()
    }
    
    @IBAction func backAction(_ sendeR: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
