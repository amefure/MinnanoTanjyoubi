//
//  NotificationRequestManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/03.
//

import RealmSwift
import UIKit

class NotificationRequestManager: NSObject {
    public func sendNotificationRequest(_ id: ObjectId, _ userName: String, _ dateStr: String) {
        let userDefaults = UserDefaults.standard

        let content = UNMutableNotificationContent()
        content.title = "みんなの誕生日"
        let msg = userDefaults.object(forKey: "NoticeMsg") as? String ?? "今日は{userName}さんの誕生日！" as String
        let replaceMsg = msg.replacingOccurrences(of: "{userName}", with: userName)
        content.body = replaceMsg

        // Setting > TimePickerView.swift
        let timeStr = userDefaults.object(forKey: "NoticeTime") as? String ?? "6-0" as String
        // Setting > NotiveDateFlagView.swift
        let dateFlag = userDefaults.object(forKey: "NoticeDate") as? String ?? "0" as String

        // "yyyy-MM-dd-H-m"形式で取得した文字列を配列に変換
        let dateArray = dateStr.split(separator: "-")
        let timeArray = timeStr.split(separator: "-")

        // 当日/前日フラグの値を適応
        let calcDate = Int(dateArray[2])! - Int(dateFlag)!

        // 毎年通知を送るため年は不要
//        let nowDate = Calendar.current.dateComponents([.year], from: Date())
//        dateComponent.year = nowDate.year

        let dateComponent = DateComponents(
            month: Int(dateArray[1]),
            day: calcDate,
            hour: Int(timeArray[0]),
            minute: Int(timeArray[1])
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: id.stringValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    public func removeNotificationRequest(_ id: ObjectId, _: String) {
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
