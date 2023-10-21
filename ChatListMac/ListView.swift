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
                                .frame(maxWidth: .infinity) // Tamanho máximo disponível
                      
                        }
                        VStack(spacing: 8){
                            Button(action: {
                            }, label: {
                                Text("Salvar")
                            })
                            Button(action: {
                                chats.append(ChatsInfos(nameTitle: chatLabel, urlLink: chatUrl))
                                print("Botão Salvar pressionado!")
                            }, label: {
                                Text("Salvar")
                            })
                        }// Espaçamento à esquerda do botão
                    }
                }
                .padding(12)
                .cornerRadius(8)
            }
            .background(.background)
            .cornerRadius(8)
            
            
            VStack{
                ScrollView {
                VStack(spacing: 8){
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
                                Button(action: {
                                    openURLInExternalBrowser(chats[index].urlLink)
                                }, label: {
                                    Text("Abrir")
                                        .padding(.vertical,4)
                                })
                                
                            }
                            Divider()
                            
                        }
                    }
                }
                .padding(12)
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
