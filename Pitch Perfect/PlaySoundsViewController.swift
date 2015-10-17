//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Andrei Sadovnicov on 17/10/15.
//  Copyright © 2015 SEFdevelopment. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - Audio saving
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    // MARK: - Audio engine
    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayer!
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }
    

    // MARK: - @IBActions
    @IBAction func playSlowAudio(sender: UIButton) {
        
        playAudioWithVariableRate(0.5)
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        
        playAudioWithVariableRate(1.5)
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        
        audioPlayer.stop()
    }
    
    
    // MARK: - Sound effects
    func playAudioWithVariablePitch(pitch: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    
    func playAudioWithVariableRate(rate: Float) {
        
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }

    
}
