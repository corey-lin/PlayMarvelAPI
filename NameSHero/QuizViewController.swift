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

class QuizViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet var choiceButtons: [UIButton]!
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
          self.choiceButtons[index].sizeToFit()
        }
      }
    }
    viewModel.numberOfQuests.producer.startWithNext {
      if $0 > 0 {
        self.scoreLabel.text = "Score:\($0)"
      }
    }

    viewModel.fetchCharacterPicture()
  }

  @IBAction func selectButtonPressed(sender: AnyObject) {
    let button = sender as! UIButton
    viewModel.checkAnswer(button.titleLabel?.text)
  }
}