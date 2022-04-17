//
//  PKGameDataManager.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import PromiseKit

class PKGameManager: DataManager<PKGameData> {

    init() {
        super.init(resource: DataManagerResources.pkGames)
    }

    func createPKGame(pkGameData: PKGameData) -> Promise<PKGame> {
        firstly {
            create(newRecord: pkGameData)
        }.then { [self] pkGameData -> Promise<PKGame> in
            self.getPKGame(id: pkGameData.id)
        }
    }

    func getPKGame(id: Identifier) -> Promise<PKGame> {
        let profileManager = ProfileManager()
        return firstly {
            getOne(id: id)
        }.then { pkGameData -> Promise<PKGame> in
            var playerProfilesPromises: [Promise<Profile>] = []
            for playerProfileData in pkGameData.players {
                let playerProfilePromise = profileManager.getProfile(id: playerProfileData.id)
                playerProfilesPromises.append(playerProfilePromise)
            }
            return when(fulfilled: playerProfilesPromises).map { playerProfiles -> PKGame in
                PKGame(id: pkGameData.id, players: playerProfiles, questions: pkGameData.questions)
            }
        }
    }

    func addForfeittedPlayerToPKGame(id: Identifier, playerId: Identifier) -> Promise<PKGameData> {
        firstly {
            self.getOne(id: id)
        }.then { pkGameData -> Promise<PKGameData> in
            var forfeittedPlayers = pkGameData.forfeittedPlayers
            forfeittedPlayers.insert(playerId)
            let newPkGameData = PKGameData(
                createdAt: pkGameData.createdAt,
                players: pkGameData.players,
                questions: pkGameData.questions,
                forfeittedPlayers: forfeittedPlayers)
            return self.update(id: pkGameData.id, to: newPkGameData)
        }
    }
}
