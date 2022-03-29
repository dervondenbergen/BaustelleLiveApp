//
//  QuickLookView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 29.03.22.
//

import QuickLook
import SwiftUI

fileprivate class PreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    
    convenience init(_ url: URL, _ title: String) {
        self.init()
        
        previewItemURL = url
    }
}

// https://stackoverflow.com/q/61357888/2046802
struct QuickLookView: UIViewControllerRepresentable {
    var previewItemUrls: [URL]
    var title: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ viewController: QLPreviewController, context: UIViewControllerRepresentableContext<QuickLookView>) {
        viewController.reloadData()
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()

        controller.dataSource = context.coordinator
        controller.reloadData()
        return controller
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: QuickLookView

        init(_ qlPreviewController: QuickLookView) {
            self.parent = qlPreviewController
            super.init()
        }
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return self.parent.previewItemUrls.count
        }
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return PreviewItem(self.parent.previewItemUrls[index], self.parent.title)
        }

    }
}
