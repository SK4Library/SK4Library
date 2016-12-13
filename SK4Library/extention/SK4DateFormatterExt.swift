//
//  SK4DateFormatterExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension DateFormatter {

	/// スタイルを指定して初期化
	public convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
		self.init()

		self.dateStyle = dateStyle
		self.timeStyle = timeStyle
	}

	/// フォーマットを指定して初期化
	public convenience init(dateFormat: String) {
		self.init()

		self.dateFormat = dateFormat
	}

	/// Dateを文字列に変換
	public func stringOrNil(from date: Date?) -> String? {
		if let date = date {
			return string(from: date)
		} else {
			return nil
		}
	}

	/// 文字列をDateに変換
	public func dateOrNil(from string: String?) -> Date? {
		if let string = string {
			return date(from: string)
		} else {
			return nil
		}
	}

}

// eof
