//
//  QuizViewController.swift
//  NameSHero
//
//  Created by coreylin on 3/2/16.
//  Copyright © 2016 coreylin. All rights reserved.
//
import UIKit
//import ReactiveCocoa

class QuizViewController: UIViewController {
  @IBOutlet weak var pictureImageView: UIImageView!

  var viewModel = QuizViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.pictureURL.producer.startWithNext {
      print("\($0)")
    }
    viewModel.fetchCharacterPicture()
  }
}