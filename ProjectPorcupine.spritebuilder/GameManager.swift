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
    
    var hasSeenTutorial: Bool = NSUserDefaults.standardUserDefaults().boolForKey("userHasSeenTutorial") ?? false {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(hasSeenTutorial, forKey: "userHasSeenTutorial")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var levelDictionary2: [NSObject: AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("myLevelDictionary") ?? [:] {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(levelDictionary2, forKey: "myLevelDictionary")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
//    var levelDictionary2: [NSObject: AnyObject] = ["0": ["someKey": 0]]
//    NSUserDefaults.standardUserDefaults().setObject(levelDictionary2, forKey: "userLevelDictionary")
    
    
    var levelDictionary: [String: [String: Int]] = [:]
    
}

