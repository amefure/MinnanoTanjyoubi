
// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#elseif os(tvOS) || os(watchOS)
    import UIKit
#endif
#if canImport(SwiftUI)
    import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
    enum Colors {
        static let exText = ColorAsset(name: "ex_text")
        static let exThemaRed = ColorAsset(name: "ex_thema_red")
        static let exThemaYellow = ColorAsset(name: "ex_thema_yellow")
        static let scheme1FoundationPrimary = ColorAsset(name: "scheme_1_foundation_primary")
        static let scheme1FoundationSub = ColorAsset(name: "scheme_1_foundation_sub")
        static let scheme1Text = ColorAsset(name: "scheme_1_text")
        static let scheme1Thema1 = ColorAsset(name: "scheme_1_thema1")
        static let scheme1Thema2 = ColorAsset(name: "scheme_1_thema2")
        static let scheme1Thema3 = ColorAsset(name: "scheme_1_thema3")
        static let scheme1Thema4 = ColorAsset(name: "scheme_1_thema4")
        static let scheme2FoundationPrimary = ColorAsset(name: "scheme_2_foundation_primary")
        static let scheme2FoundationSub = ColorAsset(name: "scheme_2_foundation_sub")
        static let scheme2Text = ColorAsset(name: "scheme_2_text")
        static let scheme2Thema1 = ColorAsset(name: "scheme_2_thema1")
        static let scheme2Thema2 = ColorAsset(name: "scheme_2_thema2")
        static let scheme2Thema3 = ColorAsset(name: "scheme_2_thema3")
        static let scheme2Thema4 = ColorAsset(name: "scheme_2_thema4")
        static let scheme3FoundationPrimary = ColorAsset(name: "scheme_3_foundation_primary")
        static let scheme3FoundationSub = ColorAsset(name: "scheme_3_foundation_sub")
        static let scheme3Text = ColorAsset(name: "scheme_3_text")
        static let scheme3Thema1 = ColorAsset(name: "scheme_3_thema1")
        static let scheme3Thema2 = ColorAsset(name: "scheme_3_thema2")
        static let scheme3Thema3 = ColorAsset(name: "scheme_3_thema3")
        static let scheme3Thema4 = ColorAsset(name: "scheme_3_thema4")
        static let scheme4FoundationPrimary = ColorAsset(name: "scheme_4_foundation_primary")
        static let scheme4FoundationSub = ColorAsset(name: "scheme_4_foundation_sub")
        static let scheme4Text = ColorAsset(name: "scheme_4_text")
        static let scheme4Thema1 = ColorAsset(name: "scheme_4_thema1")
        static let scheme4Thema2 = ColorAsset(name: "scheme_4_thema2")
        static let scheme4Thema3 = ColorAsset(name: "scheme_4_thema3")
        static let scheme4Thema4 = ColorAsset(name: "scheme_4_thema4")
        static let scheme5FoundationPrimary = ColorAsset(name: "scheme_5_foundation_primary")
        static let scheme5FoundationSub = ColorAsset(name: "scheme_5_foundation_sub")
        static let scheme5Text = ColorAsset(name: "scheme_5_text")
        static let scheme5Thema1 = ColorAsset(name: "scheme_5_thema1")
        static let scheme5Thema2 = ColorAsset(name: "scheme_5_thema2")
        static let scheme5Thema3 = ColorAsset(name: "scheme_5_thema3")
        static let scheme5Thema4 = ColorAsset(name: "scheme_5_thema4")
        static let scheme6FoundationPrimary = ColorAsset(name: "scheme_6_foundation_primary")
        static let scheme6FoundationSub = ColorAsset(name: "scheme_6_foundation_sub")
        static let scheme6Text = ColorAsset(name: "scheme_6_text")
        static let scheme6Thema1 = ColorAsset(name: "scheme_6_thema1")
        static let scheme6Thema2 = ColorAsset(name: "scheme_6_thema2")
        static let scheme6Thema3 = ColorAsset(name: "scheme_6_thema3")
        static let scheme6Thema4 = ColorAsset(name: "scheme_6_thema4")
        static let scheme7FoundationPrimary = ColorAsset(name: "scheme_7_foundation_primary")
        static let scheme7FoundationSub = ColorAsset(name: "scheme_7_foundation_sub")
        static let scheme7Text = ColorAsset(name: "scheme_7_text")
        static let scheme7Thema1 = ColorAsset(name: "scheme_7_thema1")
        static let scheme7Thema2 = ColorAsset(name: "scheme_7_thema2")
        static let scheme7Thema3 = ColorAsset(name: "scheme_7_thema3")
        static let scheme7Thema4 = ColorAsset(name: "scheme_7_thema4")
    }

    enum Images {
        static let appiconRemove = ImageAsset(name: "Appicon-remove")
        static let appLogo = ImageAsset(name: "app_logo")
        static let appMinnanoOiwai = ImageAsset(name: "app_minnano_oiwai")
    }
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

