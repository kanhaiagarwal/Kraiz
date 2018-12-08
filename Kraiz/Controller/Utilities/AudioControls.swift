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
    
    func playBackgroundMusic(musicIndex: Int) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: BackgroundMusic.musicFiles[musicIndex], ofType: "mp3")!)
        do {
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
//        if audioPlayer != nil && audioPlayer!.isPlaying {
//            audioPlayer!.setVolume(0, fadeDuration: 3.0)
//            UIView.animate(withDuration: 3.0, animations: {
//
//            }) { (success) in
//                self.pauseTime = self.audioPlayer!.currentTime
//                self.audioPlayer!.pause()
//            }
//        }
    }
    
    func stopMusic() {
        if audioPlayer != nil && audioPlayer!.isPlaying {
            audioPlayer!.stopFadeOut()
        }
//        if audioPlayer != nil && audioPlayer!.isPlaying {
//            audioPlayer!.setVolume(0, fadeDuration: 3.0)
//            UIView.animate(withDuration: 3.0, animations: {
//
//            }) { (success) in
//                self.audioPlayer!.stop()
//            }
//        }
    }
    
    func resumeMusic() {
        if audioPlayer != nil {
            audioPlayer!.setVolume(1.0, fadeDuration: 0)
            audioPlayer!.play(atTime: pauseTime!)
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
