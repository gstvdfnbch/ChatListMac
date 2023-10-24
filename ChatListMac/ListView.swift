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
    
    func editLine(position: Int) {
        print("edit")
    }
    
    func deleteLine(position: Int) {
        print("remove \(position)")
        self.chats.remove(at: position)
        managerData.save(chats: chats)
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
                                
                                TextField("Título do site", text: $chatUrl)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Link completo", text: $chatLabel)
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
                    VStack(spacing: 16){
                        if chats.count != 0 {
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
                                    ZStack{
                                        Image(systemName: "ellipsis.circle")
                                            .foregroundColor(.secondary)
                                            .padding(4)
                                    }
                                    .onTapGesture {
                                        selectedMenuIndex = index
                                    }
                                    .popover(isPresented: Binding(get: { self.selectedMenuIndex == index }, set: { _ in }), arrowEdge: .bottom, content: {
                                        VStack(spacing: 8) {
                                            Button(action: {
                                                editLine(position: index)
                                            }) {
                                                HStack{
                                                    Image(systemName: "pencil")
                                                        .font(.caption)
                                                    Text("Editar")
                                                        .font(.callout)
                                                    Spacer()
                                                }
                                                .frame(width: 70)
                                            }
                                            .buttonStyle(.accessoryBar)
                                            
                                            Button(action: {
                                                deleteLine(position: index)
                                            }) {
                                                HStack{
                                                    Image(systemName: "trash")
                                                        .font(.caption)
                                                    Text("Apagar")
                                                        .font(.callout)
                                                    Spacer()
                                                }
                                                .frame(width: 70)
                                                
                                            }
                                            .buttonStyle(.accessoryBar)
                                        }
                                        .padding(4)
                                        .padding(.vertical, 4)
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
