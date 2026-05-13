//
//  MockNotificationDispatcher.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2026/05/13.
//

import Foundation
@testable import MinnanoTanjyoubi

class MockNotificationDispatcher: NotificationDispatcher {
    var postedNames: [Notification.Name] = []

    func post(name: Notification.Name, object _: Any?) {
        postedNames.append(name)
    }
}
