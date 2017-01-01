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

// /////////////////////////////////////////////////////////////
// MARK: - その他

/// サイズを表す文字列を取得（数字3桁＋単位）
public func sk4SizeString(size: UInt64) -> String {

	// ※実はZBが使われる事はない
	let units: [String] = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB"]

	var size = size
	for i in 0..<units.count-1 {

		// 3桁以下ならそのまま出力
		if size < 1000 {
			return "\(size) \(units[i])"
		}

		// 次の単位で2桁未満か？
		if size < 1024 * 10 {

			// 小数点以下1桁で四捨五入
			let tmp = round((Double(size) * 10.0) / 1024.0) / 10.0
			let fmt = (tmp < 10.0) ? "%0.1f" : "%0.0f"
			let num = String(format: fmt, tmp)
			return "\(num) \(units[i+1])"
		}

		size /= 1024
	}

	return "\(size) YB"
}

// eof
