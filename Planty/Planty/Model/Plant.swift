//
//  Plant.swift
//  Planty
//
//  Created by Craig Belinfante on 12/17/20.
//

import Foundation

struct Plant: Equatable, Codable {
    var name: String
    var plantType: String
    var waterDate: Date
    var plantImage: URL?
    var audioNotes: URL?
    
    init (name: String, plantType: String, waterDate: Date, plantImage: URL?, audioNotes: URL?) {
        self.name = name
        self.plantType = plantType
        self.waterDate = waterDate
        self.plantImage = plantImage
        self.audioNotes = audioNotes
    }
}
