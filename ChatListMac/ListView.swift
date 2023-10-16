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
    
    @State private var isAppClosed = false
    
    
    @State private var chatLabel = ""
    @State private var chatUrl = ""
    
    @State private var flagNew: Bool = false

    @Environment(\.openURL) var openURL
    
    func openURLInExternalBrowser(_ urlString: String) {
        openURL(URL(string: urlString)!)
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("Lista de Chats GPT")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
                    .bold()
                Spacer()
                Image(systemName: "plus.app")
                    .foregroundColor(Color.accentColor)
                    .font(.title2)
                    .onTapGesture {
                        flagNew = true
                        print("Add")
                    }
            }
            
            Divider()
            
            if flagNew {
                HStack{
                    VStack(spacing: 0) {
                        TextField("Name", text: $chatLabel)
                            .foregroundColor(.primary)
                        TextField("URL", text: $chatUrl)
                            .foregroundColor(.primary)
                    }
                    Image(systemName: "arrowshape.forward.circle").foregroundColor(Color.secondary.opacity(0.5))
                        .onTapGesture {
                            let addChat = ChatsInfos(nameTitle: chatLabel, urlLink: chatUrl)
                            chats.append(addChat)
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
                        Text(chats[index].urlLink)
                            .foregroundColor(Color.primary)
                            .font(.caption)
                            .onTapGesture {
                                openURLInExternalBrowser("https://www.google.com")
                                print(chats[index].urlLink)
                            }
                        
                        Spacer()
                        Image(systemName: "trash").foregroundColor(Color.secondary.opacity(0.5))
                            .onTapGesture {
                                print("Delete \(index)")
                                chats.remove(at: index)
                            }
                    }
                    .padding(.top, 1)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets.init(top: 8, leading: 16, bottom: 16, trailing: 16))
    }
    
}

#Preview {
    ListView().frame(width: 300,height: 200)
}
