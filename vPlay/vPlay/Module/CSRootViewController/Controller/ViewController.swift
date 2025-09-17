/*
 * ViewController
 * Landing page with scrollView
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class ViewController: CSParentViewController {
    // Gif Image Load
    @IBOutlet var vplayedSplash: UIImageView!
    // MARK: - UIView Controller Life cycle
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vplayedSplash.setLogo()
        UIApplication.setRootControllerBasedOnLogin()
    }
}
