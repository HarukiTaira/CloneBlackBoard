import UIKit
import RealmSwift
import SwiftyJSON
import SideMenu
import CropViewController
import DZNEmptyDataSet

 var googleAPIKey = APIkey

class ListViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CropViewControllerDelegate{
    
    var itemList: [TodoRealm] = []
    var selectedImage:UIImage!
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    var detailList : [String]=[]
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    let cellHeigh:CGFloat = 103
    let session = URLSession.shared
    
    @IBOutlet var detailTableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.emptyDataSetSource = self
        detailTableView.emptyDataSetDelegate = self
        
        //カスタムセルの登録
        detailTableView.register(UINib(nibName: "CustomCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
        
        detailTableView.refreshControl = refreshCtl
              refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        //線消し
        detailTableView.tableFooterView = UIView()
        setupSideMenu()
//        self.detailTableView.reloadData()
        
        //        let realm = try! Realm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        loadData()
        sender.endRefreshing()
    }
    
    private func loadData(){
        itemList = TodoRealm.loadAll() ?? []
        detailTableView.reloadData()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.itemList.count == nil{
            return 0
        }else{
            return self.itemList.count
        }
    }
    //MARK:cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        let customMemo:TodoRealm = self.itemList[indexPath.row]
        cell.titleLabel.text = customMemo.title
        cell.memoImage.image = customMemo.image
        cell.timeLabel.text = customMemo.time
        return cell
    }
    
    //MARK:didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
//        print(itemList[indexPath.row].title)
//        print(itemList[indexPath.row].detail)
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let nextView = storyboard.instantiateViewController(withIdentifier: "pagingMenuViewController") as! PagingMenuViewController
        nextView.passedTitle = itemList[indexPath.row].title
        nextView.passedDetail = itemList[indexPath.row].detail
        nextView.passedSaveImage = itemList[indexPath.row].image
        nextView.passedID = itemList[indexPath.row].id
        nextView.isNew = false
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        self.show(nextView, sender: nil)
    }
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        

        let selectedId = self.itemList[indexPath.row].id
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.itemList[indexPath.row])
                }
//                print(itemList)
                self.itemList.remove(at: indexPath.row)
//                self.itemList = itemList.filter { (item) -> Bool in
//                    return item.id != selectedId
//                }
                
                detailTableView.deleteRows(at: [indexPath], with:UITableView.RowAnimation.fade)
                
//                self.itemList = TodoRealm.loadAll() ?? []
                self.detailTableView.reloadData()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        // セルの高さを設定
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            tableView.estimatedRowHeight = 100
            return UITableView.automaticDimension
        }
    }
    
    //MARK:Alert
    
    @IBAction func Alert(sender: UIButton){
        let alert : UIAlertController = UIAlertController(title: "写真", message: "以下から選択して下さい", preferredStyle: .actionSheet)
    
        let cameraAction = UIAlertAction(title: "カメラ起動", style: .default) { (UIAlertAction) in
            let sourceType:UIImagePickerController.SourceType =
                UIImagePickerController.SourceType.camera
            // カメラが利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerController.SourceType.camera){
                // インスタンスの作成
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            }
            else{
                print("error")
                
            }
        }
        
        let photoAction = UIAlertAction(title: "アルバムから", style: .default) { (UIAlertAction) in
            let sourceType:UIImagePickerController.SourceType =
                UIImagePickerController.SourceType.photoLibrary
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerController.SourceType.photoLibrary){
                // インスタンスの作成
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            }
            else{
                print("error")
                
            }
            
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel){
            (action) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:setupSideMenu
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
}

//MARK:分析
extension ListViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            do {
                // Use SwiftyJSON to parse results
                let json = try JSON(data: dataToParse)
                let errorObj: JSON = json["error"]
                
                if (errorObj.dictionaryValue != [:]) {
                    //                    self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
                } else {
                    // Parse the response
                    //                    print("sss\(json)")
                    let responses: JSON = json["responses"][0]
                    
                    // Get label annotations
                    let labelAnnotations: JSON = responses["textAnnotations"]
                    let numLabels: Int = labelAnnotations.count
                    var labels: Array<String> = []
                    if numLabels > 0 {
                        var labelResultsText:String = "Labels found: "
                        for index in 0..<numLabels {
                            let label = labelAnnotations[index]["description"].stringValue
                            labels.append(label)
                        }
                        for label in labels {
                            // if it's not the last item add a comma
                            if labels[labels.count - 1] != label {
                                labelResultsText += "\(label), "
                            } else {
                                labelResultsText += "\(label)"
                            }
                        }
                        //MARK:値渡し
                        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                        let nextView = storyboard.instantiateViewController(withIdentifier: "pagingMenuViewController") as! PagingMenuViewController
                        nextView.passedText = labelResultsText
                        nextView.passedImage = self.selectedImage
            
                        self.show(nextView,sender: nil)
                        
                    } else {
                        let alert = UIAlertController(title: "注意", message: "写真から文字が検出されません", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (_) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
            } catch let jsonError {
            }
            
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            
            
            let cropController = CropViewController(croppingStyle: croppingStyle, image: pickedImage)
            cropController.delegate = self
            
            self.selectedImage = pickedImage
            
            if croppingStyle == .circular {
                if picker.sourceType == .camera {
                    picker.dismiss(animated: true, completion: {
                        self.present(cropController, animated: true, completion: nil)
                    })
                } else {
                    picker.pushViewController(cropController, animated: true)
                }
            }
            else { //otherwise dismiss, and then present from the main controller
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                    //self.navigationController!.pushViewController(cropController, animated: true)
                })
            }
            
            
        }
//        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        let binaryImageData = base64EncodeImage(self.selectedImage)
        createRequest(with: binaryImageData)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        selectedImage = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


//MARK: Networking
extension ListViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "DOCUMENT_TEXT_DETECTION",
                        //"maxResults": 10
                    ],
                ]
            ]
        ]
        
        do {
            let jsonObject = try JSONSerialization.data(withJSONObject: jsonRequest)
            
            
            request.httpBody = jsonObject
            
            // Run the request on a background thread
            DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
        } catch let jsonError {
            print(jsonError.localizedDescription)
        }
        
        
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
//MARK:SideMenu
//extension ListViewController: SideMenuNavigationControllerDelegate {
//    
//    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
//    }
//    
//    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
//    }
//    
//    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
//    }
//    
//    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
//    }
//}
//MARK:Empty
extension ListViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "art-track.png")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "履歴はありません"
        let font = UIFont.boldSystemFont(ofSize: 18)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor : UIColor.black])
        
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "写真を撮って新しく読み取ってみましょう"
        let font = UIFont.systemFont(ofSize: 14)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}
