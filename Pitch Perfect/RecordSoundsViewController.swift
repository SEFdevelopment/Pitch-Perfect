//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Andrei Sadovnicov on 17/10/15.
//  Copyright © 2015 SEFdevelopment. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - TYPES
    enum RecordingState {
        
        case stopped
        case inProgress
        case paused
        
    }
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    
    // MARK: - Audio recording
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingState: RecordingState = .stopped
    
    
    // MARK: - Microphone button images
    let microphoneImage = UIImage(named: "microphone")
    let microphonePauseImage = UIImage(named: "microphonepause")
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // File path to the audio file
        
        /*
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        
        // let filePath = URL(withPathComponents: pathArray)
        
        // let filePath = URL.fileURL(withPathComponents: pathArray)
        
         */
 
        let fileManager = FileManager.default
        let documentDirectoryUrl = try! fileManager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let audioFileUrl = documentDirectoryUrl.appendingPathComponent("my_audio.wav")
        
        
        // Initialize the recorder
        try! audioRecorder = AVAudioRecorder(url: audioFileUrl, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUIForRecordingState(.stopped)
        
    }
    
    
    // MARK: - @IBActions
    @IBAction func recordAudio(_ sender: UIButton) {
        
        switch recordingState {
            
        case .stopped:
            
            recordingState = .inProgress
            configureUIForRecordingState(recordingState)
            
            audioRecorder.record()
            
        case .inProgress:
            
            recordingState = .paused
            configureUIForRecordingState(recordingState)
            
            audioRecorder.pause()
            
        case .paused:
            
            recordingState = .inProgress
            configureUIForRecordingState(recordingState)
            
            audioRecorder.record()
            
        }
        
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton) {
        
        // Configure UI
        recordingState = .stopped
        configureUIForRecordingState(recordingState)
        
        // Stop recorder
        audioRecorder.stop()
        

    }
    
    
    // MARK: - Configure UI
    func configureUIForRecordingState(_ recordingState: RecordingState) {
        
        switch recordingState {
            
        case .stopped:
            
            recordButton.setImage(microphoneImage, for: UIControlState())
            recordingInProgress.text = "Tap to start recording"
            stopButton.isHidden = true
            
        case .inProgress:
            
            recordButton.setImage(microphonePauseImage, for: UIControlState())
            recordingInProgress.text = "Recording..."
            stopButton.isHidden = false
            
        case .paused:
            
            recordButton.setImage(microphoneImage, for: UIControlState())
            recordingInProgress.text = "Tap to resume recording"
            stopButton.isHidden = false
            
        }
        
        
    }
    
    
    // MARK: - AVAudioRecorderDelegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            
            // Save the recorded audio
            let filePathUrl = recorder.url
            let title = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(filePathUrl: filePathUrl, title: title)

            // Perform segue
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
            
        } else {
            
            recordButton.isEnabled = true
            stopButton.isHidden = true
            
        }
        
    }
    
    
    // MARK: - Storyboard segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
        
    }
    
}

