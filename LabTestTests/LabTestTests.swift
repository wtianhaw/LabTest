//
//  LabTestTests.swift
//  LabTestTests
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import XCTest
import Combine
@testable import LabTest

class LabTestTests: XCTestCase {
    private var cancellables: [AnyCancellable] = []
    private var cancellables2: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageListAPI() throws {
        
        let exp = expectation(description: "fetching image list from API")

        let vm: ImageListVM = ImageListVM()
       
        vm.apply(.list)
        
        vm.responseSubject
            .sink(receiveValue: { [weak self] data in
                guard self != nil else { return }
                XCTAssertNotNil(data)
                XCTAssertTrue(data.list.count > 0)
                exp.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard self != nil else { return }
            print(error?.localizedDescription ?? "error")
        }
    }
    
    func testImageDetailGrayAPI() throws {
        
        let exp = expectation(description: "fetching grayscale from API")
        
        let imageListVM: ImageListVM = ImageListVM()
        imageListVM.apply(.list)
        imageListVM.responseSubject
            .sink(receiveValue: { [weak self] data in
                guard self != nil else { return }
                if let item = data.list.first {
                    let vm: ImageDetailVM = ImageDetailVM()
                    vm.model = item
                    vm.apply(.grayscale)
                    vm.responseSubject
                        .sink(receiveValue: { [weak self] data in
                        guard self != nil else { return }
                        XCTAssertNotNil(data)
                        XCTAssertTrue(data.data != nil)
                        exp.fulfill()
                        }).store(in: &self!.cancellables2)
                }
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard self != nil else { return }
            print(error?.localizedDescription ?? "error")
        }
    }
    
    func testImageDetailBlurAPI() throws {
        
        let exp = expectation(description: "fetching grayscale from API")
        
        let imageListVM: ImageListVM = ImageListVM()
        imageListVM.apply(.list)
        imageListVM.responseSubject
            .sink(receiveValue: { [weak self] data in
                guard self != nil else { return }
                if let item = data.list.first {
                    let vm: ImageDetailVM = ImageDetailVM()
                    vm.model = item
                    vm.blurRatio = 5
                    vm.apply(.grayscale)
                    vm.responseSubject
                        .sink(receiveValue: { [weak self] data in
                        guard self != nil else { return }
                        XCTAssertNotNil(data)
                        XCTAssertTrue(data.data != nil)
                        exp.fulfill()
                        }).store(in: &self!.cancellables2)
                }
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard self != nil else { return }
            print(error?.localizedDescription ?? "error")
        }
    }

}
