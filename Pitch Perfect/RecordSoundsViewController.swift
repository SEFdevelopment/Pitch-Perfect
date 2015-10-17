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
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Audio recording
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure buttons
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    
    // MARK: - @IBActions
    @IBAction func recordAudio(sender: UIButton) {
        
        // Configure buttons
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        
        // Get the path to the audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        // Set the audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialize the recorder and start recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        
        // Configure labels
        recordingInProgress.hidden = true
        
        // Stop recorder
        audioRecorder.stop()
        
        // Set the audio session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            
            // Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
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

