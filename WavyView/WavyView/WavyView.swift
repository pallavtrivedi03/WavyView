//
//  WavyView.swift
//  WavyView
//
//  Created by Pallav Trivedi on 6/27/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import UIKit

class WavyView: UIView {
    
    private var wavyLayer: WavyLayer?
    private var wavyLayer1: WavyLayer?
    private var wavyLayer2: WavyLayer?
    
    private var lyrOneSpeed: WavyLayer.WaveAnimationSpeed = .fast
    private var lyrTwoSpeed: WavyLayer.WaveAnimationSpeed = .medium
    private var lyrThreeSpeed: WavyLayer.WaveAnimationSpeed = .slow
    
    @IBInspectable var animationDuration: Double =  10.0 {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var amplitude: CGFloat =  10.0 {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerOneDarkColor: UIColor =  #colorLiteral(red: 0.06274509804, green: 0.09411764706, blue: 0.4862745098, alpha: 1) {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerOneLightColor: UIColor =  #colorLiteral(red: 0.09411764706, green: 0.537254902, blue: 0.8078431373, alpha: 1) {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerTwoDarkColor: UIColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerTwoLightColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)  {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerThreeDarkColor: UIColor =  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerThreeLightColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            resetAnimationLayers()
        }
    }
    
    @IBInspectable var layerOneSpeed: Int {
        get {
            return self.lyrOneSpeed.rawValue
        }
        set( newValue) {
            self.lyrOneSpeed = WavyLayer.WaveAnimationSpeed(rawValue: newValue) ?? .fast
        }
    }
    
    @IBInspectable var layerTwoSpeed: Int {
        get {
            return self.lyrTwoSpeed.rawValue
        }
        set( newValue) {
            self.lyrTwoSpeed = WavyLayer.WaveAnimationSpeed(rawValue: newValue) ?? .medium
        }
    }
    
    @IBInspectable var layerThreeSpeed: Int {
        get {
            return self.lyrThreeSpeed.rawValue
        }
        set( newValue) {
            self.lyrThreeSpeed = WavyLayer.WaveAnimationSpeed(rawValue: newValue) ?? .slow
        }
    }
    
    @IBInspectable var waveDirectionUp: Bool = false {
        didSet {
            resetAnimationLayers()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAnimationLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addAnimationLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetAnimationLayers()
    }
    
    func startAnimation() {
        wavyLayer!.startDisplayLink()
        wavyLayer1!.startDisplayLink()
        wavyLayer2!.startDisplayLink()
    }
    
    private func addAnimationLayers() {
        wavyLayer = WavyLayer()
        wavyLayer?.layerFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        wavyLayer?.setGradientColors(lightColor: layerOneLightColor, darkColor: layerOneDarkColor)
        wavyLayer?.animationDuration = animationDuration
        wavyLayer?.animationSpeed = lyrOneSpeed
        wavyLayer?.amplitude = amplitude
        wavyLayer?.waveDirection = waveDirectionUp
        wavyLayer?.startDisplayLink()
        
        wavyLayer1 = WavyLayer()
        wavyLayer1?.layerFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        wavyLayer1?.setGradientColors(lightColor: layerTwoLightColor, darkColor: layerTwoDarkColor)
        wavyLayer1?.animationDuration = animationDuration
        wavyLayer1?.animationSpeed = lyrTwoSpeed
        wavyLayer1?.amplitude = amplitude + 2.0
        wavyLayer1?.waveDirection = waveDirectionUp
        wavyLayer1?.startDisplayLink()
        
        wavyLayer2 = WavyLayer()
        wavyLayer2?.layerFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        wavyLayer2?.setGradientColors(lightColor: layerThreeLightColor, darkColor: layerThreeDarkColor)
        wavyLayer2?.animationDuration = animationDuration
        wavyLayer2?.animationSpeed = lyrThreeSpeed
        wavyLayer2?.amplitude = amplitude + 3.0
        wavyLayer2?.waveDirection = waveDirectionUp
        wavyLayer2?.startDisplayLink()
        
        self.layer.addSublayer(wavyLayer2!)
        self.layer.addSublayer(wavyLayer1!)
        self.layer.addSublayer(wavyLayer!)
    }
    
    private func removeAnimationLayers() {
        self.layer.sublayers?.removeAll()
        wavyLayer1 = nil
        wavyLayer2 = nil
        wavyLayer = nil
    }
    
    private func resetAnimationLayers() {
        removeAnimationLayers()
        addAnimationLayers()
    }
}


