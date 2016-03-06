//
//  ResultViewController.swift
//  NameSHero
//
//  Created by coreylin on 3/5/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
  @IBOutlet weak var finalScoreLabel: UILabel!
  var viewModel = ResultViewModel()

  override func viewDidLoad() {
    viewModel.finalScore.producer.startWithNext {
      score in
      self.finalScoreLabel.text = "\(score)"
      let recordScore: Int = NSUserDefaults.standardUserDefaults().integerForKey(Constants.RecordScoreKey)
      if recordScore < score {
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: Constants.RecordScoreKey)
      }
    }
  }

  func bindViewModel(vm: ResultViewModel!) {
    viewModel = vm
  }
}