/*
 * CSCustomFont.swift
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */
import UIKit

extension UIFont {
    /// Futuran Pt Heavy
    class func fontLightDisplay() -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: 15.0)!
    }
    class func fontRegularDisplay() -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: 15.0)!
    }
    class func fontSmallRegularDisplay() -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: 13.0)!
    }
    class func fontMediumDisplay() -> UIFont {
        return UIFont(name: "SFUIDisplay-Medium", size: 15.0)!
    }
    /// Futuran Pt Light
    class func fontLight() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 16, weight: .medium)
        } else {
            return UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    class func semiBold() -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    /// Futuran Pt Light
    class func fontNewLight() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        } else {
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    /// Futuran Pt Light
    class func fontBold() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 16, weight: .bold)
        } else {
            return UIFont.systemFont(ofSize: 14, weight: .bold)
        }
    }
    /// Subscription Font To Show Cost and Duration in card Page
    class func costAndDurationCardPage() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    class func priceFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    class func priceRegularFont() -> UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    class func viewAllButtonFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont.systemFont(ofSize: 13, weight: .semibold)
        } else {
            return UIFont.systemFont(ofSize: 11, weight: .semibold)
        }
    }
    class func loginAndSignButtonFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    class func customBackGroundButtonFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    /// CSCollection Title Label Font
    class func cscollectionLableTitleFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIFont(name: "SFUIDisplay-Medium", size: 14.0)!
        } else {
            return UIFont(name: "SFUIDisplay-Medium", size: 12.0)!
        }
    }
}
