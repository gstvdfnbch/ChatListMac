//
//  ContentView.swift
//  ChatListMac
//
//  Created by Gustavo Diefenbach on 16/10/23.
//

import SwiftUI

struct ListView: View {
    
    @State private var chats: [ChatsInfos] = [
        ChatsInfos(nameTitle: "Curriculo", urlLink: "http://www.instagram.com"),
        ChatsInfos(nameTitle: "Curriculo", urlLink: "http://www.instagram.com"),
    ]
    @State private var isAppClosed = false
    
    
    private var flagNew = true
    @State private var chatText = ""

    
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
                            print("Add")
                        }
                }
                
                Divider()
                ForEach(0..<chats.count, id: \.self) { index in
                    let chat = chats[index].nameTitle
                    HStack{
                        
                        Text(chat)
                            .foregroundColor(Color.primary)
              
                        Spacer()
                        Image(systemName: "trash").foregroundColor(Color.secondary.opacity(0.5))
                            .onTapGesture {
                                print("Delete \(index)")
                            }
                    }
                    .padding(.top, 1)
                }
                Spacer()
            }
            .padding(EdgeInsets.init(top: 8, leading: 16, bottom: 16, trailing: 16))
        }
    
}

#Preview {
    ListView().frame(width: 300,height: 200)
}
