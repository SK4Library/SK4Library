//
//  SK4NearlyEqual.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/26.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 誤差の範囲で一致するか？
public func sk4NearlyEqual<T: SignedNumber>(_ v0: T, _ v1: T, dif: T) -> Bool {
	if abs(v0 - v1) <= dif {
		return true
	} else {
		return false
	}
}

/// 誤差の範囲で一致するか？（UIColor用）
public func sk4NearlyEqual(_ c0: UIColor, _ c1: UIColor, dif: CGFloat) -> Bool {
	let v0 = c0.colorArray
	let v1 = c1.colorArray
	for i in 0..<4 {
		if sk4NearlyEqual(v0[i], v1[i], dif: dif) == false {
			return false
		}
	}
	return true
}

// eof
