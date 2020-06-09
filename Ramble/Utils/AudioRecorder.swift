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
    
    var strmurl = "filed"
    var data = ""

    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
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
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    // Stop recording locally
    
    func stopRecording() {
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
        let rambUUID = UUID().uuidString
        let storageRef = Storage.storage().reference(forURL: "gs://ramb-ecce1.appspot.com")
        let rambsRef = storageRef.child("rambs").child("ramb" + rambUUID)
        
        rambsRef.putFile(from: localFile, metadata: nil
                , completion: { (metadata, error) in
                        if error != nil {
                            print("error")
                            return
                        } else {
                            rambsRef.downloadURL(completion: { (url, error) in
                                
                                print("uploading URL")
                                
                                return self.strmurl = (url?.absoluteString)!
                                                                
                                // If this was succesful should we delete the last recording stored locally...hmmm
                            })
                        }
                })
    }
    
    
    
    func sortThenUpload() {
        
        sortLatestRecordings()
        
        uploadLatestRecording()
        
    }
}
