//
//  WavyLayer.swift
//  WavyView
//
//  Created by Pallav Trivedi on 6/27/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import UIKit

class WavyLayer: CAGradientLayer {
    
    enum WaveAnimationSpeed: Int {
        case verySlow
        case slow
        case medium
        case fast
        case veryFast
    }
    
    
    private var darkDisplayLink: CADisplayLink?
    private var startTime: CFAbsoluteTime?
    
    private var gradientColors = [#colorLiteral(red: 0.06380342692, green: 0.3197455406, blue: 0.5600522161, alpha: 1),#colorLiteral(red: 0.07490567118, green: 0.6187763214, blue: 0.8514496088, alpha: 1)] {
        didSet {
            frame = layerFrame
            colors = [gradientColors[0].cgColor, gradientColors[1].cgColor]
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
            setAffineTransform(CGAffineTransform(rotationAngle: waveDirection ? CGFloat(1) * .pi : CGFloat(2) * .pi))
            mask = darkShapeLayer
        }
    }
    
    var waveDirection = false {
        didSet {
            frame = layerFrame
            colors = [gradientColors[0].cgColor, gradientColors[1].cgColor]
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
            setAffineTransform(CGAffineTransform(rotationAngle: waveDirection ? CGFloat(1) * .pi : CGFloat(2) * .pi))
            mask = darkShapeLayer
        }
    }
    
    var animationSpeed = WaveAnimationSpeed.fast
    var animationDuration = 2.0
    var amplitude = CGFloat(10)
    
    
    var layerFrame = CGRect(x: 0, y: 0, width: 0, height: 0) {
        didSet {
            
            let tempFrame = CGRect(x: layerFrame.origin.x, y: layerFrame.origin.y, width: layerFrame.size.width, height: layerFrame.size.height + (0.11 * layerFrame.size.height))
            frame = tempFrame
            colors = [gradientColors[1].cgColor, gradientColors[0].cgColor]
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
            //        setAffineTransform(CGAffineTransform(rotationAngle: .pi))
            
            let shapeLayer: CAShapeLayer = {
                let _layer = CAShapeLayer()
                _layer.strokeColor = UIColor.purple.cgColor
                _layer.fillColor = UIColor.clear.cgColor
                _layer.lineWidth = tempFrame.size.height * 1.5
                return _layer
            }()
            
            darkShapeLayer = shapeLayer
            mask = darkShapeLayer
        }
    }
    
    /// The `CAShapeLayer` that will contain the animated path
    private var darkShapeLayer: CAShapeLayer = {
        let _layer = CAShapeLayer()
        _layer.strokeColor = UIColor.purple.cgColor
        _layer.fillColor = UIColor.clear.cgColor
        _layer.lineWidth = 150
        
        return _layer
    }()
    
    
    override init() {
        super.init()
        colors = [#colorLiteral(red: 0.06380342692, green: 0.3197455406, blue: 0.5600522161, alpha: 1).cgColor,#colorLiteral(red: 0.07490567118, green: 0.6187763214, blue: 0.8514496088, alpha: 1).cgColor]
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 0)
        //        setAffineTransform(CGAffineTransform(rotationAngle: .pi))
        mask = darkShapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGradientColors(lightColor:UIColor, darkColor: UIColor) {
        self.gradientColors = [lightColor,darkColor]
    }
    
    /// Start the display link
    func startDisplayLink() {
        startTime = CFAbsoluteTimeGetCurrent()
        darkDisplayLink?.invalidate()
        darkDisplayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        darkDisplayLink?.add(to: RunLoop.current, forMode: .common)
    }
    
    /// Stop the display link
    
    func stopDisplayLink() {
        darkDisplayLink?.invalidate()
        darkDisplayLink = nil
    }
    
    /// Handle the display link timer.
    ///
    /// - Parameter displayLink: The display link.
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime!
        
        darkShapeLayer.path = wave(at: elapsed).cgPath
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.stopDisplayLink()
        }
    }
    
    /// Create the wave at a given elapsed time.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.
    
    private func wave(at elapsed: Double) -> UIBezierPath {
        
        var speed = elapsed
        
        switch animationSpeed {
        case .veryFast:
            speed = elapsed
        case .fast:
            speed = elapsed/2
        case .medium:
            speed = elapsed/3
        case .slow:
            speed = elapsed/4
        case .verySlow:
            speed = elapsed/5
        }
        
        func f(_ x: Int) -> CGFloat {
            return sin(((CGFloat(x) / layerFrame.size.width) + CGFloat(speed)) * 1.5 * .pi) * amplitude
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: f(0)))
        for x in stride(from: -50, to: Int(layerFrame.size.width + 60), by: 10) {
            path.addLine(to: CGPoint(x: CGFloat(x), y: f(x)))
        }
        
        return path
    }
}

