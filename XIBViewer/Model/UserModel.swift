import Foundation

struct UserModel: Codable{
    
    let name: String
    let email: String
    let role: RoleModel
    var imageURL: URL? = nil
}

let dummyData:[UserModel] = [
    UserModel(name: "Jack NinetySeven",
              email: "j97@gmail.com",
              role: dummyRole[0], 
              imageURL: URL(string: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=3687&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
             ),
    UserModel(name: "Hugh Jackman", 
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    UserModel(name: "Hugh Jackman",
              email: "jackman_hugh@gmail.com",
              role: dummyRole[1]
             ),
    
]
