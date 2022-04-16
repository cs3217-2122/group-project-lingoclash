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
        let db = Firestore.firestore()
        return ProfileManager().getCurrentProfileData().then { profileData -> Promise<[ProfileLessonData]> in
            let profileLessonDatas = self.getManyReference(target: "profile_id", id: profileData.id)
            let filtered = profileLessonDatas.filterValues { profileLessonData in
                profileLessonData.lesson_id == lessonId
            }
            return filtered
//            Promise<[ProfileLessonData]> { seal in
//                db.collection(DataManagerResources.profileLessons).whereField("profile_id", in: [profileData.id])
//                    .getDocuments { querySnapshot, error in
//                        if let error = error {
//                            return seal.reject(DataManagerError.dataNotFound)
//                        }
//
//                        guard let querySnapshot = querySnapshot else {
//                            return seal.reject(DataManagerError.dataNotFound)
//
//                        }
//
//                        let dataList: [ProfileLessonData] = querySnapshot.documents.compactMap { document -> ProfileLessonData? in
//                            var documentData = document.data()
//                            documentData["id"] = document.documentID
//
//                            let data = try? JSONSerialization.data(withJSONObject: self.processDocumentData(documentData))
//                            do {
//                                let model = try JSONDecoder().decode(ProfileLessonData.self, from: data ?? Data())
//                                let hi = model
//                                return model
//
//                            } catch {
//                                assert(false)
//                                return nil
//                            }
//
//                        }
//
//                        return seal.fulfill(dataList)
//
//                    }
//                .filterValues { profileLessonData in
//                profileLessonData.lesson_id == lessonId
        }.compactMap { profileLessonDatas in
            guard !profileLessonDatas.isEmpty else {
                return nil
            }

            return profileLessonDatas[0]
        }
    }
}
