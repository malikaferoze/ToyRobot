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
    private(set) var xValue: Int
    private(set) var yValue: Int
    private(set) var direction: Direction
    
    mutating func turnLeft() {
        switch direction {
        case .north: direction = .west
        case .east: direction = .north
        case .south: direction = .east
        case .west: direction = .south
        }
    }
    
    mutating func turnRight() {
        switch direction {
        case .north: direction = .east
        case .east: direction = .south
        case .south: direction = .west
        case .west: direction = .north
        }
    }
    
    mutating func move() {
        switch direction {
        case .north:
            yValue += 1
            break
        case .east:
            xValue += 1
            break
        case .south:
            yValue -= 1
            break
        case .west:
            xValue -= 1
            break
        }
    }
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
}
