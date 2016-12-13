//
//  SK4UIControlExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/15.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UIControl {

	/// 全てのターゲットを削除
	public func removeAllTarget() {
		removeTarget(nil, action: nil, for: .allEvents)
	}

}


// eof
