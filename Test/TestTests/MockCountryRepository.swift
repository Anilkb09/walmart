import XCTest
@testable import Test

class MockCountryRepository: CountryRepositoryProtocol {
    
    var shouldReturnError = false
    var mockCountries: [Country] = [
        Country(name: "United States", region: "North America", code: "US", capital: "Washington, D.C."),
        Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa"),
        Country(name: "France", region: "Europe", code: "FR", capital: "Paris")
    ]
    
    func getCountries() async throws -> [Country] {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        }
        return mockCountries
    }
}
