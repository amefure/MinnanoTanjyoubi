//
//  WidgetCenterManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/20.
//

import WidgetKit

protocol WidgetCenterProtocol {
    func reloadAllTimelines()
    func reloadTimelines(ofKind kind: String)
}

final class WidgetCenterManager: WidgetCenterProtocol {
    private let center: WidgetCenter

    init(center: WidgetCenter = .shared) {
        self.center = center
    }

    func reloadAllTimelines() {
        center.reloadAllTimelines()
    }

    func reloadTimelines(ofKind kind: String) {
        center.reloadTimelines(ofKind: kind)
    }
}
