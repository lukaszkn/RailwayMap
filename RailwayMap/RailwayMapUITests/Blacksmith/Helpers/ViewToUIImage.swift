//
//  ViewToUIImage.swift
//  Blacksmith
//
//  Created by Florian Schweizer on 04.01.22.
//

import SwiftUI
#if canImport(UIKit)
import UIKit

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        
        let hosting = UIHostingController(rootView: self)
//        if #available(iOS 16.0, *) {
//            hosting.sizingOptions = [.preferredContentSize]
//        }
        
        hosting.view.frame = window.frame
        
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        
        return hosting.view.renderedImage
    }
    
    func saveToImage(size: CGSize) -> UIImage {
        // Apply the fixedSize modifier to ensure this view is at its ideal size (does not compress or truncate vertically in this case)
        let controller = UIHostingController(rootView: self.fixedSize(horizontal: false, vertical: true))
        guard let view = controller.view else { return .init() }
        
        // Calculate the target size based on the intrinsic content size of the view
        let targetSize = controller.sizeThatFits(in: .init(width: view.intrinsicContentSize.width, height: .greatestFiniteMagnitude))
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
    
        let image = renderer.image { render in
            view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}

extension UIView {
    var renderedImage: UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: format)
        let pngData = renderer.pngData { context in
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        
        return UIImage(data: pngData) ?? UIImage(systemName: "exclamationmark.triangle.fill")!
    }
}
#endif
