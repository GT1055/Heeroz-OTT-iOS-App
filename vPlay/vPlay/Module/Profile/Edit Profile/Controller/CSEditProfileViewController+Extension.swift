/*
 * Extension.swift
 * This controller is used to display the edit profile view
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
// MARK: - Api Request
extension CSEditProfileViewController {
    /// Save Profile info
    func saveAndUploadImageProfileInfo() {
        let countryCode = countryCodeLabel.text!
        let code = countryCode.trimmingCharacters(in: .whitespaces)
        let dailCode: String = code.replacingOccurrences(of: "+", with: "")
        let parameters = ["email": emailTextfield.text!, "name": nameTextfield.text!,
                          "country_code": dailCode,
                          "age": ageTextfield.text!]
        CSProfileApiModel.updateImageProfileInfoData(
            parentView: self,
            profileImage: userProfileImage.image!,
            parameters: parameters,
            completionHandler: { response in
                self.isImageSelected = false
                self.handleApiResponce(response.responseRequired)
        })
    }
    /// Save Profile info
    func saveProfileInfo() {
        let countryCode = countryCodeLabel.text!
        let code = countryCode.trimmingCharacters(in: .whitespaces)
        let dailCode: String = code.replacingOccurrences(of: "+", with: "")
        let parameters = ["email": emailTextfield.text!, "name": nameTextfield.text!,
                          "phone": mobileTextfield.text!,
                          "country_code": dailCode,
                          "age": ageTextfield.text!]
        CSProfileApiModel.updateProfileInfoData(
            parentView: self,
            parameters: parameters,
            completionHandler: { response in
                self.handleApiResponce(response.responseRequired)
        })
    }
    func setDefaultCountry(_ countryCode: String) {
        CSCountryApiData.fetchCountryData(
            parentView: self,
            completionHandler: { responce in
                if !countryCode.isEmpty {
                    for country in responce {
                        let code = country.countryDialCode.trimmingCharacters(in: .whitespaces)
                        let dailCode: String = code.replacingOccurrences(of: "+", with: "")
                        if dailCode == countryCode.trimmingCharacters(in: .whitespaces) {
                            self.countrySelected(countrySelected: country)
                        }
                    }
                } else {
                    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        for country in responce where country.countryCode == countryCode {
                            self.countrySelected(countrySelected: country)
                        }
                    }
                }
        })
    }
    /// Bind User Data
    func bindUserData() {
        CSProfileApiModel.showProfileInfo(parentView: self,
                                          parameters: nil, completionHandler: { responce in
                                            self.bindData(userInfo: responce.requriedResponce.profileArray)
                                            self.setDefaultCountry(
                                                responce.requriedResponce.profileArray.countryCode)
        })
    }
}
// MARK: - Imagepicker Delegates
extension CSEditProfileViewController {
    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        userProfileImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        isImageSelected = true
        dismiss(animated: true, completion: nil)
    }
    /// dismiss view controller
    /// - Parameter picker: image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isImageSelected = false
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Date Picker Delegate
extension CSEditProfileViewController: CSSignUpDatePopUpDelegate {
    func selectedDateOfBirth(_ dateString: String) {
        self.isEdited = true
        ageTextfield.text = dateString
    }
}
