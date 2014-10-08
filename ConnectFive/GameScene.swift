//
//  GameScene.swift
//  ConnectFive
//
//  Created by Bailey, Jennifer E. on 10/7/14.
//  Copyright (c) 2014 Aims. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    
    let NumRows : Int = 13
    let NumCols : Int = 8
    let TileWidth: CGFloat = 36.0
    let TileHeight: CGFloat = 36.0
    
    //layer for the tiles
    let tilesLayer = SKNode()
    let spheresLayer = SKNode()
    var gridPoints : [[CGPoint]] = []
    var bottomRowSpheres : [Sphere?] = []
    var topSpheres : [[Sphere?]] = []
  
    
    
    
    override func didMoveToView(view: SKView) {
        let layerPosition =  CGPoint(
            x:(size.width - (CGFloat(NumCols) * (TileWidth) + 3*(CGFloat(NumCols)-1)))/2,
            y:size.height - CGFloat(NumRows) * (TileHeight + 3) - 20)
        anchorPoint = CGPoint(x:0,y:0)
        tilesLayer.position = layerPosition
        spheresLayer.position = layerPosition
        topSpheres = [[Sphere?]](count: NumRows, repeatedValue: [Sphere?](count: NumCols, repeatedValue: nil))
        bottomRowSpheres = [Sphere?](count: NumCols, repeatedValue: nil)
        
        addTiles()
        self.backgroundColor = UIColor.blackColor()
        self.addChild(tilesLayer)
        self.addChild(spheresLayer)
        
        runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock(addBottomSphere),
                    SKAction.waitForDuration(1.0)])
            ))

      
    }
    
    func getTilePosition(row: Int, col: Int) -> CGPoint {
        
        return gridPoints[row][col]
    }
    
    func bottomSpheresCount() -> Int
    {
        var count : Int = 0
        for s in bottomRowSpheres
        {
            if let sphere = s {
                count++
            }
        }
        return count
    }
    
    func addBottomSphere() {
        if bottomSpheresCount() < NumCols {
            let Duration : NSTimeInterval = 0.1
            println(bottomSpheresCount())
            shuffleBottomSpheresLeft()
            let s = Sphere(column: NumCols - 1, row: 0, sphereType: SphereType.random())
            s.sprite = SKSpriteNode(imageNamed: s.sphereType.spriteName)
            s.sprite?.position = getTilePosition(s.row, col: s.column)
            s.sprite?.anchorPoint = CGPoint(x: 0, y: 0)
            s.sprite?.alpha = 0.0
            let move = SKAction.fadeInWithDuration(Duration)
            s.sprite?.runAction(move)
            bottomRowSpheres[NumCols - 1] = s
            spheresLayer.addChild(s.sprite!)
        }
    }
    
    func shuffleBottomSpheresLeft() {
        
        let Duration : NSTimeInterval = 0.1
        for var col = 0; col < NumCols - 1; col++ {
            if let s = bottomRowSpheres[col + 1]
            {
                if s.row == 0
                {
                    s.column--
                    bottomRowSpheres[col] = s
                    
                    //s.sprite?.position = getTilePosition(s.row, col: s.column)
                    let move = SKAction.moveTo(getTilePosition(s.row, col: s.column), duration:Duration)
                    
                    s.sprite?.runAction(move)
                }
                
            }
        }
    }
    
    
    
    func addTiles () {
        
        for var row = 0; row < NumRows; row++ {
            var pointsRow : [CGPoint] = []
            for var col = 0; col < NumCols; col++ {
                let tile = SKSpriteNode(imageNamed: "Tile")
                tile.anchorPoint = CGPoint(x: 0, y: 0)
                let cellPosition = CGPoint(x:CGFloat(col)*(TileWidth + 3),y:CGFloat(row)*(TileHeight + 3))
                pointsRow.append(cellPosition)
                tile.position = cellPosition
                tilesLayer.addChild(tile)
            }
            gridPoints.append(pointsRow)
        }
    }
    
    
    

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
       
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let Duration : NSTimeInterval = 0.3
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(spheresLayer)
        let (success, column, row) = convertPoint(touchLocation)
        println(column)
        if success {
            if let s = bottomRowSpheres[column]
            {
                if let r = getNextAvailableRowIn(column) {
                    let move = SKAction.moveTo(getTilePosition(r, col: column), duration: Duration)
                    //Move to the top most row
                    
                    s.row = r
                    s.sprite?.runAction(move)
                    //Take out of bottom array
                    topSpheres[r][column] = s
                    bottomRowSpheres[column] = nil
                    shuffleRightFrom(column)
                }
                
               
            }
        }
    }
    
    func shuffleRightFrom(column: Int) {
        for var col = column; col > 0; col--
        {
            if let s = bottomRowSpheres[col - 1]
            {
                let Duration : NSTimeInterval = 0.05
                s.column++
                bottomRowSpheres[col] = s
                bottomRowSpheres[col - 1] = nil
                let move = SKAction.moveTo(getTilePosition(0, col: s.column), duration: Duration)
                s.sprite?.runAction(move)
            }
        }
        
    }
    
    func getNextAvailableRowIn(column : Int) -> Int?
    {
        for var row = NumRows - 1; row > 0; row-- {
            println("row and column")
            println(row)
            println(column)
            if let s = topSpheres[row][column]
            {
                
            }
            else
            {
                return row
            }
        }
        return nil
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumCols)*(TileWidth + 3) &&
            point.y >= 0 && point.y < CGFloat(NumRows)*(TileHeight + 3) {
                return (true, Int(point.x / (TileWidth + 3)), Int(point.y / (TileHeight + 3)))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
