//
//  Utils.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 03.11.2022.
//

import Foundation
import MessageUI
import SDWebImage
import SwiftyJSON
import Miji

private let remoteDebugger = RemoteDebugger(address: "http://localhost:8080")

public func Log(
    _ string: String,
    remoteLog: Bool = false,
    consoleLog: Bool = false
) {
    if remoteLog {
        RemoteLog(string)
    }
    if consoleLog {
        debugPrint(string)
    }
}

func RemoteLog(_ string: String) {
    #if DEBUG
        let string = "\(Date())|\(string)"
        debugPrint(string)
        remoteDebugger.log(string)
    #endif
}

let RemoteImageDefaultSize: CGSize = .init(width: 96, height: 96)
let RemoteImageDefaultQuality = 96

var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

func AppVersion() -> String {
    let shortVerstion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"

    return "\(shortVerstion) (\(bundleVersion))"
}

func CustomError(errorLocalizedDescription: String) -> NSError {
     NSError.error(
        localizedDescription: errorLocalizedDescription
     ) as NSError
}

func Save(
    object: Any,
    as key: String
) {
    UserDefaults.standard.set(object, forKey: key)
    debugPrint("\(key) saved")
}

func Add(
    object: Any,
    as key: String,
    completion: ((Error?) -> Void)?
) {
    func correctError(errorType: String) -> NSError {
        CustomError(errorLocalizedDescription: "Object in storage have diffenet TYPE (Not \(errorType))")
    }
    
    let previousVersion = UserDefaults.standard.object(forKey: key)
    guard previousVersion != nil else {
        UserDefaults.standard.set(object, forKey: key)
        debugPrint("\(key) saved")
        return
    }
    var newVersion: Any?
    
    switch object {
    case is String:
        guard object is String,
              let previousVersionString = previousVersion as? String
        else {
            completion?(correctError(errorType: "String"))
            return
        }
        newVersion = previousVersionString + " " + (object as? String ?? "")
    case is Int:
        guard object is Int,
              let previousVersionInt = previousVersion as? Int else {
            completion?(correctError(errorType: "Int"))
            return
        }
        newVersion = (previousVersionInt.asString() + ((object as? Int)?.asString() ?? "")).asIntOrZero()
    case is Array<Int>:
        guard object is Array<Int>,
              var previousVersionArray = previousVersion as? Array<Int>,
              let objectArray = object as? Array<Int> else {
            completion?(correctError(errorType: "Array<Int>"))
            return
        }
        newVersion = previousVersionArray.append(contentsOf: objectArray)
    case is Array<String>:
        guard object is Array<String>,
              var previousVersionArray = previousVersion as? Array<String>,
              let objectArray = object as? Array<String> else {
            completion?(correctError(errorType: "Array<String>"))
            return
        }
        newVersion = previousVersionArray.append(contentsOf: objectArray)
    case is Array<Float>:
        guard object is Array<Float>,
              var previousVersionArray = previousVersion as? Array<Float>,
              let objectArray = object as? Array<Float> else {
            completion?(correctError(errorType: "Array<Float>"))
            return
        }
        newVersion = previousVersionArray.append(contentsOf: objectArray)
    case is Array<Double>:
        guard object is Array<Double>,
              var previousVersionArray = previousVersion as? Array<Double>,
              let objectArray = object as? Array<Double> else {
            completion?(correctError(errorType: "Array<Double>"))
            return
        }
        newVersion = previousVersionArray.append(contentsOf: objectArray)
    case is Array<Bool>:
        guard object is Array<Bool>,
              var previousVersionArray = previousVersion as? Array<Bool>,
              let objectArray = object as? Array<Bool> else {
            completion?(correctError(errorType: "Array<Bool>"))
            return
        }
        newVersion = previousVersionArray.append(contentsOf: objectArray)
    default:
        completion?(CustomError(errorLocalizedDescription: "Unable to add to the base: the saved file does not support the 'Add' function"))
    }
    
    UserDefaults.standard.set(newVersion, forKey: key)
    debugPrint("\(key) saved")
}

func SetImage(
    _ image: String?,
    imageView: UIImageView?,
    activityIndicatorView: UIActivityIndicatorView? = nil,
    size: CGSize,
    quality: Int,
    placeholderImage: UIImage? = UIImage(named: "placeholder")
) {
    guard var image = image else {
        activityIndicatorView?.stop()
        #if SET_IMAGE_BENCHMARK_ENABLED
            debugPrint("🚫 SetImage: nil STRING image to present")
        #endif
        imageView?.image = placeholderImage
        Log("🚫 SetImage: nil STRING image to present")
        return
    }
    image = image.replacingOccurrences(of: "http://", with: "https://")

    let url = URL(string: image)

    InternalSetImage(
        url,
        imageView: imageView,
        activityIndicatorView: activityIndicatorView,
        placeholderImage: placeholderImage
    )
}

