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
                                openURLInExternalBrowser("https://www.google.com")
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
