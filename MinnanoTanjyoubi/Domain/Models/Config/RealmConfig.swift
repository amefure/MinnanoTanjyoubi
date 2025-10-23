//
//  RealmConfig.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import UIKit

class RealmConfig {
    // Relam マイグレーション番号
    static let MIGRATION_VERSION: UInt64 = 2

    /* マイグレーション履歴
     1：imagePathsプロパティの追加 2024/2/22
     2：isYearsUnknownプロパティの追加 2025/4/14
     3：------
     4：------
     5：------
     */

    static let APP_GROUP_ID = "group.com.ame.MinnanoTanjyoubi"
    static let REALM_FILENAME = "db.realm"
}
