//
//  PlantTableViewController.swift
//  WaterMyPlants
//
//  Created by Craig Belinfante on 10/26/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import CoreData

class PlantTableViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickName", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "nickName", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    let loginController = LoginController()
    let plantController = PlantController()
    var user: UserRepresentation?
    var plants = [PlantRepresentation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantTableViewCell else {fatalError("Cannot dequeue cell")}
        
        // Configure the cell...
        cell.delegate = self
        cell.plant = fetchedResultsController.object(at: indexPath)
        
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.systemGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plant = fetchedResultsController.object(at: indexPath)
            plantController.deletePlant(plant) { (result) in
                guard let _ = try? result.get() else {return}
                let moc = CoreDataStack.shared.mainContext
                moc.delete(plant)
                
                do {
                    try moc.save()
                    // tableView.reloadData()
                } catch {
                    moc.reset()
                    NSLog("Error saving \(error)")
                }
                
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlantDetailSegue",
            let detailVC = segue.destination as? PlantsDetailViewController {
            if let index = self.tableView.indexPathForSelectedRow {
                detailVC.plants = fetchedResultsController.object(at: index)
            }
            detailVC.plantController = plantController
        } else if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.loginController = loginController
            }
        }
    }
}

extension PlantTableViewController: NSFetchedResultsControllerDelegate {
    
    //Updates
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    //Sections
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections((IndexSet(integer: sectionIndex)), with: .automatic)
        case .delete:
            tableView.deleteSections((IndexSet(integer: sectionIndex)), with: .automatic)
        default:
            break
        }
    }
    
    // Rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension PlantTableViewController: PlantCellDelegate {
    func didUpdatePlant(plant: Plant) {
        plantController.addPlant(plant: plant)
    }
}
