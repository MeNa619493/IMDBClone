//
//  ViewController.swift
//  IMDBClone
//
//  Created by Mina on 02/02/2023.
//

import UIKit
import ProgressHUD

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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
                self.movies = moviesData
                self.moviesTableView.tableFooterView = nil
                self.moviesTableView.reloadData()
            }
        }
        
        viewModel.fetchMovies(appDelegate: appDelegate)
        viewModel.sortMoviesByYear()
    }
    
    private func registerNibFile() {
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
        
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showprogress() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show()
    }
    
    private func hideProgress() {
        ProgressHUD.dismiss()
    }
    
    @IBAction func sortMoviesByYear(_ sender: UIButton) {
        changeButtonTextColor()
        viewModel.sortMoviesByYear()
    }
    
    @IBAction func sortMoviesByRate(_ sender: UIButton) {
        changeButtonTextColor()
        viewModel.sortMoviesByRate()
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.setPaginationMovies()
                }
            }
        }
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

