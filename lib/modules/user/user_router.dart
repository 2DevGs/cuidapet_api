
import 'package:cuidapet_api/application/routers/i_router.dart';
import 'package:cuidapet_api/modules/user/controller/auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class UserRouter implements IRouter {

  @override
  void configure(Router router) {

    final authController = GetIt.I.get<AuthController>();

    router.mount('/auth/', authController.router);
    
  }
  
}