import Foundation


class EditVM{
    
    init(data: UserModel, delegate: EditVCDelegate) {
        self.existingData = data
        self.delegate = delegate
    }
    
    let existingData: UserModel?
    var name: String?
    var email: String?
    var delegate: EditVCDelegate
}

extension EditVM{

    
    private func getData() -> PUTMethodUserModel?{
        
        guard let email = email,
              let name =  name,
              let selectedRole = existingData?.role.name
        else{
           return nil
        }
        
        return PUTMethodUserModel(name: name,
                                  email: email,
                                  role: PUTMethodRoleModel(name: selectedRole))
    }
    func sendData(completion: @escaping (Result<Void, Error>) -> Void){

        
        guard let model = getData(),
              let id = existingData?.id else{
            completion(.failure(APIErrorTypes.dataIsMissing()))
            return
            
        }
        
        guard let request = Endpoints.editUser(model: model, id: id).request else{
            completion(.failure(APIErrorTypes.unknownError("Request cannot be fullfilled - Endpoint error")))
            return
        }
        
        AccountService.editAccount(request: request) {[weak self] result in
            
            guard let self = self else {return}
            switch result{
            case .success(let newUserData):
                self.delegate.doneEditing(send: newUserData)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                }
            }
        }
    }


