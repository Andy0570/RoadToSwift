/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Combine

struct LineStatusModel: Identifiable {
    let id: String
    let displayName: String
    let status: TFLLineStatus
    let color: Color
}

struct TubeStatusModel {
    let lastUpdated: String
    let linesStatus: [LineStatusModel]
}

enum TubeStatusViewModelAction {
    case fetchCurrentStatus
}

final class TubeStatusViewModel: ObservableObject {
    let tubeLinesStatusFetcher: TubeLinesStatusFetcher
    let dateFormatter = DateFormatter()
    
    // MARK: - Publishers
    @Published var tubeStatusState: Loading<TubeStatusModel>
    
    var cancellable: AnyCancellable?
    
    init(tubeLinesStatusFetcher: TubeLinesStatusFetcher) {
        self.tubeLinesStatusFetcher = tubeLinesStatusFetcher
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        tubeStatusState = .loading(
            TubeStatusModel(lastUpdated: "", linesStatus: [])
        )
    }
    
    // MARK: Actions
    
    func perform(action: TubeStatusViewModelAction) {
        switch action {
        case .fetchCurrentStatus:
            fetchCurrentStatus()
        }
    }
    
    // MARK: Action handlers
    
    private func fetchCurrentStatus() {
        self.cancellable = tubeLinesStatusFetcher.fetchStatus()
            .sink(receiveCompletion: asyncCompletionErrorHandler) { allLinesStatus in
                DispatchQueue.main.async { [self] in
                    let lastUpdatedDisplayValue: String
                    if let updatedDate = allLinesStatus.lastUpdated {
                        lastUpdatedDisplayValue = dateFormatter.string(from: updatedDate)
                    } else {
                        lastUpdatedDisplayValue = "Unknown"
                    }
                    
                    tubeStatusState = .loaded(
                        TubeStatusModel(
                            lastUpdated: "Last Updated: \(lastUpdatedDisplayValue)",
                            linesStatus: allLinesStatus.linesStatus.compactMap {
                                LineStatusModel(
                                    id: $0.line.name,
                                    displayName: $0.line.name,
                                    status: $0.status,
                                    color: $0.line.color
                                )
                            })
                    )
                }
            }
    }
    
    private func asyncCompletionErrorHandler(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            tubeStatusState = .errored(error)
        case .finished: ()
        }
    }
}
