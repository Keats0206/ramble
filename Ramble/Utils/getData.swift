//
//  getData.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Firebase

struct datatype : Identifiable {

    var id : String
    var name : String
    var userimage : String
    var title : String
    var length : String
    var date : String
    var time : String
    var applause : String
    var stream : String
    var tagId : String
    
}

class getData : ObservableObject {

    @Published var datas = [datatype]()

        init() {

            let db = Firestore.firestore()

                db.collection("rambs").addSnapshotListener { (snap, err) in

                if err != nil {

                    print ((err?.localizedDescription)!)
                    return
                }

                for i in snap!.documentChanges{

                    if i.type == .added{
                        
                        let id = i.document.documentID
                        let name = i.document.get("name") as! String
                        let userimage = i.document.get("userimage") as! String
                        let title = i.document.get("title") as! String
                        let length = i.document.get("length") as! String
                        let date = i.document.get("date") as! String
                        let time = i.document.get("time") as! String
                        let applause = i.document.get("applause") as! String
                        let stream = i.document.get("stream") as! String
                        let tagId = i.document.get("id") as! String
                        
                        print("Hello World")

                        DispatchQueue.main.async {
                            self.datas.append(datatype(id: id, name: name, userimage: userimage, title: title, length: length, date: date, time: time, applause: applause, stream: stream, tagId: tagId))
                        }
                    }
                }
            }
        }
    }

