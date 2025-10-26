//
//  ImagePickerDialog.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import PhotosUI
import SwiftUI

struct ImagePickerDialog: UIViewControllerRepresentable {
    // MARK: - Receive

    @Binding var image: UIImage?

    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerDialog>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: PHPickerViewController, context _: UIViewControllerRepresentableContext<ImagePickerDialog>) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        var parent: ImagePickerDialog

        init(_ parent: ImagePickerDialog) {
            self.parent = parent
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let self else { return }
                    guard let image = image as? UIImage else { return }
                    DispatchQueue.main.sync {
                        self.parent.image = image
                    }
                }
            }
        }
    }
}
