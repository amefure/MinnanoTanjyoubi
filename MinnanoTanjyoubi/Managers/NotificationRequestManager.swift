//
//  NotificationRequestManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/03.
//

import RealmSwift
import UIKit

class NotificationRequestManager {
    /// 通知許可申請リクエスト
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: authOptions) { [weak self] granted, _ in
                guard self != nil else { return }
                completion(granted)
            }
    }

    /// 通知が許可されていない場合にアラートで通知許可を促す
    public func showSettingsAlert() {
        let alertController = UIAlertController(
            title: "通知が許可されていません。",
            message: "誕生日のお知らせ通知を受け取ることができないため\n設定アプリから通知を有効にしてください。",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "設定を開く", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(alertController, animated: true, completion: {})
    }

    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    public func sendNotificationRequest(_ id: ObjectId, _ userName: String, _ date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "みんなの誕生日"

        let msg = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_MSG, initialValue: NotifyConfig.INITIAL_MSG)

        let replaceMsg = msg.replacingOccurrences(of: NotifyConfig.VARIABLE_USER_NAME, with: userName)
        content.body = replaceMsg

        // Setting > TimePickerView.swift
        let timeStr = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_TIME, initialValue: NotifyConfig.INITIAL_TIME)
        // Setting > NotiveDateFlagView.swift
        let dateFlag = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG, initialValue: NotifyConfig.INITIAL_DATE_FLAG)

        var dateStr = ""

        // 前日フラグなら日付を1日前とする
        if dateFlag == "0" {
            // 0 なら当日
            dateStr = DateFormatUtility().getNotifyString(date: date)
        } else {
            let dayNum = Int(dateFlag) ?? 1
            // 0以外なら日数前にする
            let calendar = Calendar.current
            let modifiedDate = calendar.date(byAdding: .day, value: -dayNum, to: date) ?? Date()
            dateStr = DateFormatUtility().getNotifyString(date: modifiedDate)
        }

        // "yyyy-MM-dd"形式で取得した文字列を配列に変換
        let dateArray = dateStr.split(separator: "-")
        // "H-m"形式で取得した文字列を配列に変換
        let timeArray = timeStr.split(separator: "-")

        let month = Int(dateArray[safe: 1] ?? "1") ?? 1
        let day = Int(dateArray[safe: 2] ?? "1") ?? 1
        let hour = Int(timeArray[safe: 0] ?? "6") ?? 6
        let minute = Int(timeArray[safe: 1] ?? "0") ?? 0

        // 毎年通知を送るため年は不要
//        let nowDate = Calendar.current.dateComponents([.year], from: Date())
//        dateComponent.year = nowDate.year

        let dateComponent = DateComponents(
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: id.stringValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    public func removeNotificationRequest(_ id: ObjectId) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.stringValue])
    }

    // MARK: - 確認用

    #if DEBUG
        func confirmNotificationRequest() {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { array in
                print(array)
            }
        }
    #endif
}
