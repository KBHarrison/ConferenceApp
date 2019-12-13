//
//  MainController.swift
//  Project 4 Harrison Kyle
//
//  Created by IS 543 on 12/6/19.
//  Copyright © 2019 IS 543. All rights reserved.
//

import Foundation
import UIKit
import Speech


@IBDesignable
class MainController : ViewController, SFSpeechRecognizerDelegate {
    
    //    MARK: - Properties
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    //    MARK: - Constants
    
    struct Keys {
        let notesKey = "Notes"
        let datesKey = "Dates"
    }
    
    
    //    MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Actions
    
    @IBAction func Save(_ sender: Any) {
        NotesAccess.shared.notes.append(textView.text)
        NotesAccess.shared.noteDates.append(NSDate() as Date)
        print(NotesAccess.shared.notes.count)
        saveDefaults()
    }
    
    @IBAction func PushButton(_ sender: Any) {
        getPermission()
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("New Recording", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    //    MARK: - Lifecycle Hooks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.setTitle("Start Recording", for: .normal) 
        speechRecognizer?.delegate = self
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        restoreDefaults()
        addGradient()
        NotificationCenter.default.addObserver(self, selector: #selector(callSaveDefaults(_:)), name: Notification.Name(rawValue: "saveDefaults"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        saveDefaults()
    }
    
    //    MARK: - Helper Functions
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.opacity = 0.5
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func saveDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(NotesAccess.shared.notes, forKey: "Notes") //TODO: Reference Keys.Notes
        defaults.set(NotesAccess.shared.noteDates, forKey: "Dates")
        
    }
    
    @objc func callSaveDefaults(_ notification: Notification) {
        saveDefaults()
    }
    
    func restoreDefaults() {
        
        let defaults = UserDefaults.standard
        if let notesArray = defaults.array(forKey: "Notes" ) as? [String] {
            if let dateArray =  defaults.array(forKey: "Dates") as? [Date] {
                NotesAccess.shared.notes = notesArray
                NotesAccess.shared.noteDates = dateArray
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        textView.text = "Say something, I'm listening!"
    }
    
    func getPermission() {
        // Make the authorization request
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // The authorization status results in changes to the
            // app’s interface, so process the results on the app’s
            // main queue.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access                               to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition                           restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet                                          authorized", for: .disabled)
                @unknown default:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Option not recognized", for: .disabled)
                }
            }
        }
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
}
