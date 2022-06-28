//
//  ImageDetailVM.swift
//  LabTest
//
//  Created by Wong Tian Haw on 27/06/2022.
//

import Foundation
import Combine

final class ImageDetailVM: BaseViewModel, ObservableObject {
    
    private lazy var request: ImageDetailRequest = {
        return ImageDetailRequest()
    }()
    
    var model: ImageListItem?
    var blurRatio: Int = 1
    
    // MARK: Input
    private let detailSubject = PassthroughSubject<Void, Never>()
    
    enum Input {
        case list
        case normal
        case grayscale
        case blur
        case getMoreData
    }
    
    func apply(_ input: Input) {
        guard let model = model, let id = model.id else {
            return
        }
        
        switch input {
        case .list:
            self.page = 1
            self.isNotfirstPage = false
            self.request.params = ["page" : "\(self.page)", "limit" : "10"]
            self.detailSubject.send(())
        case .getMoreData:
            self.page += 1
            self.isNotfirstPage = true
            self.request.params = ["page" : "\(self.page)", "limit" : "10"]
            self.detailSubject.send(())
        case .normal:
            self.outputSubject.send(model.downloadURL ?? "")
        case .grayscale:
            //            self.outputSubject.send(String(format: "%@?%@", model.downloadURL ?? "", "grayscale"))
            
            self.request.path = String(format: "%@?%@", model.downloadURL ?? "", "grayscale")
            self.detailSubject.send(())
        case .blur:
            self.request.path = String(format: "%@?%@=%@", model.downloadURL ?? "", "blur", "\(blurRatio)")
            self.detailSubject.send(())
            //            self.outputSubject.send(String(format: "%@?%@=%@", model.downloadURL ?? "", "blur", "\(blurRatio)"))
        }
    }
    
    // MARK: Output
    @Published var newUrl: String = ""
    let responseSubject = PassthroughSubject<ImageDetailResponse, Never>()
    let outputSubject = PassthroughSubject<String, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private lazy var apiService: APIService = {
        return APIService()
    }()
    
    override init() {
        super.init()
        
        self.bindInputs()
        self.bindOutputs()
    }
    
    private func bindInputs() {
        self.bindTableLoading(loading: self.apiService.apiLoading)
        
        self.bindApiService(request: self.request, apiService: self.apiService, trigger: self.detailSubject) { [weak self] data in
            guard let `self` = self else { return }
            self.responseSubject.send(data)
        }
        
    }
    
    private func bindOutputs() {
        self.responseSubject
            .print()
            .map {url in
                return url.data ?? ""
            }
            .assign(to: \.self.newUrl, on: self)
            .store(in: &self.cancellables)
        
        
        self.outputSubject
            .print()
            .map {url in
                return url
            }
            .assign(to: \.self.newUrl, on: self)
            .store(in: &self.cancellables)
        
    }
    
}
