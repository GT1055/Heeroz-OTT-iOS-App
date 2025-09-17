/*
 * Profile Segue
 * This class  is used as Custom segue to profile story board
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSProfileSegue: UIStoryboardSegue {
    override func perform() {
        if let navigation = source.navigationController {
            if !UIApplication.isUserLoginInApplication() {
                if source is CSParentViewController {
                    let controller = source as? CSParentViewController
                    source.addLoginCloseIfUserNotLogin(controller!)
                }
                return
            }
            let viewController = profileStoryBoard.instantiateViewController(
                withIdentifier: "CSEditProfileViewController")
            navigation.show(viewController, sender: nil)
        }
    }
}
