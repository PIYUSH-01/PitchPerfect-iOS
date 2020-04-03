//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by PIYUSH KHURANA on 31/03/20.
//  Copyright © 2020 PIYUSH KHURANA. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var stopRecordingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func recordAudio(_ sender: Any) {
//        print("Record button is pressed") //This is called the caveman debuggin in which we are basically confirming that whenever we tap the button associated to this action this function will be invoked.
        recordingLabel.text = "Recording is in progress."
        
//        now in this stage the user is currently recordig someaudio thus we will hide the record button and show the stop recording button
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
//        Here we added the functionalities that we will be using of AVFOundation
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to record" //This text will appear after the user has presssed the stop recording button
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
//        print("Stop recording buton was pressed") (Caveman debugging)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        //here the flag we are checking is the flag in the function that will determine if the task was succesful ornot
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) //Here weare performing the segue manually, this is the segue fromthe first view controller to the secodn view controller and not fromsome UIButton of the first VC to the 2nd VC. Here although the paht is in the form of URL but it is the normal paht

        }
        else{
            print("recording was not successful")
        }
//        print("finished recording") //Caveman debugging
    }
    
//    This function prepare for segue is called whenthe path has been changed and the segue leads to the 2nd VC BUT THIS FUNCTION IS CALLED FOR THE FIRST VC ANDNOT THE 2ND VC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

