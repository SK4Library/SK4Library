//
//  SK4StreamIO.swift
//  SK4Library
//
//  Created by See.Ku on 2015/09/04.
//  Copyright (c) 2015 AxeRoad. All rights reserved.
//

import UIKit

/// ストリームIO関係の例外
public enum SK4StreamIOError: Error {
	case write
	case read
}

/// ストリームIOの基本クラス
open class SK4StreamIO: CustomStringConvertible {

	// /////////////////////////////////////////////////////////////
	// MARK: - for CustomStringConvertible

	open var description: String {
		return "count: \(count)"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化など

	/// Byte = 1Byte = UInt8
	public typealias Byte = UInt8

	/// true: 中身が無い
	open var isEmpty: Bool {
		assertionFailure("You need override me!")
		return true
	}

	/// true: データの後端を指してる
	open var isEnd: Bool {
		assertionFailure("You need override me!")
		return true
	}

	/// データの長さ
	open var count: Int {
		assertionFailure("You need override me!")
		return 0
	}

	/// 初期化
	public init() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 読み込み／書き込み位置関係

	/// 読み込み／書き込み位置を直接移動する
	open func seek(_ pos: Int) {
		assertionFailure("You need override me!")
	}

	/// 読み込み／書き込み位置を前後に移動する
	open func skip(_ dif: Int) {
		assertionFailure("You need override me!")
	}

	/// 読み込み／書き込み位置を取得する
	open func tell() -> Int {
		assertionFailure("You need override me!")
		return 0
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 1Byte単位の入出力

	/// 1Byte書き出し
	open func writeByte(_ val: Byte) throws {
		assertionFailure("You need override me!")
		throw SK4StreamIOError.write
	}

	/// 1Byte読み込み
	open func readByte() throws -> Byte {
		assertionFailure("You need override me!")
		throw SK4StreamIOError.read
	}

	/// 複数Byteの書き出し　※override推奨
	open func writeBytes(_ val: [Byte]) throws {
		for byte in val {
			try writeByte(byte)
		}
	}

	/// 複数Byteの読み込み　※override推奨
	open func readBytes(_ len: Int) throws -> [Byte] {
		var ar = [Byte]()
		for _ in 0..<len {
			let byte = try readByte()
			ar.append(byte)
		}
		return ar
	}


	// /////////////////////////////////////////////////////////////
	// MARK: - 基本要素
	// /////////////////////////////////////////////////////////////

	// /////////////////////////////////////////////////////////////
	// MARK: - UInt8

	open func write(_ val: UInt8) throws {
		try writeByte(val)
	}

	open func read(_ val: inout UInt8) throws {
		val = try readByte()
	}

	open func readUInt8(def: UInt8 = 0) -> UInt8 {
		do {
			return try readByte()
		} catch {
			return def
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UInt32

	open func write(_ val: UInt32) throws {
		let len = MemoryLayout<UInt32>.size
		var ar = Array<Byte>(repeating: 0, count: len)

		var temp = val
		for i in stride(from: len, to: 0, by: -1) {
			ar[i-1] = UInt8(temp & 0xff)
			temp >>= 8
		}

		try writeBytes(ar)
	}

	open func read(_ val: inout UInt32) throws {
		let len = MemoryLayout<UInt32>.size
		let ar = try readBytes(len)

		var temp: UInt32 = 0
		for i in stride(from: 0, to: len, by: 1) {
			temp <<= 8
			temp |= UInt32(ar[i])
		}

		val = temp
	}

	open func readUInt32(def: UInt32 = 0) -> UInt32 {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UInt64

	open func write(_ val: UInt64) throws {
		let len = MemoryLayout<UInt64>.size
		var ar = Array<Byte>(repeating: 0, count: len)

		var temp = val
		for i in stride(from: len, to: 0, by: -1) {
			ar[i-1] = UInt8(temp & 0xff)
			temp >>= 8
		}

		try writeBytes(ar)
	}

	open func read(_ val: inout UInt64) throws {
		let len = MemoryLayout<UInt64>.size
		let ar = try readBytes(len)

		var temp: UInt64 = 0
		for i in stride(from: 0, to: len, by: 1) {
			temp <<= 8
			temp |= UInt64(ar[i])
		}

		val = temp
	}

	open func readUInt64(def: UInt64 = 0) -> UInt64 {
		var val = def
		try? read(&val)
		return val
	}


	// /////////////////////////////////////////////////////////////
	// MARK: - 整数系
	// /////////////////////////////////////////////////////////////

	// /////////////////////////////////////////////////////////////
	// MARK: - Int32　※内部的にはUInt32

	open func write(_ val: Int32) throws {
		let temp = UInt32(bitPattern: val)
		try write(temp)
	}

	open func read(_ val: inout Int32) throws {
		var temp: UInt32 = 0
		try read(&temp)
		val = Int32(bitPattern: temp)
	}

	open func readInt32(def: Int32 = 0) -> Int32 {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - Int64　※内部的にはUInt64

	open func write(_ val: Int64) throws {
		let temp = UInt64(bitPattern: val)
		try write(temp)
	}

	open func read(_ val: inout Int64) throws {
		var temp: UInt64 = 0
		try read(&temp)
		val = Int64(bitPattern: temp)
	}

	open func readInt64(def: Int64 = 0) -> Int64 {
		var val = def
		try? read(&val)
		return val
	}
	

	// /////////////////////////////////////////////////////////////
	// MARK: - 浮動小数点系
	// /////////////////////////////////////////////////////////////

	// /////////////////////////////////////////////////////////////
	// MARK: - Float　※内部的にはUInt32

	open func write(_ val: Float) throws {
		let temp = unsafeBitCast(val, to: UInt32.self)
		try write(temp)
	}

	open func read(_ val: inout Float) throws {
		var temp: UInt32 = 0
		try read(&temp)
		val = unsafeBitCast(temp, to: Float.self)
	}

	open func readFloat(def: Float = 0) -> Float {
		var val = def
		try? read(&val)
		return val
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - Double　※内部的にはUInt64

	open func write(_ val: Double) throws {
		let temp = unsafeBitCast(val, to: UInt64.self)
		try write(temp)
	}

	open func read(_ val: inout Double) throws {
		var temp: UInt64 = 0
		try read(&temp)
		val = unsafeBitCast(temp, to: Double.self)
	}

	open func readDouble(def: Double = 0) -> Double {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - CGFloat　※内部的にはFloat

	open func write(_ val: CGFloat) throws {
		try write(Float(val))
	}

	open func read(_ val: inout CGFloat) throws {
		var temp: Float = 0
		try read(&temp)
		val = CGFloat(temp)
	}

	open func readCGFloat(def: CGFloat = 0) -> CGFloat {
		var val = def
		try? read(&val)
		return val
	}
	

	// /////////////////////////////////////////////////////////////
	// MARK: - 構造体
	// /////////////////////////////////////////////////////////////

	// /////////////////////////////////////////////////////////////
	// MARK: - CGSize　※内部的にはCGFloat*2

	open func write(_ val: CGSize) throws {
		try write(val.width)
		try write(val.height)
	}

	open func read(_ val: inout CGSize) throws {
		var temp = CGSize()
		try read(&temp.width)
		try read(&temp.height)
		val = temp
	}

	open func readCGSize(def: CGSize = CGSize()) -> CGSize {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - CGPoint　※内部的にはCGFloat*2

	open func write(_ val: CGPoint) throws {
		try write(val.x)
		try write(val.y)
	}

	open func read(_ val: inout CGPoint) throws {
		var temp = CGPoint()
		try read(&temp.x)
		try read(&temp.y)
		val = temp
	}

	open func readCGPoint(def: CGPoint = CGPoint()) -> CGPoint {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - CGRect　※内部的にはCGPointとCGSizeのペア

	open func write(_ val: CGRect) throws {
		try write(val.origin)
		try write(val.size)
	}

	open func read(_ val: inout CGRect) throws {
		var temp = CGRect()
		try read(&temp.origin)
		try read(&temp.size)
		val = temp
	}

	open func readCGRect(def: CGRect = CGRect()) -> CGRect {
		var val = def
		try? read(&val)
		return val
	}


	// /////////////////////////////////////////////////////////////
	// MARK: - その他
	// /////////////////////////////////////////////////////////////

	// /////////////////////////////////////////////////////////////
	// MARK: - Bool　※内部的にはUInt8

	open func write(_ val: Bool) throws {
		let temp: UInt8 = val ? 1 : 0
		try write(temp)
	}

	open func read(_ val: inout Bool) throws {
		var temp: UInt8 = 0
		try read(&temp)
		val = (temp == 0) ? false : true
	}

	open func readBool(def: Bool = false) -> Bool {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - Int　※内部的にはInt64

	open func write(_ val: Int) throws {
		let temp = Int64(exactly: val) ?? 0
		try write(temp)
	}

	open func read(_ val: inout Int) throws {
		var temp: Int64 = 0
		try read(&temp)
		val = Int(exactly: temp) ?? 0
	}

	open func readInt(def: Int = 0) -> Int {
		var val = def
		try? read(&val)
		return val
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - String　※内部的にはUInt32 + [UInt8] + 0

	open func write(_ val: String) throws {
		let ar = [UInt8](val.utf8)
		let len = UInt32(ar.count + 1)

		try write(len)
		try writeBytes(ar)
		try writeByte(0)
	}

	open func read(_ val: inout String) throws {
		var len: UInt32 = 0
		try read(&len)

		let ar: [UInt8] = try readBytes(Int(len))
		val = String(cString: ar)
	}

	open func readString(def: String = "") -> String {
		var str = def
		try? read(&str)
		return str
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - Date　※内部的にはDouble

	open func write(_ val: Date) throws {
		let ti = val.timeIntervalSinceReferenceDate
		try write(ti)
	}

	open func read(_ val: inout Date) throws {
		var temp: Double = 0
		try read(&temp)
		val = Date(timeIntervalSinceReferenceDate: temp)
	}

	open func readDate(def: Date = Date()) -> Date {
		var str = def
		try? read(&str)
		return str
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - バージョン　※内部的にはInt32

	public var version = 0

	public func writeVersion(_ val: Int) throws {
		version = val
		let temp = Int32(val)
		try write(temp)
	}

	public func readVersion() throws -> Int {
		var temp: Int32 = 0
		try read(&temp)
		version = Int(temp)
		return version
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - SK4MemoryIO　※内部的にInt + [Byte]

	open func write(_ val: SK4MemoryIO) throws {
		try write(val.count)
		try writeBytes(val.memory)
	}

	open func read(_ val: inout SK4MemoryIO) throws {
		var len: Int = 0
		try read(&len)

		let temp = SK4MemoryIO()
		temp.memory = try readBytes(Int(len))
		val = temp
	}
	
	open func readMemoryIO() -> SK4MemoryIO {
		var mem = SK4MemoryIO()
		try? read(&mem)
		return mem
	}

}

// eof
