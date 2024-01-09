//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import CoreGraphics
import CoreText
import os.log


public struct CustomFont {

    // MARK: Public
    
    public enum Weight: String, CaseIterable {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
    }
    
    // MARK: Private
    
    private let baseName: String
    private let logger = Logger(subsystem: "io.hiddenspectrum.secondfoundation", category: "CustomFont")
    private let supportedWeights: [Weight]
    
    // MARK: Lifecycle
    
    public init(baseName: String, supportedWeights: [Weight] = Weight.allCases, bundle: Bundle = .main) {
        self.baseName = baseName
        self.supportedWeights = supportedWeights
        supportedWeights.forEach { weight in
            registerFontFile(named: name(for: weight), bundle: bundle)
        }
    }
    
    // MARK: Font Registration
    
    private func registerFontFile(named name: String, bundle: Bundle) {
        guard let asset = NSDataAsset(name: name, bundle: bundle),
              let provider = CGDataProvider(data: asset.data as NSData),
              let font = CGFont(provider)
        else {
            logger.error("Failed to find font asset \(name) in bundle: \(bundle.bundlePath)")
            return
        }
        
        var registerError: Unmanaged<CFError>? = nil
        guard CTFontManagerRegisterGraphicsFont(font, &registerError) else {
            logger.error("Failed to register font: \(registerError.debugDescription)")
            return
        }
    }
    
    // MARK: Helpers
    
    public func name(for weight: Weight) -> String {
        "\(baseName)-\(weight.rawValue)"
    }
}
