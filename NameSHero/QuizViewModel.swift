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

enum QuizViewState {
  case Init
  case Loading
  case UserPlay
  case GameOver
}

struct QuizViewStateInfo {
  var prevState: QuizViewState = QuizViewState.Init
  var curState: QuizViewState = QuizViewState.Init
  init(){}
  init(current: QuizViewState, previous: QuizViewState) {
    prevState = previous
    curState = current
  }
}

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
  let quizViewStateInfo: MutableProperty<QuizViewStateInfo>
  let notifyAnswerCorrect = MutableProperty<Bool>(false)
  let notifyAnswerWrong = MutableProperty<Bool>(false)

  init() {
    pictureURL = MutableProperty<NSURL?>(nil)
    choices = MutableProperty<[String]?>(nil)
    numberOfQuests = MutableProperty<Int>(0)
    quizViewStateInfo = MutableProperty<QuizViewStateInfo>(QuizViewStateInfo())

    numberOfQuests.producer.startWithNext {
      if 0 < $0 && $0 <= 10 {
        self.generateQuest()
      }
    }
  }

  func fetchCharacterPicture() {
    let publicKey = Constants.MarvelAPIPublicKey
    let privateKey = Constants.MarvelAPIPrivateKey
    let ts = NSDate().timeIntervalSince1970.description
    let hash = "\(ts)\(privateKey)\(publicKey)".md5()
    let limit = 20
    let offset = pickRandomNumber(Constants.TotalOfHeroes - limit)

    Alamofire.request(.GET, Constants.MarvelAPIURL + "/characters",
      parameters:
      ["apikey": Constants.MarvelAPIPublicKey,
          "ts" : ts,
        "hash" : hash,
        "offset" : offset,
        "limit": limit])
      .responseJSON { response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.data)     // server data
//        print(response.result)   // result of response serialization

        guard let JSON = response.result.value,
          let data = JSON["data"] as? [String: AnyObject],
          let results = data["results"] as? [AnyObject]
          else {
            print("Response with invalid JSON \(response.result.value)")
            self.fetchCharacterPicture() // this might be an issue
            return
          }
        let count: Int = data["count"] as! Int
        var namesArray = [String]()
        for idx in 0..<count {
          let character = results[idx] as! [String: AnyObject]
          let thumbnail = character["thumbnail"] as! [String: AnyObject]
          let characterId = character["id"] as! Int
          let characterName = character["name"] as! String
          var imageURL: String = thumbnail["path"] as! String
          if !imageURL.containsString("image_not_available") &&
            !characterName.containsString("(") &&
            !self.containsName(namesArray, other: character["name"] as! String) {
            imageURL += "/standard_fantastic.jpg"
            namesArray.append(character["name"] as! String)
            self.heroes.append(Hero(id: characterId, name: characterName, pictureURL: imageURL))
          }
        }
        self.numberOfQuests.value = 1;
      }
    let nextStateInfo = QuizViewStateInfo(current: QuizViewState.Loading, previous: quizViewStateInfo.value.curState)
    quizViewStateInfo.value = nextStateInfo
  }

  func containsName(names: [String], other: String) -> Bool {
    for n in names {
      if n.containsString(other) {
        return true
      }
    }
    return false
  }

  func containsParenthesis(name: String) -> Bool {
    return name.containsString("(")
  }

  func resetQuiz() {
    heroes = [Hero]()
    let nextStateInfo = QuizViewStateInfo(current: QuizViewState.Init, previous: quizViewStateInfo.value.curState)
    quizViewStateInfo.value = nextStateInfo
  }

  func checkAnswer(userAnswer: String?) {
    if questHero?.name == userAnswer {
      print("Bingo")
      self.notifyAnswerCorrect.value = true
      self.numberOfQuests.value++
    } else {
      print("Game Over")
      self.notifyAnswerWrong.value = true
      let nextStateInfo = QuizViewStateInfo(current: QuizViewState.GameOver, previous: quizViewStateInfo.value.curState)
      quizViewStateInfo.value = nextStateInfo
    }
  }

  private func generateQuest() {
    let answerHeroIndex = 0
    self.questHero = self.heroes[answerHeroIndex]
    self.heroes.removeAtIndex(answerHeroIndex)
    pictureURL.value = NSURL(string: self.questHero!.pictureURL)

    let rand1 = pickRandomNumber(self.heroes.count)
    let rand2 = pickRandomNumber(self.heroes.count, filterNumbers: rand1)
    let rand3 = pickRandomNumber(self.heroes.count, filterNumbers: rand1, rand2)
    var namesToSelect = [String]()
    namesToSelect.append(self.heroes[rand1].name)
    namesToSelect.append(self.heroes[rand2].name)
    namesToSelect.append(self.heroes[rand3].name)
    print(self.questHero!.name)
    let locationForAnswer = pickRandomNumber(namesToSelect.count+1)
    namesToSelect.insert(self.questHero!.name, atIndex: locationForAnswer)
    print(namesToSelect)
    choices.value = namesToSelect
    let nextStateInfo = QuizViewStateInfo(current: QuizViewState.UserPlay, previous: quizViewStateInfo.value.curState)
    quizViewStateInfo.value = nextStateInfo
  }

  private func pickRandomNumber(range:  Int, filterNumbers: Int...) -> Int {
    var rand = Int(arc4random_uniform(UInt32(range)))
    while(checkValueIncludedInNumbers(rand, numbers: filterNumbers) == true) {
      rand = Int(arc4random_uniform(UInt32(range)))
    }
    print("rand = \(rand)")
    return rand
  }

  private func checkValueIncludedInNumbers(value: Int, numbers: [Int]?) -> Bool {
    guard (numbers != nil) else {return false}
    for n in numbers! {
      if n == value{
        return true
      }
    }
    return false
  }
}
