//
//  ResultViewModel.swift
//  NameSHero
//
//  Created by coreylin on 3/5/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ResultViewModel {
  let finalScore: MutableProperty<Int>
  init() {
    finalScore = MutableProperty<Int>(0)
  }
  init(_ score: Int) {
    finalScore = MutableProperty<Int>(score)
  }
}
