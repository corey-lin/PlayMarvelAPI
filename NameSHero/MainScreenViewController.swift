//
//  ViewController.swift
//  NameSHero
//
//  Created by coreylin on 3/1/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

  @IBOutlet weak var recordScoreLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController?.navigationBarHidden = true;
  }
  override func viewWillAppear(animated: Bool) {
    let recordScore = NSUserDefaults.standardUserDefaults().integerForKey(Constants.RecordScoreKey)
    recordScoreLabel.text = "Best score : \(recordScore)"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

