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

    // converts from firebase types to swift types
    private func processDocumentData(_ documentData: [String: Any]) -> [String: Any] {
        var newDocumentData = documentData
        newDocumentData.forEach { (key: String, value: Any) in
            switch value {
            case is DocumentReference:
                newDocumentData.removeValue(forKey: key)
            case let ts as Timestamp:
                let date = ts.dateValue()

                let jsonValue = Int((date.timeIntervalSince1970 * 1_000).rounded())
                newDocumentData[key] = jsonValue
            default:
                break
            }
        }
        return newDocumentData
    }

    func getOneCurrentUser(lessonId: Identifier) -> Promise<ProfileLessonData> {
        ProfileManager().getCurrentProfileData().then { profileData -> Promise<[ProfileLessonData]> in
            let profileLessonDatas = self.getManyReference(target: "profile_id", id: profileData.id)
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
