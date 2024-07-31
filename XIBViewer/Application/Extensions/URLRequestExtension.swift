import Foundation

extension URLRequest {
    mutating func addValues(_ endpoints: Endpoints) {
        switch endpoints {
        case .login, .signup, .refreshToken, .editUser, .getUserList, .deleteUser, .getRole, .loadMoreUserList:
            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)

        case .getAccountData, .accessGuarded:

            self.setValue(HTTP.Headers.Value.applicationJson.HeaderValues,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.HeadersKey)

            self.setValue(HTTP.Headers.Value.accessToken(
                accessToken:
                AuthenticationLocalDataSourceImp.getToken.getAccessToken().access).HeaderValues,
            forHTTPHeaderField: HTTP.Headers.Key.authorization.HeadersKey)
        }
    }
}
