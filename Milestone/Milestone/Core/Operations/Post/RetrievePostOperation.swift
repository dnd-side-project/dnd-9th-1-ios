//
//  RetrievePostOperation.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

class RetrievePostOperation<T: BindableViewModel & ServicesPost>: NetworkOperation {
    private let viewModel: T
    
    var posts: [Post] = []
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        viewModel.getPost()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    guard let posts = response.posts else {
                        self.requestDidFinish(.decode, success: false)
                        return
                    }
                    
                    self.posts = posts
                    self.requestDidFinish(nil, success: true)
                case .failure(let error):
                    self.requestDidFinish(error, success: false)
                }
            })
            .disposed(by: viewModel.bag)
    }
}
