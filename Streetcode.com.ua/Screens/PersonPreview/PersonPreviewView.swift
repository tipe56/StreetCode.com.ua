//
//  PersonPreviewView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct PersonPreviewView: View {
    // MARK: Properties
    let person: HistoricalPerson
    @Environment(\.dismiss) var dismiss
    
    // MARK: Body
    var body: some View {
        VStack {
            ScrollView {
                PreviewHeader(id: person.id)
                PreviewImage(image: person.imageBundle)
                PersonTitlesView(person: person)
                Text(person.description)
                    .font(.body)
                    .padding(.bottom, 5)
            }
            
            Button {
                //
            } label: {
                Text("Дізнатися більше")
                    .radiusButtonStyle()
            }
        }.padding(.horizontal, 8)
    }
}


// MARK: Preview
struct PersonPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PersonPreviewView(person: MockData.sampleHistoricalPerson)
    }
}


// MARK: SubViews

struct PreviewHeader: View {
    var id: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Text("Стріткод #" + String(format: "%04d", id))
            Spacer()
            
            Button {
                dismiss()   
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
            }
        }.padding(.horizontal, 5)
    }
}


struct PreviewImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
    }
}

struct PersonTitlesView: View {
    var person: HistoricalPerson
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(person.title)
                    .font(.closer(.medium, size: 18))
                
                
                if let aliasTitle = person.aliasTitle {
                    Text("\"\(aliasTitle)\"")
                        .font(.closer(.medium, size: 16))
                }
            }
            .foregroundColor(Color(.label))
            .multilineTextAlignment(.leading)
            .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.bottom, 5)
    }
}


