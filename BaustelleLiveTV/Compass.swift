//
//  Compass.swift
//  BaustelleLiveTV
//
//  Created by Felix De Montis on 14.08.22.
//

import SwiftUI

enum CompassDirection: String, CaseIterable {
    case N   = "north"
    case NNE = "north-northeast"
    case NE  = "northeast"
    case ENE = "east-northeast"
    case E   = "east"
    case ESE = "east-southeast"
    case SE  = "southeast"
    case SSE = "south-southeast"
    case S   = "south"
    case SSW = "south-southwest"
    case SW  = "southwest"
    case WSW = "west-southwest"
    case W   = "west"
    case WNW = "west-northwest"
    case NW  = "northwest"
    case NNW = "north-northwest"
    
    var degree: Angle {
        switch self {
        case .N:
            return .degrees(0.0)
        case .NNE:
            return .degrees(22.5)
        case .NE:
            return .degrees(45.0)
        case .ENE:
            return .degrees(67.5)
        case .E:
            return .degrees(90.0)
        case .ESE:
            return .degrees(112.5)
        case .SE:
            return .degrees(135.0)
        case .SSE:
            return .degrees(157.5)
        case .S:
            return .degrees(180.0)
        case .SSW:
            return .degrees(202.5)
        case .SW:
            return .degrees(225.0)
        case .WSW:
            return .degrees(247.5)
        case .W:
            return .degrees(270.0)
        case .WNW:
            return .degrees(292.5)
        case .NW:
            return .degrees(315.0)
        case .NNW:
            return .degrees(337.5)
        }
    }
}

struct Compass: Shape {
    
    let direction: CompassDirection
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let diameter = min(rect.width, rect.height)
        let center = diameter * 0.5
        
        let circleStroke = diameter * 0.08
        let radius = diameter / 2
        
        let top = center - diameter * 0.3
        let flopHorizontal = diameter * 0.25
        let flopVertical = diameter * 0.15
        let horizontalOffset = diameter * 0.02
        
        path.addArc(
            center: CGPoint(x: center, y: center),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: true
        )
        
        path.addArc(
            center: CGPoint(x: center, y: center),
            radius: radius - circleStroke,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        path = path.applying(CGAffineTransform(translationX: 0, y: -horizontalOffset))
        
        path.addLines([
            CGPoint(x: center, y: top),
            CGPoint(x: center + flopHorizontal, y: center + flopVertical),
            CGPoint(x: center, y: center),
            CGPoint(x: center - flopHorizontal, y: center + flopVertical),
            CGPoint(x: center, y: top),
        ])
        
        path = path.applying(CGAffineTransform(translationX: 0, y: +horizontalOffset))
        
        let rotation = CGAffineTransform(translationX: -center, y: -center)
            .concatenating(CGAffineTransform(rotationAngle: direction.degree.radians))
            .concatenating(CGAffineTransform(translationX: center, y: center))
        
        return path.applying(rotation)
    }
}

extension Compass {
//    @MainActor
//    var image: UIImage? {
//        let renderer = ImageRenderer(content: self)
//        return Task {
//            let uiImage = await renderer.uiImage
//            return uiImage
//        }
//    }
    
    @MainActor func asImage(size: CGFloat, scale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: self.frame(width: size, height: size))
        
        // make sure and use the correct display scale for this device
        renderer.scale = scale * 2
        
        if let uiImage = renderer.uiImage {
            return uiImage
        }
        return nil
    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass(direction: .NNE)
            .fill(.blue)
            .frame(height: 300)
    }
}
