//
//  SK4DispatchQueueExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/01.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension DispatchQueue {

	/// メインキューか？
	public static var isMainQueue: Bool {
		return Thread.isMainThread
	}

}

// eof
