//
//  LevelManager.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class GameManager {

    static let sharedInstance = GameManager()
    
    var currentLevel = 0
    
    var hasSeenTutorial: Bool = NSUserDefaults.standardUserDefaults().boolForKey("myTutorialRecord") ?? false {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(hasSeenTutorial, forKey: "myTutorialRecord")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var levelDictionary2: [String: Dictionary] = NSUserDefaults.standardUserDefaults().dictionaryForKey("test") ?? [:] {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(levelDictionary2, forKey: "test")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var levelDictionary: [String: [String: Int]] = [:]
    
}

