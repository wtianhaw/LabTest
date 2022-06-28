//
//  ImageDetailVC.swift
//  LabTest
//
//  Created by Wong Tian Haw on 27/06/2022.
//

import UIKit
import Combine

class ImageDetailVC: BaseViewController {
    
    //    @IBOutlet weak var searchBar: UISearchBar!
    //    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoText: UILabel!
    
    private var model: ImageListItem?
    
    convenience init(model: ImageListItem){
        self.init()
        self.model = model
        self.vm.model = model
    }
    
    private lazy var vm: ImageDetailVM = {
        return ImageDetailVM()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = model?.author ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindVM()
        vm.apply(.normal)
    }
    
    private func setupUI(){
        if let model = model {
            ImageLoadingHelper.loadImageWithUrl(urlString: model.downloadURL ?? "" , imageView: self.imageView, placeHolder:  UIImage(named: "icon_search"))
            
            infoText.text = "ID: \(checkOptionalString(text: model.id))\nwidth: \(checkOptionalString(text: model.width))\nheight: \(checkOptionalString(text: model.height))\nauthor: \(checkOptionalString(text: model.author))\n"
        }
        slider.isContinuous = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        infoView.backgroundColor = .black.withAlphaComponent(0.6)
        infoText.numberOfLines = 0
        
    }
    
    
    private func bindVM(){
        self.vm.$newUrl
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newUrl in
                guard let `self` = self else { return }
                if let imageData = Data(base64Encoded: newUrl) {
                    self.imageView.image = UIImage(data: imageData)
                }
                
                if let url = URL(string: newUrl), let data = try? Data(contentsOf: url) {
                    self.imageView.image = UIImage(data: data)
                }
            })
            .store(in: &self.cancellables)
    }
    
    @IBAction func recurranceChanged(sender: UISegmentedControl?) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            slider.isHidden = true
            vm.apply(.normal)
        case 1:
            slider.isHidden = false
            vm.apply(.blur)
        case 2:
            slider.isHidden = true
            vm.apply(.grayscale)
        default:
            slider.isHidden = true
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        vm.blurRatio = currentValue
        vm.apply(.blur)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        infoView.isHidden = !infoView.isHidden
    }
    
    func checkOptionalString(text: Any?) -> String{
        if let text = text {
            if let string = text as? String {
                return string
            }
            return "\(text)"
        }
        return ""
    }
    
}

