//
//  SK4CollectionExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/14.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {

	/// 範囲チェック付きのget
	public func safe(_ index: Index) -> Generator.Element? {
		return indices.contains(index) ? self[index] : nil
	}

}

// eof
