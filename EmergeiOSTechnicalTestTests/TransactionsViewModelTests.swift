//
//  TransactionsViewModelTests.swift
//  EmergeiOSTechnicalTestTests
//
//  Created by Eduardo Dias on 21/08/2025.
//

import Combine
import Testing
import Foundation

@testable import EmergeiOSTechnicalTest

@MainActor
struct TransactionsViewModelTests {

    @Test
    func initialState() {
        
        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        #expect(viewModel.transactions.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.selectedTransaction == nil)
    }

    @Test
    func loadTransactionsSuccess() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let expectedTransactions = [
            TransactionData.mock(id: "1", amount: 100.0),
            TransactionData.mock(id: "2", amount: 200.0)
        ]

        mockRepository.getEnrichedTransactionsResult = .success(expectedTransactions)

        var loadingStates: [Bool] = []

        let cancellable = viewModel.$isLoading.sink { loadingStates.append($0) }

        await viewModel.loadTransactions()

        #expect(viewModel.transactions == expectedTransactions)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(mockRepository.getEnrichedTransactionsCallCount == 1)

        #expect(loadingStates == [false, true, false])

        cancellable.cancel()
    }

    @Test
    func loadTransactionsFailure() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        mockRepository.getEnrichedTransactionsResult = .failure(TestError.networkError)

        await viewModel.loadTransactions()

        #expect(viewModel.transactions.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == "Transactions were not able to load")
        #expect(mockRepository.getEnrichedTransactionsCallCount == 1)
    }

    @Test
    func loadTransactionsWithSuppressLoading() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let expectedTransactions = [TransactionData.mock(id: "1")]
        mockRepository.getEnrichedTransactionsResult = .success(expectedTransactions)

        var loadingStates: [Bool] = []
        let cancellable = viewModel.$isLoading.sink { loadingStates.append($0) }

        await viewModel.loadTransactions(suppressLoading: true)

        #expect(viewModel.transactions == expectedTransactions)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)

        #expect(loadingStates == [false])

        cancellable.cancel()
    }

    @Test
    func loadTransactionsClearsPreviousError() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        viewModel.error = .transactionApprovalError
        let expectedTransactions = [TransactionData.mock(id: "1")]
        mockRepository.getEnrichedTransactionsResult = .success(expectedTransactions)

        await viewModel.loadTransactions()

        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func approveTransactionSuccess() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let transaction = TransactionData.mock(id: "1")
        let updatedTransactions = [TransactionData.mock(id: "1", approved: true)]

        mockRepository.approveTransactionResult = .success(())
        mockRepository.getEnrichedTransactionsResult = .success(updatedTransactions)

        var loadingStates: [Bool] = []
        let cancellable = viewModel.$isLoading.sink { loadingStates.append($0) }

        viewModel.approveTransaction(transaction)

        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        #expect(viewModel.transactions == updatedTransactions)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(mockRepository.approveTransactionCallCount == 1)
        #expect(mockRepository.getEnrichedTransactionsCallCount == 1)

        #expect(loadingStates.contains(true))
        #expect(loadingStates.last == false)

        cancellable.cancel()
    }

    @Test
    func approveTransactionApprovalFailure() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let transaction = TransactionData.mock(id: "1")
        mockRepository.approveTransactionResult = .failure(TestError.networkError)

        viewModel.approveTransaction(transaction)

        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == "Transaction approval failed")
        #expect(mockRepository.approveTransactionCallCount == 1)
        #expect(mockRepository.getEnrichedTransactionsCallCount == 0)
    }

    @Test
    func approveTransactionLoadFailureAfterApprovalSuccess() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let transaction = TransactionData.mock(id: "1")
        mockRepository.approveTransactionResult = .success(())
        mockRepository.getEnrichedTransactionsResult = .failure(TestError.networkError)

        viewModel.approveTransaction(transaction)

        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == "Transactions were not able to load")
        #expect(mockRepository.approveTransactionCallCount == 1)
        #expect(mockRepository.getEnrichedTransactionsCallCount == 1)
    }

    @Test
    func approveTransactionClearsErrorOnStart() async {

        let mockRepository = MockTransactionRepository()
        let viewModel = TransactionsViewModel(repository: mockRepository)

        let transaction = TransactionData.mock(id: "1")
        viewModel.error = .transactionApprovalError
        mockRepository.approveTransactionResult = .success(())
        mockRepository.getEnrichedTransactionsResult = .success([])

        viewModel.approveTransaction(transaction)

        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds

        #expect(viewModel.errorMessage == nil)
    }
}


// MARK: - Mocks

final class MockTransactionRepository: TransactionRepositoryProtocol {

    var getTransactionsResult: Result<[TransactionData], Error> = .success([])
    var getTransactionsCallCount = 0

    var approveTransactionResult: Result<Void, Error> = .success(())
    var approveTransactionCallCount = 0
    var approveTransactionLastTransaction: TransactionData?

    var getCategoriesResult: Result<[CategoryData], Error> = .success([])
    var getCategoriesCallCount = 0

    var getEnrichedTransactionsResult: Result<[TransactionData], Error> = .success([])
    var getEnrichedTransactionsCallCount = 0

    func getTransactions() async throws -> [TransactionData] {
        getTransactionsCallCount += 1
        return try getTransactionsResult.get()
    }

    func approveTransaction(transaction: TransactionData) async throws {
        approveTransactionCallCount += 1
        approveTransactionLastTransaction = transaction
        return try approveTransactionResult.get()
    }

    func getCategories() async throws -> [CategoryData] {
        getCategoriesCallCount += 1
        return try getCategoriesResult.get()
    }

    func getEnrichedTransactions() async throws -> [TransactionData] {
        getEnrichedTransactionsCallCount += 1
        return try getEnrichedTransactionsResult.get()
    }
}

// MARK: - Test Helpers

private enum TestError: Error {
    case networkError
    case unknownError
}

private extension TransactionData {

    static func mock(
        id: String,
        amount: Double = 100.0,
        description: String = "Test Transaction",
        categoryId: String = "cat1",
        date: TimeInterval = Date().timeIntervalSince1970,
        approved: Bool = false,
        categoryName: String? = "Test Category"
    ) -> TransactionData {

        TransactionData(
            id: id,
            amount: amount,
            description: description,
            categoryId: categoryId,
            date: date,
            approved: approved,
            categoryName: categoryName
        )
    }
}

private extension CategoryData {
    static func mock(id: String, name: String = "Test Category") -> CategoryData {
        CategoryData(id: id,name: name)
    }
}
