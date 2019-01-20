//
//  ViewController.swift
//  FifteenPuzzle
//
//  Created by user on 07.06.2018.
//  Copyright © 2018 Vlad Veretennikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let bigView = UIView()
  let restartButton = UIButton()
  let arrayPiece = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
  var randPieceArray: [Int] = []
  var pieceArray: [UIView] = []
  var centerPieceWithPanGesture: CGPoint!
  
  func randomPiece() -> [Int] {
    var randArray = arrayPiece.shuffled()
    if parityCheck(array: randArray) {
      print("good array: \(randArray)")
    } else {
      print("bad array: \(randArray)")
      randArray = randomPiece()
    }
    return randArray
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createPlayingField()
    createRestartButton()
  }
  
  func createPlayingField() {
    bigView.bounds = CGRect(x: 0, y: 0, width: (Int(view.bounds.width - 24)), height: (Int(view.bounds.width - 24)))
    bigView.center = view.center
    bigView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    view.addSubview(bigView)
    
    randPieceArray = randomPiece()
    pieceArray = createPiece(pieceNumber: randPieceArray)
    for pieceView in pieceArray {
      bigView.addSubview(pieceView)
    }
  }
  
  func createRestartButton() {
    restartButton.bounds = CGRect(x: 0, y: 0, width: view.bounds.width / 2, height: view.bounds.width / 6)
    restartButton.center = CGPoint(x: view.center.x, y: view.center.y + ((bigView.bounds.width - 50) / 4) * 3)
    restartButton.layer.cornerRadius = 5
    restartButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    restartButton.titleLabel?.textColor = UIColor.white
    restartButton.setTitle("Restart", for: .normal)
    restartButton.addTarget(self, action: #selector(restartButtonPressed(sender:)), for: .touchUpInside)
    view.addSubview(restartButton)
  }
  
  func pieceCoordinate(numberPiece: Int) -> (x: Int, y: Int) {
    var x: Int = 0
    var y: Int = 0
    let interval = 10
    let wight = Int((self.bigView.bounds.width - 50) / 4)
    if numberPiece > 0 && numberPiece < 5 {
      x = interval * numberPiece + wight * (numberPiece - 1)
      y = interval
    } else if numberPiece > 4 && numberPiece < 9 {
      x = interval * (numberPiece - 4) + wight * (numberPiece - 5)
      y = interval * 2 + wight
    } else if numberPiece > 8 && numberPiece < 13 {
      x = interval * (numberPiece - 8) + wight * (numberPiece - 9)
      y = interval * 3 + wight * 2
    } else if numberPiece > 12 && numberPiece < 17 {
      x = interval * (numberPiece - 12) + wight * (numberPiece - 13)
      y = interval * 4 + wight * 3
    }
    return (x, y)
  }
  
  func createPiece(pieceNumber: [Int]) -> [UIView] {
    var pieceArray: [UIView] = []
    var i = 0
    let width = Int((bigView.bounds.width - 50) / 4)
    let frameNumberLabel = CGRect(x: 0, y: 0, width: width, height: width)
    for number in pieceNumber {
      i += 1
      let coordinate = pieceCoordinate(numberPiece: i)
      let piece = UIView(frame: CGRect(x: coordinate.x, y: coordinate.y, width: width, height: width))
      piece.layer.cornerRadius = 5
      if number < 16 {
        let numberLabel = UILabel(frame: frameNumberLabel)
        numberLabel.font = numberLabel.font.withSize(34)
        numberLabel.textAlignment = .center
        numberLabel.text = "\(number)"
        piece.addSubview(numberLabel)
        piece.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        piece.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        piece.addGestureRecognizer(pan)
      }
      piece.tag = number
      pieceArray.append(piece)
    }
    return pieceArray
  }
  
  func restart() {
    randPieceArray = randomPiece()
    var newArray: [UIView] = []
    var i = 1
    let width = Int((bigView.bounds.width - 50) / 4)
    for item in randPieceArray {
      for view in pieceArray {
        if view.tag == item {
          newArray.append(view)
          break
        }
      }
    }
    pieceArray = newArray
    for pieceView in pieceArray {
      let coordinate = pieceCoordinate(numberPiece: i)
      pieceView.frame = CGRect(x: coordinate.x, y: coordinate.y, width: width, height: width)
      i += 1
    }
  }
  
  @objc func restartButtonPressed(sender: UIButton) {
    restart()
  }
  
  @objc func handleTap(sender: UITapGestureRecognizer) {
    var hidenView = (CGPoint(),0)
    var index16 = 0
    for piece16 in pieceArray {
      if piece16.tag == 16 {
        hidenView = (piece16.center, index16)
        break
      }
      index16 += 1
    }
    var indexTapPiece = 0
    for tapPiece in pieceArray {
      if tapPiece.tag == sender.view?.tag {
        break
      }
      indexTapPiece += 1
    }
    let currentPiece = (sender.view?.center)!
    let distance = (bigView.bounds.width - 50) / 4 + 10
    var x = hidenView.0.x - currentPiece.x
    if x < 0 {
      x *= -1
    }
    var y = hidenView.0.y - currentPiece.y
    if y < 0 {
      y *= -1
    }
    if hidenView.0.x == currentPiece.x || hidenView.0.y == currentPiece.y {
      if x <= distance && y <= distance {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
          self.pieceArray[hidenView.1].center = currentPiece
          sender.view?.center = hidenView.0
        }) { (finished) in
          // do something
        }
        let piece = pieceArray[indexTapPiece]
        pieceArray[indexTapPiece] = pieceArray[index16]
        pieceArray[index16] = piece
        var array: [Int] = []
        for i in pieceArray {
          array.append(i.tag)
        }
        print(array)
        checkWin(array: array)
      }
    }
  }
  
  @objc func handlePan(sender: UIPanGestureRecognizer) {
    var hidenView = (CGPoint(),0)
    var index16 = 0
    for piece16 in pieceArray {
      if piece16.tag == 16 {
        hidenView = (piece16.center, index16)
        break
      }
      index16 += 1
    }
    var indexTapPiece = 0
    for tapPiece in pieceArray {
      if tapPiece.tag == sender.view?.tag {
        break
      }
      indexTapPiece += 1
    }
    let currentPiece = (sender.view?.center)!
    let distance = (bigView.bounds.width - 50) / 4 + 10
    var x = hidenView.0.x - currentPiece.x
    if x < 0 { x *= -1 }
    var y = hidenView.0.y - currentPiece.y
    if y < 0 { y *= -1 }
    if hidenView.0.x == currentPiece.x || hidenView.0.y == currentPiece.y {
      if x <= distance * 1.9 && y <= distance * 1.9 {
        var translation = sender.translation(in: self.view)
        var movement: CGFloat = 0.0
        switch sender.state {
        case .began:
          centerPieceWithPanGesture = sender.view?.center
        case .changed:
          if let view = sender.view {
            if hidenView.0.x == currentPiece.x {
              if hidenView.0.y >= currentPiece.y {
                if centerPieceWithPanGesture.y > currentPiece.y && translation.y < 0 {
                  translation.y = 0
                }
              } else if centerPieceWithPanGesture.y < currentPiece.y && translation.y > 0 {
                translation.y = 0
              }
              view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
            } else if hidenView.0.y == currentPiece.y {
              if hidenView.0.x >= currentPiece.x {
                if centerPieceWithPanGesture.x > currentPiece.x && translation.x < 0 {
                  translation.x = 0
                }
              } else if centerPieceWithPanGesture.x < currentPiece.x && translation.x > 0 {
                translation.x = 0
              }
              view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
            }
          }
          sender.setTranslation(.zero, in: self.view)
        case .ended:
          movement = (centerPieceWithPanGesture.y - currentPiece.y) + (centerPieceWithPanGesture.x - currentPiece.x)
          if movement < 0 { movement *= -1 }
          if movement < ((sender.view?.bounds.width)! / 2) {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
              sender.view?.center = self.centerPieceWithPanGesture
            })
          } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
              self.pieceArray[hidenView.1].center = self.centerPieceWithPanGesture
              sender.view?.center = hidenView.0
            })
            let piece = pieceArray[indexTapPiece]
            pieceArray[indexTapPiece] = pieceArray[index16]
            pieceArray[index16] = piece
            var array: [Int] = []
            for i in pieceArray {
              array.append(i.tag)
            }
            print(array)
            checkWin(array: array)
          }
          centerPieceWithPanGesture = nil
        case .possible:
          centerPieceWithPanGesture = nil
        case .cancelled:
          centerPieceWithPanGesture = nil
        case .failed:
          centerPieceWithPanGesture = nil
        }
      }
    }
  }
  
  func checkWin(array:[Int]) {
    if array == arrayPiece {
      let alert = UIAlertController(title: nil, message: "Win!", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
        // dosomething
      }
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
    }
  }
}








