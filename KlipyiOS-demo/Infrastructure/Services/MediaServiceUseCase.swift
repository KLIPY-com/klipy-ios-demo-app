protocol MediaServiceUseCase {
    associatedtype Item
    func fetchTrending(page: Int, perPage: Int) async throws -> AnyResponse<Item>
    func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<Item>
}