//
//  DetailViewController.swift
//  Planty
//
//  Created by Craig Belinfante on 1/5/21.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantTypeLabel: UILabel!
    @IBOutlet weak var plantWaterDateLabel: UILabel!

    //Change title to plant name
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playAudioNoteButton(_ sender: UIButton) {
    }
    
    @IBAction func updateWaterDateButton(_ sender: UIButton) {
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
