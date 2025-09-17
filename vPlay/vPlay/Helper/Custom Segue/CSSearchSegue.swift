/*
 * CSSearch Segue
 * This class  is used as Custom segue to Serach story board
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSSearchSegue: UIStoryboardSegue {
    override func perform() {
        if let navigation = source.navigationController {
            let controller = menuStoryBoard.instantiateViewController(
                withIdentifier: "CSSearchViewController")
            navigation.show(controller, sender: nil)
        }
    }
}
