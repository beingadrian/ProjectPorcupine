class MainScene: CCNode {

    // start game selector
    func start() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }    
    
}
