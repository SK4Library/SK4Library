//
//  SK4MemoryIOTests.swift
//  SK4LibraryTests
//
//  Created by See.Ku on 2015/09/04.
//  Copyright (c) 2015 AxeRoad. All rights reserved.
//

import XCTest
import SK4Library

class SK4MemoryIOTests: XCTestCase {

	func testBasic() {

		// 生成
		let mem = SK4MemoryIO()
		XCTAssert(mem.isEnd == true)
		XCTAssert(mem.isEmpty == true)
		XCTAssert(mem.count == 0)

		// 書き込み
		do {
			try mem.writeByte(1)
			try mem.writeByte(2)
			try mem.writeByte(3)
			try mem.writeByte(4)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4)
		} catch {
			XCTAssert(false)
		}

		// seek
		mem.seek(0)
		XCTAssert(mem.isEnd == false)

		// 通常の読み込み
		do {
			let t0 = try mem.readByte()
			XCTAssert(t0 == 1)

			var t1: SK4MemoryIO.Byte = 0
			try mem.read(&t1)
			XCTAssert(t1 == 2)
		} catch {
			XCTAssert(false)
		}

		// 後端の読み込み
		mem.skip(2)
		XCTAssert(mem.isEnd == true)

		do {
			_ = try mem.readByte()
			XCTAssert(false)
		} catch {
			XCTAssert(true)
		}

