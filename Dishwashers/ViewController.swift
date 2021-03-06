//  Copyright © 2019 Software101. All rights reserved.

import UIKit

class ViewController: UIViewController {
    var apiService: APIServiceProtocol = APIService(configuration: Configuration(), session: URLSession(configuration: .default))

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard
            let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? ProductListViewController
        else { return }
        vc.viewModel = ProductListViewModel(apiService: apiService)
        vc.viewModel.delegate = vc
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "launchProductList", sender: nil)
    }
}
