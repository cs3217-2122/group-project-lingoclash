//
//  QueueEntryDataManager.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

class QueueEntryDataManager: DataManager<QueueEntry> {

    init() {
        super.init(resource: DataManagerResources.queueEntries)
    }
}
