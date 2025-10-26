//
//  DetailUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import RealmSwift
import SwiftUI
import UIKit

struct DetailUserState {
    /// 詳細画面で表示するUser情報
    var targetUser: User = .init()
    /// 画像ピッカー表示
    var isShowImagePicker: Bool = false
    /// メモ表示ポップアップ
    var isShowPopUpMemo: Bool = false
    /// 年齢月数表示フラグ
    var isDisplayAgeMonth: Bool = false
    /// 保存成功ダイアログ
    var isSaveSuccessAlert: Bool = false
    /// 削除確認ダイアログ
    var isDeleteConfirmAlert: Bool = false
    /// 削除成功ダイアログ
    var isDeleteSuccessAlert: Bool = false
    /// 画像表示ダイアログ
    var isImageShowAlert: Bool = false
    /// 画像エラーダイアログ
    var isImageErrorAlert: Bool = false

    /// 有効なパスに変換された画像パス
    var displayImages: [String] = []
    /// 画像エラー
    var imageError: ImageError?

    /// プレビュー表示対象の`Image`
    var selectedPreViewImage: Image?
    /// 画像削除対象のパス
    var selectedDeleteImagePath: String = ""
}

class DetailUserViewModel: ObservableObject {
    @Published var state = DetailUserState()

    // 以下パブリッシャーとして観測するプロパティはstateに含めない
    /// 更新画面モーダル
    @Published var isShowUpdateModalView: Bool = false
    /// 通知トグルフラグ
    @Published var isNotifyFlag: Bool = false
    /// 画像ピッカー選択の`UIImage`
    @Published var selectedPickerImage: UIImage?

    private let imageFileManager = ImageFileManager()

    private var cancellables: Set<AnyCancellable> = []

    private let repository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let notificationRequestManager: NotificationRequestManager

    init(
        repository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository,
        notificationRequestManager: NotificationRequestManager
    ) {
        self.repository = repository
        self.userDefaultsRepository = userDefaultsRepository
        self.notificationRequestManager = notificationRequestManager
    }

    @MainActor
    func onAppear(id: ObjectId) {
        refreshTargetUser(id: id)

        state.isDisplayAgeMonth = getDisplayAgeMonth()
        // 通知初期値セット
        isNotifyFlag = state.targetUser.alert

        $isNotifyFlag
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                switchNotifyFlag(flag: newValue, user: state.targetUser)
            }.store(in: &cancellables)

        $selectedPickerImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                saveImage(image: image)
            }.store(in: &cancellables)

        // 更新モーダルから戻った(falseになった)際にはリフレッシュ
        $isShowUpdateModalView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in
                guard let self else { return }
                guard !flag else { return }
                refreshTargetUser(id: state.targetUser.id)
            }.store(in: &cancellables)
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: UserDefaults

extension DetailUserViewModel {
    private func getDisplayAgeMonth() -> Bool {
        userDefaultsRepository.getDisplayAgeMonth()
    }

    private func refreshTargetUser(id: ObjectId) {
        guard let user: User = repository.getByPrimaryKey(id) else { return }
        state.targetUser = user
        // 有効な画像保存パスに変換してUI更新
        state.displayImages = state.targetUser.imagePaths.compactMap { loadImagePath(name: $0) }
    }
}

// MARK: UserDefaults

extension DetailUserViewModel {
    /// エラーハンドラー
    func showImageErrorHandle(error: ImageError) {
        state.imageError = error
        state.isImageErrorAlert = true
    }

    /// 画像プレビューポップアップ表示
    func showPreViewImagePopup(image: Image) {
        state.selectedPreViewImage = image
        state.isImageShowAlert = true
    }

    /// 画像削除確認ダイアログ表示
    func showDeleteConfirmAlert(user: User, index: Int) {
        state.selectedDeleteImagePath = user.imagePaths[safe: index] ?? ""
        state.isDeleteConfirmAlert = true
    }

    /// 画像がちゃんと保存されているパスをチェック & 取得
    private func loadImagePath(name: String) -> String? {
        imageFileManager.loadImagePath(name: name)
    }

    /// 画像保存
    private func saveImage(image: UIImage?) {
        guard let image else { return }
        let imgName = UUID().uuidString
        do {
            _ = try imageFileManager.saveImage(name: imgName, image: image)
            repository.appendImagePathUser(id: state.targetUser.id, imagePath: imgName)
            // User情報リフレッシュ
            refreshTargetUser(id: state.targetUser.id)
            state.isSaveSuccessAlert = true
        } catch {
            guard error is ImageError else { return }
            showImageErrorHandle(error: error as! ImageError)
        }
    }

    /// 画像削除
    func deleteImage() {
        var imagePaths = Array(state.targetUser.imagePaths)
        imagePaths.removeAll(where: { $0 == state.selectedDeleteImagePath })
        // ここのエラーは握り潰す
        _ = try? imageFileManager.deleteImage(name: state.selectedDeleteImagePath)
        repository.removeImagePathUser(id: state.targetUser.id, imagePath: state.selectedDeleteImagePath)
        // User情報リフレッシュ
        refreshTargetUser(id: state.targetUser.id)
        state.isDeleteSuccessAlert = true
    }

    /// 通知フラグ切り替え & 通知登録 / 削除 / 許可リクエスト
    @MainActor
    private func switchNotifyFlag(flag: Bool, user: User) {
        Task {
            // 通知リクエスト申請
            let granted: Bool = await notificationRequestManager.requestAuthorization()
            if !granted {
                // 通知許可アラート
                notificationRequestManager.showSettingsAlert()

                isNotifyFlag = false
                // データベース更新
                repository.updateNotifyUser(id: user.id, notify: false)
            } else {
                if flag {
                    let setting = userDefaultsRepository.getNotifyUserSetting()
                    // 通知を登録
                    notificationRequestManager
                        .sendNotificationRequest(
                            id: user.id,
                            userName: user.name,
                            date: user.date,
                            msg: setting.msg,
                            timeStr: setting.timeStr,
                            dateFlag: setting.dateFlag
                        )
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: true)
                } else {
                    // 通知を削除
                    notificationRequestManager.removeNotificationRequest(user.id)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: false)
                }
            }
        }
    }
}
