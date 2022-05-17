import Foundation
import RxSwift

protocol MenuSegmentedControllViewModelDelegate: AnyObject {
    func segmentedControlTapped(_ currentSelectedButton: MenuSegmentedControlViewModel.MenuButton)
}

final class MenuSegmentedControlViewModel {
    // MARK: - Nested Types
    enum MenuButton {
        case table
        case grid
    }
    
    struct Input {
        let gridButtonDidTap: Observable<Void>
        let tableButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let selectedGridButton: Observable<Void>
        let selectedTableButton: Observable<Void>
    }
    
    // MARK: - Properties
    weak var delegate: MenuSegmentedControllViewModelDelegate?
    private(set) var currentSelectedButton: MenuButton = .grid
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let selectedGridButton = configureSelectedGridButtonObserver(inputObservable: input.gridButtonDidTap)
        let selectedTableButton = configureSelectedTableButtonObserver(inputObservable: input.tableButtonDidTap)
        
        let output = Output(selectedGridButton: selectedGridButton,
                            selectedTableButton: selectedTableButton)
        
        return output
    }
    
    private func configureSelectedGridButtonObserver(inputObservable: Observable<Void>) -> Observable<Void> {
        return inputObservable
            .map { [weak self] _ in
                if self?.currentSelectedButton == .table {
                    self?.delegate?.segmentedControlTapped(.grid)
                }
                self?.currentSelectedButton = .grid
            }
    }
    
    private func configureSelectedTableButtonObserver(inputObservable: Observable<Void>) -> Observable<Void> {
        inputObservable
            .map { [weak self] _ in
                if self?.currentSelectedButton == .grid {
                    self?.delegate?.segmentedControlTapped(.table)
                }
                self?.currentSelectedButton = .table
            }
    }
}
