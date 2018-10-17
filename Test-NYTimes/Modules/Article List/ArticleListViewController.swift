//
//  ViewController.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 16/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import UIKit

protocol ArticleListView : class {
    func refreshList()
    func showError(error : String)
    func showLoading()
    func hideLoading()
}

class ArticleListViewController: UIViewController {

    var configurator = ArticleListConfiguratorImplementation()
    var viewModel : ArticleListViewModel!
    
    @IBOutlet var tblView : UITableView!
    @IBOutlet var viewError : UIView!
    @IBOutlet var lblError : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configurator.configure(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let articleCell = sender as! ArticleListCellView
        let viewController = segue.destination as! ArticleDetailViewController
        viewController.configurator = viewModel.didSelectIndexpath(articleCell.indexPath)
    }
    
    //MARK:- Actions
    @IBAction func btnTryAgainTapped(){
        viewModel.didTapOnTryAgain()
    }
    
    //MARK:- Private
    private func setupTableView(){
        tblView.estimatedRowHeight = 110
        tblView.rowHeight = UITableViewAutomaticDimension
    }
    
    
}

extension ArticleListViewController : ArticleListView{
    func refreshList(){
        activityIndicator.isHidden = true
        viewError.isHidden = true
        tblView.isHidden = false
        tblView.reloadData()
    }
    
    func showError(error : String){
        lblError.text = error
        viewError.isHidden = false
        activityIndicator.isHidden = true
        tblView.isHidden = true
    }
    
    func showLoading(){
        activityIndicator.isHidden = false
        viewError.isHidden = true
        tblView.isHidden = true
    }
    
    func hideLoading(){
        activityIndicator.isHidden = true
    }
}

extension ArticleListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleListCellViewImplementation
        
        viewModel.displayInformationOnCell(cellView: cell, indexPath: indexPath)
        return cell
    }
}
