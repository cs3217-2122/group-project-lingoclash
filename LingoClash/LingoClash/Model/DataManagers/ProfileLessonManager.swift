//
//  ProfileLessonManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 9/4/22.
//

import PromiseKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileLessonManager: DataManager<ProfileLessonData> {

    init() {
        super.init(resource: DataManagerResources.profileLessons)
    }

    func getOne(lessonId: Identifier, profileId: Identifier) -> Promise<ProfileLessonData> {
        return firstly { () -> Promise<[ProfileLessonData]> in
            let profileLessonDatas = self.getManyReference(target: "profile_id", id: profileId)
            let filtered = profileLessonDatas.filterValues { profileLessonData in
                profileLessonData.lesson_id == lessonId
            }
            return filtered
        }.compactMap { profileLessonDatas in
            guard !profileLessonDatas.isEmpty else {
                return nil
            }

            return profileLessonDatas[0]
        }
    }
}