		do {
			var t4b: UInt8 = 0
			try mem.read(&t4b)
			XCTAssert(false)
		} catch {
			XCTAssert(true)
		}
	}

	func testDataConvert() {
		let ar: [UInt8] = [3,4,5,6]
		let src = Data(bytes: ar)

		// 生成
		let mem = SK4MemoryIO(data: src)
		XCTAssert(mem.isEnd == false)
		XCTAssert(mem.isEmpty == false)
		XCTAssert(mem.count == 4)
		XCTAssert(mem.tell() == 0)

		// 通常の読み込み
		do {
			let t0 = try mem.readByte()
			XCTAssert(t0 == 3)

			var t1: UInt8 = 0
			try mem.read(&t1)
			XCTAssert(t1 == 4)
		} catch {
			XCTAssert(false)
		}

		// データ書き換え
		do {
			try mem.write(UInt8(0))
			try mem.write(UInt8(1))
			try mem.write(UInt8(2))
			try mem.write(UInt8(3))
			XCTAssert(mem.description == "count: 6, memory: [3, 4, 0, 1, 2, 3]")
		} catch {
			XCTAssert(false)
		}
	}

	func testByts() {
		do {
			let mem = SK4MemoryIO()

			// Byteの配列を書き出し
			let ar0: [UInt8] = [1, 2, 3, 4]
			try mem.writeBytes(ar0)
			XCTAssert(mem.count == 4)
			XCTAssert(mem.tell() == 4)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 4, memory: [1, 2, 3, 4]")

			// Byteの配列で部分的に上書き
			mem.seek(3)

			let ar1: [UInt8] = [8, 9]
			try mem.writeBytes(ar1)
			XCTAssert(mem.count == 5)
			XCTAssert(mem.tell() == 5)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 5, memory: [1, 2, 3, 8, 9]")

			// Byteの配列を追加
			let ar2: [UInt8] = [16, 17]
			try mem.writeBytes(ar2)
			XCTAssert(mem.count == 7)
			XCTAssert(mem.tell() == 7)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 7, memory: [1, 2, 3, 8, 9, 16, 17]")

			// Byteの配列で上書き
			mem.seek(0)

			let ar3: [UInt8] = [32, 33]
			try mem.writeBytes(ar3)
			XCTAssert(mem.count == 7)
			XCTAssert(mem.tell() == 2)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 7, memory: [32, 33, 3, 8, 9, 16, 17]")

		} catch {
			XCTAssert(false)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 基本要素

	func testUInt8() {
		do {
			let mem = SK4MemoryIO()

			let w0: UInt8 = 0
			let w1: UInt8 = 127
			let w2: UInt8 = 255

			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 1)
			XCTAssert(mem.tell() == 1)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 3)
			XCTAssert(mem.tell() == 3)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 3, memory: [0, 127, 255]")

			mem.seek(0)
			var r0: UInt8 = 0
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			var r1: UInt8 = 0
			var r2: UInt8 = 0
			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readUInt8()
			let d1 = mem.readUInt8()
			let d2 = mem.readUInt8()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testUInt32() {
		do {
			let mem = SK4MemoryIO()

			let w0: UInt32 = 0
			let w1: UInt32 = 1000
			let w2: UInt32 = 0xffff_ffff

			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4)
			XCTAssert(mem.tell() == 4)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 12)
			XCTAssert(mem.tell() == 12)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 12, memory: [0, 0, 0, 0, 0, 0, 3, 232, 255, 255, 255, 255]")

			mem.seek(0)
			var r0: UInt32 = 0
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			var r1: UInt32 = 0
			var r2: UInt32 = 0
			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readUInt32()
			let d1 = mem.readUInt32()
			let d2 = mem.readUInt32()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testUInt64() {
		do {
			let mem = SK4MemoryIO()

			let w0: UInt64 = 0
			let w1: UInt64 = 0x123_4567_89ab_cdef
			let w2: UInt64 = 0xffff
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 1, 35, 69, 103, 137, 171, 205, 239, 0, 0, 0, 0, 0, 0, 255, 255]")

			var r0: UInt64 = 0
			var r1: UInt64 = 0
			var r2: UInt64 = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readUInt64()
			let d1 = mem.readUInt64()
			let d2 = mem.readUInt64()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - 整数系

	func testInt32() {
		do {
			let mem = SK4MemoryIO()

			let w0: Int32 = 0
			let w1: Int32 = -2000
			let w2: Int32 = -10
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4)
			XCTAssert(mem.tell() == 4)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 12)
			XCTAssert(mem.tell() == 12)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 12, memory: [0, 0, 0, 0, 255, 255, 248, 48, 255, 255, 255, 246]")

			var r0: Int32 = 0
			var r1: Int32 = 0
			var r2: Int32 = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)

			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readInt32()
			let d1 = mem.readInt32()
			let d2 = mem.readInt32()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testInt64() {
		do {
			let mem = SK4MemoryIO()

			let w0: Int64 = 0
			let w1: Int64 = 0x123_4567_89ab_cdef
			let w2: Int64 = -100
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 1, 35, 69, 103, 137, 171, 205, 239, 255, 255, 255, 255, 255, 255, 255, 156]")

			var r0: Int64 = 0
			var r1: Int64 = 0
			var r2: Int64 = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readInt64()
			let d1 = mem.readInt64()
			let d2 = mem.readInt64()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 浮動小数点系

	func testFloat() {
		do {
			let mem = SK4MemoryIO()

			let w0: Float = 0
			let w1: Float = 1234.5678
			let w2: Float = -8765.4321
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4)
			XCTAssert(mem.tell() == 4)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 12)
			XCTAssert(mem.tell() == 12)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 12, memory: [0, 0, 0, 0, 68, 154, 82, 43, 198, 8, 245, 186]")

			var r0: Float = 0
			var r1: Float = 0
			var r2: Float = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readFloat()
			let d1 = mem.readFloat()
			let d2 = mem.readFloat()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}
	
	func testDouble() {
		do {
			let mem = SK4MemoryIO()

			XCTAssert(MemoryLayout<Double>.size == 8)

			let w0: Double = 0
			let w1: Double = 1234.56789
			let w2: Double = -100
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 64, 147, 74, 69, 132, 244, 198, 231, 192, 89, 0, 0, 0, 0, 0, 0]")

			var r0: Double = 0
			var r1: Double = 0
			var r2: Double = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readDouble()
			let d1 = mem.readDouble()
			let d2 = mem.readDouble()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testCGFloat() {
		do {
			let mem = SK4MemoryIO()

			let w0: CGFloat = 0
			let w1: CGFloat = 1234.5678
			let w2: CGFloat = -8765.4321
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4)
			XCTAssert(mem.tell() == 4)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 12)
			XCTAssert(mem.tell() == 12)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 12, memory: [0, 0, 0, 0, 68, 154, 82, 43, 198, 8, 245, 186]")

			var r0: CGFloat = 0
			var r1: CGFloat = 0
			var r2: CGFloat = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)

			XCTAssert(mem.isEnd == true)

			// 変換誤差を許容する
			XCTAssert(sk4NearlyEqual(r1, w1, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2, w2, dif: 0.01))

			mem.seek(0)
			let d0 = mem.readCGFloat()
			let d1 = mem.readCGFloat()
			let d2 = mem.readCGFloat()
			XCTAssert(d0 == w0)
			XCTAssert(sk4NearlyEqual(d1, w1, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2, w2, dif: 0.01))

		} catch {
			XCTAssert(false)
		}
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - 構造体

	func testCGSize() {
		do {
			let mem = SK4MemoryIO()

			let w0 = CGSize(width: 0, height: 0)
			let w1 = CGSize(width: 23456.789, height: -987.654321)
			let w2 = CGSize(width: 0.0001, height: -0.000002)
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 70, 183, 65, 148, 196, 118, 233, 224, 56, 209, 183, 23, 182, 6, 55, 189]")

			var r0 = CGSize()
			var r1 = CGSize()
			var r2 = CGSize()
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(sk4NearlyEqual(r1.width, w1.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r1.height, w1.height, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2.width, w2.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2.height, w2.height, dif: 0.01))

			mem.seek(0)
			let d0 = mem.readCGSize()
			let d1 = mem.readCGSize()
			let d2 = mem.readCGSize()
			XCTAssert(d0 == w0)
			XCTAssert(sk4NearlyEqual(d1.width, w1.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d1.height, w1.height, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2.width, w2.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2.height, w2.height, dif: 0.01))

		} catch {
			XCTAssert(false)
		}
	}

	func testCGPoint() {
		do {
			let mem = SK4MemoryIO()

			let w0 = CGPoint(x: 0, y: 0)
			let w1 = CGPoint(x: 2, y: 2)
			let w2 = CGPoint(x: -257, y: 11)
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 64, 0, 0, 0, 195, 128, 128, 0, 65, 48, 0, 0]")

			var r0 = CGPoint()
			var r1 = CGPoint()
			var r2 = CGPoint()
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readCGPoint()
			let d1 = mem.readCGPoint()
			let d2 = mem.readCGPoint()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testCGRect() {
		do {
			let mem = SK4MemoryIO()

			let w0 = CGRect(x: 0, y: 0, width: 0, height: 0)
			let w1 = CGRect(x: 10, y: 20, width: 30, height: 40)
			let w2 = CGRect(x: 1.001, y: 2.002, width: 3.0003, height: 4.00004)
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 16)
			XCTAssert(mem.tell() == 16)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 48)
			XCTAssert(mem.tell() == 48)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 48, memory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 32, 0, 0, 65, 160, 0, 0, 65, 240, 0, 0, 66, 32, 0, 0, 63, 128, 32, 197, 64, 0, 32, 197, 64, 64, 4, 234, 64, 128, 0, 84]")

			var r0 = CGRect()
			var r1 = CGRect()
			var r2 = CGRect()
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(sk4NearlyEqual(r2.origin.x, w2.origin.x, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2.origin.y, w2.origin.y, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2.size.width, w2.size.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(r2.size.height, w2.size.height, dif: 0.01))

			mem.seek(0)
			let d0 = mem.readCGRect()
			let d1 = mem.readCGRect()
			let d2 = mem.readCGRect()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(sk4NearlyEqual(d2.origin.x, w2.origin.x, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2.origin.y, w2.origin.y, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2.size.width, w2.size.width, dif: 0.01))
			XCTAssert(sk4NearlyEqual(d2.size.height, w2.size.height, dif: 0.01))
			
		} catch {
			XCTAssert(false)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	func testBool() {
		do {
			let mem = SK4MemoryIO()

			let w0 = true
			let w1 = false
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 1)
			XCTAssert(mem.tell() == 1)

			try mem.write(w1)
			XCTAssert(mem.count == 2)
			XCTAssert(mem.tell() == 2)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 2, memory: [1, 0]")

			var r0 = Bool()
			var r1 = Bool()
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)

			mem.seek(0)
			let d0 = mem.readBool()
			let d1 = mem.readBool()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)

		} catch {
			XCTAssert(false)
		}
	}
	
	func testInt() {
		do {
			let mem = SK4MemoryIO()

			let w0: Int = 0
			let w1: Int = 0x123_4567
			let w2: Int = -100
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 35, 69, 103, 255, 255, 255, 255, 255, 255, 255, 156]")

			var r0: Int = 0
			var r1: Int = 0
			var r2: Int = 0
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readInt()
			let d1 = mem.readInt()
			let d2 = mem.readInt()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}
	
	func testString() {
		do {
			let mem = SK4MemoryIO()

			let w0 = "abcdefg_"
			let w1 = "0123４５６７"
			let w2 = "ＡＢＣdefg"
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 4 + 8 + 1)
			XCTAssert(mem.tell() == 4 + 8 + 1)

			try mem.write(w1)
			try mem.write(w2)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 52, memory: [0, 0, 0, 9, 97, 98, 99, 100, 101, 102, 103, 95, 0, 0, 0, 0, 17, 48, 49, 50, 51, 239, 188, 148, 239, 188, 149, 239, 188, 150, 239, 188, 151, 0, 0, 0, 0, 14, 239, 188, 161, 239, 188, 162, 239, 188, 163, 100, 101, 102, 103, 0]")

			var r0 = ""
			var r1 = ""
			var r2 = ""

			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readString()
			let d1 = mem.readString()
			let d2 = mem.readString()
			XCTAssert(w0 == d0)
			XCTAssert(w1 == d1)
			XCTAssert(w2 == d2)

		} catch {
			XCTAssert(false)
		}
	}

	func testDate() {
		do {
			let mem = SK4MemoryIO()

			let w0 = Date(timeIntervalSince1970: 0)
			let w1 = Date(timeIntervalSince1970: 1000)
			let w2 = Date(timeIntervalSinceReferenceDate: 0)
			try mem.write(w0)
			XCTAssert(mem.isEnd == true)
			XCTAssert(mem.isEmpty == false)
			XCTAssert(mem.count == 8)
			XCTAssert(mem.tell() == 8)

			try mem.write(w1)
			try mem.write(w2)
			XCTAssert(mem.count == 24)
			XCTAssert(mem.tell() == 24)

			//			print("\(mem)")
			XCTAssert(mem.description == "count: 24, memory: [193, 205, 39, 228, 64, 0, 0, 0, 193, 205, 39, 226, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]")

			var r0 = Date()
			var r1 = Date()
			var r2 = Date()
			mem.seek(0)
			try mem.read(&r0)
			XCTAssert(mem.isEnd == false)
			XCTAssert(r0 == w0)

			try mem.read(&r1)
			try mem.read(&r2)
			XCTAssert(mem.isEnd == true)
			XCTAssert(r1 == w1)
			XCTAssert(r2 == w2)

			mem.seek(0)
			let d0 = mem.readDate()
			let d1 = mem.readDate()
			let d2 = mem.readDate()
			XCTAssert(d0 == w0)
			XCTAssert(d1 == w1)
			XCTAssert(d2 == w2)

		} catch {
			XCTAssert(false)
		}
	}

	func testVersion() {
		do {
			let mem = SK4MemoryIO()
			try mem.writeVersion(100)
			XCTAssert(mem.version == 100)

			mem.seek(0)
			let ver = try mem.readVersion()
			XCTAssert(mem.version == 100)
			XCTAssert(ver == 100)

		} catch {
			XCTAssert(false)
		}
	}

	func testMemoryIO() {
		do {
			let tmp = SK4MemoryIO()
			try tmp.writeVersion(101)
			let w0 = CGPoint(x: 20, y: 30)
			try tmp.write(w0)
			let w1 = "abcdefg_"
			try tmp.write(w1)

			let mem = SK4MemoryIO()
			try mem.writeVersion(101)
			try mem.write(tmp)

//			print("\(mem)")
			XCTAssert(mem.description == "count: 37, memory: [0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 0, 25, 0, 0, 0, 101, 65, 160, 0, 0, 65, 240, 0, 0, 0, 0, 0, 9, 97, 98, 99, 100, 101, 102, 103, 95, 0]")

		} catch {
			XCTAssert(false)
		}
	}

}

// eof
