//
//  ImagePickerButton.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/5/24.
//

import SwiftUI

struct ImagePickerButton<Label: View>: View {
    @State private var showImageSourceDialog = false
    @State private var sourceType: UIImagePickerController.SourceType?
    @Binding var imageURL: URL?
    @ViewBuilder let label: () -> Label
    
    var body: some View {
        Button(action: {
            showImageSourceDialog = true
        }) {
            label()
        }
        .confirmationDialog("Choose Image", isPresented: $showImageSourceDialog) {
            Button("Choose from Library", action: {
                sourceType = .photoLibrary
            })
            Button("Take Photo", action: {
                sourceType = .camera
            })
            if imageURL != nil {
                Button("Remove Photo", role: .destructive, action: {
                    imageURL = nil
                })
            }
        }
        .fullScreenCover(item: $sourceType) { sourceType in
            ImagePickerView(sourceType: sourceType) {
                imageURL = $0
            }
            .ignoresSafeArea()
        }

    }
}

private extension ImagePickerButton{
    struct ImagePickerView: UIViewControllerRepresentable {
        let sourceType: UIImagePickerController.SourceType
        let onSelect: (URL) -> Void
        
        @Environment(\.dismiss) var dismiss
        
        func makeCoordinator() -> ImagePickerCoordinator {
            return ImagePickerCoordinator(view: self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = context.coordinator
            imagePicker.sourceType = sourceType
            return imagePicker
        }
        
        func updateUIViewController(_ imagePicker: UIImagePickerController, context: Context) {}
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let view: ImagePickerView
        
        init(view: ImagePickerView) {
            self.view = view
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let imageURL = info[.imageURL] as? URL else { return }
            view.onSelect(imageURL)
            view.dismiss()
        }
    }
}

extension UIImagePickerController.SourceType: Identifiable {
    public var id: String { "\(self)" }
}

struct ImagePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerButton(imageURL: .constant(nil)) {
            Label("Choose Image", systemImage: "photo.fill")
        }
    }
}
