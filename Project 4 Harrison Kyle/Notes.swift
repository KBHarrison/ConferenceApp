//
//  Notes.swift
//  Project 4 Harrison Kyle
//
//  Created by IS 543 on 12/6/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation

class Notes {
    var noteDates: [Date] = []
    var notes: [String] = []
}

class NotesAccess {
    static let shared = Notes()
    init() {}
}

