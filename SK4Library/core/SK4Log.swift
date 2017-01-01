//
//  SK4Log.swift
//  SK4Library
//
//  Created by See.Ku on 2017/01/03.
//  Copyright (c) 2017 AxeRoad. All rights reserved.
//

import Foundation
import os.log

public class SK4Log {

	// /////////////////////////////////////////////////////////////
	// MARK: - public

	/// ログを出力するレベルを指定
	public static var logLevel = OSLogType.error

	/// Debug情報を出力
	public static func debug(_ mes: String) {
		admin.log(mes, level: .debug)
	}

	/// Error情報を出力
	public static func error(_ mes: String) {
		admin.log(mes, level: .error)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - internal

	static let admin = SK4Log()

	init() {
		#if DEBUG
			SK4Log.logLevel = .debug
		#endif
	}

	func log(_ mes: String, level: OSLogType, _ args: CVarArg...) {
		if level.rawValue >= SK4Log.logLevel.rawValue {
			let str = levelString(level)
			os_log("[%@] %@", type: level, str, mes)
		}
	}

	func levelString(_ level: OSLogType) -> String {
		switch level {
		case OSLogType.info:
			return "INFO"

		case OSLogType.debug:
			return "DEBUG"

		case OSLogType.error:
			return "ERROR"

		case OSLogType.fault:
			return "FAULT"

		default:
			return "DEFAULT"
		}
	}

}

// eof
