//
//  PostViewModel.swift
//  AsyncAwaitNetwork
//
//  Created by Asad Khan on 8/9/22.
//

import Foundation
struct User: Codable {
    var id: Int
    var name: String
    var email: String
    
}
struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
  private  func getUser() async -> Result<[User], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let urlRequest = URLRequest(url: url)
        do {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    private  func getPosts(user: User) async -> Result<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(user.id)/posts")!
        let urlRequest = URLRequest(url: url)
        do {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return .success(posts)
        } catch (let error) {
            return .failure(error)
        }
    }
    
    func getUserPosts() {
        
        Task(priority: .background) {
            
            let userResult = await getUser()
            
            switch userResult {
            case .success(let users):
                let postResult = await getPosts(user: users.first!)
                switch postResult {
                case .success(let posts):
                    self.posts = posts
                case .failure(let postError):
                    print(postError.localizedDescription)
                }
               
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
