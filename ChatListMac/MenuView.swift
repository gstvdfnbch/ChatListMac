//
//  MenuView.swift
//  Jumplink
//
//  Created by Gustavo Diefenbach on 23/10/23.
//

import Foundation
import SwiftUI

struct MenuView: View {
    var body: some View {
        HStack(spacing: 8) {
            HStack{
                Image(systemName: "pencil")
                    .font(.headline)
                    .padding(4)
                    .onTapGesture {
                        print("pencil")
                    }
            }
            HStack{
                Image(systemName: "trash")
                    .font(.headline)
                    .padding(4)
                    .onTapGesture {
                        print("trash")
                    }
            }
        }
        .padding(8)
    }
}
