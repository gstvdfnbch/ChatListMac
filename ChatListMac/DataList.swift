//
//  DataList.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import Foundation

struct ChatsInfos: Codable {
    var nameTitle: String
    var urlLink: String
}

class UserDefaultsManager {
    private let itemsKey = "chatsInfosKey"
    
    // Função para salvar o array de ChatsInfos no UserDefaults
    func save(chats: [ChatsInfos]) {
        if let encodedData = try? JSONEncoder().encode(chats) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
        
        print("save")
    }
    
    // Função para carregar o array de ChatsInfos do UserDefaults
    func load() -> [ChatsInfos]? {
        if let savedData = UserDefaults.standard.data(forKey: itemsKey) {
            if let decodedChats = try? JSONDecoder().decode([ChatsInfos].self, from: savedData) {
                print("load")

                return decodedChats
            }
        }
        print("fail load")

        return nil
    }
}
