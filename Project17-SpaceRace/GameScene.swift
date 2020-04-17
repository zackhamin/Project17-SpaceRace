//
//  GameScene.swift
//  Project17-SpaceRace
//
//  Created by Ishaq Amin on 17/04/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameView = GameViewController()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball","hammer","tv"]
    var isGameOver = false
    var gameTimer: Timer?
    
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")

    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = 3 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        //        player = SKSpriteNode(imageNamed: "player")
        //        player.position = CGPoint(x: 100, y: 384)
        //        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //        player.physicsBody?.contactTestBitMask = 1
        //        addChild(player)
        createPlayer()
        
//        levelTimerLabel.fontColor = SKColor.white
//        levelTimerLabel.fontSize = 40
//        levelTimerLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 350)
//        levelTimerLabel.text = "Time left: \(levelTimerValue)"
//        addChild(levelTimerLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func createPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        scoreUpdate()
    }
    
    func scoreUpdate() {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
            print(score)
        }
    }
    
    @objc func createEnemy() {
        if !isGameOver {
            print("Enemy made")
            guard let enemy = possibleEnemies.randomElement() else {return}
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
        }
            
        else {
            print("No more enemies")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
        gameOver()
        
        print(isGameOver)
    }
    
    func newGame() {
        isGameOver = false
        gameView.gameScene()
        score = 0
        scoreUpdate()
        createPlayer()
        
    }
    
    func gameOver() {
        
        if  isGameOver{
            let ac = UIAlertController(title: "Oh No!", message: "You Scored \(score) try again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { action in self.newGame()}))
            ac.addAction(UIAlertAction(title: "No, Thanks!", style: .default, handler: nil))
            
            self.view?.window?.rootViewController?.present(ac, animated: true, completion: nil)
            
        }
        
    }
    
    /*
     
        things to do:
            1. Timer for game reset
            2. Debris cleared after game ends
     
     */
}
