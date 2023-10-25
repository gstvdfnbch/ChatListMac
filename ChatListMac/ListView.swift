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
    @State private var selectedMenuIndex: Int?
    @State private var selectedEdited: Int = -1
    
    @State private var chats: [ChatsInfos] = []
    
    @State private var chatLabelNew = ""
    @State private var chatUrlNew = ""
    @State private var chatLabelEdit = ""
    @State private var chatUrlEdit = ""
    
    
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
    
    func editLine(position: Int) {
        selectedEdited = position
        print("edit")
    }
    
    func deleteLine(position: Int) {
        print("remove \(position)")
        self.chats.remove(at: position)
        managerData.save(chats: chats)
        selectedEdited = -1
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
                        chatUrlNew = ""
                        chatLabelNew = ""
                        flagNew.toggle()
                        selectedEdited = -1
                    }
                    
                    if flagNew {
                        HStack(spacing: 8){
                            VStack(spacing: 4){
                                
                                TextField("Título do site", text: $chatLabelNew)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Link completo", text: $chatUrlNew)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
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
                                    chats.append(ChatsInfos(nameTitle: chatLabelNew, urlLink: chatUrlNew))
                                    managerData.save(chats: chats)
                                    chatLabelNew = ""
                                    chatUrlNew = ""
                                    selectedEdited = -1
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
                    VStack(spacing: 8){
                        if chats.count != 0 {
                            ForEach(0..<chats.count, id: \.self) { index in
                                HStack(spacing:4){
                                    VStack {
                                        if selectedEdited != index {
                                            HStack{
                                                Text(chats[index].nameTitle)
                                                    .font(.callout)
                                                Spacer()
                                            }
                                            .onTapGesture {
                                                openURLInExternalBrowser(chats[index].urlLink)
                                            }
                                            HStack{
                                                Text(chats[index].urlLink)
                                                    .font(.callout)
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                            }
                                            .onTapGesture {
                                                openURLInExternalBrowser(chats[index].urlLink)
                                            }
                                        } else {
                                            VStack (spacing: 4){
                                                TextField(chats[index].nameTitle, text: $chatLabelEdit)
                                                    .font(.callout)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .underline(color: .blue)
                                                
                                                TextField(chats[index].urlLink, text: $chatUrlEdit)
                                                    .font(.callout)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        if selectedEdited != index {
                                            openURLInExternalBrowser(chats[index].urlLink)
                                        } else {
                                            selectedEdited = -1
                                        }
                                    }
                                    if selectedEdited != index {
                                        ZStack{
                                            Image(systemName: "pencil")
                                                .foregroundColor(.secondary)
                                                .padding(4)
                                        }
                                        .onTapGesture {
                                            selectedMenuIndex = index
                                            editLine(position: index)
                                        }
                                        ZStack{
                                            Image(systemName: "trash")
                                                .foregroundColor(.secondary)
                                                .padding(4)
                                        }
                                        .onTapGesture {
                                            selectedMenuIndex = index
                                            deleteLine(position: index)
                                        }
                                    } else {
                                        VStack{
                                            Spacer()
                                            Button(action: {
                                                flagNew = false
                                                chats[selectedEdited] = ChatsInfos(nameTitle: chatLabelEdit, urlLink: chatUrlEdit)
                                                managerData.save(chats: chats)
                                                selectedEdited = -1
                                            }) {
                                                Text("Salvar")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .onTapGesture {
                                            selectedMenuIndex = index
                                            deleteLine(position: index)
                                        }
                                    }
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
                        } else {
                            HStack {
                                Spacer()
                                Text("Nenhum link adicionado")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.top, 32)
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
