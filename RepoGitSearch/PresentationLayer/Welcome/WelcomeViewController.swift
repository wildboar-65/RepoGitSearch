import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: UIViewController {
    
    let viewModel: WelcomeViewModel
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var signInBtn: UIButton!
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBinding()
    }
    
    private func viewModelBinding() {
        let input = WelcomeViewModel.Input(signInTap: signInBtn.rx.tap.asDriver())
        let output = viewModel.transform(from: input)
        output.signInStart
            .drive()
            .disposed(by: disposeBag)
        
        output.signUpDone
            .drive()
            .disposed(by: disposeBag)
    }
}
