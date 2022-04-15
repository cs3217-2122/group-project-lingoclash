//
//  PKGameOutcomeManager.swift
//  LingoClash
//
//  Created by Sherwin Poh on 15/4/22.
//
import PromiseKit

class PKGamePlayerOutcomeManager: DataManager<PKGamePlayerOutcomeData> {

    init() {
        super.init(resource: DataManagerResources.pkGamePlayerOutcomes)
    }
}
