//
//  SK4TableViewAdmin.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITableViewのセクションを管理するクラス
open class SK4TableViewAdmin: SK4TableViewModel {

	/// 管理するセクションの配列
	public var sectionArray = SK4ArrayWithHook<SK4TableViewSection>()

	/// 初期化
	override public init() {
		super.init()

		// フックを設定
		sectionArray.onRegisterHook = { [weak self] (section, at) in
			section.onRegister(tableAdmin: self, at: at)
		}

		sectionArray.onRemoveHook = { [weak self] (section, at) in
			section.onRemove(tableAdmin: self, at: at)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション関係の情報・操作

	/// セクションのインデックスを取得
	public func index(ofSection: SK4TableViewSection) -> Int? {
		return sectionArray.index(of: ofSection)
	}

	/// IndexPathを取得
	public func indexPath(row: Int, section: SK4TableViewSection) -> IndexPath? {
		if let sec = index(ofSection: section) {
			return IndexPath(row: row, section: sec)
		} else {
			return nil
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 基本要素

	/// セクションの数を返す
	override open func numberOfSections() -> Int {
		return sectionArray.count
	}

	/// 行の数を返す
	override open func numberOfRows(inSection section: Int) -> Int {
		return sectionArray[section].numberOfRows()
	}

	/// Cellの内容を設定
	override open func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
		return sectionArray[indexPath.section].cellForRow(at: indexPath)
	}

	/// Cellが選択された
	override open func didSelectRow(at indexPath: IndexPath) {
		return sectionArray[indexPath.section].didSelectRow(at: indexPath)
	}

	/// Cellが表示される
	override open func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		sectionArray[indexPath.section].willDisplayCell(cell, at: indexPath)
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - ヘッダー／フッター

	/// ヘッダーの文字列を返す
	override open func titleForHeader(inSection section: Int) -> String? {
		return sectionArray[section].header
	}

	/// フッターの文字列を返す
	override open func titleForFooter(inSection section: Int) -> String? {
		return sectionArray[section].footer
	}

}

// eof