func InternalSetImage(
    _ url: URL?,
    imageView: UIImageView?,
    activityIndicatorView: UIActivityIndicatorView?,
    placeholderImage: UIImage? = UIImage(named: "placeholder")
) {
    guard let url = url else {
        #if SET_IMAGE_BENCHMARK_ENABLED
            debugPrint("🚫 SetImage: nil URL image to present")
        #endif
        Log("🚫 SetImage: nil URL image to present")
        return
    }
    let startDate = Date()

    activityIndicatorView?.start()

    if activityIndicatorView == nil {
        imageView?.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    }

    imageView?.sd_cancelCurrentImageLoad()
    imageView?.sd_setImage(
        with: url,
        placeholderImage: placeholderImage,
        completed: { _, error, _, _ in
            let endDate = Date()
            let requestTime = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
            let requestPerformance = AdaptRequestTime(
                requestTime,
                prefix: "SET_IMAGE"
            )

            if let error = error {
                if error.code == SDWebImageError.cancelled.rawValue {
                    Log("---\n🚫 SetImage: can't download \(url)\nImage loading CANCELLED MANUALLY (view reuse probably)\n---")
                    return
                }
                let logString = "---\n 🚫 SetImage: can't download \(url) because of error: \(error)\n Request time: \(requestTime)\nADAPTED_SET_IMAGE_REQUEST_PERFORMANCE: \(requestPerformance)\n---"
                #if SET_IMAGE_BENCHMARK_ENABLED
                    debugPrint(logString)
                #endif
                Log(logString)
                imageView?.image = placeholderImage
                activityIndicatorView?.stop()
                return
            }

            let logString = "---\n🖼 SetImage: success \(url)\nRequest time: \(requestTime)\nADAPTED_SET_IMAGE_REQUEST_PERFORMANCE: \(requestPerformance)\n---"
            #if SET_IMAGE_BENCHMARK_ENABLED
                debugPrint(logString)
            #endif
            Log(logString)
            activityIndicatorView?.stop()
        }
    )
}

func AdaptRequestTime(
    _ time: Double,
    prefix: String = ""
) -> String {
    if time < 1 {
        return "\(prefix)_FAST_REQUEST ( <1s )"
    }
    else if time < 5 {
        return "\(prefix)_KINDA_SLOW_REQUEST ( >1s, <5s )"
    }
    else if time < 10 {
        return "\(prefix)_VERY_SLOW_REQUEST ( >5s, <10s )"
    }
    else if time < 20 {
        return "\(prefix)_DISASTER_REQUEST ( >10s, < 20s )"
    }
    else {
        return "\(prefix)_ALMOST_NO_CONNECTION_REQUEST_BAD_BAD_BAD ( >20s )"
    }
}

func MailTo(
    email: String,
    errorText: String = "Невозможно открыть системный почтовый клиент Mail, скорее всего просто не настроен в системе"
) -> Error? {
    guard let url = URL(string: "mailto:\(email)") else {
        return NSError.error(
            domain: "MailTo",
            code: 1,
            localizedDescription: "Неизвестная ошибка адреса почты mailto:\(email)"
        )
    }
    guard UIApplication.shared.canOpenURL(url) else {
        return NSError.error(
            domain: "MailTo",
            code: 2,
            localizedDescription: errorText
        )
    }
    UIApplication.shared.open(url)
    return nil
}

func Sms(phone: String, completion: ErrorCompletion?) {
    let phone = phone.replacingOccurrences(of: " ", with: "")
    guard let url = URL(string: "sms://\(phone)") else { return }
    guard UIApplication.shared.canOpenURL(url) else {
        completion?(NSError.error(localizedDescription: "Невозможно отправить смс по номеру \(url)"))
        return
    }
    UIApplication.shared.open(url)
}

func GAParams(_ params: [String: String]) -> [String: String] {
    let output = Dictionary(uniqueKeysWithValues: params.map { key, value in (key.gaString(), value.gaString()) })
    return output
}

private func prepare(phoneNumber: String) -> String {
    phoneNumber
        .replace(" ", "")
        .replace("-", "")
        .replace("+", "")
        .replace("(", "")
        .replace(")", "")
}

