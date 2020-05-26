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
    var userimage : String
    var msg : String
    var length : String
    var date : String
    var like : String
    var comments: String
    var echos : String
    var streamurl : String
    var tagId : String

}

class getData : ObservableObject {

    @Published var datas = [datatype]()

        init() {

            let db = Firestore.firestore()

                db.collection("rambles").addSnapshotListener { (snap, err) in

                if err != nil {

                    print ((err?.localizedDescription)!)
                    return
                }

                for i in snap!.documentChanges{

                    if i.type == .added{

                        let id = i.document.documentID
                        let userimage = i.document.get("userimage") as! String
                        let msg = i.document.get("msg") as! String
                        let length = i.document.get("length") as! String
                        let date = i.document.get("date") as! String
                        let like = i.document.get("like") as! String
                        let comments = i.document.get("comments") as! String
                        let echos = i.document.get("echos") as! String
                        let streamurl = i.document.get("streamurl") as! String
                        let tagId = i.document.get("id") as! String

                        print("hello world")

                        DispatchQueue.main.async {
                            self.datas.append(datatype(id: id, userimage: userimage, msg: msg, length: length, date: date, like: like, comments: comments, echos: echos, streamurl: streamurl, tagId: tagId))
                        }
                    }
                }
            }
        }
    }

