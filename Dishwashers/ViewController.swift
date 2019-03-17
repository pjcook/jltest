//
//  ViewController.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? ProductListViewController
        else { return }
        vc.viewModel = ProductListViewModel(apiService: APIService(configuration: Configuration(), session: URLSession(configuration: .default)))
        vc.viewModel.delegate = vc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "launchProductList", sender: nil)
    }
}

