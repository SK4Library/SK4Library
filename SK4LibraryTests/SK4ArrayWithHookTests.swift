//
//  SK4ArrayWithHookTests.swift
//  SK4LibraryTests
//
//  Created by See.Ku on 2016/12/29.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Library

class SK4ArrayWithHookTests: XCTestCase {

	func testSingle() {
		var ar = SK4ArrayWithHook<String>()

		var add_item = ""
		var add_no = 0
		ar.onRegisterHook = { (item, no) in
			add_item = item
			add_no = no
		}

		var del_item = ""
		var del_no = 0
		ar.onRemoveHook = { (item, no) in
			del_item = item
			del_no = no
		}

		XCTAssert(ar.count == 0)

		ar.append("1st")
		XCTAssert(ar.count == 1)
		XCTAssert(ar[0] == "1st")
		XCTAssert(add_item == "1st")
		XCTAssert(add_no == 0)

		ar.insert("2nd", at: 1)
		XCTAssert(ar.count == 2)
		XCTAssert(ar[1] == "2nd")
		XCTAssert(add_item == "2nd")
		XCTAssert(add_no == 1)

		ar.insert("3rd", before: "2nd")
		XCTAssert(ar.count == 3)
		XCTAssert(ar[1] == "3rd")
		XCTAssert(add_item == "3rd")
		XCTAssert(add_no == 1)

		ar.insert("4th", after: "2nd")
		XCTAssert(ar.count == 4)
		XCTAssert(ar[3] == "4th")
		XCTAssert(add_item == "4th")
		XCTAssert(add_no == 3)

		ar.remove("2nd")
		XCTAssert(ar.count == 3)
		XCTAssert(ar[2] == "4th")
		XCTAssert(del_item == "2nd")
		XCTAssert(del_no == 2)

		ar.removeAll()
		XCTAssert(ar.count == 0)
		XCTAssert(del_item == "1st")
		XCTAssert(del_no == 0)
	}

	func testArray() {
		var ar = SK4ArrayWithHook<Int>()

		ar.append([1,2,3,4])
		XCTAssert(ar.count == 4)
		XCTAssert(ar[0] == 1)

		ar.append([5,6,7,8])
		XCTAssert(ar.count == 8)
		XCTAssert(ar[4] == 5)

		ar.insert([10,11], at: 2)		// ar: [1, 2, 10, 11, 3, 4, 5, 6, 7, 8]
		XCTAssert(ar.count == 10)
		XCTAssert(ar[2] == 10)
		XCTAssert(ar[4] == 3)

		ar.insert([20,21], before: 5)	// ar: [1, 2, 10, 11, 3, 4, 20, 21, 5, 6, 7, 8]
		XCTAssert(ar.count == 12)
		XCTAssert(ar[6] == 20)
		XCTAssert(ar[5] == 4)

		ar.insert([30,31], after: 7)	// ar: [1, 2, 10, 11, 3, 4, 20, 21, 5, 6, 7, 30, 31, 8]
		XCTAssert(ar.count == 14)
		XCTAssert(ar[11] == 30)
		XCTAssert(ar[10] == 7)

		ar.remove([1,3,5,7,11])			// ar: [2, 10, 4, 20, 21, 6, 30, 31, 8]
		XCTAssert(ar.count == 9)
		XCTAssert(ar[1] == 10)
		XCTAssert(ar[4] == 21)
	}

}

// eof
