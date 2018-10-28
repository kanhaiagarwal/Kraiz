//
//  AudioRecorderViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 04/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
// Audio Recorder Class.

import UIKit
import AVFoundation

protocol AudioRecorderProtocol {
    func audioRecording(recordingURL: URL)
}

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var recordingTime: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: AudioRecorderProtocol?
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    var timer : Timer!
    
    var FILENAME = "audioFile.m4a"
    
    var recordingUrl : URL!
    
    var isRecording : Bool = false
    var isPlaying : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    /// Initial setup of the audio recorder.
    func setupRecorder() {
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 32000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.0 ] as [String : Any]
    
        do {
            try audioRecorder = AVAudioRecorder(url: getFileUrl(), settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }

    @IBAction func closePressed(_ sender: UIButton) {
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "Close Audio Recorder", message: "Are you sure you want to close the audio recorder? Your recording would not be saved.", preferredStyle: .alert)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func preparePlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    /// Get the url of the file path in the device.
    func getFileUrl() -> URL {
        let path = getCacheDirectory().appending(FILENAME)
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    /// Get the file path in the device.
    func getCacheDirectory() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as [String]
        
        return path[0]
    }
    
    @objc func updateTime() {
        let ti = NSInteger(audioRecorder.currentTime)
        let mins = (ti / 60) % 60
        var stringMins : String
        if mins < 10 {
            stringMins = "0" + String(mins)
        } else {
            stringMins = String(mins)
        }
        let seconds = ti % 60
        var stringSeconds : String
        if seconds < 10 {
            stringSeconds = "0" + String(seconds)
        } else {
            stringSeconds = String(seconds)
        }
        recordingTime.text = stringMins + ":" + stringSeconds
    }

    @IBAction func playButtonClicked(_ sender: UIButton) {
        recordButton.isEnabled = false
        isPlaying = !isPlaying
        
        if isPlaying {
            preparePlayer()
            doneButton.isEnabled = false
            audioPlayer.play()
            playButton.setImage(UIImage(named: "recorder-pause"), for: .normal)
        } else {
            doneButton.isEnabled = true
            audioPlayer.pause()
            playButton.setImage(UIImage(named: "recorder-play-enabled"), for: .normal)
            recordButton.isEnabled = true
        }
    }
    
    @IBAction func recordButtonClicked(_ sender: UIButton) {
        isRecording = !isRecording
        
        if isRecording {
            audioRecorder.record()
            playButton.isEnabled = false
            doneButton.isEnabled = false
            recordButton.setImage(UIImage(named: "recorder-stop"), for: .normal)
            
            // Call updateSlider every 0.1 seconds.
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        } else {
            // Stop the timer
            timer.invalidate()
            
            audioRecorder.stop()
            recordButton.setImage(UIImage(named: "recorder-start"), for: .normal)
            playButton.isEnabled = true
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        recordingUrl = getFileUrl()
        
        let alert = UIAlertController(title: "Complete Audio Recording", message: "Do want to complete the Audio Recording", preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            print("Inside the doneAction closure")
            if let pathComponent = self.recordingUrl {
                print("recordingUrl is not nil")
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("File exists in the fileManager")
                self.delegate?.audioRecording(recordingURL: self.recordingUrl)
                } else {
                    print("recordingUrl is nil")
                    self.delegate?.audioRecording(recordingURL: URL(fileURLWithPath: ""))
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        recordButton.setImage(UIImage(named: "recorder-start"), for: .normal)
        doneButton.isEnabled = true
        isPlaying = false
        playButton.setImage(UIImage(named: "recorder-play-enabled"), for: .normal)
    }
}
