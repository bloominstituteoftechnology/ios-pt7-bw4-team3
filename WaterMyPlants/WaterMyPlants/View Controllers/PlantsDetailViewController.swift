//
//  PlantsDetailViewController.swift
//  WaterMyPlants
//
//  Created by Rob Vance on 10/14/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

class PlantsDetailViewController: UIViewController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantClassLabel: UILabel!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var plantTypeTextField: UITextField!
    @IBOutlet weak var plantNotesTextView: UITextView!
    @IBOutlet weak var plantTimerLabel: UILabel!
    
    // MARK: - Properties -
    var plants: Plant?
    var currentImage: UIImage!
    var plantController = PlantController()
    var wasEdited = false
    //var plantRep: PlantRepresentation?
    var waterTimer: WaterTimerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing { wasEdited = true }
        plantNicknameTextField.isUserInteractionEnabled = editing
        plantTypeTextField.isUserInteractionEnabled = editing
        plantNotesTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let nickName = plantNicknameTextField.text, !nickName.isEmpty, let notes = plantNotesTextView.text, !notes.isEmpty, let plantClass = plantTypeTextField.text, !plantClass.isEmpty, let plant = plants else { return }
            
            plant.nickName = nickName
            plant.notes = notes
            plant.plantClass = plantClass
            
            plantController.addPlant(plant: plant)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving")
            }
        }
    }
    
    
    func updateViews() {
        
        plantImage.image = UIImage(systemName: "birds")
        plantClassLabel.text = plants?.plantClass
        plantNicknameTextField.text = plants?.nickName
        plantNicknameTextField.isUserInteractionEnabled = isEditing
        plantTypeTextField.text = plants?.plantClass
        plantTypeTextField.isUserInteractionEnabled = isEditing
        plantNotesTextView.text = plants?.notes
        plantNotesTextView.isUserInteractionEnabled = isEditing
        plantTimerLabel.text = "\(plants?.frequency ?? 0)"
    }
    
    // MARK: - IBActions -
    
    @IBAction func addPlantImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateWaterTimer" {
            guard let timerVC = segue.destination as? WaterTimerViewController else { return }
            timerVC.popoverPresentationController?.delegate = self
            timerVC.presentationController?.delegate = self
        }
    }
}

extension PlantsDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension PlantsDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        updateViews()
    }
}

extension PlantsDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        plantImage.image = image
        dismiss(animated: true)
        currentImage = image
    }
}
extension PlantsDetailViewController: WaterTimerPickedDelegate {
    func plantTimer(date: Date) {
        
    }    
    
}
