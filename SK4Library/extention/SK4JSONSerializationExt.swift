//
//  SK4JSONSerializationExt.swift
//  SK4Library
//
//  Created by See.Ku on 2017/01/04.
//  Copyright (c) 2017 AxeRoad. All rights reserved.
//

import Foundation

extension JSONSerialization {

	// /////////////////////////////////////////////////////////////
	// MARK: - JSON <-> Data の変換

	/// 辞書からJSONを表すDataを作成
	public class func data(fromDic: NSDictionary, options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> Data? {
		do {
			return try self.data(withJSONObject: fromDic, options: options)
		} catch {
			SK4Log.debug("JSONSerialization.string: \(error)")
			return nil
		}
	}

	/// JSONを表すDataから辞書を作成
	public class func dictionary(fromData: Data, options: JSONSerialization.ReadingOptions = []) -> NSDictionary? {
		do {
			let dic = try self.jsonObject(with: fromData, options: options)
			return dic as? NSDictionary
		} catch {
			SK4Log.debug("JSONSerialization.dictionary: \(error)")
			return nil
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - JSON <-> String の変換

	/// 辞書からJSONを表す文字列を作成
	public class func string(fromDic: NSDictionary, options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> String? {
		if let data = self.data(fromDic: fromDic, options: options) {
			return String(data: data, encoding: .utf8)
		} else {
			return nil
		}
	}

	/// JSONを表す文字列から辞書を作成
	public class func dictionary(fromString: String, options: JSONSerialization.ReadingOptions = []) -> NSDictionary? {
		if let data = fromString.data(using: .utf8) {
			return self.dictionary(fromData: data, options: options)
		} else {
			return nil
		}
	}
	
}

// eof
