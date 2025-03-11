import XCTest
@testable import Test

@MainActor
class CountryListViewModelTests: XCTestCase {
    
    var mockRepository: MockCountryRepository!
    var viewModel: CountryListViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        viewModel = CountryListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() async {
        // When
        await viewModel.fetchCountries()
        
        // Then
        XCTAssertEqual(viewModel.countries.count, 3)
        XCTAssertEqual(viewModel.filteredCountries.count, 3)
    }
    
    func testFetchCountriesFailure() async {
        // Given
        mockRepository.shouldReturnError = true
        
        // When
        await viewModel.fetchCountries()
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testFilterCountriesByName() async {
        // Given
        await viewModel.fetchCountries()
        
        // When
        viewModel.filterCountries(query: "Canada")
        
        // Then
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Canada")
    }
    
    func testFilterCountriesByCapital() async {
        await viewModel.fetchCountries()
        
        viewModel.filterCountries(query: "Paris")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.capital, "Paris")
    }
    
    func testFilterCountriesWithNoMatch() async {
        await viewModel.fetchCountries()
        
        viewModel.filterCountries(query: "XYZ")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 0)
    }
}
