//
//  ExPublisher.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/09/25.
//

import Combine

extension Publisher {
    /// `receiveValue`を省略できる`sink`
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
}
