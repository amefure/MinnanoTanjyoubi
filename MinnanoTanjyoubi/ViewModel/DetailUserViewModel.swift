//
//  DetailUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import SwiftUI
import UIKit
import RealmSwift

@MainActor
class DetailUserViewModel: ObservableObject {
    
    /// 詳細画面で表示するUser情報
    @Published var targetUser: User = User()
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

    /// 画像削除対象のパス
    var selectedDeleteImagePath: String = ""
    /// プレビュー表示対象の`Image`
    var selectedPreViewImage: Image?
    /// 画像ピッカー選択の`UIImage`
    @Published var selectedPickerImage: UIImage?
    /// 有効なパスに変換された画像パス
    @Published private(set) var displayImages: [String] = []
    
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

    func onAppear(id: ObjectId) {
        
        refreshTargetUser(id: id)
        
        isDisplayAgeMonth = getDisplayAgeMonth()
        // 通知初期値セット
        isNotifyFlag = targetUser.alert
        
        $isNotifyFlag
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self else { return }
                self.switchNotifyFlag(flag: newValue, user: targetUser)
            }.store(in: &cancellables)
        
        $selectedPickerImage
            .sink { [weak self] image in
                guard let self else { return }
                self.saveImage(image: image)
            }.store(in: &cancellables)
        
        // 更新モーダルから戻った(falseになった)際にはリフレッシュ
        $isShowUpdateModalView
            .sink { [weak self] flag in
                guard let self else { return }
                guard !flag else { return }
                refreshTargetUser(id: targetUser.id)
            }.store(in: &cancellables)
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: UserDefaults
extension DetailUserViewModel {
    private func getDisplayAgeMonth() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayAgeMonth()
    }
    
    private func refreshTargetUser(id: ObjectId) {
        guard let user: User = repository.getByPrimaryKey(id) else { return }
        targetUser = user
        // 有効な画像保存パスに変換してUI更新
        displayImages = targetUser.imagePaths.compactMap { loadImagePath(name: $0) }
    }
}

// MARK: UserDefaults
extension DetailUserViewModel {
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
        selectedPreViewImage = image
        isImageShowAlert = true
    }

    /// 画像削除確認ダイアログ表示
    func showDeleteConfirmAlert(user: User, index: Int) {
        selectedDeleteImagePath = user.imagePaths[safe: index] ?? ""
        isDeleteConfirmAlert = true
    }

    /// 画像がちゃんと保存されているパスをチェック & 取得
    private func loadImagePath(name: String) -> String? {
        imageFileManager.loadImagePath(name: name)
    }

    /// 画像保存
    private func saveImage(image: UIImage?) {
        guard let image = image else { return }
        let imgName = UUID().uuidString
        do {
            _ = try imageFileManager.saveImage(name: imgName, image: image)
            repository.appendImagePathUser(id: targetUser.id, imagePath: imgName)
            // User情報リフレッシュ
            refreshTargetUser(id: targetUser.id)
            isSaveSuccessAlert = true
        } catch {
            guard error is ImageError else { return }
            showImageErrorHandle(error: error as! ImageError)
        }
    }

    /// 画像削除
    func deleteImage() {
        var imagePaths = Array(targetUser.imagePaths)
        imagePaths.removeAll(where: { $0 == selectedDeleteImagePath })
        // ここのエラーは握り潰す
        _ = try? imageFileManager.deleteImage(name: selectedDeleteImagePath)
        repository.removeImagePathUser(id: targetUser.id, imagePath: selectedDeleteImagePath)
        // User情報リフレッシュ
        refreshTargetUser(id: targetUser.id)
        isDeleteSuccessAlert = true
    }

    /// 通知フラグ切り替え & 通知登録 / 削除 / 許可リクエスト
    private func switchNotifyFlag(flag: Bool, user: User) {
        Task {
            // 通知リクエスト申請
            let granted: Bool = await AppManager.sharedNotificationRequestManager.requestAuthorization()
            if !granted {
                // 通知許可アラート
                AppManager.sharedNotificationRequestManager.showSettingsAlert()

                isNotifyFlag = false
                // データベース更新
                repository.updateNotifyUser(id: user.id, notify: false)
            } else {
                if flag {
                    // 通知を登録
                    AppManager.sharedNotificationRequestManager.sendNotificationRequest(user.id, user.name, user.date)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: true)
                } else {
                    // 通知を削除
                    AppManager.sharedNotificationRequestManager.removeNotificationRequest(user.id)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: false)
                }
            }
        }
    }
}
