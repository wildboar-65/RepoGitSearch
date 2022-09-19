import UIKit
import RxSwift
import RxCocoa

class UserInfoView: UIView, LoadViewable {

    @IBOutlet var contentView: UIView!
    @IBOutlet private var userInfoLbl: UILabel!
    @IBOutlet private var logoutBtn: UIButton!
    
    var viewModelBinding: Binder<UserInfoViewModel> {
        return Binder(self, binding: { view, viewModel in
            view.userInfoLbl.text = "You are logged in as, \(viewModel.userNickName)"
        })
    }
    
    public var logoutBtnInput: Driver<Void> {
        return logoutBtn.rx.tap.asDriver()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("\(UserInfoView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.fillToSuperview()
    }

}
