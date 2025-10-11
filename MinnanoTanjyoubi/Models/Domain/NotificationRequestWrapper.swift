//
//  NotificationRequestWrapper.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import Foundation
import UIKit

/// 通知設定履歴表示用ラッパークラス
final class NotificationRequestWrapper: Identifiable, Sendable {
    let id: String
    let date: DateComponents
    let title: String
    let message: String
    
    init(id: String, date: DateComponents, title: String, message: String) {
        self.id = id
        self.date = date
        self.title = title
        self.message = message
    }
    
    static func createFromUNNotificationRequest(
        _ request: UNNotificationRequest
    ) -> NotificationRequestWrapper? {
        // UNCalendarNotificationTrigger型で取得
        guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { return nil }
        return NotificationRequestWrapper(
            id: request.identifier,
            date: trigger.dateComponents,
            title: request.content.title,
            message: request.content.body
        )
    }
}
