//
//  ScreenshotHelper.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Screenshot helper with metadata overlay (debug builds only)

import SwiftUI
import UIKit

#if DEBUG
/// App metadata for screenshot overlays
struct AppMetadata {
    let screenName: String
    let dataset: String
    let seed: String
    let timestamp: Date
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: timestamp)
    }
    
    /// Redacts mock IDs from strings (privacy requirement)
    static func redactMockIDs(_ text: String) -> String {
        // Simple redaction: replace UUID-like patterns
        let uuidPattern = #"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"#
        return text.replacingOccurrences(
            of: uuidPattern,
            with: "[REDACTED]",
            options: [.regularExpression, .caseInsensitive]
        )
    }
}

/// Screenshot helper for capturing screens with metadata overlay
struct ScreenshotHelper {
    /// Captures the current screen with optional metadata overlay
    static func captureScreen(
        from view: UIView,
        metadata: AppMetadata? = nil,
        showOverlay: Bool = true
    ) -> UIImage? {
        // Capture the view as image
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        var image = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        
        // Add metadata overlay if requested
        if showOverlay, let metadata = metadata {
            image = addMetadataOverlay(to: image, metadata: metadata)
        }
        
        return image
    }
    
    /// Adds metadata overlay to an image
    private static func addMetadataOverlay(to image: UIImage, metadata: AppMetadata) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        return renderer.image { context in
            // Draw original image
            image.draw(at: .zero)
            
            // Prepare overlay text
            let overlayText = """
            Screen: \(metadata.screenName)
            Dataset: \(metadata.dataset)
            Seed: \(metadata.seed)
            Time: \(metadata.formattedTimestamp)
            """
            
            let redactedText = AppMetadata.redactMockIDs(overlayText)
            
            // Draw overlay background
            let textRect = CGRect(x: 16, y: 16, width: image.size.width - 32, height: 200)
            let overlayRect = textRect.insetBy(dx: -8, dy: -8)
            
            context.cgContext.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
            context.cgContext.fill(overlayRect)
            
            // Draw text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: redactedText, attributes: attributes)
            attributedString.draw(in: textRect)
        }
    }
    
    /// Presents share sheet with screenshot
    static func shareScreenshot(
        _ image: UIImage,
        from viewController: UIViewController
    ) {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                      y: viewController.view.bounds.midY,
                                      width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true)
    }
}

/// SwiftUI helper for capturing screenshots
extension ScreenshotHelper {
    /// Captures the current window as a screenshot
    static func captureCurrentWindow(
        screenName: String,
        dataset: String = "datasetA",
        seed: String = "12345",
        showOverlay: Bool = true
    ) -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        
        let metadata = AppMetadata(
            screenName: screenName,
            dataset: dataset,
            seed: seed,
            timestamp: Date()
        )
        
        return captureScreen(
            from: window,
            metadata: showOverlay ? metadata : nil,
            showOverlay: showOverlay
        )
    }
}

/// Share sheet wrapper for SwiftUI
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // For iPad
        if let popover = controller.popoverPresentationController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                       y: UIScreen.main.bounds.height / 2,
                                       width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

