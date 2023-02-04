//
//  SplashScreenViewController.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import UIKit
import Lottie
import TTGSnackbar

class SplashScreenViewController: UIViewController {

    var animationView: AnimationView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var viewModel: SplashViewModel = {
            return SplashViewModel()
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    private func initView() {
        animationView = .init(name: "movie-play")
        animationView?.frame = view.bounds
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.play()
    }
        
    private func initVM() {

        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else { return }
            
            switch self.viewModel.state {
            case .success:
                self.navigationToNextView()
            case .failed:
                self.animationView?.stop()
                self.showSnackBar()
            case .none:
                self.animationView?.play()
            }
        }
            
        viewModel.fetchMoviesFromApi(appDelegate: appDelegate)
    }
        
    private func showSnackBar() {
        let snackbar = TTGSnackbar(message: "Connection Failed !",duration: .forever)
            
        // Action 1
        snackbar.actionText = "Reload"
        snackbar.actionTextColor = UIColor.white
        snackbar.actionBlock = { (snackbar) in
            self.viewModel.fetchMoviesFromApi(appDelegate: self.appDelegate)
        }

        // Action 2
        snackbar.secondActionText = "Continue"
        snackbar.secondActionTextColor = UIColor.white
        snackbar.secondActionBlock = { [weak self] (snackbar) in
            guard let self = self else { return }
            self.navigationToNextView()
        }
        
        snackbar.show()
    }

    func navigationToNextView() {
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieTableViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
