//
//  SK4Interpolation.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - 線形補間（手動展開版）

public func sk4Interpolation(y0: Int, y1: Int, x0: Int, x1: Int, x: Int) -> Int {
	if x0 == x1 {
		return (y0 + y1) / 2
	} else {
		return	(y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	}
}

public func sk4Interpolation(y0: CGFloat, y1: CGFloat, x0: CGFloat, x1: CGFloat, x: CGFloat) -> CGFloat {
	if x0 == x1 {
		return (y0 + y1) / 2
	} else {
		return	(y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	}
}

public func sk4Interpolation(y0: Double, y1: Double, x0: Double, x1: Double, x: Double) -> Double {
	if x0 == x1 {
		return (y0 + y1) / 2
	} else {
		return	(y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - 線形補間（Generics版）

/*
	※あまりにもビルドで時間がかかるので封印

public protocol SK4InterpolationType: SignedNumber {
	static func +(lhs: Self, rhs: Self) -> Self
	static func -(lhs: Self, rhs: Self) -> Self
	static func *(lhs: Self, rhs: Self) -> Self
	static func /(lhs: Self, rhs: Self) -> Self
	static func %(lhs: Self, rhs: Self) -> Self
}

extension Double: SK4InterpolationType {}
extension CGFloat: SK4InterpolationType {}
extension Int: SK4InterpolationType {}


// /////////////////////////////////////////////////////////////

/// 単純な線形補間
public func sk4Interpolation<T: SK4InterpolationType>(y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x0 == x1 {
		return (y0 + y1) / 2
	} else {
		return	(y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	}
}

/// 上限／下限付きの線形補間
public func sk4InterpolationFloor<T: SK4InterpolationType>(y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x <= x0 {
		return y0
	}

	if x >= x1 {
		return y1
	}

	return sk4Interpolation(y0: y0, y1: y1, x0: x0, x1: x1, x: x)
}

/// 繰り返す形式の線形補間
public func sk4InterpolatioCycle<T: SK4InterpolationType>(y0: T, y1: T, x0: T, x1: T, x: T) -> T {
	if x0 == x1 {
		return (y0 + y1) / 2
	}

	let max = abs(x1 - x0)
	let dif = abs(x - x0)
	let xn = dif % (max * 2)

	if xn < max {
		return sk4Interpolation(y0: y0, y1: y1, x0: 0, x1: max, x: xn)
	} else {
		return sk4Interpolation(y0: y0, y1: y1, x0: 0, x1: max, x: xn - max)
	}
}
*/

// /////////////////////////////////////////////////////////////

/// 単純な線形補間（UIColor用）
public func sk4Interpolation(y0: UIColor, y1: UIColor, x0: CGFloat, x1: CGFloat, x: CGFloat) -> UIColor {
	let c0 = y0.colorArray
	let c1 = y1.colorArray
	var cn: [CGFloat] = [1, 1, 1, 1]
	for i in 0..<4 {
		cn[i] = sk4Interpolation(y0: c0[i], y1: c1[i], x0: x0, x1: x1, x: x)
	}
	return UIColor(colorArray: cn)
}

// eof
