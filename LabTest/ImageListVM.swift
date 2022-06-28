//
//  ImageListVM.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation
import Combine

final class ImageListVM: BaseViewModel, ObservableObject {
    
    private lazy var request: ImageListRequest = {
        return ImageListRequest()
    }()
    
    // MARK: Input
    private let listSubject = PassthroughSubject<Void, Never>()
    
    enum Input {
        case list
        case getMoreData
    }
    
    func apply(_ input: Input) {
        switch input {
        case .list:
            self.page = 1
            self.isNotfirstPage = false
            self.request.params = ["page" : "\(self.page)", "limit" : "10"]
            self.listSubject.send(())
        case .getMoreData:
            self.page += 1
            self.isNotfirstPage = true
            self.request.params = ["page" : "\(self.page)", "limit" : "10"]
            self.listSubject.send(())
        }
    }
    
    // MARK: Output
    @Published var searchResultList: [ImageListItem] = []
    let responseSubject = PassthroughSubject<ImageListResponse, Never>()
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
        
        self.bindApiService(request: self.request, apiService: self.apiService, trigger: self.listSubject) { [weak self] data in
            guard let `self` = self else { return }
            self.responseSubject.send(data)
        }
        
    }
    
    private func bindOutputs() {
        self.responseSubject
            .print()
            .map {
                if self.isNotfirstPage {
                    let new: [ImageListItem] = $0.list
                    self.searchResultList += new
                }else {
                    self.searchResultList = $0.list
                    self.footLoading = false
                }
                return self.searchResultList
            }
            .assign(to: \.self.searchResultList, on: self)
            .store(in: &self.cancellables)
    }
    
}
