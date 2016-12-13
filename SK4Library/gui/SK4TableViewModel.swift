//
//  SK4TableViewModel.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITableViewを簡単に使うためのモデルクラス
open class SK4TableViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 管理対象のTableView
	public weak var tableView: UITableView!

	/// 親ViewController
	public weak var parent: UIViewController!

	/// 標準で使うCellのID
	public var cellId = "Cell"

	/// 初期化
	public convenience init(tableView: UITableView, parent: UIViewController) {
		self.init()

		setup(tableView: tableView, parent: parent)
	}

	/// 初期化
	open func setup(tableView: UITableView, parent: UIViewController) {
		self.tableView = tableView
		self.parent = parent

		tableView.delegate = self
		tableView.dataSource = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ViewControllerの表示／非表示

	/// ViewControllerが表示される
	open func viewWillAppear() {
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	/// ViewControllerが非表示になる
	open func viewWillDisappear() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 再利用可能なCellの取得／生成

	/// 再利用可能なCellを取得
	open func dequeueCell(at indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
	}

	/// 再利用可能なCellを取得。取得できなかった場合は生成
	open func dequeueOrMakeCell(style: UITableViewCellStyle = .default) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) {
			return cell
		} else {
			return UITableViewCell(style: style, reuseIdentifier: cellId)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 基本設定

	/// セクションの数を返す
	open func numberOfSections() -> Int {
		return 1
	}

	/// 行の数を返す
	open func numberOfRows(inSection section: Int) -> Int {
		assertionFailure("You need override me!")
		return 0
	}
	
	/// Cellの内容を設定
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
	// MARK: - ヘッダー／フッター

	/// ヘッダーの文字列を返す
	open func titleForHeader(inSection section: Int) -> String? {
		return nil
	}

	/// フッターの文字列を返す
	open func titleForFooter(inSection section: Int) -> String? {
		return nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UITableViewDataSource

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfRows(inSection: section)
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cellForRow(at: indexPath)
	}

	open func numberOfSections(in tableView: UITableView) -> Int {
		return numberOfSections()
	}

	open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titleForHeader(inSection: section)
	}

	open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return titleForFooter(inSection: section)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UITableViewDelegate

	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectRow(at: indexPath)
	}

	open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return tableView.rowHeight
	}

	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return tableView.rowHeight
	}

	open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		willDisplayCell(cell, at: indexPath)
	}
	
}

// eof
