//
//  DetailViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import SwiftUI
import UIKit

@MainActor
class DetailViewModel: ObservableObject {
    /// 更新画面モーダル
    @Published var isShowUpdateModalView: Bool = false
    // 画像ピッカー表示
    @Published var isShowImagePicker: Bool = false
    /// メモ表示ポップアップ
    @Published var isShowPopUpMemo: Bool = false
    /// 年齢月数表示フラグ
    @Published private(set) var isDisplayAgeMonth: Bool = false
    /// 保存成功ダイアログ
    @Published var isSaveSuccessAlert: Bool = false
    /// 削除確認ダイアログ
    @Published var isDeleteConfirmAlert: Bool = false
    /// 削除成功ダイアログ
    @Published var isDeleteSuccessAlert: Bool = false
    /// 画像表示ダイアログ
    @Published var isImageShowAlert: Bool = false
    /// 画像エラーダイアログ
    @Published var isImageErrorAlert: Bool = false

    /// 画像表示コンテナビューをリフレッシュ
    @Published private(set) var isUpdateImageContainerView: Int = 0
    /// 画像エラー
    @Published private(set) var imageError: ImageError?

    /// 通知トグルフラグ
    @Published var isNotifyFlag: Bool = false

    /// 削除対象のパス
    var selectPath: String = ""
    /// 表示対象のUIImage
    var selectImage: Image?
    
    let deviceWidth = DeviceSizeUtility.deviceWidth
    let isSESize = DeviceSizeUtility.isSESize
    
    var roundWidth: CGFloat {
        if deviceWidth < 400 {
            return 50
        } else {
            return 65
        }
    }

    private let imageFileManager = ImageFileManager()
    private let repository: RealmRepository

    private var cancellables: Set<AnyCancellable> = []

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
    }

    func onAppear(user: User) {
        isDisplayAgeMonth = getDisplayAgeMonth()
        // 通知初期値セット
        isNotifyFlag = user.alert
        $isNotifyFlag.sink { [weak self] newValue in
            guard let self else { return }
            self.switchNotifyFlag(flag: newValue, user: user)
        }.store(in: &cancellables)
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: UserDefaults
extension DetailViewModel {
    private func getDisplayAgeMonth() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayAgeMonth()
    }
}

// MARK: UserDefaults
extension DetailViewModel {
    /// ImageContainerViewの描画更新フラグ
    func updateImageContainerView() {
        isUpdateImageContainerView += 1
    }

    /// エラーハンドラー
    func showImageErrorHandle(error: ImageError) {
        imageError = error
        isImageErrorAlert = true
    }

    /// 画像プレビューポップアップ表示
    func showPreViewImagePopup(image: Image) {
        selectImage = image
        isImageShowAlert = true
    }

    /// 画像削除確認ダイアログ表示
    func showDeleteConfirmAlert(user: User, index: Int) {
        selectPath = user.imagePaths[safe: index] ?? ""
        isDeleteConfirmAlert = true
    }

    /// 画像がちゃんと保存されているパスをチェック & 取得
    func loadImagePath(name: String) -> String? {
        imageFileManager.loadImagePath(name: name)
    }

    /// 画像保存
    func saveImage(user: User, image: UIImage?) {
        guard let image = image else { return }
        let imgName = UUID().uuidString
        do {
            _ = try imageFileManager.saveImage(name: imgName, image: image)
            var imagePaths = Array(user.imagePaths)
            imagePaths.append(imgName)
            repository.updateImagePathsUser(id: user.id, imagePathsArray: imagePaths)
            // 再取得
            NotificationCenter.default.post(name: .readAllUsers, object: true)
            isSaveSuccessAlert = true
        } catch {
            guard error is ImageError else { return }
            showImageErrorHandle(error: error as! ImageError)
        }
    }

    /// 画像削除
    func deleteImage(user: User) {
        var imagePaths = Array(user.imagePaths)
        imagePaths.removeAll(where: { $0 == selectPath })
        // ここのエラーは握り潰す
        _ = try? imageFileManager.deleteImage(name: selectPath)
        repository.updateImagePathsUser(id: user.id, imagePathsArray: imagePaths)
        // 再取得
        NotificationCenter.default.post(name: .readAllUsers, object: true)
        isDeleteSuccessAlert = true
    }

    /// 通知フラグ切り替え & 通知登録 / 削除 / 許可リクエスト
    private func switchNotifyFlag(flag: Bool, user: User) {
        Task {
            // 通知リクエスト申請
            let granted = await AppManager.sharedNotificationRequestManager.requestAuthorization()
            if !granted {
                // 通知許可アラート
                AppManager.sharedNotificationRequestManager.showSettingsAlert()

                isNotifyFlag = false
                // データベース更新
                repository.updateNotifyUser(id: user.id, notify: false)
                // 再取得
                NotificationCenter.default.post(name: .readAllUsers, object: true)
            } else {
                if flag {
                    // 通知を登録
                    AppManager.sharedNotificationRequestManager.sendNotificationRequest(user.id, user.name, user.date)

                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: true)
                    // 再取得
                    NotificationCenter.default.post(name: .readAllUsers, object: true)
                } else {
                    // 通知を削除
                    AppManager.sharedNotificationRequestManager.removeNotificationRequest(user.id)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: false)
                    // 再取得
                    NotificationCenter.default.post(name: .readAllUsers, object: true)
                }
            }
        }
    }
}
