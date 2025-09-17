/*
 * CSDatePickerViewController.swift
 * This class is used to create A date Picker View for selecting the Date
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
protocol CSSignUpDatePopUpDelegate: class {
    func selectedDateOfBirth(_ dateString: String)
}
class CSDatePickerViewController: CSParentViewController {
    // Exam List Table
    @IBOutlet var datePicker: UIDatePicker!
    // Current Selected Data
    var currentDate = String()
    // Pervious Date
    var previousDate = String()
    // Delegate
    weak var delegate: CSSignUpDatePopUpDelegate?
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDatePicker()
        self.setDefaultDate()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Private Method
extension CSDatePickerViewController {
    /// Set Default Date
    func setDefaultDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if !previousDate.isEmpty {
            if let chosseDate = dateFormatter.date(from: previousDate) {
                datePicker.date = chosseDate
            } else {
                datePicker.date = Date.tenYearsBackFromNow()
            }
        } else {
            let date = Date.tenYearsBackFromNow()
            previousDate = dateFormatter.string(from: date)
        }
    }
    /// Cinfiguration of Date
    func configureDatePicker() {
        datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        /// setting maximun date to ten years from now
        datePicker.maximumDate = Date.tenYearsBackFromNow()
        /// date picker change date action
        datePicker.addTarget(self,
                             action: #selector(CSDatePickerViewController.datePickerChanged),
                             for: UIControl.Event.valueChanged)
    }
    /// Can the Date
    func cancelOptionIsSelected() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Button Action
extension CSDatePickerViewController {
    // Done button Action
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if currentDate.isEmpty {
            delegate?.selectedDateOfBirth(previousDate)
            self.cancelOptionIsSelected()
            return
        }
        delegate?.selectedDateOfBirth(currentDate)
        self.cancelOptionIsSelected()
    }
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.cancelOptionIsSelected()
    }
    // Dismiss View
    @IBAction func tabToDismiss(_ sender: UITapGestureRecognizer) {
        self.cancelOptionIsSelected()
    }
    /// Date Picker Changed
    /// date in NS date formate
    @objc func datePickerChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        currentDate = String()
        currentDate = dateFormatter.string(from: datePicker.date)
    }
}
