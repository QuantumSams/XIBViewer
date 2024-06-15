import UIKit

final class AccountVC: UIViewController {

    //Property
    
    
    //Outlet
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lifecycle
        setupViews()
    }
    
    //Action - event processing
}

//Extenions - private methods

extension AccountVC{
    
    private func setupViews(){
        displayNavigationTitle()
    }
    
    
    private func displayNavigationTitle(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
    }
    
}
