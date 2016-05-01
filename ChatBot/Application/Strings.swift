// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Error
  case Error
  /// OK
  case OK
  /// Done
  case Done
  /// Could not load chat
  case ErrMsgLoadChatTitle
  /// Retry in some minutes by pulling the list to refresh
  case ErrMsgLoadChatMsg
  /// Invalid username
  case ErrMsgUserNotValidTitle
  /// Username not valid, please enter a different one
  case ErrMsgUserNotValidMsg
  /// Login error
  case ErrMsgUserInvalidLoginTitle
  /// Something has been wrong, please retry again
  case ErrMsgUserInvalidLoginMsg
  /// Slow internet connectivity, be patient ...
  case ErrMsgSlowInternet
  /// No data to show
  case ErrMsgNodataItemsTitle
  /// No data, pull tp refresh to get data
  case ErrMsgNodataItemsMsg
  /// Back
  case TitleBackButton
  /// Type your name
  case LoginTypeYourName
  /// First Name & Last Name
  case LoginUsernamePlaceHolder
  /// Chat - [%@]
  case ChatTitleMain(String)
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .Error:
        return L10n.tr("Error")
      case .OK:
        return L10n.tr("OK")
      case .Done:
        return L10n.tr("Done")
      case .ErrMsgLoadChatTitle:
        return L10n.tr("ErrMsgLoadChatTitle")
      case .ErrMsgLoadChatMsg:
        return L10n.tr("ErrMsgLoadChatMsg")
      case .ErrMsgUserNotValidTitle:
        return L10n.tr("ErrMsgUserNotValidTitle")
      case .ErrMsgUserNotValidMsg:
        return L10n.tr("ErrMsgUserNotValidMsg")
      case .ErrMsgUserInvalidLoginTitle:
        return L10n.tr("ErrMsgUserInvalidLoginTitle")
      case .ErrMsgUserInvalidLoginMsg:
        return L10n.tr("ErrMsgUserInvalidLoginMsg")
      case .ErrMsgSlowInternet:
        return L10n.tr("ErrMsgSlowInternet")
      case .ErrMsgNodataItemsTitle:
        return L10n.tr("ErrMsgNodataItemsTitle")
      case .ErrMsgNodataItemsMsg:
        return L10n.tr("ErrMsgNodataItemsMsg")
      case .TitleBackButton:
        return L10n.tr("TitleBackButton")
      case .LoginTypeYourName:
        return L10n.tr("LoginTypeYourName")
      case .LoginUsernamePlaceHolder:
        return L10n.tr("LoginUsernamePlaceHolder")
      case .ChatTitleMain(let p0):
        return L10n.tr("ChatTitleMain", p0)
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}
