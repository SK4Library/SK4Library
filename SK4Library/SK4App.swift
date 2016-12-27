//
//  SK4App.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// アプリケーションに固有の情報を集めたクラス
open class SK4App {

	// /////////////////////////////////////////////////////////////
	// MARK: - ディレクトリ

	/// ドキュメントディレクトリへのパス
	public static let documentDirectory = searchPath(for: .documentDirectory)

	/// テンポラリディレクトリへのパス
	public static let temporaryDirectory = NSTemporaryDirectory()

	/// システムで用意されたディレクトリへのパスを取得
	public static func searchPath(for directory: FileManager.SearchPathDirectory) -> String {
		let paths = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
		return paths[0] + "/"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// iPadで動作中か？
	public static var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}

	/// バージョン情報
	public static var version: String {
		if let str = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
			#if DEBUG
				return str + "[D]"
			#else
				return str
			#endif
		} else {
			assertionFailure()
			return ""
		}
	}

}

// eof
