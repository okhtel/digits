//
//  DrawView.swift
//  Digits
//
//  Created by Alex on 05/05/2018.
//  Copyright © 2018 Overdensity. All rights reserved.
//

import UIKit


//MARK: DRAW VIEW
class DrawView: UIView {

    // THICKNESS
    var lineThickness = CGFloat(15) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // COLOR
    var lineColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // Keep touches made by user in view
    var lines: [Line] = []
    var lastPoint: CGPoint!

    
    // TOUCHES BEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first!.location(in: self)
    }
    
    
    // TOUCHES MOVED
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = touches.first!.location(in: self)
        
        // Keep all lines drawn by user
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        setNeedsDisplay()
    }
    
    
    // DRAW
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let drawPath = UIBezierPath()
        drawPath.lineCapStyle = .round
        
        for line in lines {
            drawPath.move(to: line.start)
            drawPath.addLine(to: line.end)
        }
        
        drawPath.lineWidth = lineThickness
        lineColor.set()
        drawPath.stroke()
    }
    

    // GET VIEW CONTEXT
    // Get pixel data of view - put it in MTLTexture
    func getViewContext() -> CGContext? {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        // View pixel data goes in after render call
        let context = CGContext(data: nil, width: 28, height: 28, bitsPerComponent: 8, bytesPerRow: 28, space: colorSpace, bitmapInfo: bitmapInfo)
        
        // Scale and translate - 28x28
        context!.translateBy(x: 0 , y: 28)
        context!.scaleBy(x: 28/self.frame.size.width, y: -28/self.frame.size.height)
        
        // Render pixel data in context
        self.layer.render(in: context!)
        return context
    }
}


//MARK: LINE
class Line {
    var start, end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end   = end
    }
}
