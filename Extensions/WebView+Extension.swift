import WebKit
import RxSwift
import RxCocoa

public typealias DecisionHandlerCompletion = @convention(block) (WKNavigationActionPolicy, WKWebpagePreferences) -> Void

extension Reactive where Base: WKWebView {
    var webViewNavigationEvent: ControlEvent<(WKNavigationAction, DecisionHandlerCompletion)> {
        let source = self.navigationDelegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:decidePolicyFor:preferences:decisionHandler:))).map { args -> (WKNavigationAction, DecisionHandlerCompletion)  in
            return (self.cast(args[1]), self.castPointer(args[3]))
    }
        return ControlEvent(events: source)
    }
}

extension Reactive {

  public func castPointer<T>(_ any: Any) -> T {
    let block = any as AnyObject
    let ptr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block).toOpaque())
    let casted = unsafeBitCast(ptr, to: T.self)
    return casted
  }

  public func cast<T>(_ any: Any) -> T {
    guard let casted: T = any as? T else { fatalError() }
    return casted
  }
}

extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
