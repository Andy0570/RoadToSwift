// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  /// Plural format key: "%#@drinks@"
  public static func drinksCount(_ p1: Int) -> String {
    return Strings.tr("Localizable", "drinksCount", p1)
  }

  public enum DrinkDetail {
    public enum List {
      /// Name
      public static let name = Strings.tr("Localizable", "DrinkDetail.List.Name")
      /// Rating: %u
      public static func rating(_ p1: Int) -> String {
        return Strings.tr("Localizable", "DrinkDetail.List.Rating", p1)
      }
    }
    public enum Navigation {
      /// Your Drink
      public static let title = Strings.tr("Localizable", "DrinkDetail.Navigation.Title")
    }
  }

  public enum DrinkList {
    public enum Navigation {
      /// Drinks
      public static let title = Strings.tr("Localizable", "DrinkList.Navigation.Title")
      public enum Button {
        /// Learn More
        public static let learnMore = Strings.tr("Localizable", "DrinkList.Navigation.Button.LearnMore")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
