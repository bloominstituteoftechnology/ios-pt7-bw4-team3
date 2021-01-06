//
//  WaterDateViewController.swift
//  Planty
//
//  Created by Craig Belinfante on 12/28/20.
//

import UIKit

class WaterDateViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var waterDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WaterDateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}
