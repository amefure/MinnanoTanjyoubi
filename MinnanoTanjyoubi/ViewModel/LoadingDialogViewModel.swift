//
//  LoadingDialogViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/10.
//

import Combine
import SwiftUI

/// ローディングの発火を制御する
class LoadingDialogViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false

    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []

    public func onAppear() {
        // ローディング発火用Notificationを観測
        NotificationCenter.default.publisher(for: .loading)
            .sink { [weak self] notification in
                guard let self else { return }
                guard let obj = notification.object as? Bool else { return }
                self.isLoading = obj
            }
            .store(in: &cancellables)
    }

    public func onDisappear() {
        isLoading = false
        cancellables.forEach { $0.cancel() }
    }
}
