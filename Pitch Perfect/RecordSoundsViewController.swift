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
        
        case Stopped
        case InProgress
        case Paused
        
    }
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    
    // MARK: - Audio recording
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingState: RecordingState = .Stopped
    
    
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
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Initialize the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUIForRecordingState(.Stopped)
        
    }
    
    
    // MARK: - @IBActions
    @IBAction func recordAudio(sender: UIButton) {
        
        switch recordingState {
            
        case .Stopped:
            
            recordingState = .InProgress
            configureUIForRecordingState(recordingState)
            
            audioRecorder.record()
            
        case .InProgress:
            
            recordingState = .Paused
            configureUIForRecordingState(recordingState)
            
            audioRecorder.pause()
            
        case .Paused:
            
            recordingState = .InProgress
            configureUIForRecordingState(recordingState)
            
            audioRecorder.record()
            
        }
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        
        // Configure UI
        recordingState = .Stopped
        configureUIForRecordingState(recordingState)
        
        // Stop recorder
        audioRecorder.stop()
        

    }
    
    
    // MARK: - Configure UI
    func configureUIForRecordingState(recordingState: RecordingState) {
        
        switch recordingState {
            
        case .Stopped:
            
            recordButton.setImage(microphoneImage, forState: .Normal)
            recordingInProgress.text = "Tap to start recording"
            stopButton.hidden = true
            
        case .InProgress:
            
            recordButton.setImage(microphonePauseImage, forState: .Normal)
            recordingInProgress.text = "Recording..."
            stopButton.hidden = false
            
        case .Paused:
            
            recordButton.setImage(microphoneImage, forState: .Normal)
            recordingInProgress.text = "Tap to resume recording"
            stopButton.hidden = false
            
        }
        
        
    }
    
    
    // MARK: - AVAudioRecorderDelegate methods
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            
            // Save the recorded audio
            let filePathUrl = recorder.url
            let title = recorder.url.lastPathComponent
            recordedAudio = RecordedAudio(filePathUrl: filePathUrl, title: title)

            // Perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
        
    }
    
    
    // MARK: - Storyboard segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "stopRecording" {
            
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
        
    }
    
}

