//
//  SK4PickerViewAdmin.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4PickerViewUnit

/// それぞれの列を管理するための内部クラス
public class SK4PickerViewUnit {

	// /////////////////////////////////////////////////////////////
	// MARK: - アイテムの管理・生成

	/// true: 無限スクロール
	public let infinite: Bool

	/// 列の幅　※0の場合は余ってるスペースを等分して使用
	public var width: CGFloat = 0

	/// アイテムの配列
	public var itemArray = [String]()

	/// アイテムを生成するジェネレーター
	public var itemGenerator: ((Int) -> String)?

	/// アイテムを生成するときの最大値
	public var generatorMax: Int = 0

	/// アイテムの数
	public var itemCount: Int {
		if itemGenerator != nil {
			return generatorMax
		} else {
			return itemArray.count
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 選択

	/// 選択されてるインデックス
	public var selectIndex = 0

	/// 選択されてる文字列
	public var selectString: String? {
		get {
			return item(at: selectIndex)
		}

		set {
			if let str = newValue {
				selectIndex = index(for: str)
			} else {
				selectIndex = -1
			}
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 初期化
	public init(width: CGFloat, select: Int, items: [String], infinite: Bool) {
		self.width = width
		self.selectIndex = select
		self.itemArray = items
		self.infinite = infinite
	}

	/// インデックスからアイテムを取得
	public func item(at index: Int) -> String? {
		if let gen = itemGenerator {
			if 0 <= index && index < generatorMax {
				return gen(index)
			}
		} else {
			if 0 <= index && index < itemArray.count {
				return itemArray[index]
			}
		}
		return nil
	}

	/// アイテムからインデックスを取得
	public func index(for item: String) -> Int {
		if let gen = itemGenerator {
			for i in 0..<generatorMax {
				if gen(i) == item {
					return i
				}
			}
		} else {
			if let no = itemArray.index(of: item) {
				return no
			}
		}
		return -1
	}

}


// /////////////////////////////////////////////////////////////
// MARK: - SK4PickerViewAdmin

/// UIPickerViewの管理クラス
public class SK4PickerViewAdmin: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

	struct Const {

		/// 無限スクロールで使用するnumberOfRows
		static let infiniteOfRows = 20000
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 管理対象のPickerView
	public weak var pickerView: UIPickerView!

	/// 親ViewController
	public weak var parent: UIViewController!

	/// Pickerで使用する各列の情報
	public var unitArray = [SK4PickerViewUnit]()

	/// インデックスでまとめて設定／取得
	public var selectIndex: [Int] {
		get {
			pickerToSelect()
			return unitArray.map { $0.selectIndex }
		}

		set {
			for (i, unit) in unitArray.enumerated() {
				let index = (i < newValue.count) ? newValue[i] : -1
				unit.selectIndex = index
			}
			selectToPicker()
		}
	}

	/// 文字列でまとめて設定／取得
	public var selectString: [String] {
		get {
			pickerToSelect()
			return unitArray.map { $0.selectString ?? "" }
		}

		set {
			for (i, unit) in unitArray.enumerated() {
				let str = (i < newValue.count) ? newValue[i] : nil
				unit.selectString = str
			}
			selectToPicker()
		}
	}

	/// アイテムが選択された時の処理
	public var didSelect: (() -> Void)?

	/// 初期化
	override public init() {
		super.init()
	}

	/// 初期化
	public convenience init(pickerView: UIPickerView, parent: UIViewController) {
		self.init()

		setup(pickerView: pickerView, parent: parent)
	}

	/// 初期化
	public func setup(pickerView: UIPickerView, parent: UIViewController) {
		self.pickerView = pickerView

		pickerView.delegate = self
		pickerView.dataSource = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 列の追加

	/// 列の情報を追加
	@discardableResult
	public func addUnit(items: [String], width: CGFloat = 0, select: Int = 0, infinite: Bool = false) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: items, infinite: infinite)
		unitArray.append(unit)
		return unit
	}

	/// 列の情報を追加　※アイテムが１つだけの列
	@discardableResult
	public func addUnit(item: String, width: CGFloat) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: 0, items: [item], infinite: false)
		unitArray.append(unit)
		return unit
	}

	/// 列の情報を追加　※ジェネレーターに対応
	@discardableResult
	public func addUnit(max: Int, width: CGFloat = 0, select: Int = 0, infinite: Bool = false, gen: @escaping ((Int) -> String)) -> SK4PickerViewUnit {
		let unit = SK4PickerViewUnit(width: width, select: select, items: [], infinite: infinite)
		unit.itemGenerator = gen
		unit.generatorMax = max
		unitArray.append(unit)
		return unit
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// 選択項目をPickerに反映
	public func selectToPicker() {
		for (i, unit) in unitArray.enumerated() {
			var sel = unit.selectIndex
			if unit.infinite {
				let max = unit.itemCount
				let tmp = (Const.infiniteOfRows / 2) / max
				sel += max * tmp
			}
			pickerView.selectRow(sel, inComponent: i, animated: false)
		}
	}

	/// Pickerの選択項目を取得
	public func pickerToSelect() {
		for (i, unit) in unitArray.enumerated() {
			unit.selectIndex = pickerView.selectedRow(inComponent: i) % unit.itemCount
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIPickerViewDataSource

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return unitArray.count
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let unit = unitArray[component]
		if unit.infinite {
			return Const.infiniteOfRows
		} else {
			return unit.itemCount
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIPickerViewDelegate

	public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		var wi = unitArray[component].width
		if wi == 0.0 {

			// 幅が指定されてない時は、残りのスペースを等分して使用
			for unit in unitArray {
				wi += unit.width
			}
			return (pickerView.bounds.width - wi) / CGFloat(unitArray.count)

		} else {

			// 幅が指定されてる時は、その値を使用
			return wi
		}
	}

	public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

		// 0.5倍まで縮小可能なUILabelを使用
		let label: UILabel
		if let tmp = view as? UILabel {
			label = tmp
		} else {
			label = UILabel()
			label.textAlignment = .center
			label.backgroundColor = UIColor.clear

			label.font = UIFont.systemFont(ofSize: 22)
			label.adjustsFontSizeToFitWidth = true
			label.minimumScaleFactor = 0.5
		}

		// テキストをセット
		let unit = unitArray[component]
		let max = unit.itemCount
		label.text = unit.item(at: row % max)

		return label
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		pickerToSelect()
		selectToPicker()
		
		didSelect?()
	}

}

// eof
