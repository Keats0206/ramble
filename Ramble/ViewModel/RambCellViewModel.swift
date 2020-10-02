//
//  RambCellViewModel.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Combine

//class RambCellViewModel: ObservableObject, Identifiable  { // (6)
//  @Published var ramb: Ramb2
//
//    var user: User2
//    var id = ""
//
//    @Published var completionStateIconName = ""
//
//    private var cancellables = Set<AnyCancellable>()
//
////    static func newTask() -> TaskCellViewModel {
////        TaskCellViewModel(task: Task(title: "", priority: .medium, completed: false))
////      }
////
//    init(user: User2, ramb: Ramb2) {
//        self.user = user
//        self.ramb = ramb
//
//        //    $task // (8)
//        //      .map { $0.completed ? "checkmark.circle.fill" : "circle" }
//        //      .assign(to: \.completionStateIconName, on: self)
//        //      .store(in: &cancellables)
//
//        //    $task // (7)
//        //      .map { $0.id }
//        //      .assign(to: \.id, on: self)
//        //      .store(in: &cancellables)
//
//    }
//}
