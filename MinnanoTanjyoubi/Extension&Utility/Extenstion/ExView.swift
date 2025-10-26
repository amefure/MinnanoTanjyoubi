//
//  ExView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI

/// アラートを簡易的に呼び出すための拡張
extension View {
    func alert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        positiveButtonTitle: String = "",
        negativeButtonTitle: String = "",
        positiveButtonRole: ButtonRole? = nil,
        negativeButtonRole: ButtonRole? = .cancel,
        positiveAction: @escaping () -> Void = {},
        negativeAction: @escaping () -> Void = {}
    ) -> some View {
        alert(title, isPresented: isPresented) {
            if !negativeButtonTitle.isEmpty, !positiveButtonTitle.isEmpty {
                Button(role: negativeButtonRole) {
                    negativeAction()
                } label: {
                    Text(negativeButtonTitle)
                }
            }

            if !positiveButtonTitle.isEmpty {
                Button(role: positiveButtonRole) {
                    positiveAction()
                } label: {
                    Text(positiveButtonTitle)
                }
            }
        } message: {
            Text(message)
        }
    }
}
