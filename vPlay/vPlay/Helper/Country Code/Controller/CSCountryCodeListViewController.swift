/*
 * CSCountryCodeListViewController.swift
 * This class is used to list all The country Code
 * @category   Vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSCountryCodeListViewController: CSParentViewController {
    /// Country Code Table View
    @IBOutlet weak var countryTableView: UITableView!
    /// Country Data Sources
    @IBOutlet weak var countryDataSource: CSCountryDataSource!
    /// Search Bar Veiw
    @IBOutlet weak var searchBar: UISearchBar!
    /// Country Filter List
    var countriesFiltered = [CSCountryList]()
    /// country List
    var countriesList = [CSCountryList]()
    /// Country List Delegate
    weak var countryDelegate: CountrySelectedDelegate?
    // MARk: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
        setupNavigation()
        countryTableView.backgroundColor = UIColor.backgroundColor()
        searchBar.backgroundColor = UIColor.navigationColor()
        searchBar.textColor = UIColor.invertColor(true)
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        CSCountryApiData.fetchCountryData(parentView: self,
                                          completionHandler: { responce in
                                            self.countriesList = responce
                                            self.reloadData()
        })
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        controllerTitle = NSLocalizedString("Select a country", comment: "Countries")
        addLeftBarButton()
        addRightBarButton()
    }
    /// Reload Data
    func reloadData() {
        countryDataSource.countryList = self.countriesList
        countryDataSource.delegate = self
        countryTableView.reloadData()
    }
    /// Filter Country
    func filtercountry(_ searchText: String) {
        if searchText.isEmpty {
            reloadData()
            return
        }
        countriesFiltered = countriesList.filter({(country ) -> Bool in
            let value = country.countryName.lowercased().contains(searchText.lowercased()) ||
                country.countryCode.lowercased().contains(searchText.lowercased())
            return value
        })
        countryDataSource.countryList = self.countriesFiltered
        countryDataSource.delegate = self
        countryTableView.reloadData()
    }
    /// Check Search bar is Active
    func checkSearchBarActive() -> Bool {
        if searchBar.isFirstResponder && searchBar.text != "" {
            return true
        } else {
            return false
        }
    }
}
// MARK: - Search Delegate
extension CSCountryCodeListViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkSearchBarActive() {
            countryDelegate?.countrySelected(countrySelected: countriesFiltered[indexPath.row])
        } else {
            countryDelegate?.countrySelected(countrySelected: countriesList[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Search Delegate
extension CSCountryCodeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtercountry(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
/// Country Delegate
protocol CountrySelectedDelegate: class {
    func countrySelected(countrySelected country: CSCountryList)
}
