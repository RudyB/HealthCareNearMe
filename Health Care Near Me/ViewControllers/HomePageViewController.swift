//
//  ViewController.swift
//  Health Care Near Me
//
//  Created by Rudy Bermudez on 4/30/17.
//  Copyright © 2017 Rudy Bermudez. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    
    let data = iterateEnum(MedicalLocation.self).map { $0.description }
    
    var userSelection: MedicalLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barStyle = .black //
        picker.dataSource = self
        picker.delegate = self
        userSelection = MedicalLocation(rawValue: picker.selectedRow(inComponent: 0))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func transitionToSearch() {
        if let userSelection = userSelection {
            let vc = storyboard?.instantiateViewController(withIdentifier: LocationResultsViewController.storyboardIdentifier) as! LocationResultsViewController
            vc.searchItem = userSelection
            vc.navigationItem.title = userSelection.description
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}


extension HomePageViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - PickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    // MARK: - PickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Note: It is okay to force unwrap here because we know it is a finite number of posibilities.
        userSelection = MedicalLocation(rawValue: row)!
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: data[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
}
