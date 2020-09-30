//
//  TestData.swift
//  Ramble
//
//  Created by Peter Keating on 9/27/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

let _user = User(uid: "1", values: [
                 "id": "1",
                 "email": "testing@gmail.com",
                 "username": "Testuser",
                 "fullname": "Testuser",
                 "profileImageUrl": "https://electrek.co/wp-content/uploads/sites/3/2020/08/Tesla-Elon-Musk.jpg?quality=82&strip=all",
                 "isCurrentUser": true,
                 "bio": "Hey, I'm a test user this my bio",
                 "isFollowed": true
])

let _ramb = Ramb(user: _user, id: "1", dictionary: [
                    "id": 1,
                    "caption": "I love music wow this is so fun",
                    "claps": 0,
                    "length": 30,
                    "rambUrl": "https://firebasestorage.googleapis.com/v0/b/ramb-ecce1.appspot.com/o/rambs%2F049D2988-6618-458E-9A70-8EDBDAB70BDC?alt=media&token=8b3004a8-76fd-4050-9bce-c1c79eaabf6d",
                    "fileId": "257671983",
                    "uid": "1",
                    "timestamp":"-1601176781",
                    "user": _user,
])
