//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Surajit A Bose on 12/5/14.
//  Copyright (c) 2014 Surajit A Bose. All rights reserved.
//

// Views are optimized for iPhone 6 and iPhone 6+.
// TODO: Redo all constraints to work on other devices

import UIKit
import AVFoundation

class PlaySoundsViewController:UIViewController {

    var audioPlayer: AVAudioPlayer!
    var echoPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        echoPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)

        super.viewDidLoad()
    }

    // Abstracted function for bunny and snail buttons
    func playAudioAtRate(given_rate : Float) {
        stopAudioPlayback()
        audioPlayer.rate = given_rate
        audioPlayer.play()
    }

    // Abstracted function for vader and chipmunk buttons
    func playAudioWithVariablePitch(pitch: Float) {

        var audioPlayerNode = AVAudioPlayerNode()
        stopAudioPlayback()

        audioEngine.attachNode(audioPlayerNode)

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    // Abstracted function for parrot and reverb buttons
    func playEchoAndReverb(delay: NSTimeInterval, vol: Float) {
        stopAudioPlayback()
        var play_delay: NSTimeInterval
        play_delay = echoPlayer.deviceCurrentTime + delay
        echoPlayer.volume = vol
        audioPlayer.play()
        echoPlayer.playAtTime(play_delay)
    }

    // One liners corresponding to each effect and button
    @IBAction func playAudioSlowly(sender: UIButton) {
        playAudioAtRate(0.5)
    }

    @IBAction func playAudioFast(sender: UIButton) {
        playAudioAtRate(2.0)
    }

    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playAudioVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func playAudioEcho(sender: UIButton) {
        playEchoAndReverb(0.5, vol: 0.4)
    }

    @IBAction func playAudioReverb(sender: UIButton) {
        playEchoAndReverb(0.175, vol: 1.0)
    }

    // Triggered by stop button as well as called without 
    // button press from various other functions
    @IBAction func stopAudioPlayback() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.0

        echoPlayer.stop()
        echoPlayer.currentTime = 0.0

        audioEngine.stop()
        audioEngine.reset()
    }

}
