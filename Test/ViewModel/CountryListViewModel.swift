import Foundation
import Combine

@MainActor
class CountryListViewModel: ObservableObject {
    
    private let repository: CountryRepositoryProtocol
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var errorMessage: String? 
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCountries() async {
        do {
            let fetchedCountries = try await repository.getCountries()
            self.countries = fetchedCountries
            self.filteredCountries = fetchedCountries
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func filterCountries(query: String) {
        if query.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { country in
                country.name.lowercased().contains(query.lowercased()) ||
                country.capital.lowercased().contains(query.lowercased())
            }
        }
    }
}
