//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Surajit A Bose on 11/9/14.
//  Copyright (c) 2014 Surajit A Bose. All rights reserved.
//

import UIKit
import AVFoundation

// Views are optimized for iPhone 6 and iPhone 6+. 
// TODO: Redo all constraints to work on other devices

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!

    @IBOutlet weak var recordingInProgress: UILabel!



    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordingInProgress.text = "Tap to Record"

        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(sender: UIButton) {

        recordButton.enabled = false
        recordingInProgress.text = "Recording in Progress"
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        resumeButton.enabled = false


        // Set path and name for saved audio file
        // Course suggests using date stamp to mark recordings
        // but there is no way shown to access earlier recordings
        // so reuse name in order to keep inaccessible recordings
        // from piling up

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let recordingName = "audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)


        // Record audio

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {

        // Trigger segue, or handle error
        if (flag) {
            recordingInProgress.text = "Tap to Record"
            recordedAudio = RecordedAudio(path: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            recordingInProgress.text = "Recording Failed! Try Again"
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Pass recorded file to next VC
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        recordButton.enabled = true
        stopButton.hidden = true
        resumeButton.hidden = true
        pauseButton.hidden = true

        audioRecorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }

    // Pause and Resume functionality
    // Somewhat hacky; does not actually check whether
    // recording is in progress/paused before attempting
    // to pause/resume. 
    // TODO: unhack this, implement proper checks

    @IBAction func pauseRecording(sender: UIButton) {
        stopButton.enabled = false
        resumeButton.enabled = true
        pauseButton.enabled = false
        recordingInProgress.text = "Recording Paused"
        audioRecorder.pause()
    }

    @IBAction func resumeRecording(sender: UIButton) {
        stopButton.enabled = true
        resumeButton.enabled = false
        pauseButton.enabled = true
        recordingInProgress.text = "Recording in Progress"
        audioRecorder.record()

    }
}

