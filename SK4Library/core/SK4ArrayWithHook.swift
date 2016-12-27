//
//  SK4ArrayWithHook.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 登録・削除のタイミングで処理を行うことが出来る配列
public struct SK4ArrayWithHook<ItemType: Equatable>: Collection, RandomAccessCollection, CustomStringConvertible {

	/// アイテムを登録したときのHook
	public var onRegisterHook: ((ItemType, Int) -> Void)?

	/// アイテムを削除したときのHook
	public var onRemoveHook: ((ItemType, Int) -> Void)?

	/// 初期化
	public init() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 登録・削除（単独）

	public mutating func append(_ item: ItemType) {
		let at = itemArray.count
		insert(item, at: at)
	}

	public mutating func insert(_ item: ItemType, at: Int) {
		itemArray.insert(item, at: at)
		onRegisterHook?(item, at)
	}

	public mutating func insert(_ item: ItemType, before: ItemType) {
		if let at = index(of: before) {
			insert(item, at: at)
		}
	}

	public mutating func insert(_ item: ItemType, after: ItemType) {
		if let at = index(of: after) {
			insert(item, at: at + 1)
		}
	}

	public mutating func remove(_ item: ItemType) {
		if let at = index(of: item) {
			itemArray.remove(at: at)
			onRemoveHook?(item, at)
		}
	}

	public mutating func remove(at: Int) {
		let item = itemArray[at]
		itemArray.remove(at: at)
		onRemoveHook?(item, at)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 登録・削除（複数）

	public mutating func append(_ items: [ItemType]) {
		let at = itemArray.count
		insert(items, at: at)
	}

	public mutating func insert(_ items: [ItemType], at: Int) {
		for (i, item) in items.enumerated() {
			insert(item, at: at + i)
		}
	}

	public mutating func insert(_ items: [ItemType], before: ItemType) {
		if let at = index(of: before) {
			for item in items.reversed() {
				insert(item, at: at)
			}
		}
	}

	public mutating func insert(_ items: [ItemType], after: ItemType) {
		if let at = index(of: after) {
			insert(items, at: at + 1)
		}
	}

	public mutating func remove(_ items: [ItemType]) {
		for item in items {
			remove(item)
		}
	}
	
	public mutating func removeAll() {
		for (at, item) in itemArray.enumerated().reversed() {
			itemArray.remove(at: at)
			onRemoveHook?(item, at)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for Collection & RandomAccessCollection

	var itemArray: [ItemType] = []

	public typealias Indices = Array<ItemType>.Indices

	public var startIndex: Int {
		return itemArray.startIndex
	}

	public var endIndex: Int {
		return itemArray.endIndex
	}

	public func index(before i: Int) -> Int {
		return itemArray.index(before: i)
	}

	public func index(after i: Int) -> Int {
		return itemArray.index(after: i)
	}

	public func index(of item: ItemType) -> Int? {
		return itemArray.index(of: item)
	}

	public subscript(position: Int) -> ItemType {
		return itemArray[position]
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - for CustomStringConvertible

	public var description: String {
		return String(describing: itemArray)
	}

}

// eof
