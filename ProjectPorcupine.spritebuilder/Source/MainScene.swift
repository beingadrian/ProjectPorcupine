
class MainScene: CCNode {
    
    weak var playButton: CCButton!
    
    // debug purposes
    let memoryStorageAllowed = true
    

    func didLoadFromCCB() {
        
        // remove previous textures to free up memory
        CCTextureCache.sharedTextureCache().removeAllTextures()
        
        // add level plate for level 1
        if GameManager.sharedInstance.levelDictionary["1"] == nil {
            let levelDict = ["isUnlocked": 0, "totalMoonCount": 0, "totalStarsAwarded": 0]
            GameManager.sharedInstance.levelDictionary["1"] = levelDict
        }
        
        // load game
        if memoryStorageAllowed {
            GameManager.sharedInstance.loadLevelDictionary()
            GameManager.sharedInstance.loadTutorialHistory()
        }

    }
    
    // MARK: - Animations
    
    func animationDidFinish() {
        
        animationManager.runAnimationsForSequenceNamed("AnimationLoop")
        
    }
    
    // button selector
    func runExitAnimation() {
        
        playButton.enabled = false
        
        // triggers callback showLevelScreen()
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")

    }

    
    // MARK: - Level screen
    
    func showLevelScreen() {
        
        let levelScreen = CCBReader.load("LevelScreen") as! LevelScreen
        addChild(levelScreen)
        
        playButton.enabled = true
        
    }
    
    
    // MARK: - Info page
    
    func showInfoPage() {
        
        let infoPage = CCBReader.load("InfoPage") as! InfoPage
        addChild(infoPage)
        
    }
    
}
