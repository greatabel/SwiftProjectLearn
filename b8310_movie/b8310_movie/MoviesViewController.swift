//
//  MoviesViewController.swift
//  b8310_movie
//
//  Created by abel on 2020/12/16.
//

import UIKit

//private let reuseIdentifier = "Cell"

class MoviesViewController: UICollectionViewController {
    
    var store: PhotoStore! = PhotoStore()

    let photoDataSource = PhotoDataSource()
    var count: Int = 0
    
    // https://ithelp.ithome.com.tw/articles/10223501
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.dataSource = photoDataSource
        self.collectionView.delegate = self
        updateDataSource()
        
//        let width = (collectionView.bounds.width - 1 * 2) / 3
//        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
//        flowLayout?.itemSize = CGSize(width: width, height: width)
//        flowLayout?.estimatedItemSize = .zero
//
        // Do any additional setup after loading the view.
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addTapped))
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addTapped))
        //
        self.navigationItem.rightBarButtonItem = item1
        
        let itemSpace: CGFloat = 2
        let columnCount: CGFloat = 3
        let inset: CGFloat = 2
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1) - inset * 2) / columnCount)
        flowLayout?.itemSize = CGSize(width: width, height: width*1.5)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    @objc func addTapped() {
        
        store.saveNewPhoto(photoID: String(count), url: "http://clipart-library.com/img/1759126.png")
        count += 1
        print("here tapped count=\(count)")
        // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewDidLoad()
        }
       
//        performSegue(withIdentifier: "showDetail_segue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool){
        print("viewWillAppear")
        self.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail_segue", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        switch segue.identifier {
        case "showDetail_segue"?:
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 8
//    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
////
////        // Configure the cell
////        var imageview:UIImageView=UIImageView(frame: CGRect(x: 50, y: 50, width: 150, height: 222));
////
////        var img : UIImage? = UIImage(named:"movie_reel.png")
////        imageview.image = img
////
////        cell.contentView.addSubview(imageview)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! MovieCell
//
//        // Configure the cell
////        cell.imageView.image = UIImage(named: "pic\(indexPath.item)")
//        cell.imageView.image = UIImage(named: "movie_reel.png")
//
//        return cell
//    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        print("---- here 0 ---")
        let photo = photoDataSource.photos[indexPath.row]
        
//        var default_image : UIImage? = UIImage(named:"movie_reel.png")
        //download image data
         store.fetchImage(for: photo) { (result) -> Void in
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                case let .success(image) = result else {
//                print("---- here 1 ---")
//                if let cell = self.collectionView.cellForItem(at: indexPath) as?
//                    MovieCell {
//                    cell.update(with: default_image)
//                }
//
                return
                
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)

            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as?
                MovieCell {
                cell.update(with: image)
            }
           
            
        }
        
    }
    
    private func updateDataSource() {
        
        store.fetchAllPhotos {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
