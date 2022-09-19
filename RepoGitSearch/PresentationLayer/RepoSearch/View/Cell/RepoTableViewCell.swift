import UIKit
import RxSwift

class RepoTableViewCell: UITableViewCell {

    @IBOutlet private var nameLbl: UILabel!
   
    var viewModel: RepoCellViewModel! {
        didSet {
            self.nameLbl.text = viewModel.name
        }
    }
    
}
