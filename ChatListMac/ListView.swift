//
//  ContentView.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import Foundation
import SwiftUI
import Cocoa

struct ListView: View {
    
    let paddingGSTV = 16
    
    @State private var showMenu = false

    @State private var chats: [ChatsInfos] = []
    
    @State private var chatLabel = ""
    @State private var chatUrl = ""
    
    @FocusState private var isFocusedLabel: Bool
    @FocusState private var isFocusedUrl: Bool    
    
    @State private var flagNew: Bool = false
    
    @Environment(\.openURL) var openURL
    
    let managerData = UserDefaultsManager()
    
    var statusItem: NSStatusItem?
    var menu: NSMenu?
    
    
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
        
        if let urlDone = URL(string: urlString) {
            openURL(urlDone)
        }
        
    }
    
    func onAppearDataDeafult() {
        if let loadedChats = managerData.load() {
            self.chats.removeAll()
            self.chats.append(contentsOf: loadedChats)
        }
    }
    
    var body: some View {
        VStack(spacing: 16){
            VStack{
                VStack{
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            
                        Text("Criar novo link")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .onTapGesture {
                        chatUrl = ""
                        chatLabel = ""
                        flagNew.toggle()
                    }
                    if flagNew {
                        HStack(spacing: 8){
                            VStack(spacing: 4){
                                
                                TextField("Título do site", text: $chatUrl, onCommit: {
                                    isFocusedLabel = false
                                    isFocusedUrl = true
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isFocusedLabel)
                                .frame(maxWidth: .infinity)
                                
                                
                                
                                TextField("Link completo", text: $chatLabel, onCommit: {
                                    isFocusedLabel = true
                                    isFocusedUrl = false
                                })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($isFocusedUrl)
                                    .frame(maxWidth: .infinity)
                            }
                            VStack(spacing: 8){
                                Button(action: {
                                }) {
                                    Text("Salvar")
                                        .foregroundColor(.blue)
                                }
                                .disabled(true)
                                .opacity(0)
                                
                                Button(action: {
                                    flagNew = false
                                    chats.append(ChatsInfos(nameTitle: chatLabel, urlLink: chatUrl))
                                    managerData.save(chats: chats)
                                    chatLabel = ""
                                    chatUrl = ""
                                }) {
                                    Text("Salvar")
                                        .foregroundColor(.blue)
                                }
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
                ScrollView (showsIndicators: false){
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
                                .onTapGesture {
                                    openURLInExternalBrowser(chats[index].urlLink)
                                }
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(.secondary)
                                    .onTapGesture {
                                        showMenu.toggle()
                                    }
                                    .popover(isPresented: $showMenu, arrowEdge: .bottom, content: {
                                        MenuView()
                                    })
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .onTapGesture {
                                        openURLInExternalBrowser(chats[index].urlLink)
                                    }

                            }
                            .padding(8)
                            .background(Color.black.opacity(0.05))
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
