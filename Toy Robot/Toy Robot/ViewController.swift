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
    private var robot: RobotModel?
    private var xValue: Int? {
        didSet {
            txtFieldXValue.text = String(xValue ?? 0)
            updateButtonStatus()
        }
    }
    private var yValue: Int? {
        didSet {
            txtFieldYValue.text = String(yValue ?? 0)
            updateButtonStatus()
        }
    }
    private var direction: Direction? {
        didSet {
            txtFieldDirection.text = direction?.rawValue
            updateButtonStatus()
        }
    }
    private var isRobotOnBoard: Bool = false {
        didSet {
            updateButtonStatus()
        }
    }
    
    private var isValidXValue: Bool {
        guard let val = xValue else { return false }
        return val < maxRowsColumns
    }
    private var isValidYValue: Bool {
        guard let val = yValue else { return false }
        return val < maxRowsColumns
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldXValue.delegate = self
        txtFieldYValue.delegate = self
        txtFieldDirection.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Helper methods
    
    private func updateButtonStatus() {
        btnPlace.isEnabled = txtFieldXValue.text != nil && txtFieldYValue.text != nil && direction != nil
        btnLeft.isEnabled = isRobotOnBoard
        btnRight.isEnabled = isRobotOnBoard
        if isRobotOnBoard {
            guard let d = direction else { return }
            switch d {
            case .north:
                btnMove.isEnabled = (yValue ?? 0) < 5
                break
            case .east:
                btnMove.isEnabled = (xValue ?? 0) < 5
                break
            case .south:
                btnMove.isEnabled = (yValue ?? 0) > 0
                break
            case .west:
                btnMove.isEnabled = (xValue ?? 0) > 0
                break
            }
        } else {
            btnMove.isEnabled = false
        }
    }
    
    private func updateRobot() {
        guard
            let x = xValue,
            let y = yValue,
            let d = direction
            else { return }
        
        board
            .arrangedSubviews
            .compactMap({ $0 as? UIStackView })
            .flatMap({ $0.arrangedSubviews })
            .compactMap({ $0 as? BoardBlockView })
            .forEach {
                $0.image = $0.xPosition == x && $0.yPosition == y ? d.image : nil
        }
        isRobotOnBoard = true
    }
    
    //MARK:- UITextField methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFieldDirection {
            let alert = UIAlertController(title: "Direction", message: nil, preferredStyle: .actionSheet)
            Direction.allCases.forEach { d in
                let action = UIAlertAction(title: d.rawValue, style: .default, handler: { [weak self] _ in
                    self?.direction = d
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
        
        
        if let text = txtFieldXValue.text, let val = Int(text), val < maxRowsColumns {
            xValue = val
        } else {
            errorMessages.append("X Value should be between 0-5")
        }
        if let text = txtFieldYValue.text, let val = Int(text), val < maxRowsColumns {
            yValue = val
        } else {
            errorMessages.append("Y Value should be between 0-5")
        }
        
        if errorMessages.isEmpty {
            updateRobot()
        } else {
            let alert = UIAlertController(title: "Error", message: errorMessages.joined(separator: "\n"), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPressedRight(_ sender: UIButton) {
        direction = direction?.right
        updateRobot()
    }
    
    @IBAction func btnPressedLeft(_ sender: UIButton) {
        direction = direction?.left
        updateRobot()
    }
    
    @IBAction func btnPressedMove(_ sender: UIButton) {
        guard let d = direction else { return }
        switch d {
        case .north:
            yValue = (yValue ?? 0) + 1
            break
        case .east:
            xValue = (xValue ?? 0) + 1
            break
        case .south:
            yValue = (yValue ?? 0) - 1
            break
        case .west:
            xValue = (xValue ?? 0) - 1
            break
        }
        updateRobot()
    }
}

