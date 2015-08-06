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
    
    var levelDictionary: [NSObject: AnyObject] = (NSUserDefaults.standardUserDefaults().dictionaryForKey("myLevelDictionary")) ?? ["0": ["someKey": 0]] {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(levelDictionary, forKey: "myLevelDictionary")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
//    var levelDictionary: [String: [String: Int]] = [:]
    
//    var levelDictionary: [NSObject: AnyObject] = ["0": ["someKey": 0]]
    
}

