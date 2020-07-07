//
//  AudioRecorder.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine
import Firebase
import FirebaseStorage

class AudioRecorder: NSObject, ObservableObject {
    override init() {
        super.init()
        sortLatestRecordings()
    }
    
//  Currently unused!

    @Published var rambUrl: String = "";
    @Published var rambFileID: String = "";
    @Published var currentTime: Int = 0
    @Published var didUpload = false

    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var timer = Timer()
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    // Starting recording locally
    
    func startRecording() {
        
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
                
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            //      start recorder
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record(forDuration: 60.0)
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    // Stop recording locally
    
    func stopRecording() {
//      stop recorder
        audioRecorder.stop()
        recording = false
        sortThenUpload()
    }
    
    // store file locally and sort the latest local recordings so newest is at the top
    
    func sortLatestRecordings(){
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
            //  Sort the recordings array by the creation date of its items and eventually update all observing views
            recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
            objectWillChange.send(self)
        }
    }
    
    // Upload to firestore function and get streaming url :)
    
    func uploadLatestRecording() {
        let localFile = recordings[0].fileURL
        let rambId = UUID().uuidString
        let rambsRef = STORAGE_RAMBS.child(rambId)
        
        rambsRef.putFile(from: localFile, metadata: nil
            , completion: { (metadata, error) in
                if error != nil {
                    print("error")
                    return
                } else {
                    rambsRef.downloadURL(completion: { (url, error) in
                        self.rambUrl = (url?.absoluteString)!
                        self.rambFileID = rambId
                        self.didUpload.toggle()
                        return
                    })
                }
        })
    }
    
    func sortThenUpload() {
        sortLatestRecordings()
        uploadLatestRecording()
    }
}
