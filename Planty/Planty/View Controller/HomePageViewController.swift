//
//  HomePageViewController.swift
//  Planty
//
//  Created by Craig Belinfante on 12/23/20.
//

import UIKit

class HomePageViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var homePageTableView: UITableView!
    @IBOutlet weak var recentPlant: UILabel!
    @IBOutlet weak var plantsToWater: UILabel!
    @IBOutlet weak var recentPlantImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- Actions
    @IBAction func waterPlants(_ sender: UIButton) {
        
    }
    

    

    /*
    
    // cell - ShowPlant
    // waterPlants - WaterPlant
    // add - AddPlant
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
