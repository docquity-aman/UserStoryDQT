//
//  storyCVC+progressBar.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 17/04/23.
//

import Foundation
import UIKit
//progressbar
extension storyCVC {
    
    func startAnimation() {
        if !self.isAnimating {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            play()
        }
       
    }
    func pause() {
        timer?.invalidate()
        
    }
    func reset() {
        stop()
        progressViewsArray[currentIndex].setProgress(0, animated: false)
        play()
        
    }
    
    func play() {
//        print("called for currentInex",currentIndex)
//        let currentProgressView = progressViewsArray[currentIndex]
//            UIView.animate(withDuration: 10, delay: 0,options: .curveLinear) {
//                currentProgressView.setProgress(1.0, animated: true)
//            }
            
        
    }
    
    func next() {
        
    }
    
    func stop() {
        print("Stop")
        timer?.invalidate()
        timer = nil
    }
}



extension storyCVC {
    @objc func updateProgressView() {
        print("yet to be completed")
        stop()
    
    }
}
