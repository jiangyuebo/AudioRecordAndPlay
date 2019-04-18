//
//  ViewController.swift
//  Recorder
//
//  Created by yuebo.jiang on 2019/4/16.
//  Copyright © 2019 com.jerry. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    @IBOutlet weak var stopBTN: UIButton!
    
    let recordTitle = "录音"
    let pauseTitle = "暂停"
    let stopTitle = "停止"
    let playTitle = "播放"
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRecorder()
        playBTN.isEnabled = false
        stopBTN.isEnabled = false
    }
    
    func setupUI() {
        recordBTN.setTitle(recordTitle, for: .normal)
        playBTN.setTitle(playTitle, for: .normal)
        stopBTN.setTitle(stopTitle, for: .normal)
    }
    
    func getDocumentsDirectory() -> URL {
        let url = URL(fileURLWithPath: filePath!)
        return url
    }
    
    func setupRecorder() {
        let audioFileName = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let session = AVAudioSession.sharedInstance()
        //set session
        do{
            try session.setCategory(.playAndRecord)
        }catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        
        //set session action
        do{
            try session.setActive(true)
        }catch let err{
            print("初始化失败:\(err.localizedDescription)")
        }
        
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless ,
                             AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue ,
                             AVEncoderBitRateKey : 320000 ,
                             AVNumberOfChannelsKey : 1 ,
                             AVSampleRateKey : 44100.2
        ] as [String : Any]
        
        do{
            soundRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func setupPlayer() {
        let audioFileName = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 10.0
        } catch {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        stopBtnStatus()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopBtnStatus()
    }

    //record and pause
    @IBAction func recordAction(_ sender: Any) {
        if recordBTN.titleLabel?.text == recordTitle {
            print("开始录音")
            soundRecorder.record()
            
            recordingBtnStatus()
        }else{
            print("暂停了")
            soundRecorder.pause()
            pausingBtnStatus()
        }
        
    }
    
    //stop record
    @IBAction func stopAction(_ sender: Any) {
        print("停止录音")
        soundRecorder.stop()
        
        stopBtnStatus()
    }
    
    //play
    @IBAction func playAction(_ sender: Any) {
        if playBTN.titleLabel?.text == playTitle {
            setupPlayer()
            soundPlayer.play()
            
            playingBtnStatus()
        }else{
            soundPlayer.stop()
            
            stopBtnStatus()
        }
    }
    
    //button status
    func recordingBtnStatus(){
        recordBTN.setTitle(pauseTitle, for: .normal)
        stopBTN.setTitle(stopTitle, for: .normal)
        playBTN.setTitle(playTitle, for: .normal)
        
        recordBTN.isEnabled = true
        stopBTN.isEnabled = true
        playBTN.isEnabled = false
    }
    
    func pausingBtnStatus(){
        recordBTN.setTitle(recordTitle, for: .normal)
        stopBTN.setTitle(stopTitle, for: .normal)
        playBTN.setTitle(playTitle, for: .normal)
        
        recordBTN.isEnabled = true
        stopBTN.isEnabled = true
        playBTN.isEnabled = false
    }
    
    func stopBtnStatus(){
        recordBTN.setTitle(recordTitle, for: .normal)
        stopBTN.setTitle(stopTitle, for: .normal)
        playBTN.setTitle(playTitle, for: .normal)
        
        recordBTN.isEnabled = true
        stopBTN.isEnabled = false
        playBTN.isEnabled = true
    }
    
    func playingBtnStatus(){
        recordBTN.setTitle(recordTitle, for: .normal)
        stopBTN.setTitle(stopTitle, for: .normal)
        playBTN.setTitle(stopTitle, for: .normal)
        
        recordBTN.isEnabled = false
        stopBTN.isEnabled = false
        playBTN.isEnabled = true
    }
}

