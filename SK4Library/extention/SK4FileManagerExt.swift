//
//  SK4FileManagerExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

extension FileManager {

	/// ドキュメントディレクトリへのパス
	public static let documentDirectory = searchPath(for: .documentDirectory)

	/// テンポラリディレクトリへのパス
	public static let temporaryDirectory = NSTemporaryDirectory()

	/// システムで用意されたディレクトリへのパスを取得
	public static func searchPath(for directory: FileManager.SearchPathDirectory) -> String {
		let paths = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
		return paths[0] + "/"
	}
	
}

// eof
