//
//  ContentView.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import Foundation
import SwiftUI


struct ListView: View {
    
    let paddingGSTV = 16
    
    @State private var chats: [ChatsInfos] = []
    
    @State private var chatLabel = ""
    @State private var chatUrl = ""
    
    @State private var flagNew: Bool = false
    
    @Environment(\.openURL) var openURL
    
    let managerData = UserDefaultsManager()
    

    
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
        
        openURL(URL(string: urlString)!)

        
    }
    
    func onAppearDataDeafult() {
        if let loadedChats = managerData.load() {
            print(loadedChats)
            self.chats.removeAll()
            self.chats.append(contentsOf: loadedChats)
        }
    }
    
    var body: some View {
        VStack(spacing: 16){
            
            VStack{
                VStack{
                    HStack{
                        Text("Criar novo link")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    HStack(spacing: 8){
                        VStack(spacing: 4){
                            TextField("Título do site", text: $chatUrl)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                            
                            TextField("Link completo", text: $chatLabel)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                        }
                        VStack(spacing: 8){
                            Button(action: {
                            }) {
                                Text("Salvar")
                                    .foregroundColor(.blue)
                            }.opacity(0)
                            Button(action: {
                                
                                chats.append(ChatsInfos(nameTitle: chatLabel, urlLink: chatUrl))
                                
                                managerData.save(chats: chats)
                            }) {
                                Text("Salvar")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(12)
                .cornerRadius(8)
            }
            .background(.background)
            .cornerRadius(8)
            
            
            VStack{
                ScrollView {
                    VStack(spacing: 4){
                        ForEach(0..<chats.count, id: \.self) { index in
                            HStack(spacing:8){
                                VStack {
                                    HStack{
                                        Text(chats[index].nameTitle)
                                            .font(.callout)
                                        Spacer()
                                    }
                                    HStack{
                                        Text(chats[index].urlLink)
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    openURLInExternalBrowser(chats[index].urlLink)
                                }, label: {
                                    Text("Abrir")
                                        .padding(.vertical,4)
                                })
                                
                            }
                            .padding(8)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                            
                        }
                    }
                }
                .padding(8)
            }
            .background(.background)
            .cornerRadius(8)
            .onAppear() {
                self.onAppearDataDeafult()
            }
        }
        .padding(16)
        
    }
    
    
}





#Preview {
    ListView().frame(width: 400,height: 300)
}
