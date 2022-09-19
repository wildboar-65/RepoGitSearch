import UIKit
import WebKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {

    let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var changeAccountBtn: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
        viewModelBinding()
    }
    
    private func uiConfig() {
        reloadBtn.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.webView.reload()
            }).disposed(by: disposeBag)
        
        backBtn.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.webView.goBack()
            }).disposed(by: disposeBag)
        
        backBtn.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.webView.goForward()
            }).disposed(by: disposeBag)
    }
    
    private func viewModelBinding() {
        let webViewNavigation = webView.rx.webViewNavigationEvent
            .asObservable()
            .map { (navAction, completion) -> URLRequest in
                completion(.allow, WKWebpagePreferences())
                return navAction.request
            }
        
        let input = SignInViewModel.Input(viewWillApear: rx.viewWillAppear.asDriver(),
                                          changeAccountTap: changeAccountBtn.rx.tap.asDriver(),
                                          webViewNavigation: webViewNavigation.asDriverOnErrorJustComplete(),
                                          dismissTap: closeBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(from: input)
        
        output.startPageLoad
            .drive(onNext: { [unowned self] request in
                self.webView.load(request)
            }).disposed(by: disposeBag)
        
        output.signInFinish
            .drive()
            .disposed(by: disposeBag)
        
        output.signInWithAnotherAccout
            .drive(onNext: { [unowned self] _ in
                self.webView.reload()
            }).disposed(by: disposeBag)
        
        output.dismiss
            .drive()
            .disposed(by: disposeBag)
    }
}
