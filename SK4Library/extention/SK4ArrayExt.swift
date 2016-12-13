//
//  SK4ArrayExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/22.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension Array {

	// /////////////////////////////////////////////////////////////
	// MARK: -

	/// 全ての要素の間に、別の要素を挿しこむ
	///
	///		let src = [10, 20, 30, 40]
	///		let dst = src.insertRepeat(between: 0)
	///		->	dst: [10, 0, 20, 0, 30, 0, 40]
	public func insertRepeat(between item: Element) -> [Element] {
		if count <= 0 {
			return []
		}

		var ar: [Element] = []
		for no in 0..<count-1 {
			ar.append(self[no])
			ar.append(item)
		}
		ar.append(self[count-1])
		return ar
	}

	/// 全ての要素を、別の要素で挟む
	///
	///		let src = [10, 20, 30, 40]
	///		let dst = src.insertRepeat(sandwich: 0)
	///		->	dst: [0, 10, 0, 20, 0, 30, 0, 40, 0]
	public func insertRepeat(sandwich item: Element) -> [Element] {
		if count <= 0 {
			return []
		}

		var ar: [Element] = [item]
		for ele in self {
			ar.append(ele)
			ar.append(item)
		}
		return ar
	}
	
}

// eof