func Call(phone: String, completion: ((Error?) -> Void)?) {
    let phone = prepare(phoneNumber: phone)
    guard let url = URL(string: "tel://\(phone)") else { return }
    guard UIApplication.shared.canOpenURL(url) else {
        completion?(NSError.error(localizedDescription: "Невозможно позвонить по номеру \(url)"))
        return
    }
    UIApplication.shared.open(url)
}

func Open(url: String) {
    guard let url = URL(string: url) else { return }
    UIApplication.shared.open(url)
}

func Open(url: URL) {
    UIApplication.shared.open(url)
}

func Share(url: String, from viewController: UIViewController?) {
    guard let url = url.asURL() else {
        viewController?.showAlert(title: "Невозможно поделиться ссылкой, некорректный url: \(url)")
        return
    }
    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = viewController?.view
    viewController?.present(activityViewController, animated: true, completion: nil)
    activityViewController.completionWithItemsHandler = { (_, completed: Bool, _: [Any]?, _: Error?) in
        if completed {
            viewController?.dismiss(animated: true, completion: nil)
        }
    }
}

func SafeArea() -> UIEdgeInsets {
    guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    guard let firstWindow = firstScene.windows.first(where: { $0.isKeyWindow }) else {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    return firstWindow.safeAreaInsets
}

func SecondsBetweenNowAnd(date: Date?) -> TimeInterval {
    return SecondsBetweenDates(Date(), date)
}

func SecondsBetweenDates(_ lhsDate: Date?, _ rhsDate: Date?) -> TimeInterval {
    guard let lhsDate = lhsDate else { return Double.infinity }
    guard let rhsDate = rhsDate else { return Double.infinity }
    let diff = abs(lhsDate.timeIntervalSince1970 - rhsDate.timeIntervalSince1970)
    return diff
}

func Stick(viewA: UIView?, to viewB: UIView?) {
    guard let viewA = viewA else { return }
    guard let viewB = viewB else { return }

    let bottomConstraint = NSLayoutConstraint(
        item: viewA,
        attribute: NSLayoutConstraint.Attribute.bottom,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: viewB,
        attribute: NSLayoutConstraint.Attribute.bottom,
        multiplier: 1,
        constant: 0
    )

    let trailingConstraint = NSLayoutConstraint(
        item: viewA,
        attribute: NSLayoutConstraint.Attribute.trailing,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: viewB,
        attribute: NSLayoutConstraint.Attribute.trailing,
        multiplier: 1,
        constant: 0
    )

    let topConstraint = NSLayoutConstraint(
        item: viewA,
        attribute: NSLayoutConstraint.Attribute.top,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: viewB,
        attribute: NSLayoutConstraint.Attribute.top,
        multiplier: 1,
        constant: 0
    )

    let leadingConstraint = NSLayoutConstraint(
        item: viewA,
        attribute: NSLayoutConstraint.Attribute.leading,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: viewB,
        attribute: NSLayoutConstraint.Attribute.leading,
        multiplier: 1,
        constant: 0
    )

    viewB.addConstraints([bottomConstraint, trailingConstraint, topConstraint, leadingConstraint])
}

func SizeOfDevice() -> String {
    return "\(ScreenWidth) x \(ScreenHeight)"
}

func iOSVersion() -> String {
    let systemVersion = UIDevice.current.systemVersion
    return systemVersion
}

func VersionOfApp() -> String {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return version
    }
    else {
        return "0.0"
    }
}

func SeparatedIntoGroupsOfThree(int: Int) -> String {
    let result = NSNumber(value: int)
    let numberFormatter = NumberFormatter()
    numberFormatter.groupingSeparator = " "
    numberFormatter.groupingSize = 3
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.decimalSeparator = "."
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    guard let stringFromNumber = numberFormatter.string(from: result) as String? else { return String(int) }
    return stringFromNumber
}

func GetOneInstallDeviceUUID() throws -> String {
    let key = "OneInstallDeviceUUID"
    var rawUuid = UserDefaults.standard.string(forKey: key)
    if rawUuid == nil {
        rawUuid = UUID().uuidString
        UserDefaults.standard.setValue(rawUuid, forKey: key)
    }

    guard let uuid = rawUuid else {
        throw NSError.error(
            domain: "Utils",
            code: 1,
            localizedDescription: "Can't get \(key) - UUID, for some reason"
        )
    }
    return uuid
}

func TypeOf(value: Any) -> String {
    switch value {
    case is Bool:
        return "Bool"
    case is Int:
        return "Int"
    case is Double:
        return "Double"
    case is String:
        return "String"
    case is Float:
        return "Float"
    case is [Any]:
        return "Array"
    case is [String:Any]:
        return "Dictionary"
    default:
        return "NotUsual"
    }
}
