//
//  ResultViewController.swift
//  NameSHero
//
//  Created by coreylin on 3/5/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import Twinkle
import Shimmer

class ResultViewController: UIViewController {
  @IBOutlet weak var finalScoreLabel: UILabel!
  @IBOutlet weak var perfectScoreLabel: UILabel!
  @IBOutlet weak var newRecordLabel: UILabel!
  @IBOutlet weak var finalScoreView: FBShimmeringView!

  var timer: NSTimer?
  var viewModel = ResultViewModel()

  override func viewDidLoad() {
    timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("twinkleLabels"), userInfo: nil, repeats: true)
    viewModel.finalScore.producer.startWithNext {
      score in
      self.finalScoreLabel.text = "\(score)"
    }
    viewModel.newRecordScore.producer.startWithNext {
      newRecord in
      if newRecord {
        self.newRecordLabel.hidden = false
      } else {
        self.newRecordLabel.hidden = true
      }
    }
    viewModel.perfectScore.producer.startWithNext {
      perfect in
      if perfect {
        self.perfectScoreLabel.hidden = false
      } else {
        self.perfectScoreLabel.hidden = true
      }
    }
    finalScoreView.contentView = finalScoreLabel
    finalScoreView.shimmering = true
  }

  func twinkleLabels() {
    self.newRecordLabel.twinkle()
    self.perfectScoreLabel.twinkle()
  }
  
  deinit {
    timer?.invalidate()
  }

  @IBAction func backToMainScreen(sender: AnyObject) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }

  @IBAction func backToQuizScreen(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }

  func bindViewModel(vm: ResultViewModel!) {
    viewModel = vm
  }
}