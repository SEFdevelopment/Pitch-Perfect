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
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
    }
    

    // MARK: - @IBActions
    @IBAction func playSlowAudio(_ sender: UIButton) {
        
        playAudioWithVariableRate(0.5)
    }
    
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        
        playAudioWithVariableRate(1.5)
        
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        
        stopAndResetAudio()
        
        let chipmunkEffect = AVAudioUnitTimePitch()
        chipmunkEffect.pitch = 1000
        
        playAudioWithEffect(chipmunkEffect)
        
    }
    
    @IBAction func playDarthvaderAudio(_ sender: UIButton) {
        
        stopAndResetAudio()
        
        let darthvaderEffect = AVAudioUnitTimePitch()
        darthvaderEffect.pitch = -1000
        
        playAudioWithEffect(darthvaderEffect)
        
    }
    
    @IBAction func playEchoAudio(_ sender: UIButton) {
        
        stopAndResetAudio()
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = TimeInterval(2.0)
        
        playAudioWithEffect(echoEffect)
        
    }
    
    
    @IBAction func playReverbAudio(_ sender: UIButton) {
        
        stopAndResetAudio()
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.cathedral)
        reverbEffect.wetDryMix = 50
        
        playAudioWithEffect(reverbEffect)
        
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton) {
        
        audioPlayer.stop()
    }
    
    
    // MARK: - Sound effects
    
    // Fast and slow audio 
    // This can be achieved also by using the AVAudioUnit effects. I left it like it is in the Udacity videos.
    func playAudioWithVariableRate(_ rate: Float) {
        
        stopAndResetAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    // AVAudioUnit effects
    func playAudioWithEffect(_ effect: AVAudioNode) {
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        audioEngine.attach(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
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
