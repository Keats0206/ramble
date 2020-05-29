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

class AudioRecorder: NSObject,ObservableObject {
    
    override init() {
        super.init()
        
        sortLatestRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
   
    var strmURL = ""
    
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
        
//        postRamb()
    }
    
    // Store url on firebase
    
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
                                print("Stream URL: \((url?.absoluteString)!)")
                                
                                // If this was succesful should we delete the last recording stored locally...hmmm
                            })
                        }
                    })
            }
    
    func sortThenUpload() {
        
        sortLatestRecordings()
        
        uploadLatestRecording()
        
    }
    
    func postRamb(title: String) {
                
        let db = Firestore.firestore()
        
            db.collection("rambs").document().setData(
                ["name":"Pete",
                 "id":"@pete",
                 "userimage": "https://media-exp1.licdn.com/dms/image/C5603AQGbHL6OVW4A8A/profile-displayphoto-shrink_400_400/0?e=1596067200&v=beta&t=K0rDOMqlkKiL8xnxktJaVUDO_H8ct2bXqV4E_AVXQ2Y",
                 "title":"\(title)",
                 "length":"59s",
                 "applause":"0",
                 "stream": "stream",
                 "time":"12:04:68",
                 "date":"5/27/19"
                ])
            { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    
                    return
                }
            print("success")
        }
    }
}
        
//        1. User types in input field with a name
    
//        2. If user bails on post, show alert. If yes - call delete recording function from local & cloud. If no, return to before alert.
        
//        3. User hits POST button - create Ram in data base with user, uid, post title, rambUUID, downloadURL, claps array, location!
        
//        4. Call function that refreshes feed.
        
        func deleteRamb() {
            print("deletePastRamb")
        }

//    func postRamb() {
//
//        let db = Firestore.firestore()
//
//        db.collection("rambs").document().setData(
//            ["name":"Pete",
//             "id":"@pete",
//             "userimage": "https://media-exp1.licdn.com/dms/image/C5603AQGbHL6OVW4A8A/profile-displayphoto-shrink_400_400/0?e=1596067200&v=beta&t=K0rDOMqlkKiL8xnxktJaVUDO_H8ct2bXqV4E_AVXQ2Y",
//             "title":"this a second test audio post",
//             "length":"59s",
//             "applause":"0",
//             "stream":"https://firebasestorage.googleapis.com/v0/b/ramb-ecce1.appspot.com/o/rambs%2FrambA22D42A0-CEC2-4CDD-A474-3B44A90EA643?alt=media&token=0bda7895-8092-4ee5-8169-807925535d14",
//             "time":"12:04:68",
//             "date":"5/27/19"
//        ])
//            { (err) in
//                if err != nil{
//                    print((err?.localizedDescription)!)
//                    return
//                }
//                print("ramb uploaded")
//            }
//    }

    // CreateRamb
    
    // 1. User types in input field with a name
        
    // 2. If user bails on post, show alert. If yes - call delete recording function from local & cloud. If no, return to before alert.
    
    // 3. User hits POST button - create Ram in data base with user, uid, post title, rambUUID, downloadURL, claps array, location!
    
    // 4. Call function that refreshes feed.
        
    
//      Function to add a delete button to the recordings
        
//      func deleteRecording(urlsToDelete: [URL]) {
//
//        for url in urlsToDelete {
//            print(url)
//            do {
//               try FileManager.default.removeItem(at: url)
//            } catch {
//                print("File could not be deleted!")
//            }
//        }
