//
//  SK4ArrayExtTests.swift
//  SK4LibraryTests
//
//  Created by See.Ku on 2016/12/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Library

class SK4ArrayExtTests: XCTestCase {

	func testBasic() {
		let zero = [Int]()
		let a1 = zero.insertRepeat(between: 100)
		XCTAssert(a1.count == 0)

		let a2 = zero.insertRepeat(sandwich: 100)
		XCTAssert(a2.count == 0)

		let base = [
			"red",
			"green",
			"blue",
		]

		let a3 = base.insertRepeat(between: "---")	// ["red", "---", "green", "---", "blue"]
		XCTAssert(a3.count == 5)
		XCTAssert(a3[1] == "---")

		let a4 = base.insertRepeat(sandwich: "___")	// ["___", "red", "___", "green", "___", "blue", "___"]
		XCTAssert(a4.count == 7)
		XCTAssert(a4[2] == "___")
	}

}

// eof
