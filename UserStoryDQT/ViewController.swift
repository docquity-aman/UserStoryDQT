//
//  ViewController.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 12/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cvContainer: UIView!
    private var  collectionView: UICollectionView?
    private var viewModel: HomeViewModel!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        configureData()
    }
    
    func configureView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator =  false
        collectionView?.dataSource = self
        collectionView?.delegate = self
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .vertical
//        }
        collectionView?.register(homeCVC.self, forCellWithReuseIdentifier: homeCVC.identifier)
//        collectionView?.backgroundColor = .green
        guard let collectionView = self.collectionView else {
            return
        }
        cvContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: cvContainer.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: cvContainer.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: cvContainer.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: cvContainer.trailingAnchor, constant: 0)
        ])
        
    }
    override func viewDidLayoutSubviews() {
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150).integral
    }
    
    func configureData() {
        viewModel = HomeViewModel.init()
    }


}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.storyModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCVC.identifier, for: indexPath) as? homeCVC else{
            return UICollectionViewCell()
        }
        if let story = viewModel.storyModel?[indexPath.row]{
            cell.cellViewModel = homeCVCM.init(storyModel: (viewModel.getCellFromViewModel(indexPath: indexPath)))
            return cell
        }
        return UICollectionViewCell()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected ", indexPath.row)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "Main") as! StoryViewController
//        vc.create(storyModel: (viewModel.storyModel?[indexPath.item])!,stories: viewModel.storyModel, indexPath: indexPath)
//        vc.modalPresentationStyle = .fullScreen
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! ContentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.pages = self.viewModel.storyModel!
        vc.currentIndex = indexPath.row
        self.present(vc, animated: true, completion: nil)
    
    }
    
    
}





