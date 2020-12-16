//
//  AddPlantsViewController.swift
//  WaterMyPlants
//
//  Created by Rob Vance on 10/14/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

class AddPlantsViewController: UIViewController {
    
    var currentImage: UIImage!
    
    let waterTimer = WaterTimerViewController()
    var plantController = PlantController()
    

    // MARK: - IBOutlets -
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var plantTypeTextField: UITextField!
    @IBOutlet weak var plantNotesTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - IBActions -
    
    @IBAction func addPhotoOfPlant(_ sender: UIButton) {
        let picker = UIImagePickerController()
                  picker.allowsEditing = true
                  picker.delegate = self
                  present(picker, animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        guard let nickname = plantNicknameTextField.text, !nickname.isEmpty,
              let plantType = plantTypeTextField.text, !plantType.isEmpty,
              let plantNotes = plantNotesTextView.text, !plantNotes.isEmpty else { return }
        
        let image = "\(String(describing: UIImage(systemName: "birds")))"
        
        let plant = Plant(image: image, nickName: nickname, frequency: 1, notes: plantNotes, plantClass: plantType)
        plantController.addPlant(plant: plant)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.popViewController(animated: true)
        } catch {
            NSLog("Error saving \(error)")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        timerLabel.text = waterTimer.selectedTimer
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddWaterTimerSegue" {
            guard let timerVC = segue.destination as? WaterTimerViewController else { return }
            timerVC.popoverPresentationController?.delegate = self
            timerVC.presentationController?.delegate = self
        }
    }
}

extension AddPlantsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension AddPlantsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        updateViews()
    }
}

extension AddPlantsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        plantImage.image = image
        dismiss(animated: true)
        currentImage = image
    }
}
