//
//  ViewController.swift
//  BC_CryptoCurrency
//
//  Created by chvck on 21.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    
    var cryptoList = [Crypto]()
    let disposeBag = DisposeBag()
    
    let cryptoVM = CryptoViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.delegate = self
        //tableView.dataSource = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Hücreyi kaydet
        
        setupBindings()
        cryptoVM.requestData()
       
    }
    
    private func setupBindings() {
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
            //    self.cryptoList = cryptos
            //    self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { error in
                print(error)
            }.disposed(by: disposeBag)
        
   
        cryptoVM
            .loading
            //.bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        cryptoVM
            .loading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { bool in
                print(bool)
            }.disposed(by: disposeBag)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }



}


