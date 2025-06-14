
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_api/modules/user/service/i_user_service.dart';

import '../../../entities/user.dart';
import '../view_models/login_view_model.dart';

part 'auth_controller.g.dart';

@injectable
class AuthController {

  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/')
  Future<Response> login(Request request) async{

    try {
      
      final loginViewModel = LoginViewModel(await request.readAsString());
      User user;
      
      if (!loginViewModel.socialLogin) {
        user = await userService.loginWithEmailPassword(
            loginViewModel.login, loginViewModel.password, loginViewModel.supplierUser
        );
      } else { 
        // Social Login (Facebook, google, apple, etc...)
        user = await userService.loginWithSocial(
          loginViewModel.login,
          loginViewModel.avatar,
          loginViewModel.socialType,
          loginViewModel.socialKey,
        );
        // user = User();
      }

      return Response.ok(jsonEncode(
        {'access_token': JwtHelper.generateJWT(user.id!, user.supplierId),}));
    } on UserNotFoundException {
      return Response.forbidden(jsonEncode({'message': 'Usuario ou senha invalidos'}));
    } catch(e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response.internalServerError(body: jsonEncode({
        'message': 'Erro ao realizar login',
      }));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {

    try {

      final userModel = UserSaveInputModel(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(jsonEncode({'message': 'Cadastro realizado com sucesso'}));

    } on UserExistsException {
      return Response(400, body: jsonEncode({'message': 'Usuario ja cadastrado na base de dados'}));
    } catch (e) {
      log.error('Erro ao cadastrar usuario', e);
      return Response.internalServerError();
    }

  }

  Router get router => _$AuthControllerRouter(this);
}
