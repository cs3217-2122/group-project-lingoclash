//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

class BookDataManager {
    
    private let dataProvider: DataProvider
    private let resource = "books"
    
    init(dataProvider: DataProvider = RestProvider(apiURL: Constants.API.baseURL)) {
        self.dataProvider = dataProvider
    }
    
    func getList(
        page: Int,
        perPage: Int = Constants.ListConfig.perPage,
        field: String = Constants.ListConfig.field,
        order: String = Constants.ListConfig.order,
        filter: [String: String] = [:]
    ) -> Promise<[Book]> {
        
        let pagination = PaginationPayload(page: page, perPage: perPage)
        let sort = SortPayload(field: field, order: order)
        let data = dataProvider.getList(resource: self.resource, params: GetListParams(pagination: pagination, sort: sort, filter: filter))
        
        return data.compactMap { listResult in
            try? JSONDecoder().decode(
                [Book].self, from: listResult.data)
        }
        
    }
    
    func getOne() {}
    
    func getMany() {}
    
    func getManyReference() {}
    
    func create() {}
    
    func update() {}
    
    func updateMany() {}
    
    func delete() {}
    
    func deleteMany() {}
    
}
