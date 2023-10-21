//
//  ContentView.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import Foundation
import SwiftUI

struct ListView: View {
    
    @State private var chats: [ChatsInfos] = []
        
    @State private var chatLabel = ""
    @State private var chatUrl = ""
    
    @State private var flagNew: Bool = false

    @Environment(\.openURL) var openURL
    
    let managerData = UserDefaultsManager()
    
    func transformToValidURL(from string: String, completion: @escaping (String) -> Void) {
        var urlString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Se não contém "www.", adicione "http://"
        if !urlString.contains("www.") {
            urlString = "http://" + urlString
        }
        
        // Se não tem um domínio conhecido (.com, .br, etc.), adicione ".com"
        let knownDomains = [".com", ".br"] // Adicione outros domínios conforme necessário
        if !knownDomains.contains(where: urlString.hasSuffix) {
            urlString += ".com"
        }
        
        // Verifica a validade da URL
        validateURL(urlString) { isValid in
            if isValid {
                completion(urlString)
            } else {
                completion("http://www.google.com")
            }
        }
    }

    func validateURL(_ urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"  // Método HEAD é mais eficiente para essa verificação
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(false)
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func openURLInExternalBrowser(_ urlString: String) {
        
        transformToValidURL(from: "example") { finalURL in
            print(finalURL)
            print("url valida!")
            openURL(URL(string: finalURL)!)
        }
        
        
    }
    
    func onAppearDataDeafult() {
        if let loadedChats = managerData.load() {
            print(loadedChats)
            self.chats.removeAll()
            self.chats.append(contentsOf: loadedChats)
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Image(systemName: "plus.app")
                    .foregroundColor(Color.accentColor)
                    .font(.title2)
                    .onTapGesture {
                        flagNew = true
                        chatLabel = ""
                        chatUrl = ""
                        print("Add")
                    }
                Image(systemName: "gearshape")
                    .foregroundColor(Color.accentColor)
                    .font(.title2)
                    .onTapGesture {
                        print("Config")
                    }
            }
            
        
            if flagNew {
                HStack{
                    VStack(spacing: 0) {
                        TextField("Name", text: $chatLabel)
                            .foregroundColor(.primary)
                            .background(.clear)
                        TextField("URL", text: $chatUrl)
                            .foregroundColor(.primary)
                            .background(.clear)
                    }
                    Image(systemName: "arrowshape.forward.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .foregroundColor(Color.secondary.opacity(0.5))
                        .onTapGesture {
                            
                            if chatLabel.isEmpty  || chatUrl.isEmpty {
                                chatLabel = ""
                                chatUrl = ""
                            } else {
                                let addChat = ChatsInfos(nameTitle: chatLabel, urlLink: chatUrl)
                                chats.append(addChat)
                                
                                managerData.save(chats: chats)
                            }
                            
                            flagNew = false

                        }
                }
                .padding(.top, 1)
            }
            
            if chats.isEmpty {
                Spacer()
                Text("Nenhum link salvo")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ForEach(0..<chats.count, id: \.self) { index in
                    HStack{
                        Text(chats[index].nameTitle)
                            .foregroundColor(Color.primary)
                            .onTapGesture {
                                openURLInExternalBrowser(chats[index].urlLink)
                                print(chats[index].urlLink)
                            }
                        Spacer()
                        Image(systemName: "trash.fill").foregroundColor(Color.secondary.opacity(0.5))
                            .onTapGesture {
                                print("Delete \(index)")
                                chats.remove(at: index)
                                managerData.save(chats: chats)
                            }
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets.init(top: 8, leading: 16, bottom: 16, trailing: 16))
        .onAppear() {
            self.onAppearDataDeafult()
        }
    }
    
}

#Preview {
    ListView().frame(width: 300,height: 200)
}
