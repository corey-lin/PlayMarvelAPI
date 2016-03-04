//
//  QuizViewModel.swift
//  NameSHero
//
//  Created by coreylin on 3/2/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Alamofire

class QuizViewModel {
  let pictureURL: MutableProperty<NSURL?>

  init() {
    pictureURL = MutableProperty<NSURL?>(nil);
  }

  func fetchCharacterPicture() {
    let publicKey = Constants.MarvelAPIPublicKey
    let privateKey = Constants.MarvelAPIPrivateKey
    let ts = NSDate().timeIntervalSince1970.description
    let hash = "\(ts)\(privateKey)\(publicKey)".md5()

    Alamofire.request(.GET, Constants.MarvelAPIURL + "/characters",
      parameters:
      ["apikey": Constants.MarvelAPIPublicKey,
          "ts" : ts,
        "hash" : hash])
      .responseJSON { response in
        //print(response.request)  // original URL request
        //print(response.response) // URL response
        //print(response.data)     // server data
        //print(response.result)   // result of response serialization

        if let JSON = response.result.value {
          //print("JSON: \(JSON)")
        }
      }

  }
}