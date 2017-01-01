//
//  SK4StringExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/*
/// 垂直方向のAlignment
public enum SK4VerticalAlignment: Int {
	case Top
	case Center
	case Bottom
}
*/

extension String {

	// /////////////////////////////////////////////////////////////
	// MARK: - 変換・取得

	/// ローカライズした文字列を取得
	public var ls: String {
		return NSLocalizedString(self, comment: self)
	}

	/// NSStringを取得
	public var nsString: NSString {
		return (self as NSString)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - トリミング

	/// 文字列の前後から空白文字を削除
	public func trimmingSpace() -> String {
		return trimmingCharacters(in: .whitespaces)
	}

	/// 文字列の前後から空白文字と改行を削除
	public func trimmingSpaceNL() -> String {
		return trimmingCharacters(in: .whitespacesAndNewlines)
	}

	/// 文字列の前後から指定した文字を削除
	public func trimmingString(in str: String) -> String {
		let cs = CharacterSet(charactersIn: str)
		return trimmingCharacters(in: cs)
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - 部分文字列

	/// 先頭から指定された位置までの部分文字列を取得　※範囲チェックあり
	public func substring(to pos: Int) -> String {
		if pos <= 0 {
			return ""
		} else if characters.count <= pos {
			return self
		} else {
			let pos = startIndexOffset(by: pos)
			return substring(to: pos)
		}
	}

	/// 指定された位置から末尾までの部分文字列を取得　※範囲チェックあり
	public func substring(from pos: Int) -> String {
		if pos <= 0 {
			return self
		} else if characters.count <= pos {
			return ""
		} else {
			let pos = startIndexOffset(by: pos)
			return substring(from: pos)
		}
	}

	/// 指定された範囲の部分文字列を作成する　※範囲チェックあり
	public func substring(start: Int, end: Int) -> String {
		let len = characters.count
		if start >= end || end <= 0 || len <= start {
			return ""
		} else {
			let p0 = startIndexOffset(by: max(0, start))
			let p1 = startIndexOffset(by: min(len, end))
			return substring(with: p0..<p1)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// startIndexをずらしたIndexを取得
	public func startIndexOffset(by: Int) -> Index {
		return index(startIndex, offsetBy: by)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 正規表現

	/// 正規表現でマッチング
	public func matchArray(regularExpression pattern: String, locale: Locale? = nil) -> [String] {
		var ar = [String]()
		var target = startIndex..<endIndex
		while true {
			if let rc = range(of: pattern, options: .regularExpression, range: target, locale: locale) {
				ar.append(self[rc])
				target = rc.upperBound..<endIndex
			} else {
				return ar
			}
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ファイル名

	/// ディレクトリの文字列にファイル名を連結
	public func appendingPath(_ fn: String) -> String {
		return nsString.appendingPathComponent(fn)
	}
	



/*


	// /////////////////////////////////////////////////////////////
	// MARK: - データ変換

	/// 文字列からNSDataを生成
	public func sk4ToNSData() -> NSData? {
		return nsString.dataUsingEncoding(NSUTF8StringEncoding)
	}

	/// Base64文字列をNSDataにデコード
	public func sk4Base64Decode(options: NSDataBase64DecodingOptions = .IgnoreUnknownCharacters) -> NSData? {
		return NSData(base64EncodedString: self, options: options)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - JSON

	/// JSON形式の文字列からNSDictionaryを生成
	public func sk4JsonToDic(options: NSJSONReadingOptions = []) -> NSDictionary? {
		guard let data = sk4ToNSData() else { return nil }

		do {
			if let dic = try NSJSONSerialization.JSONObjectWithData(data, options: options) as? NSDictionary {
				return dic
			}
		} catch {
			sk4DebugLog("JSONObjectWithData error: \(error)")
		}

		return nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ファイル入出力

	/// ファイルを読み込み
	public static func sk4ReadFile(path: String) -> String? {
		do {
			return try String(contentsOfFile: path)
		} catch {
			return nil
		}
	}

	/// ファイルに書き出し
	public func sk4WriteFile(path: String) -> Bool {
		do {
			try writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
			return true
		} catch {
			return false
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 描画

	/// 描画範囲を示す矩形を取得
	public func sk4BoundingRect(size: CGSize, options: NSStringDrawingOptions = .UsesLineFragmentOrigin, attributes: [String : AnyObject]? = nil, context: NSStringDrawingContext? = nil) -> CGRect {
		return self.boundingRectWithSize(size, options: options, attributes: attributes, context: context)
	}

	/// 指定された範囲の中央に文字列を描画
	public func sk4DrawAtCenter(rect: CGRect, withAttributes attrs: [String:AnyObject]?) {
		let size = self.sizeWithAttributes(attrs)
		let cx = rect.midX - size.width/2
		let cy = rect.midY - size.height/2
		self.drawAtPoint(CGPoint(x: cx, y: cy), withAttributes: attrs)
	}

	/// 垂直方向のアライメントを指定して、文字列を描画
	public func sk4DrawInRect(rect: CGRect, withAttributes attrs: [String:AnyObject]?, vertical: SK4VerticalAlignment = .Top) {
		var rect = rect
		let bound = sk4BoundingRect(rect.size, attributes: attrs)

		switch vertical {
		case .Top:
			break

		case .Center:
			let dif = (rect.height - bound.height) / 2
			rect.origin.y += dif
			rect.size.height -= dif

		case .Bottom:
			let dif = rect.height - bound.height
			rect.origin.y += dif
			rect.size.height -= dif
		}

		self.drawInRect(rect, withAttributes: attrs)
	}
*/

/*
	// /////////////////////////////////////////////////////////////
	// MARK: - 正規表現

	/// 正規表現でマッチング
	public func sk4RegularExpression(pattern: String, options: NSRegularExpressionOptions = []) -> [String] {
		do {
			let rex = try NSRegularExpression(pattern: pattern, options: options)
			let ar = rex.matchesInString(self, options: [], range: NSRange(location: 0, length: nsString.length))
			return ar.map() { rc in
				return self.nsString.substringWithRange(rc.range)
			}
		} catch {
			assertionFailure("Wrong regular expression. str: \(self) pat:\(pattern)")
			return []
		}
	}

	/// 文字列の分割
	public func sk4Split(separater: String) -> [String] {
		return componentsSeparatedByString(separater)
	}
*/

}

// eof
