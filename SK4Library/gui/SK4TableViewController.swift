//
//  SK4TableViewController.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// シンプルなTable表示用ViewControllerクラス
/// ※基本的にコードからViewControllerを生成するときに使用する
open class SK4TableViewController: UIViewController {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// UITableView
	public var tableView: UITableView!

	/// UITableView管理クラス
	public var tableModel: SK4TableViewModel!

	/// 初期化
	open func setup(tableModel: SK4TableViewModel) {
		self.tableView = tableModel.tableView
		self.tableModel = tableModel
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// テーブルビューの背景色
	public static let backColor = UIColor(white: 0.75, alpha: 1.0)

	/// 標準のTableViewを作成
	public func makeTableView(style: UITableViewStyle) -> UITableView {
		let tv = UITableView(frame: view.bounds, style: style)
		tv.rowHeight = UITableViewAutomaticDimension
		tv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		view.addSubview(tv)
		return tv
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIViewController

	override open func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトの設定
		view.backgroundColor = SK4TableViewController.backColor
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".ls)
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		tableModel?.viewWillAppear()
	}

	override open func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		tableModel?.viewWillDisappear()
	}

}

// eof
