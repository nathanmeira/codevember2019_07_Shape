//
//  GameScene.swift
//  Shape
//
//  Created by Pedro Cacique on 08/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let images:[String] = ["monalisa_50x75","moca_50x72","beijo_50x69","grito_50x64"]
    var currentImage:Int = 0
    var colors:[[UIColor]] = []
    
    override func didMove(to view: SKView) {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))

        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        restart()
    }
    
    func restart(){
        removeAllChildren()
        removeAllActions()
        
        colors = []
        
        if let image = UIImage(named: images[currentImage]){
            let rgba = RGBA(image)
            for x in 0..<rgba.width {
                var temp:[UIColor] = []
                for y in 0..<rgba.height {
                    let index = y * rgba.width + x
                    let pixel = rgba.pixels[index]
                    temp.append(UIColor(red: CGFloat(pixel.red)/CGFloat(255), green: CGFloat(pixel.green)/CGFloat(255), blue: CGFloat(pixel.blue)/CGFloat(255), alpha: 1))
                }
                colors.append(temp)
            }
            showImage()
        }
    }
    
    func showImage(){
        
        let s = CGFloat(UIScreen.main.bounds.size.width) / CGFloat(colors.count)
        let border:CGFloat = UIScreen.main.bounds.size.height - (s * CGFloat(colors[0].count))
        
        for x in 0..<colors.count {
            for y in 0..<colors[x].count {
                drawArc(center: CGPoint(x:CGFloat(x) * s - UIScreen.main.bounds.size.width/2 + s / 2,
                                        y: CGFloat(y) * s - UIScreen.main.bounds.size.height/2 + s / 2 + border / 2) ,
                        radius: CGFloat.random(in:1...3) * s,
                        height: s/4,
                        color:colors[x][colors[x].count - 1 - y])
            }
        }
    }
    
    func drawArc(center:CGPoint, radius:CGFloat = 100, startAngle:Int = 0, endAngle:Int = 360, height:CGFloat = 20, color:UIColor = .yellow, randomAlpha:Bool = true) {

        let startRad:CGFloat = CGFloat(startAngle) * .pi / 180
        let endRad:CGFloat = CGFloat(endAngle) * .pi / 180
        
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                  radius: radius,
                  startAngle: startRad,
                  endAngle: endRad,
                  clockwise: true)

        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: size.width/2, y: size.height/2)
        section.lineWidth = height
        section.strokeColor = color
        if randomAlpha {
            section.alpha = CGFloat.random(in: 0.3...1)
        } else {
            section.alpha = 0.2
        }
        addChild(section)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
               
           if (sender.direction == .left) {
               currentImage -= 1
               if currentImage < 0{
                   currentImage = images.count-1
               }
               restart()
            print("left")
           }
               
           if (sender.direction == .right) {
               currentImage += 1
               if currentImage >= images.count{
                   currentImage = 0
               }
               restart()
            print("right")
           }
       }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
