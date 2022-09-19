import UIKit
import RxSwift
import RxCocoa

final class RepoSearchViewController: UIViewController {

    let viewModel: RepoSearchViewModel
    private let disposeBag = DisposeBag()
        
    private lazy var searchController = UISearchController()
    private var rightNavBtn: UIBarButtonItem!
    @IBOutlet var noResultsLbl: UILabel!
    @IBOutlet var userInfoView: UserInfoView!
    @IBOutlet private var tableView: UITableView!
    private lazy var viewTouch = UITapGestureRecognizer()
    init(viewModel: RepoSearchViewModel) {
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
        configureNavigationBar()
        configureSearchController()
        
        tableView.register(UINib(nibName: RepoTableViewCell.className, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.className)
        
        view.addGestureRecognizer(viewTouch)
        
        viewTouch.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                print("Touch event")
                self?.searchController.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing
            .asDriver()
            .map({ _ in
                return true
            })
            .drive(searchController.searchBar.rx.showsCancelButton)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidEndEditing
            .asDriver()
            .map({ _ in
                return false
            })
            .drive(searchController.searchBar.rx.showsCancelButton)
            .disposed(by: disposeBag)
    }
    
    private func viewModelBinding() {
        
        let searchNext = searchController.searchBar.rx.text
            .compactMap({$0})
            .asDriverOnErrorJustComplete()
        
        let searchTap = searchController.searchBar.rx.textDidEndEditing.asDriver()
        
        let willDisplay = tableView.rx.willDisplayCell.asDriver()
            .map { (cell: UITableViewCell, indexPath: IndexPath) in
                return ()
            }
        
        
        let output = viewModel
            .transform(from:RepoSearchViewModel
                        .Input(viewWillApear: rx.viewWillAppear.asDriver(),
                                              logoutTap: userInfoView.logoutBtnInput,
                                              openHistoryTap: rightNavBtn.rx.tap.asDriver(),
                                              searchText: searchNext,
                               searchTap: searchTap,
                               loadNextTrigger: Driver.just(())))
        
        output.loadUser
            .drive(userInfoView.viewModelBinding)
            .disposed(by: disposeBag)
        
        output.logout
            .drive()
            .disposed(by: disposeBag)
        
        output.reposResults
            .drive(tableView.rx.items(cellIdentifier: RepoTableViewCell.className, cellType: RepoTableViewCell.self)) { (row, element, cell) in
                print("ELEMENT", element.name)
                cell.viewModel = element
            }.disposed(by: disposeBag)
        
        
        output.openHistory
            .drive()
            .disposed(by: disposeBag)
        
        output.emptyResults
            .drive(emptyResultBinder)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        showNavigationBar()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "Search"
        
        rightNavBtn = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath")?.withTintColor(.white), style: .plain, target: self, action: nil)
        self.navigationItem.setRightBarButton(rightNavBtn, animated: true)
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = false
        searchController.searchBar.placeholder = "Enter repo name"
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    var emptyResultBinder: Binder<Bool> {
        return Binder(self) { view, isEmpty  in
            view.tableView.isHidden = isEmpty
            view.noResultsLbl.isHidden = !isEmpty
        }
    }
}
