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
  struct Hero {
    let id: Int
    let name: String
    let pictureURL: String
    init(id: Int, name: String, pictureURL: String) {
      self.id = id
      self.name = name
      self.pictureURL = pictureURL
    }
  }

  var heroes = [Hero]()
  var questHero: Hero?
  let pictureURL: MutableProperty<NSURL?>
  let choices: MutableProperty<[String]?>
  let numberOfQuests: MutableProperty<Int>


  init() {
    pictureURL = MutableProperty<NSURL?>(nil)
    choices = MutableProperty<[String]?>(nil)
    numberOfQuests = MutableProperty<Int>(0)

    numberOfQuests.producer.startWithNext {
      if 0 < $0 && $0 <= 50 {
        self.generateQuest()
      }
    }
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
        "hash" : hash,
        "limit": 20])
      .responseJSON { response in
        //print(response.request)  // original URL request
        //print(response.response) // URL response
        //print(response.data)     // server data
        print(response.result)   // result of response serialization

        guard let JSON = response.result.value,
          let data = JSON["data"] as? [String: AnyObject],
          let results = data["results"] as? [AnyObject]
          else {
            return
          }
        let count: Int = data["count"] as! Int
        for idx in 0..<count {
          let character = results[idx] as! [String: AnyObject]
          let thumbnail = character["thumbnail"] as! [String: AnyObject]
          print(character["name"])
          print(character["id"])
          var imageURL: String = thumbnail["path"] as! String
          imageURL += "/standard_fantastic.jpg"
          print(imageURL)
          self.heroes.append(Hero(id: character["id"] as! Int, name: character["name"] as! String, pictureURL: imageURL))
        }
        print(self.heroes)
        self.numberOfQuests.value++
      }
  }

  func checkAnswer(userAnswer: String?) {
    if questHero?.name == userAnswer {
      print("Bingo")
      self.numberOfQuests.value++
    } else {
      print("Game Over")
    }
  }

  private func generateQuest() {
    let answerHeroIndex = 0
    self.questHero = self.heroes[answerHeroIndex]
    self.heroes.removeAtIndex(answerHeroIndex)
    pictureURL.value = NSURL(string: self.questHero!.pictureURL)

    let namesToSelect:[String] = [self.questHero!.name, self.heroes[0].name, self.heroes[1].name, self.heroes[2].name]
    print(namesToSelect)
    choices.value = namesToSelect
  }
}