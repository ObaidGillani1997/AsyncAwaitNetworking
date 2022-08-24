//
//  ContentView.swift
//  AsyncAwaitNetwork
//
//  Created by Asad Khan on 8/9/22.
//

import SwiftUI

struct PostView: View {
    @StateObject var viewmodel = PostViewModel()
    
    var body: some View {
       
        List(viewmodel.posts, id: \.id) { post in
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title).bold()
                Text(post.body)
            }
        }.onAppear {
            viewmodel.getUserPosts()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
