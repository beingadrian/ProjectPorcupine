//
//  LevelManager.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class GameManager: NSObject, NSCoding {
    
    // MARK: - Shared instnace
    
    static let sharedInstance = GameManager()
    
    // MARK: - Properties

    var currentLevel = 0
    var hasSeenTutorial = false
    var levelDictionary: [String: [String: Int]] = [:]

    // MARK: - NSCoding
    
    required convenience init(coder aDecoder: NSCoder) {
        
        self.init()
        
        self.hasSeenTutorial = aDecoder.decodeBoolForKey("hasSeenTutorial")
        self.levelDictionary = (aDecoder.decodeObjectForKey("levelDictionary") as! [String: [String: Int]]?)!
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeBool(self.hasSeenTutorial, forKey: "hasSeenTutorial")
        aCoder.encodeObject(self.levelDictionary, forKey: "levelDictionary")
        
    }
    
    // MARK: - Load game
    
    func loadGame() -> [String: [String: Int]]? {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("GameManager.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
            }
        }
        
        if let rawData = NSData(contentsOfFile: path) {
            // do we get serialized data back from the attempted path?
            if let data = NSKeyedUnarchiver.unarchiveObjectWithData(rawData) as? [String: [String: Int]] {
                return data
            }
        }
        
        return nil
        
    }
    
    
    // MARK: - Save game
    
    func save() {
        
        let saveLevelDictionaryData = NSKeyedArchiver.archivedDataWithRootObject(GameManager.sharedInstance.levelDictionary)
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameManager.plist")
        
        saveLevelDictionaryData.writeToFile(path, atomically: true)
        
        // test if successful
        let saveSuccessful = NSKeyedArchiver.archiveRootObject(GameManager.sharedInstance.levelDictionary, toFile: path)
        println(saveSuccessful)
        
    }


}

