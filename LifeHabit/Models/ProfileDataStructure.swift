import UIKit

struct ProfileDataStructure: Codable {
    var name: String
    var age: String
    var gender: String
    var profileImage: Data?
    

    
    init(name: String, age: String, gender: String, profileImage: UIImage?) {
        self.name = name
        self.age = age
        self.gender = gender
        self.profileImage = profileImage?.jpegData(compressionQuality: 0.8)
    }
}
