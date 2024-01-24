//
//  ExUIApplication.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import UIKit

extension UIApplication {
    // フォーカスの制御をリセット
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
