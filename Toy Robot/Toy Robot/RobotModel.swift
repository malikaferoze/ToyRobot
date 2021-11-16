//
//  RobotModel.swift
//  Toy Robot
//
//  Created by Malik A. Feroze on 16/11/21.
//  Copyright © 2021 Malik A. Feroze. All rights reserved.
//

import Foundation
import UIKit

struct RobotModel {
    var xValue: Int
    var yValue: Int
    var direction: Direction
}

enum Direction: String, CaseIterable {
    case north = "NORTH"
    case east = "EAST"
    case south = "SOUTH"
    case west = "WEST"
    
    var image: UIImage? {
        switch self {
        case .north: return UIImage(systemName: "chevron.up.square.fill")
        case .east: return UIImage(systemName: "chevron.right.square.fill")
        case .south: return UIImage(systemName: "chevron.down.square.fill")
        case .west: return UIImage(systemName: "chevron.left.square.fill")
        }
    }
    
    var left: Direction {
        switch self {
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }
    
    var right: Direction {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }
}
