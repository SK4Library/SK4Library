//
//  SK4LeakCheck.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// メモリリークをチェックするためだけのクラス
public class SK4LeakCheck {

	static var leakCheckTab = 0

	let tab: Int
	let name: String

	/// 名前を指定して初期化
	public init(name: String) {
		self.tab = SK4LeakCheck.leakCheckTab
		self.name = name

		#if DEBUG
			SK4LeakCheck.leakCheckTab += 1
			printState(">>")
		#endif
	}

	/// ファイル名と行数から初期化
	public convenience init(file: String = #file, line: Int = #line) {
		let fn = file.nsString.lastPathComponent
		let name = "file: \(fn), line: \(line)"
		self.init(name: name)
	}

	deinit {
		#if DEBUG
			printState("<<")
			SK4LeakCheck.leakCheckTab -= 1
		#endif
	}

	func printState(_ mes: String) {
		let no = String(format: "%02d", tab + 1)
		var skip = no + mes
		for _ in 0..<tab {
			skip += "  "
		}
		print("\(skip)\(name)")
	}

}

// eof
