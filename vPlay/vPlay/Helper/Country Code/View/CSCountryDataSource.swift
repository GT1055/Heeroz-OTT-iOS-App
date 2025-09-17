/*
 * CSCountryDataSource.swift
 * @category   Vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSCountryDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    /// Video Detail
    var countryList = [CSCountryList]()
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as? CSCountryCodeTableCell else { return UITableViewCell() }
        cell.changeViewByDarkMode()
        cell.bindDataCountryCode(countryList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return countryList.count == 0 ? 40 : 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.clear
        let label = UILabel.init(frame: view.bounds)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.invertColor(true)
        label.textAlignment = .center
        label.text = "Results not found"
        view.addSubview(label)
        return view
    }
}
