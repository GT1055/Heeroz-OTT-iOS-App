//
//  BMPlayerProtocols.swift
//  Pods
//
//  Created by BrikerMan on 16/4/30.
//
//

import UIKit

extension BMPlayerControlView {
    public enum ButtonType: Int {
        case play       = 101
        case pause      = 102
        case back       = 103
        case fullscreen = 105
        case replay     = 106
    }
}

extension BMPlayer {
    static func formatSecondsToString(_ secounds: TimeInterval) -> String {
        if secounds.isNaN { return "-- : --" }
        let hours: Int = Int(secounds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes: Int = Int(secounds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds: Int = Int(secounds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
