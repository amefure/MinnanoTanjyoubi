//
//  ImagePickerDialog.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import SwiftUI
import PhotosUI

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
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePickerDialog>) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let parent: ImagePickerDialog
        
        init(_ parent: ImagePickerDialog) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let image = image as? UIImage else {
                        return
                    }
                    DispatchQueue.main.sync {
                        self?.parent.image = image
                    }
                }
            }
        }
    }
}

