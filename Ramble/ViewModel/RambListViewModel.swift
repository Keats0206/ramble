//
//  RambListViewModel.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Combine

//class RambListViewModel: ObservableObject { // (1)
//  @Published var rambCellViewModels = [RambCellViewModel]() // (3)
//
//  private var cancellables = Set<AnyCancellable>()
//
//  init() {
//    self.rambCellViewModels = testDataRamb.map { ramb in // (2)
//      RambCellViewModel(ramb: ramb)
//    }
//  }
//
//  func removeTasks(atOffsets indexSet: IndexSet) { // (4)
//    rambCellViewModels.remove(atOffsets: indexSet)
//  }
//
//  func addTask(ramb: Ramb2) { // (5)
//    rambCellViewModels.append(RambCellViewModel(ramb: ramb))
//  }
//}
