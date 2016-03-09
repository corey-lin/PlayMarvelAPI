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
  let perfectScore = MutableProperty<Bool>(false)
  let newRecordScore = MutableProperty<Bool>(false)
  init() {
    finalScore = MutableProperty<Int>(0)
  }
  init(_ score: Int) {
    finalScore = MutableProperty<Int>(score)
    finalScore.producer.startWithNext {
      currentScore in
      let recordScore: Int = NSUserDefaults.standardUserDefaults().integerForKey(Constants.RecordScoreKey)
      if recordScore < currentScore {
        self.newRecordScore.value = true
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: Constants.RecordScoreKey)
      }
      if currentScore == 100 {
        self.perfectScore.value = true
      }
    }

  }
}
