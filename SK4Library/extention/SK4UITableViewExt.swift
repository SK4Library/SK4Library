//
//  SK4UITableViewExtention.swift
//  SK4Library
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UITableView {

	/// 不要なセパレーターを消す
	public func clearSeparator() {
		let vi = UIView(frame: CGRect.zero)
		vi.backgroundColor = .clear
		tableFooterView = vi
	}

	/// 指定されたCellへ非同期でスクロール　※reloadDataの直後等で使用
	public func scrollToRowAsync(at indexPath: IndexPath, at position: UITableViewScrollPosition = .middle) {
		DispatchQueue.main.async {
			self.scrollToRow(at: indexPath, at: position, animated: false)
		}
	}


/*

	/// delaysContentTouchesをまとめて設定する
	public func sk4DelaysContentTouches(delay: Bool) {
		delaysContentTouches = delay
		for vi in subviews {
			if let vi = vi as? UIScrollView {
				vi.delaysContentTouches = delay
			}
		}
	}

	/// 先頭のCellへスクロール
	public func sk4ScrollToTop() {
		if numberOfRowsInSection(0) > 0 {
			let index = NSIndexPath(forRow: 0, inSection: 0)
			scrollToRowAtIndexPath(index, atScrollPosition: .Top, animated: false)
		}
	}

	/// 最後のCellへスクロール
	public func sk4ScrollToBottom() {
		let sec = numberOfSections
		if sec > 0 {
			let row = numberOfRowsInSection(sec - 1)
			if row > 0 {
				let index = NSIndexPath(forRow: row - 1, inSection: sec - 1)
				scrollToRowAtIndexPath(index, atScrollPosition: .Bottom, animated: false)
			}
		}
	}

*/

}

// eof
