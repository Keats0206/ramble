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
        self.recorderState = .ready
    }
//  Currently unused!
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var timer = Timer()
    var recordings = [Recording]()
    
    var rambUrl = "" {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var recorderState: RecordState = .ready {
        didSet {
            objectWillChange.send(self)
        }
    }
    
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
            recorderState = .started
            print("2 \(self.recorderState)")
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
        recorderState = .stopped
        print("3 \(self.recorderState)")
    }
    // store file locally and sort the latest local recordings so newest is at the top
    func sortLatestRecordings() {
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // swiftlint:disable force_try
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        // swiftlint:enable force_try
        for audio in directoryContents {
            let recording = Recording(fileUrl: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
            //  Sort the recordings array by the creation date of its items and eventually update all observing views
            recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
            objectWillChange.send(self)
        }
    }
    
    // Upload to firestore function and get streaming url :)
    
    func uploadLatestRecording() {
        let localFile = recordings[0].fileUrl
        let rambId = UUID().uuidString
        let rambsRef = FBStorageProfileImages.child(rambId)
                        
        rambsRef.putFile(from: localFile, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("error")
                    return
                } else {
                    rambsRef.downloadURL(completion: { [self] (url, error) in
                        rambUrl = (url?.absoluteString)!
                        recorderState = .uploaded
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

enum RecordState {
    case ready
    case started
    case stopped
    case uploaded
}
