//
//  SK4FileManagerExt.swift
//  SK4Library
//
//  Created by See.Ku on 2017/01/01.
//  Copyright (c) 2017 AxeRoad. All rights reserved.
//

import Foundation

extension FileManager {

	/// ファイルの一覧を取得（拡張子の指定が可能）
	public func fileArray(atPath path: String, withExtension ext: String? = nil) -> [String] {
		do {
			let ar = try contentsOfDirectory(atPath: path)
			if let ext = ext {
				let trim = ext.trimmingString(in: ".")
				return ar.filter { $0.nsString.pathExtension == trim }
			} else {
				return ar
			}
		} catch {
			assertionFailure("contentsOfDirectory: \(error)")
			return []
		}
	}

}

// eof
