//
//  SK4TableViewSection.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITableViewのセクションを表すクラス
open class SK4TableViewSection: Equatable {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// セクションの管理人
	public weak var tableAdmin: SK4TableViewAdmin!

	/// 表示に使用するTableView
	public weak var tableView: UITableView! {
		return tableAdmin?.tableView
	}

	/// 親ViewController
	public weak var parent: UIViewController! {
		return tableAdmin?.parent
	}

	/// 標準で使うCellのID
	public var cellId = "Cell"

	/// セクションのヘッダー
	public var header: String?

	/// セクションのフッター
	public var footer: String?

	/// 初期化
	public init() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション関係の情報・操作

	/// セクションが登録された
	open func onRegister(tableAdmin: SK4TableViewAdmin?, at: Int) {
		self.tableAdmin = tableAdmin

		let ins = IndexSet(integer: at)
		tableView?.insertSections(ins, with: .automatic)
	}

	/// セクションが削除された
	open func onRemove(tableAdmin: SK4TableViewAdmin?, at: Int) {
		let ins = IndexSet(integer: at)
		tableView?.deleteSections(ins, with: .automatic)

		self.tableAdmin = nil
	}

	// /////////////////////////////////////////////////////////////

	/// セクションに対応するインデックス
	public var index: Int? {
		return tableAdmin?.index(ofSection: self)
	}

	/// IndexPathを取得
	public func indexPath(row: Int) -> IndexPath? {
		if let sec = index {
			return IndexPath(row: row, section: sec)
		} else {
			return nil
		}
	}

	// /////////////////////////////////////////////////////////////

	/// 行を挿入
	open func insertRow(_ row: Int, with: UITableViewRowAnimation = .automatic) {
		if let ip = indexPath(row: row) {
			tableView?.insertRows(at: [ip], with: with)
		}
	}

	/// 行を削除
	open func removeRow(_ row: Int, with: UITableViewRowAnimation = .automatic) {
		if let ip = indexPath(row: row) {
			tableView?.deleteRows(at: [ip], with: with)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 再利用可能なCellの取得／生成

	/// 再利用可能なCellを取得
	open func dequeueCell(at indexPath: IndexPath) -> UITableViewCell {
		return tableView!.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 基本要素

	/// 行の数を返す
	open func numberOfRows() -> Int {
		assertionFailure("You need override me!")
		return 0
	}

	/// Cellの内容をセット
	open func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
		return dequeueCell(at: indexPath)
	}

	/// Cellが選択された
	open func didSelectRow(at indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: true)
	}

	/// Cellが表示される
	open func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for Equatable

	public static func ==(lhs: SK4TableViewSection, rhs: SK4TableViewSection) -> Bool {
		return lhs === rhs
	}
	
}
