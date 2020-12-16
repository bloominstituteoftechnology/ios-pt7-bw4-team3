//
//  PlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by Craig Belinfante on 10/26/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

protocol PlantCellDelegate: class {
    func didUpdatePlant(plant: Plant)
}

class PlantTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var plantImageLabel: UIImageView!
    
    
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: PlantCellDelegate?
    
    private func updateViews() {
        guard let plant = plant else {return}
        
        plantNameLabel.text = plant.nickName
      //  plantImageLabel.image = UIImage(contentsOfFile: "\(plant.image)")
        timerLabel.text = "\(plant.frequency)"
        
        do {
            try CoreDataStack.shared.mainContext.save()
            delegate?.didUpdatePlant(plant: plant)
        } catch {
            NSLog("Error saving \(error)")
        }
        
    }
    
}
