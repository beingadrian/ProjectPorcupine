
class MainScene: CCNode {
    
    weak var playButton: CCButton!
    
    
    func didLoadFromCCB() {
        
        // add level plate
        for i in 1...5 {
            
            let levelDict = ["isCompleted": 0, "totalMoonCount": 0, "totalStarsAwarded": 0]
            
            if GameManager.sharedInstance.levelDictionary[String(i)] == nil {
                GameManager.sharedInstance.levelDictionary[String(i)] = levelDict
            }

            
        }
        
    }
    
    func animationDidFinish() {
        
        animationManager.runAnimationsForSequenceNamed("AnimationLoop")
        
    }
    
    // button selector
    func runExitAnimation() {
        
        playButton.enabled = false
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        // triggers callback showLevelScreen()
        
    }

    func showLevelScreen() {
        
        let levelScreen = CCBReader.load("LevelScreen") as! LevelScreen
        addChild(levelScreen)
        
        playButton.enabled = true
        
    }
    
}
