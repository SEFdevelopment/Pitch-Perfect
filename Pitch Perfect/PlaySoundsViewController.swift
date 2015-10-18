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
        
        stopAndResetAudio()
        
        let chipmunkEffect = AVAudioUnitTimePitch()
        chipmunkEffect.pitch = 1000
        
        playAudioWithEffect(chipmunkEffect)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        stopAndResetAudio()
        
        let darthvaderEffect = AVAudioUnitTimePitch()
        darthvaderEffect.pitch = -1000
        
        playAudioWithEffect(darthvaderEffect)
        
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        stopAndResetAudio()
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(2.0)
        
        playAudioWithEffect(echoEffect)
        
    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        stopAndResetAudio()
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.Cathedral)
        reverbEffect.wetDryMix = 50
        
        playAudioWithEffect(reverbEffect)
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        
        audioPlayer.stop()
    }
    
    
    // MARK: - Sound effects
    
    // Fast and slow audio 
    // This can be achieved also by using the AVAudioUnit effects. I left it like it is in the Udacity videos.
    func playAudioWithVariableRate(rate: Float) {
        
        stopAndResetAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    // AVAudioUnit effects
    func playAudioWithEffect(effect: AVAudioNode) {
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    
    // MARK: - Audio engine stop and reset
    func stopAndResetAudio() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }

    
}
