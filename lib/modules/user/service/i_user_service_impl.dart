

import 'package:injectable/injectable.dart';

import '../../../entities/user.dart';
import '../data/i_user_repository.dart';
import '../view_models/user_save_input_model.dart';
import './i_user_service.dart';

@LazySingleton(as: IUserService)
class IUserServiceImpl implements IUserService {

  IUserRepository userRepository;

  IUserServiceImpl({
    required this.userRepository,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {

    final userEntity = User(
      email:  user.email,
      password: user.password,
      registerType: 'App',
      supplierId:  user.supplierId,
    );

    return userRepository.createUser(userEntity);

  }
  
  @override
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser) => 
          userRepository.loginWithEmailPassword(email, password, supplierUser);

}
