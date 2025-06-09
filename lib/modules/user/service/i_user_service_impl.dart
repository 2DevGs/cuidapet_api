

import 'package:injectable/injectable.dart';

import 'package:cuidapet_api/application/exceptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';

import '../../../entities/user.dart';
import '../data/i_user_repository.dart';
import '../view_models/user_save_input_model.dart';
import './i_user_service.dart';

@LazySingleton(as: IUserService)
class IUserServiceImpl implements IUserService {

  IUserRepository userRepository;
  ILogger log;

  IUserServiceImpl({
    required this.userRepository,
    required this.log,
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
          
  @override
  Future<User> loginWithSocial(String email, String avatar, String socialType, String socialKey) async {
    
    try {
      return await userRepository.loginByEmailSocialKey(email, socialKey, socialType);
    } on UserNotFoundException catch (e) {
      log.error('Usuario nao encontrado, criando um novo usuario', e);
      final user = User(
        email: email,
        imageAvatar: avatar,
        registerType: socialType,
        socialKey: socialKey,
        password: DateTime.now().toString(),
      );
      return await userRepository.createUser(user);
    }

  }

}
