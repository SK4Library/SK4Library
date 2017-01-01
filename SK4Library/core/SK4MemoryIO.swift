//
//  SK4MemoryIO.swift
//  SK4Library
//
//  Created by See.Ku on 2015/09/04.
//  Copyright (c) 2015 AxeRoad. All rights reserved.
//

import UIKit

/// メモリを対象としたストリームIOクラス
open class SK4MemoryIO: SK4StreamIO {

	// /////////////////////////////////////////////////////////////
	// MARK: - for CustomStringConvertible

	override open var description: String {
		return "count: \(count), memory: \(memory)"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	open var memory = [Byte]()
	open var pos = 0

	/// true: 中身が無い
	override open var isEmpty: Bool {
		return memory.isEmpty
	}

	/// true: データの後端を指してる
	override open var isEnd: Bool {
		return (pos == memory.count)
	}

	/// データの長さ
	override open var count: Int {
		return memory.count
	}

	/// 初期化
	override public init() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 読み込み／書き込み位置関係

	/// 読み込み／書き込み位置を直接移動する
	override open func seek(_ pos: Int) {
		if pos < 0 {
			self.pos = 0

		} else if pos > memory.count {
			self.pos = memory.count

		} else {
			self.pos = pos
		}
	}

	/// 読み込み／書き込み位置を前後に移動する
	override open func skip(_ dif: Int) {
		seek(pos+dif)
	}

	/// 読み込み／書き込み位置を取得する
	override open func tell() -> Int {
		return pos
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 基本的な入出力

	/// 1Byte書き出し
	override open func writeByte(_ val: Byte) throws {
		if isEnd {
			memory.append(val)
		} else {
			memory[pos] = val
		}
		pos += 1
	}

	/// 1Byte読み込み
	override open func readByte() throws -> Byte {
		if isEnd {
			throw SK4StreamIOError.read
		}

		let rc = memory[pos]
		pos += 1
		return rc
	}

	/// 複数Byteの書き出し
	override open func writeBytes(_ val: [Byte]) throws {
		if val.isEmpty {
			return
		}

		let max = val.count
		var use = 0

		if pos < memory.count {
			let end = min(pos+max, memory.count)
			use = end - pos
			memory[pos..<end] = val[0..<use]
		}

		// データを追加
		if max > use {
			memory += val[use..<max]
		}

		pos += max
	}

	/// 複数Byteの読み込み
	override open func readBytes(_ len: Int) throws -> [Byte] {
		if pos + len > count {
			throw SK4StreamIOError.read
		}

		let top = pos
		pos += len
		return [Byte](memory[top..<pos])
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - NSDataとの変換

	/// NSDataから生成
	public convenience init(data: Data) {
		self.init()

		setData(data)
	}

	/// バンドルデータから生成
	public convenience init(bundle: String) throws {
		self.init()

		try readFile(bundle: bundle)
	}
	
	/// ファイルのデータから生成
	public convenience init(path: String) throws {
		self.init()

		try readFile(path: path)
	}

	// /////////////////////////////////////////////////////////////

	/// Dataから内部のデータをセット
	open func setData(_ data: Data) {
		memory = [Byte](data)
		pos = 0
	}

	/// 内部のデータをDataに変換
	open func getData() -> Data {
		return Data(memory)
	}

	// /////////////////////////////////////////////////////////////

	/// バンドルのデータを読み込み
	open func readFile(bundle: String) throws {
		if let path = Bundle.main.path(forResource: bundle, ofType: nil) {
			try readFile(path: path)
		} else {
			throw SK4StreamIOError.read
		}
	}

	/// ファイルのデータを読み込み
	open func readFile(path: String) throws {
		do {
			let url = URL(fileURLWithPath: path)
			let data = try Data(contentsOf: url)
			setData(data)
		} catch {
			SK4Log.debug("Data(contentsOf:): \(error)")
			throw SK4StreamIOError.read
		}
	}

	/// ファイルへデータを書き込み　※NSDataを経由する分、無駄がある
	open func writeFile(path: String) throws {
		let data = getData()
		let url = URL(fileURLWithPath: path)
		try data.write(to: url)
	}

}

// eof
