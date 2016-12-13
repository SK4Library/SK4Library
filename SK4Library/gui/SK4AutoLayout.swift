//
//  SK4AutoLayout.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/25.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// AutoLayout関係の処理を行うためのクラス
public class SK4AutoLayout {

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	// UITableViewのおすすめ最大幅
	public static let tableViewMaxWidth = 560

	/// 同じサイズで覆い被さる制約を設定　※最大幅の指定付き
	public static func overlay(target: UIView, parent: UIViewController, maxWidth: Int = SK4AutoLayout.tableViewMaxWidth) {
		if let base = parent.view {
			let maker = SK4AutoLayout(viewController: parent)
			maker.setOverlay(target: target, base: base, maxWidth: maxWidth)
			base.addConstraints(maker.constraints)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// Visual Formatで使用する辞書
	public var dic = [String : Any]()

	/// 作成した制約
	public var constraints = [NSLayoutConstraint]()

	/// 初期化
	public init() {
	}

	/// 初期化
	public convenience init(viewController: UIViewController) {
		self.init()
		addDic(viewController: viewController)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 辞書関係

	/// 辞書にレイアウトを追加
	public func addDic(viewController: UIViewController) {
		dic["topLayoutGuide"] = viewController.topLayoutGuide
		dic["bottomLayoutGuide"] = viewController.bottomLayoutGuide
	}

	/// 辞書にViewを追加
	public func addDic(name: String, view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		dic[name] = view
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 制約関係

	/// Visual Format Languageで制約を追加
	public func addFormat(_ format: String) {
		let con = NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: dic)
		constraints += con
	}

	/// 親Viewと四方の間隔を保つ制約を生成
	public func addKeepMargin(name: String, view: UIView) {
		if let parent = view.superview {
			let r0 = parent.bounds
			let r1 = view.frame
			addDic(name: name, view: view)
			addFormat("H:|-\(r1.minX)-[\(name)]-\(r0.maxX - r1.maxX)-|")
			addFormat("V:|-\(r1.minY)-[\(name)]-\(r0.maxY - r1.maxY)-|")
		}
	}

	/// 水平・中央揃えの制約を追加
	public func addCenterEqualX(target: UIView, base: UIView, gap: CGFloat = 0) {
		let con = NSLayoutConstraint(item: target, attribute: .centerX, relatedBy: .equal, toItem: base, attribute: .centerX, multiplier: 1, constant: gap)
		constraints.append(con)
	}

	/// 垂直・中央揃えの制約を追加
	public func addCenterEqualY(target: UIView, base: UIView, gap: CGFloat = 0) {
		let con = NSLayoutConstraint(item: target, attribute: .centerY, relatedBy: .equal, toItem: base, attribute: .centerY, multiplier: 1, constant: gap)
		constraints.append(con)
	}

	/// 同じサイズで覆い被さる制約を設定　※最大幅の指定付き
	public func setOverlay(target: UIView, base: UIView, maxWidth: Int, edge: Int = 0, name: String = "over") {

		// 指定されたViewに関するAuto Layoutを削除
		removeConstraints(target: target, base: base)

		// 新しくAuto Layoutを設定
		addDic(name: name, view: target)

		addFormat("V:|-[\(name)]-|")
		addFormat("H:|-(\(edge)@750)-[\(name)(<=\(maxWidth))]-(\(edge)@750)-|")
		addCenterEqualX(target: target, base: base)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 特定のViewに関する制約を削除
	public func removeConstraints(target: UIView, base: UIView) {
		let ar = base.constraints.filter { co in (co.firstItem === target || co.secondItem === target) }
		base.removeConstraints(ar)
	}

}

// eof
