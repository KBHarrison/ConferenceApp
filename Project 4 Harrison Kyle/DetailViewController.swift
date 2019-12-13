//
//  DetailViewController.swift
//  Project 4 Harrison Kyle
//
//  Created by IS 543 on 12/12/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: ViewController, UITextViewDelegate {
    
    //    MARK: - Properties
    
    var index: Int = -1
    
    //    MARK: - Outlets
    
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var copyLabel: UILabel!
    
    //    MARK: LifeCycle Hooks
    
    override func viewDidLoad() {
        if index != -1 {
            noteField.text = NotesAccess.shared.notes[index]
            self.title = "Note recorded on \(NotesAccess.shared.noteDates[index].toShortString())"
        }
        else {
            noteField.text = "Note not found. Index is \(index). Please try again"
        }
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        addGradient()
        noteField.delegate = self
    }
    
    //    MARK: - Helper Functions
    
    
    @IBAction func copyText(_ sender: Any) {
        UIPasteboard.general.string = noteField.text
        copyLabel.alpha = 1
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        NotesAccess.shared.notes.remove(at: index)
        NotesAccess.shared.noteDates.remove(at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "saveDefaults"), object: nil)
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.opacity = 0.5
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        copyLabel.alpha = 0
    }
}


