//
//  NotificationRequestManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/03.
//

import RealmSwift
import UIKit

final class NotificationRequestManager: Sendable {
    /// 通知許可申請リクエスト
    static func requestAuthorization() async -> Bool {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        do {
            let result: Bool = try await UNUserNotificationCenter
                .current()
                .requestAuthorization(options: authOptions)
            return result
        } catch {
            return false
        }
    }

    /// 通知が許可されていない場合にアラートで通知許可を促す
    @MainActor
    func showSettingsAlert() {
        let alertController = UIAlertController(
            title: "通知が許可されていません。",
            message: "誕生日のお知らせ通知を受け取ることができないため\n設定アプリから通知を有効にしてください。",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "設定を開く", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(alertController, animated: true, completion: {})
    }

    /// 通知登録処理
    /// - Parameters:
    ///   - id: 通知ID =`UserID`
    ///   - userName: 誕生日の人名
    ///   - date: 誕生日
    ///   - msg: 通知メッセージ
    ///   - timeStr: ユーザーが選択している通知設定時間
    ///   - dateFlag: ユーザーが選択している通知日付(`n日前`)
    func sendNotificationRequest(
        id: ObjectId,
        userName: String,
        date: Date,
        msg: String,
        timeStr: String,
        dateFlag: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = "みんなの誕生日"

        let replaceMsg = msg.replacingOccurrences(of: NotifyConfig.VARIABLE_USER_NAME, with: userName)
        content.body = replaceMsg

        var dateStr = ""

        let dfm = DateFormatUtility(format: .hyphen)
        // 前日フラグなら日付を1日前とする
        if dateFlag == "0" {
            // 0 なら当日
            dateStr = dfm.getString(date: date)
        } else {
            // 0以外なら日数前にする
            let dayNum = Int(dateFlag) ?? 1
            let calendar = Calendar.current
            let modifiedDate: Date = calendar.date(byAdding: .day, value: -dayNum, to: date) ?? Date()
            dateStr = dfm.getString(date: modifiedDate)
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

        // 通知登録
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: id.stringValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    /// 登録済み通知の削除
    func removeNotificationRequest(_ id: ObjectId) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.stringValue])
    }

    /// 通知確認用
    func confirmNotificationRequest() async -> [NotificationRequestWrapper] {
        let center = UNUserNotificationCenter.current()
        return await withCheckedContinuation { continuation in
            center.getPendingNotificationRequests { array in
                let list = array.compactMap { NotificationRequestWrapper.createFromUNNotificationRequest($0) }
                AppLogger.logger.debug("設定済み通知一覧：\(list)")
                continuation.resume(returning: list)
            }
        }
    }
}