final class ColorAsset: @unchecked Sendable {
    fileprivate(set) var name: String

    #if os(macOS)
        typealias Color = NSColor
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        typealias Color = UIColor
    #endif

    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
    private(set) lazy var color: Color = {
        guard let color = Color(asset: self) else {
            fatalError("Unable to load color asset named \(name).")
        }
        return color
    }()

    #if os(iOS) || os(tvOS)
        @available(iOS 11.0, tvOS 11.0, *)
        func color(compatibleWith traitCollection: UITraitCollection) -> Color {
            let bundle = BundleToken.bundle
            guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
                fatalError("Unable to load color asset named \(name).")
            }
            return color
        }
    #endif

    #if canImport(SwiftUI)
        @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
        private(set) lazy var swiftUIColor: SwiftUI.Color = .init(asset: self)
    #endif

    fileprivate init(name: String) {
        self.name = name
    }
}

extension ColorAsset.Color {
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
    convenience init?(asset: ColorAsset) {
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            self.init(named: NSColor.Name(asset.name), bundle: bundle)
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

#if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    extension SwiftUI.Color {
        init(asset: ColorAsset) {
            let bundle = BundleToken.bundle
            self.init(asset.name, bundle: bundle)
        }
    }
#endif

struct ImageAsset {
    fileprivate(set) var name: String

    #if os(macOS)
        typealias Image = NSImage
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        typealias Image = UIImage
    #endif

    @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
    var image: Image {
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
            let image = Image(named: name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            let name = NSImage.Name(self.name)
            let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
        #elseif os(watchOS)
            let image = Image(named: name)
        #endif
        guard let result = image else {
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }

    #if os(iOS) || os(tvOS)
        @available(iOS 8.0, tvOS 9.0, *)
        func image(compatibleWith traitCollection: UITraitCollection) -> Image {
            let bundle = BundleToken.bundle
            guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
                fatalError("Unable to load image asset named \(name).")
            }
            return result
        }
    #endif

    #if canImport(SwiftUI)
        @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
        var swiftUIImage: SwiftUI.Image {
            SwiftUI.Image(asset: self)
        }
    #endif
}

extension ImageAsset.Image {
    @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
    @available(macOS, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init?(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
            let bundle = BundleToken.bundle
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            self.init(named: NSImage.Name(asset.name))
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

#if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    extension SwiftUI.Image {
        init(asset: ImageAsset) {
            let bundle = BundleToken.bundle
            self.init(asset.name, bundle: bundle)
        }

        init(asset: ImageAsset, label: Text) {
            let bundle = BundleToken.bundle
            self.init(asset.name, bundle: bundle, label: label)
        }

        init(decorative asset: ImageAsset) {
            let bundle = BundleToken.bundle
            self.init(decorative: asset.name, bundle: bundle)
        }
    }
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
