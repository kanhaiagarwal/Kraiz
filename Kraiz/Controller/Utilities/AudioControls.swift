//
//  AudioControls.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 07/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import AVFoundation
import UIKit

public class AudioControls {

    public static let shared = AudioControls()
    private var audioPlayer : AVAudioPlayer?
    private var pauseTime : TimeInterval?
    private var playAudioOnForeground = false
    
    private init() {
        pauseTime = 0
    }

    func setPauseTime(time: TimeInterval) {
        pauseTime = time
    }
    
    func getCurrentTime() -> TimeInterval {
        if audioPlayer != nil {
            return audioPlayer!.currentTime
        }
        return 0
    }
    
    func isAudioPlaying() -> Bool {
        if audioPlayer != nil && audioPlayer!.isPlaying {
            return true
        }
        return false
    }
    
    func setPlayAudioOnForeground(playAudio: Bool) {
        playAudioOnForeground = playAudio
    }
    
    func getPlayAudioOnForeground() -> Bool {
        return playAudioOnForeground
    }
    
    func playBackgroundMusic(musicIndex: Int) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: BackgroundMusic.musicFiles[musicIndex], ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.setVolume(1.0, fadeDuration: 0)
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func pauseMusic() {
        if audioPlayer != nil && audioPlayer!.isPlaying {
            audioPlayer!.pauseFadeOut()
        }
    }
    
    func stopMusic() {
        if audioPlayer != nil && audioPlayer!.isPlaying {
            audioPlayer!.stopFadeOut()
        }
    }
    
    func resumeMusic() {
        print("inside resumeMusic")
        if audioPlayer != nil {
            print("audioPlayer is not nil")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.duckOthers)
                try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
                audioPlayer!.setVolume(1.0, fadeDuration: 0)
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                print("audioPlayer.isPlaying: \(audioPlayer!.isPlaying)")
                print("audioPlayer.volume: \(audioPlayer!.volume)")
            } catch {
                print("Cannot resume the audio")
            }
        } else {
            print("AudioPlayer is nil")
        }
    }
}

extension AVAudioPlayer {
    @objc func pauseFadeOut() {
        if volume > 0.1 {
            // Fade
            volume -= 0.1
            perform(#selector(pauseFadeOut), with: nil, afterDelay: 0.1)
        } else {
            // Stop and get the sound ready for playing again
            pause()
            AudioControls.shared.setPauseTime(time: AudioControls.shared.getCurrentTime())
            volume = 1
        }
    }
    
    @objc func stopFadeOut() {
        if volume > 0.1 {
            // Fade
            volume -= 0.1
            perform(#selector(stopFadeOut), with: nil, afterDelay: 0.1)
        } else {
            // Stop and get the sound ready for playing again
            stop()
            prepareToPlay()
            volume = 1
        }
    }
}
