//
//  ViewController.swift
//  Toy Robot
//
//  Created by Malik A. Feroze on 16/11/21.
//  Copyright © 2021 Malik A. Feroze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var board: UIStackView! {
        didSet {
            board.arrangedSubviews.compactMap({ $0 as? UIStackView }).enumerated().forEach { y, stackView in
                stackView.arrangedSubviews.compactMap({ $0 as? BoardBlockView }).enumerated().forEach { x, block in
                    block.backgroundColor = .white
                    block.xPosition = x
                    block.yPosition = (maxRowsColumns - 1) - y
                }
            }
        }
    }
    @IBOutlet weak var txtFieldXValue: UITextField! {
        didSet {
            txtFieldXValue.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            txtFieldXValue.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtFieldYValue: UITextField! {
        didSet {
            txtFieldYValue.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            txtFieldYValue.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtFieldDirection: UITextField!
    @IBOutlet weak var btnPlace: UIButton! {
        didSet {
            btnPlace.isEnabled = false
        }
    }
    @IBOutlet weak var btnRight: UIButton! {
        didSet {
            btnRight.isEnabled = false
        }
    }
    @IBOutlet weak var btnLeft: UIButton! {
        didSet {
            btnLeft.isEnabled = false
        }
    }
    @IBOutlet weak var btnMove: UIButton! {
        didSet {
            btnMove.isEnabled = false
        }
    }
    
    private let maxRowsColumns: Int = 6
    private var robot: RobotModel? {
        didSet {
            updateButtonStatus()
        }
    }
    private var isRobotOnBoard: Bool { robot != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldXValue.delegate = self
        txtFieldYValue.delegate = self
        txtFieldDirection.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Helper methods
    
    private func updateButtonStatus() {
        btnPlace.isEnabled = txtFieldXValue.text != nil && txtFieldYValue.text != nil && txtFieldDirection.text != nil
        if let r = robot {
            btnLeft.isEnabled = true
            btnRight.isEnabled = true
            switch r.direction {
            case .north:
                btnMove.isEnabled = r.yValue < 5
                break
            case .east:
                btnMove.isEnabled = r.xValue < 5
                break
            case .south:
                btnMove.isEnabled = r.yValue > 0
                break
            case .west:
                btnMove.isEnabled = r.xValue > 0
                break
            }
        } else {
            btnLeft.isEnabled = false
            btnRight.isEnabled = false
            btnMove.isEnabled = false
        }
    }
    
    private func updateBoard() {
        guard
            let x = robot?.xValue,
            let y = robot?.yValue,
            let d = robot?.direction
            else { return }
        
        board
            .arrangedSubviews
            .compactMap({ $0 as? UIStackView })
            .flatMap({ $0.arrangedSubviews })
            .compactMap({ $0 as? BoardBlockView })
            .forEach {
                $0.image = $0.xPosition == x && $0.yPosition == y ? d.image : nil
        }
    }
    
    //MARK:- UITextField methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFieldDirection {
            let alert = UIAlertController(title: "Direction", message: nil, preferredStyle: .actionSheet)
            Direction.allCases.forEach { d in
                let action = UIAlertAction(title: d.rawValue, style: .default, handler: { _ in
                    textField.text = d.rawValue
                })
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        return textField != txtFieldDirection
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        updateButtonStatus()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func btnPressedPlace(_ sender: UIButton) {
        var errorMessages = [String]()
        var x: Int!
        var y: Int!
        var direction: Direction!
        
        if let text = txtFieldXValue.text, let val = Int(text), val < maxRowsColumns {
            x = val
        } else {
            errorMessages.append("X Value should be between 0-5")
        }
        if let text = txtFieldYValue.text, let val = Int(text), val < maxRowsColumns {
            y = val
        } else {
            errorMessages.append("Y Value should be between 0-5")
        }
        if let text = txtFieldDirection.text, let val = Direction(rawValue: text) {
            direction = val
        }
        
        if errorMessages.isEmpty {
            robot = RobotModel(xValue: x, yValue: y, direction: direction)
            updateBoard()
        } else {
            let alert = UIAlertController(title: "Error", message: errorMessages.joined(separator: "\n"), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPressedRight(_ sender: UIButton) {
        robot?.turnRight()
        updateBoard()
    }
    
    @IBAction func btnPressedLeft(_ sender: UIButton) {
        robot?.turnLeft()
        updateBoard()
    }
    
    @IBAction func btnPressedMove(_ sender: UIButton) {
        robot?.move()
        updateBoard()
    }
}

