//
//  ViewController.swift
//  IMDBClone
//
//  Created by Mina on 02/02/2023.
//

import UIKit

class MoviesTableViewController: UIViewController {

    @IBOutlet private weak var moviesTableView: UITableView!{
        didSet {
            moviesTableView.delegate = self
            moviesTableView.dataSource = self
        }
    }
    
    private var movies = [Movie]()
    private lazy var viewModel: MoviesTableViewModel = {
            return MoviesTableViewModel()
        }()
    
    @IBOutlet private weak var sortYearButton: UIButton!
    @IBOutlet private weak var sortRateButton: UIButton!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        initVM()
    }
    
    private func initView() {
        registerNibFile()
    }
        
    private func initVM() {
            
        viewModel.showAlertClosure = { [weak self] () in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert( message )
            }
        }

        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else { return }
            
            switch self.viewModel.state {
            case .empty, .error:
                self.hideProgress()
            case .loading:
                self.showprogress()
            case .populated:
                self.hideProgress()
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] moviesData in
            guard let self = self else { return }
            if let moviesData = moviesData {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.movies = moviesData
                    self.moviesTableView.tableFooterView = nil
                    self.moviesTableView.reloadData()
                }
            }
        }
        
        viewModel.fetchMovies(appDelegate: appDelegate)
        sortMoviesByYear()
    }
    
    private func registerNibFile() {
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
        
    @IBAction private func sortMoviesByYear(_ sender: UIButton) {
        changeButtonTextColor()
        sortMoviesByYear()
    }
    
    private func sortMoviesByYear() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.viewModel.sortMoviesByYear()
        }
    }
    
    @IBAction private func sortMoviesByRate(_ sender: UIButton) {
        changeButtonTextColor()
        viewModel.sortMoviesByRate()
    }
    
    private func sortMoviesByRate() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.viewModel.sortMoviesByRate()
        }
    }
    
    private func changeButtonTextColor() {
        sortYearButton.tintColor = sortYearButton.state.rawValue == 1 ? UIColor(hex: "#88A4E8") : UIColor(.black)
        sortRateButton.tintColor = sortRateButton.state.rawValue == 1 ? UIColor(hex: "#88A4E8") : UIColor(.black)
    }
}

extension MoviesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none
        cell.configureCell(movie: movies[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == moviesTableView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                moviesTableView.tableFooterView = createSpinnerFooter()
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.setPaginationMovies()
                }
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}
