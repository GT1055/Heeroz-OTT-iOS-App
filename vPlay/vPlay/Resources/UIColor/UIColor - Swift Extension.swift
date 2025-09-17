/*
 * Class of colour
 * This class as Color extension Which Contain theme and other custom creted Color
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

extension UIColor {
    // cutomize gradient background
    func theGradientBackground(backgroundView: UIView,
                               hexColor1: String, hexColor2: String) -> UIView {
        let color1: UIColor = UIColor.convertHexStringToColor(hexColor1)
        let color2: UIColor = UIColor.convertHexStringToColor(hexColor2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(x: backgroundView.frame.origin.x,
                                          y: backgroundView.frame.origin.y,
                                          width: UIScreen.main.bounds.width,
                                          height: backgroundView.frame.size.height)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return backgroundView
    }
    // Convert Hex String To Color
    class func convertHexStringToColor(_ hexString: String) -> UIColor {
        var hexColorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexColorString.hasPrefix("#") {
            hexColorString = hexColorString.substring(from: hexColorString.startIndex)
        }
        if hexColorString.count != 6 {
            let error = NSError()
            NSException.raise(NSExceptionName(rawValue: "Hex Color String Error"),
                              format: "Error: Please ensure hex color string has 6 elements",
                              arguments: getVaList([error]))
        }
        var hexColorRGBValue: UInt32 = 0
        Scanner(string: hexColorString).scanHexInt32(&hexColorRGBValue)
        return .changeHexColorCodeToRGB(hex: hexColorRGBValue, alpha: 1)
    }
    // Private change hex to RGB
    class func changeHexColorCodeToRGB(hex: UInt32, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0,
                       green: CGFloat((hex & 0xFF00) >> 8)/255.0,
                       blue: CGFloat((hex & 0xFF))/255.0,
                       alpha: alpha)
    }
    /// Navigation Color
    class func navigationColor() -> UIColor {
        return .convertHexStringToColor(
            (LibraryAPI.sharedInstance.isDarkMode()) ? NAVIGATIONDARKBACKGROUND : NAVIGATIONLIGHTBACKGROUND)
    }
    /// Loader Color
    class func loaderColor() -> UIColor {
        return white
//        return .convertHexStringToColor(THEMECOLOR)
    }
    /// live Now Color
    class func liveNowColor() -> UIColor {
        return UIColor(red: 96.0/255.0,
                       green: 142.0/255.0,
                       blue: 47.0/255.0,
                       alpha: 1.0)
    }
    /// Bottom Curve Color
    class func bottomCurveColor() -> UIColor {
        return .convertHexStringToColor("27B4D5")
    }
    /// Transcation Color
    class func transcationColor() -> UIColor {
        return .convertHexStringToColor("1FD059")
    }
    /// Navigation Color
    class func navigationHeaderColor() -> UIColor {
        return .convertHexStringToColor(NAVIGATIONHEADERCOLORCODE)
    }
    /// Back Ground Color
    class func backgroundColor() -> UIColor {
        return .convertHexStringToColor(
            (LibraryAPI.sharedInstance.isDarkMode()) ? VIEWDARKBACKGROUNDCOLOR : VIEWLIGHTBACKGROUNDCOLOR)
    }
    /// Icon Color
    class func iconColor() -> UIColor {
        return .convertHexStringToColor(
            (LibraryAPI.sharedInstance.isDarkMode()) ? ICONDARKCOLOR : ICONLIGHTCOLOR)
    }
    /// Content Color
    class func contentColor() -> UIColor {
        return .convertHexStringToColor(
            (LibraryAPI.sharedInstance.isDarkMode()) ? ICONDARKCOLOR : LIGHTFONTCOLOR)
    }
    /// Invert Color
    class func invertColor(_ change: Bool) -> UIColor {
        if change {
            return (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.white : UIColor.black
        } else {
            return (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.black : UIColor.white
        }
    }
    /// Read More And Read Less Color
    class func readMoreReadLessColor() -> UIColor {
        return .convertHexStringToColor(THEMECOLOR)
    }
    /// View All Button Color
    class func viewAllButtonColor() -> UIColor {
        return .convertHexStringToColor(THEMECOLOR)
    }
    /// View All Button Color
    class func themeColorButton() -> UIColor {
        return .convertHexStringToColor(THEMECOLOR)
    }
    /// View All Button Color
    class func commentNameColor() -> UIColor {
        return .convertHexStringToColor(THEMECOLOR)
    }
    /// Custom BackGround Color
    class func customBackGroundColor() -> UIColor {
        return .convertHexStringToColor(THEMECOLOR)
    }
    /// Custom BackGround Color
    class func customPremiumBackGroundColor() -> UIColor {
        return .convertHexStringToColor(PREMIUMCOLOR)
    }
}
// Update Color code
extension UIColor {
    /// Keyboard Input to TextField Depend on this Color
    class var textFieldTextColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.textFieldText : LightColorCode.textFieldText
        return UIColor.convertHexStringToColor(code)
    }
    /// Keyboard Input to TextField Depend on this Color
    class var backgroundViewColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.viewBackground : LightColorCode.viewBackground
        return UIColor.convertHexStringToColor(code)
    }
    /// Keyboard Input to TextField Depend on this Color
    class var disabledTextFieldTextColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.disabledTexFieldText : LightColorCode.disabledTexFieldText
        return UIColor.convertHexStringToColor(code)
    }
    /// Keyboard Input to TextField Depend on this Color
    class var textFieldPlaceHolderColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.textFieldPlaceHolder : LightColorCode.textFieldPlaceHolder
        return UIColor.convertHexStringToColor(code)
    }
    /// Label Text Color
    class var labelTextColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.labelText : LightColorCode.labelText
        return UIColor.convertHexStringToColor(code)
    }
    /// Thumbnail Default color
    class var thumbnailDefaultColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? DarkColorCode.thumbnailBackground : LightColorCode.thumbnailBackground
        return UIColor.convertHexStringToColor(code)
    }
    /// Seperator Line Color
    class var separatorColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? DarkColorCode.separator : LightColorCode.separator
        return UIColor.convertHexStringToColor(code)
    }
    /// Icon Color
    class var navigationIconColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.navigationIcon : LightColorCode.navigationIcon
        return UIColor.convertHexStringToColor(code)
    }
    /// Title Color
    class var navigationTitleColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.navigationTitle : LightColorCode.navigationTitle
        return UIColor.convertHexStringToColor(code)
    }
    /// Keyboard Input to TextField Depend on this Color
    class var bottomBar: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.bottomBar : LightColorCode.bottomBar
        return UIColor.convertHexStringToColor(code)
    }
    /// Navigation Color
    class var navigationBarColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? DarkColorCode.navigation : LightColorCode.navigation
        return .convertHexStringToColor(code)
    }
    // BackGound Color
    class var background: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? DarkColorCode.background : LightColorCode.background
        return .convertHexStringToColor(code)
    }
    // Table icon of Menu list
    class var menuListIcon: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? MenuTableDarkMode.icon : MenuTableLightMode.icon
        return .convertHexStringToColor(code)
    }
    // Table Title of Menu list
    class var menuListTitle: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? MenuTableDarkMode.title : MenuTableLightMode.title
        return .convertHexStringToColor(code)
    }
    // Setting Title Color
    class var settingCellTitle: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? SettingDarkMode.title : SettingLightMode.title
        return .convertHexStringToColor(code)
    }
    // Setting Description Color
    class var settingCellDescription: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ? SettingDarkMode.description : SettingLightMode.description
        return .convertHexStringToColor(code)
    }
    // Setting icon Color
    class var settingCellIcon: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            SettingDarkMode.icon : SettingLightMode.icon
        return .convertHexStringToColor(code)
    }
    // Contact US Color
    class var contactUsLabel: UIColor {
        let color = LibraryAPI.sharedInstance.isDarkMode() ?
            ContactUsDarkMode.labelText : ContactUsLightMode.labelText
        return color
    }
    // Contact US Icon Color
    class var contactUsIcon: UIColor {
        let color = LibraryAPI.sharedInstance.isDarkMode() ?
            ContactUsDarkMode.icon : ContactUsLightMode.icon
        return color
    }
    // Contact US Icon Color
    class var tabBarUnselect: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            LightColorCode.tabUnSelection : DarkColorCode.tabUnSelection
        return .convertHexStringToColor(code)
    }
    class var cardCustomView: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            CardCollectionCellDarkMode.customView : CardCollectionCellLightMode.customView
        return .convertHexStringToColor(code)
    }
    class var transcationCellBackground: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            TranscationCellDarkMode.background : TranscationCellLightMode.background
        return .convertHexStringToColor(code)
    }
    class var homeCollectionBackground: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            HomeCollectionCellDarkMode.background : HomeCollectionCellLightMode.background
        return .convertHexStringToColor(code)
    }
    class var videoDetailStaticText: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            VideoDetailDarkMode.staticTextColor : VideoDetailLightMode.staticTextColor
        return .convertHexStringToColor(code)
    }
    class var videoDetailRelatedBackground: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            VideoDetailDarkMode.relatedTitleBackground : VideoDetailLightMode.relatedTitleBackground
        return .convertHexStringToColor(code)
    }
    class var commenterNameColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            CommentDarkMode.commenterName : CommentLightMode.commenterName
        return .convertHexStringToColor(code)
    }
    class var commentDescriptionColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            CommentDarkMode.commentDescription : CommentLightMode.commentDescription
        return .convertHexStringToColor(code)
    }
    class var dateAndTimeColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.dataAndTime : LightColorCode.dataAndTime
        return .convertHexStringToColor(code)
    }
    class var descriptionColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.descriptionColor : LightColorCode.descriptionColor
        return .convertHexStringToColor(code)
    }
    class var timeLabelColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.timeColor : LightColorCode.timeColor
        return .convertHexStringToColor(code)
    }
    class var namelabelColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.nameColor : LightColorCode.nameColor
        return .convertHexStringToColor(code)
    }
    class var backgroundCellColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.backgroundCellcolor : LightColorCode.backgroundCellcolor
        return .convertHexStringToColor(code)
    }
    class var topviewMode: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.topviewColor : LightColorCode.topviewColor
        return .convertHexStringToColor(code)
    }
    class var middleCellColor: UIColor {
        let code = LibraryAPI.sharedInstance.isDarkMode() ?
            DarkColorCode.middleViewColor : LightColorCode.middleViewColor
        return .convertHexStringToColor(code)
    }
}
extension UIImageView {
    func setLogo() {
        let name = LibraryAPI.sharedInstance.isDarkMode() ? "whiteLogo" : "blackLogo"
        self.image = UIImage.init(named: name)
    }
}
