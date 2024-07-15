import Foundation

class EditVM {
    init(data: UserModel, delegate: EditVCDelegate) {
        self.existingData = data
        self.delegate = delegate
    }
    
    let existingData: UserModel?
    var name: String?
    var email: String?
    var delegate: EditVCDelegate
    
    let userRepo: AccountRepository = AccountRemoteDataSourceImp()
}

extension EditVM {
    private func getData() -> UserModel? {
        guard let name = name,
              let email = email,
              let role = existingData?.role,
              let id = existingData?.id
        else {
            return nil
        }
        
        return UserModel(id: id, name: name, email: email, role: role)
    }

    func sendData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let data = getData()
        else {
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
        }
        
        userRepo.editOneUser(for: data.toEditMethod()) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let newUserData):
                self.delegate.doneEditing(send: newUserData)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
