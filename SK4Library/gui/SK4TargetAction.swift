//
//  SK4TargetAction.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIControlのイベントにClosuresを関連付けるための代理クラス
open class SK4TargetAction: NSObject {

	public typealias ControlBlock = ((UIControl) -> Void)

	/// 実行する処理
	public var exec: ControlBlock?

	/// 初期化　※Closureは[weak self]推奨
	public convenience init(control: UIControl, event: UIControlEvents, exec: ControlBlock? = nil) {
		self.init()

		setup(control: control, event: event, exec: exec)
	}

	/// 設定　※Closureは[weak self]推奨
	open func setup(control: UIControl, event: UIControlEvents, exec: ControlBlock? = nil) {
		self.exec = exec

		control.addTarget(self, action: #selector(SK4TargetAction.onAction(_:)), for: event)
	}

	/// 処理を実行
	open func onAction(_ sender: UIControl) {
		exec?(sender)
	}

}

// eof
