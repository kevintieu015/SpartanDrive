//
//  Music.swift
//  Project Group 7
//
//  Created by Johnny Sun on 10/9/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import Foundation
import AVKit
class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    func playBackgroundMusic() {
        if MusicisOn{
        var  BackgroundMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Avicii - The Nights", ofType: "mp3")!)
        if MusicChoice == 1{
        BackgroundMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Avicii - The Nights", ofType: "mp3")!)
        }
        else if MusicChoice == 2{
            BackgroundMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "MaskOff_Instrumental", ofType: "mp3")!)
        }
        else if MusicChoice == 3{
            BackgroundMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Kygo Firestone Instrumental", ofType: "mp3")!)
        }
        print(BackgroundMusic)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:BackgroundMusic as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
            }
        }
    if !MusicisOn{
    audioPlayer!.stop()
    }
    
    }
    
}

