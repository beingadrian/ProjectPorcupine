
class MainScene: CCNode {
    
    weak var playButton: CCButton!
    
    
    func didLoadFromCCB() {
        
        // remove previous textures to free up memory
        CCTextureCache.sharedTextureCache().removeAllTextures()
        
        // add level plate
        for i in 1...5 {
            
            let levelDict = ["isUnlocked": 0, "totalMoonCount": 0, "totalStarsAwarded": 0]
            
            if GameManager.sharedInstance.levelDictionary[String(i)] == nil {
                GameManager.sharedInstance.levelDictionary[String(i)] = levelDict
            }

        }
        
        // load game
        GameManager.sharedInstance.loadLevelDictionary()
        GameManager.sharedInstance.loadTutorialHistory()
        
    }
    
    // MARK: - Animations
    
    func animationDidFinish() {
        
        animationManager.runAnimationsForSequenceNamed("AnimationLoop")
        
    }
    
    // button selector
    func runExitAnimation() {
        
        playButton.enabled = false
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        // triggers callback showLevelScreen()
        
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
    
    
    // MARK: - Load game
    
    
    
}
