//
//  CSSubscribeSegue.swift
//  vPlay
//
//  Created by user on 05/01/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class CSSubscribeSegue: UIStoryboardSegue {
    override func perform() {
        if let navigation = source.navigationController {
            let controller = subscriptionStoryBoard.instantiateViewController(withIdentifier:
                                                                                        "CSSubscriptionViewController")
            navigation.show(controller, sender: nil)            
        }
    }
}
