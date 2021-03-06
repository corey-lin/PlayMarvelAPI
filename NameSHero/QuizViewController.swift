//
//  QuizViewController.swift
//  NameSHero
//
//  Created by coreylin on 3/2/16.
//  Copyright © 2016 coreylin. All rights reserved.
//
import UIKit
//import ReactiveCocoa
import Kingfisher
import SwiftSpinner
import TAOverlay

class QuizViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet var choiceButtons: [UIButton]!
  @IBOutlet weak var quizPlayView: UIView!

  var viewModel = QuizViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.pictureURL.producer.startWithNext {
      print("\($0)")
      if let imageURL = $0 {
        self.pictureImageView.kf_setImageWithURL(imageURL)
      }
    }
    viewModel.choices.producer.startWithNext {
      if let choices = $0 {
        for index in 0..<choices.count {
          self.choiceButtons[index].setTitle(choices[index], forState: UIControlState.Normal)
        }
      }
    }
    viewModel.numberOfQuests.producer.startWithNext {
      if $0 > 0 {
        let score = ($0 - 1) * 10
        self.scoreLabel.text = "Score:\(score)"
        if score == 100 {
          self.performSegueWithIdentifier("toResult", sender: nil)
        }
      }
    }
    viewModel.quizViewStateInfo.producer.startWithNext {
      if $0.curState == QuizViewState.GameOver {
        self.performSegueWithIdentifier("toResult", sender: nil)
      } else if $0.curState == QuizViewState.Loading {
        SwiftSpinner.show("Loading Data From Server...")
        self.quizPlayView.hidden = true
      } else if $0.curState == QuizViewState.UserPlay {
        SwiftSpinner.hide()
        self.quizPlayView.hidden = false
      }
    }
    viewModel.notifyAnswerCorrect.producer.startWithNext {
      if $0 && self.viewModel.numberOfQuests.value > 0 {
        TAOverlay.showOverlayWithLabel(nil, options:[
          TAOverlayOptions.OverlayTypeSuccess,
          TAOverlayOptions.AutoHide,
          TAOverlayOptions.OverlaySizeFullScreen])
      }
    }
    viewModel.notifyAnswerWrong.producer.startWithNext {
      if $0 && self.viewModel.numberOfQuests.value > 0 {
        TAOverlay.showOverlayWithLabel(nil, options:[
          TAOverlayOptions.OverlayTypeError,
          TAOverlayOptions.AutoHide,
          TAOverlayOptions.OverlaySizeFullScreen
        ])
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    viewModel.resetQuiz()
    viewModel.fetchCharacterPicture()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toResult" {
      let resultVC = segue.destinationViewController as! ResultViewController
      let vm = ResultViewModel((viewModel.numberOfQuests.value - 1) * 10)
      resultVC.bindViewModel(vm)
    }
  }

  @IBAction func selectButtonPressed(sender: AnyObject) {
    let button = sender as! UIButton
    viewModel.checkAnswer(button.titleLabel?.text)
  }
}