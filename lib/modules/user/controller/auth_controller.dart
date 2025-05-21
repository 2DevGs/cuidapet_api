
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_api/modules/user/service/i_user_service.dart';

part 'auth_controller.g.dart';

@injectable
class AuthController {

  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

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
