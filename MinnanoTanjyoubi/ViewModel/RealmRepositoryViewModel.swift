//
//  RealmRepositoryViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import Combine
import RealmSwift
import UIKit

// TODO: この設計を変更したい
class RealmRepositoryViewModel: ObservableObject {
    @MainActor
    static let shared = RealmRepositoryViewModel()

    @Published var users: [User] = []

    private let imageFileManager = ImageFileManager()

    private let repository: RealmRepository

    private var cancellables: Set<AnyCancellable> = []

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
        readAllUsers()

        // 更新用Notificationを観測
        NotificationCenter.default.publisher(for: .readAllUsers)
            .sink { [weak self] notification in
                guard let self else { return }
                guard let obj = notification.object as? Bool else { return }
                // trueなら更新
                guard obj else { return }
                readAllUsers()
                NotificationCenter.default.post(name: .readAllUsers, object: false)
            }.store(in: &cancellables)
    }

    func readAllUsers(sort: AppSortItem? = nil) {
        var sort: AppSortItem? = sort
        users.removeAll()
        let result = repository.readAllUsers()
        if sort == nil {
            sort = getSortItem()
        }
        
        let dfmMonthOnly = DateFormatUtility(format: .monthOnly)
        
        switch sort {
        case .daysLater:
            // 誕生日までの日付が近い順にソート
            users = Array(result).sorted(by: {
                UserCalcUtility.daysLater(from: $0.date) < UserCalcUtility.daysLater(from: $1.date)
            })
        case .nameAsce:
            // 名前(昇順)
            users = Array(result).sorted(by: { $0.ruby < $1.ruby })
        case .nameDesc:
            // 名前(降順)
            users = Array(result).sorted(by: { $0.ruby > $1.ruby })
        case .ageAsce:
            // 年齢(昇順)
            users = Array(result).sorted(by: {
                if $0.isYearsUnknown != $1.isYearsUnknown {
                    return !$0.isYearsUnknown && $1.isYearsUnknown
                }
                return UserCalcUtility.currentAge(from: $0.date) < UserCalcUtility.currentAge(from: $1.date)
            })
        case .ageeDesc:
            // 年齢(降順)
            users = Array(result).sorted(by: {
                if $0.isYearsUnknown != $1.isYearsUnknown {
                    return !$0.isYearsUnknown && $1.isYearsUnknown
                }
                return UserCalcUtility.currentAge(from: $0.date) > UserCalcUtility.currentAge(from: $1.date)
            })
        case .montheAsce:
            // 生まれ月(昇順)
            users = Array(result).sorted(by: {
                let pre = dfmMonthOnly.getMonthInt(date: $0.date)
                let late = dfmMonthOnly.getMonthInt(date: $1.date)
                return pre < late
            })
        case .montheDesc:
            // 生まれ月(降順)
            users = Array(result).sorted(by: {
                let pre = dfmMonthOnly.getMonthInt(date: $0.date)
                let late = dfmMonthOnly.getMonthInt(date: $1.date)
                return pre > late
            })
        case .none:
            // 誕生日までの日付が近い順にソート
            users = Array(result).sorted(by: {
                UserCalcUtility.daysLater(from: $0.date) < UserCalcUtility.daysLater(from: $1.date)
            })
        }

        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
    }

    func createUser(newUser: User) {
        repository.createUser(user: newUser)
        readAllUsers()
    }

    func shareCreateUsers(shareUsers: [User], unlockStorage: Bool) -> ShareCreateError? {
        // 容量チェック && 容量解放されていないか
        guard !isOverCapacity(shareUsers.count) || unlockStorage else { return ShareCreateError.overCapacity }
        for user in shareUsers {
            // エラーが発生したら登録シーケンスを終了
            guard !(users.contains { $0.name == user.name }) else { return ShareCreateError.existUser }
            let copy = copyUser(user)
            repository.createUser(user: copy)
        }
        return nil
    }

    func isOverCapacity(_ size: Int) -> Bool {
        let size = users.count + size
        return size > getMaxCapacity()
    }

    // 最大容量取得
    private func getMaxCapacity() -> Int {
        AppManager.sharedUserDefaultManager.getCapacity()
    }

    private func copyUser(_ user: User) -> User {
        let copy = User()
        copy.name = user.name
        copy.ruby = user.ruby
        copy.date = user.date
        copy.relation = user.relation
        copy.memo = user.memo
        // alertとimagePathはコピーしない
        return copy
    }

    func filteringUser(selectedRelation: Relation) {
        readAllUsers()
        users = users.filter { $0.relation == selectedRelation }
    }

    func updateUser(id: ObjectId, newUser: User) {
        repository.updateUser(id: id, newUser: newUser)
        readAllUsers()
    }

    func updateNotifyUser(id: ObjectId, notify: Bool) {
        repository.updateNotifyUser(id: id, notify: notify)
        readAllUsers()
    }

    func removeUsers(users: [User]) {
        for user in users {
            let userId: ObjectId = user.id
            Task {
                /// 削除対象の通知を全てOFFにする
                await AppManager.sharedNotificationRequestManager.removeNotificationRequest(userId)
            }

            // 画像を削除する
            deleteImage(user: user)
        }

        let removeIds: [ObjectId] = users.map { $0.id }
        repository.removeUser(removeIdArray: removeIds)
        readAllUsers()
    }

    /// 画像削除
    private func deleteImage(user: User) {
        let imagePaths = Array(user.imagePaths)
        for selectPath in imagePaths {
            // ここのエラーは握り潰す
            _ = try? imageFileManager.deleteImage(name: selectPath)
        }
    }
}

// User Defaults
extension RealmRepositoryViewModel {
    /// 並び順
    private func getSortItem() -> AppSortItem {
        AppManager.sharedUserDefaultManager.getSortItem()
    }
}
