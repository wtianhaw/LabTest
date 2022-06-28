//
//  BaseViewModel.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation
import Combine
import KafkaRefresh

class BaseViewModel {
    @Published var loading: Bool = false
    @Published var headLoading: Bool = false
    @Published var footLoading: Bool = false

    var cancellables: [AnyCancellable] = []
    var page: Int = 1
    var totalPage: Int = 1
    var totalNumber: Int = 0
    var isNotfirstPage: Bool = false
    private var retryTrigger = PassthroughSubject<Void, Never>()
    
    init() {
        self.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    LoadingManager.shared.show()
                }else {
                    LoadingManager.shared.hide()
                }
            })
            .store(in: &self.cancellables)
        
    }
    
    func checkResponse(stat: Bool, code: Int = -1, msg: String = "", success: @escaping () -> Void) {
        if stat {
            success()
        }else {
            self.showError(error: APIServiceError.apiError, msg: msg)
        }
    }
    
    func showError(error: Error, msg: String = "", path: String = "", duration: TimeInterval = 1.5) {
        var msg:String = msg
        if !path.isEmpty {
            msg = "Something went wrong in \(msg)\n[\(path)]"
        }
        
        MsgManager.shared.show(msg: msg, duration: duration)
    }
    
    func isValidPage() -> Bool {
        if self.page < self.totalPage {
            return true
        }
        self.footLoading = false
        return false
    }

}


// MARK: Bindings
extension BaseViewModel {
    
    func bindApiService<T: APIRequestType>(request: T, apiService: APIService, trigger: PassthroughSubject<Void, Never>, success: @escaping (T.Response) -> Void) {
        trigger.flatMap { [apiService] _ in
            apiService.response(from: request)
                .catch { [weak self] error -> Empty<T.Response, Never> in
                    apiService.apiLoading.loading = false
                    self?.showError(error: error, path: request.path)
                    return .init()
                }
        }
        #if DEV
        .print()
        #endif
        .sink(receiveValue: { [weak self] data in
            guard let `self` = self else { return }
            self.retryTrigger = trigger
            success(data)
        })
        .store(in: &self.cancellables)
    }
    
    func bindHeaderRefreshCtrl(_ ctrl: KafkaRefreshControl) {
        self.$headLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    ctrl.beginRefreshing()
                }else {
                    ctrl.endRefreshing()
                }
            })
            .store(in: &self.cancellables)
    }
    
    func bindFooterRefreshCtrl(_ ctrl: KafkaRefreshControl) {
        self.$footLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    ctrl.beginRefreshing()
                }else {
                    ctrl.endRefreshing()
                }
            })
            .store(in: &cancellables)
    }
    
    func bindLoading(loading: ApiLoading) {
        loading.$loading
        .receive(on: DispatchQueue.main)
        .assign(to: \.self.loading, on: self)
        .store(in: &self.cancellables)
    }
    
    func bindTableLoading(loading: ApiLoading) {
        loading.$loading
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] loading in
            guard let `self` = self else { return }
            
            if self.isNotfirstPage {
                self.footLoading = loading
            }else {
                self.headLoading = loading
            }
            
        })
        .store(in: &self.cancellables)
    }
    
}
