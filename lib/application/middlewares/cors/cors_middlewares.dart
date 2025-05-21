
import 'dart:io';

import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

class CorsMiddlewares extends Middlewares {

  final Map<String, String> headers = {
    'Acces-Control-Allow-Origin': '*', 
    'Acces-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS', 
    'Acces-Control-Allow-Header': '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}', 
  };

  @override
  Future<Response> execute(Request request) async {
    print('-----------------------------------------Iniciando CrossDomian-----------------------------------------');
    if(request.method == 'OPTIONS') {
      print('-----------------------------------------Retornando Headers do CrossDomain-----------------------------------------');
      return Response(HttpStatus.ok, headers: headers);
    }

    print('-----------------------------------------Executando Função CrossDomain-----------------------------------------');

    final response = await innerHandler(request);
    print('-----------------------------------------Respondendo para o cliente CrossDomain-----------------------------------------');
    return response.change();

  }

  
  
}