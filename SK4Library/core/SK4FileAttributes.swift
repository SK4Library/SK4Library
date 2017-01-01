//
//  SK4FileAttributes.swift
//  SK4Library
//
//  Created by See.Ku on 2017/01/02.
//  Copyright (c) 2017 AxeRoad. All rights reserved.
//

import Foundation

/// ファイルの属性に関する情報をまとめて取得するための構造体
public struct SK4FileAttributes {

	public var path: String!

	public var type: FileAttributeType!
	public var size: UInt64!
	public var readOnly: Bool!
	public var creationDate: Date!
	public var modificationDate: Date!

	public var isDirectory = false
	public var isRegular = false

	public var sizeString: String {
		return sk4SizeString(size: size)
	}

	public init?(atPath path: String) {
		if attributes(atPath: path) == false {
			return nil
		}
	}

	public init?(inDirectory dir: String, file: String) {
		let path = dir.nsString.appendingPathComponent(file)
		if attributes(atPath: path) == false {
			return nil
		}
	}

	mutating func attributes(atPath path: String) -> Bool {
		do {
			let info = try FileManager.default.attributesOfItem(atPath: path)

			self.path = path
			self.type = info[.type] as? FileAttributeType
			self.size = info[.size] as? UInt64
			self.readOnly = info[.appendOnly] as? Bool
			self.creationDate = info[.creationDate] as? Date
			self.modificationDate = info[.modificationDate] as? Date

			if let type = type {
				if type == .typeDirectory {
					self.isDirectory = true

				} else if type == .typeRegular {
					self.isRegular = true
				}
			}

			return true

		} catch {
			assertionFailure("attributesOfItem: \(error)")
			return false
		}
	}
	
}

// eof
