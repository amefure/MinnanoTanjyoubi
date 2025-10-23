//
//  EntryNotifyListViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import RealmSwift
import SwiftUI

final class EntryNotifyListViewModel: ObservableObject {
    @Published var notifyList: [NotificationRequestWrapper] = []
    @Published var isShowConfirmAllDeleteAlert: Bool = false
    @Published var isShowConfirmDeleteAlert: Bool = false
    @Published var isShowSuccessDeleteAlert: Bool = false
    @Published var isShowFailedDeleteAlert: Bool = false

    @Published var isFetching: Bool = false
    private var targetNotify: NotificationRequestWrapper?

    private let df = DateFormatUtility()

    private let notificationRequestManager: NotificationRequestManager
    private let repository: RealmRepository

    init(
        repository: RealmRepository,
        notificationRequestManager: NotificationRequestManager
    ) {
        self.repository = repository
        self.notificationRequestManager = notificationRequestManager
    }

    @MainActor
    func onAppear() {
        fecthNotifyList()
    }

    @MainActor
    private func fecthNotifyList() {
        Task {
            isFetching = true
            notifyList = await notificationRequestManager.confirmNotificationRequest()
                .sorted {
                    let preMonth: Int = $0.date.month ?? 0
                    let lateMonth: Int = $1.date.month ?? 0
                    if preMonth == lateMonth {
                        return ($0.date.day ?? 0) < ($1.date.day ?? 0)
                    } else {
                        return preMonth < lateMonth
                    }
                }
            isFetching = false
        }
    }

    func convertDateTime(_ dateComponents: DateComponents) -> String {
        let month: Int = dateComponents.month ?? 1
        let day: Int = dateComponents.day ?? 1
        let hour: Int = dateComponents.hour ?? 1
        let minuteInt: Int = dateComponents.minute ?? 1
        let minute: String = minuteInt < 10 ? "0\(minuteInt)" : "\(minuteInt)"
        // yyyy-MM-dd-H-m
        return "毎年：\(month)月\(day)日 \(hour):\(minute)"
    }

    func setTargetNotify(_ notify: NotificationRequestWrapper?) {
        targetNotify = notify
        if targetNotify != nil {
            isShowConfirmDeleteAlert = true
        }
    }

    @MainActor
    func deleteTargetNotify() {
        guard let targetNotify else {
            isShowFailedDeleteAlert = true
            return
        }
        guard let objectId = try? ObjectId(string: targetNotify.id) else {
            isShowFailedDeleteAlert = true
            return
        }
        repository.updateNotifyUser(id: objectId, notify: false)
        notificationRequestManager.removeNotificationRequest(objectId)
        isShowSuccessDeleteAlert = true
        fecthNotifyList()
    }

    @MainActor
    func deleteAllNotify() {
        for notify in notifyList {
            guard let objectId = try? ObjectId(string: notify.id) else { continue }
            repository.updateNotifyUser(id: objectId, notify: false)
            notificationRequestManager.removeNotificationRequest(objectId)
        }
        isShowSuccessDeleteAlert = true
        fecthNotifyList()
    }
}
