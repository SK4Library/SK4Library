//
//  SK4Library.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

// /////////////////////////////////////////////////////////////
// MARK: - 乱数

/// 乱数を取得
public func sk4Random(max: Int) -> Int {
	let tmp = UInt32(max)
	return Int(arc4random_uniform(tmp))
}

/// 乱数を取得
public func sk4Random(max: CGFloat) -> CGFloat {
	let tmp = UInt32(max)
	return CGFloat(arc4random_uniform(tmp))
}


// eof
