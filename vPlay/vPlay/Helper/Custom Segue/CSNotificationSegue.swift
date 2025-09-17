/*
 * CSNotification Segue
 * This class  is used as Custom segue to Notification story board
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSNotificationSegue: UIStoryboardSegue {
    override func perform() {
        if let navigation = source.navigationController {
            let viewController = notificationStoryBoard.instantiateViewController(
                withIdentifier: "CSNotificationViewController")
            navigation.show(viewController, sender: nil)
        }
    }
}
