//
//  NotesTableController.swift
//  Project 4 Harrison Kyle
//
//  Created by IS 543 on 12/6/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation
import UIKit

class NotesTableController : UITableViewController {
    
    //    MARK: - Properties
    
    var selectedRow = -1
    let segueIdentifier = "ShowNote"
    
    //    MARK: - Actions
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //    MARK: - Lifecycle Hooks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NotesAccess.shared.notes.count == 0 {
            self.title = "No Saved Notes"
        }
    }
    
    //    MARK: - Delegate Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
        navigationController?.navigationBar.alpha = 0.5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index path.row is \(indexPath.row)")
        selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? UINavigationController {
            if let finalController = nextViewController.topViewController as? DetailViewController {
                finalController.index = selectedRow
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if NotesAccess.shared.notes.count != NotesAccess.shared.noteDates.count {
            let noteCount = NotesAccess.shared.notes.count
            let dateCount = NotesAccess.shared.noteDates.count
            NotesAccess.shared.notes = []
            NotesAccess.shared.noteDates = []
            fatalError("The counts of the arrays are off. There are \(noteCount) notes elements and \(dateCount) date elements. Deleting all data.")
        }
        
        return NotesAccess.shared.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = NotesAccess.shared.notes[indexPath.row]
        cell.detailTextLabel?.text = NotesAccess.shared.noteDates[indexPath.row].toMediumString() as String
        return cell
    }
}

