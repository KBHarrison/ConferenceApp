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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NotesAccess.shared.notes.count != NotesAccess.shared.noteDates.count {
            fatalError("The counts of the arrays are off. There are \(NotesAccess.shared.notes.count) notes elements and \(NotesAccess.shared.noteDates.count) date elements.")
    }
        return NotesAccess.shared.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = NotesAccess.shared.notes[indexPath.row]

            return cell
    }
}

