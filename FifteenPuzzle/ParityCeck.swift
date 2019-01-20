//
//  ParityCeck.swift
//  FifteenPuzzle
//
//  Created by user on 20.01.2019.
//  Copyright © 2019 Vlad Veretennikov. All rights reserved.
//

import Foundation

func parityCheck(array: [Int]) -> Bool {
  var numberRow16Piece = 0
  var i = 0
  for n in array {
    i += 1
    if n == 16 {
      if i > 0 && i < 5 {
        numberRow16Piece = 1
        break
      } else if i > 4 && i < 9 {
        numberRow16Piece = 2
        break
      } else if i > 8 && i < 13 {
        numberRow16Piece = 3
        break
      } else if i > 12 && i < 17 {
        numberRow16Piece = 4
        break
      }
    }
  }
  
  var k = 0
  for m in array.enumerated() {
    if m.element == 16 {
      continue
    }
    for j in array.enumerated() {
      if j.element == 16 {
        continue
      }
      if j.offset > m.offset {
        if m.element > j.element {
          k += 1
        }
      }
    }
  }
  k += numberRow16Piece
  return k % 2 == 0
}
