import 'package:cuidapet_api/application/exceptions/user_not_found_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import '../../../application/database/i_database_connection.dart';
import '../../../application/exceptions/database_exception.dart';
import '../../../application/exceptions/user_exists_exception.dart';
import '../../../application/helpers/cripty_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class IUserRepositoryImpl implements IUserRepository {

  final IDatabaseConnection connection;
  final ILogger log;

  IUserRepositoryImpl({
    required this.connection, 
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    
    late final MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        insert usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
        values(?,?,?,?,?,?)
      ''';

      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        CriptyHelper.generateSha256Hash(user.password ?? ''),
        user.supplierId,
        user.socialKey,
      ]);

      final userId = result.insertId;
      return user.copyWith(id: userId, password: null);

    } on MySqlException catch (e, s) {

      if(e.message.contains('usuario.email_UNIQUE')) {
        log.error('Usuario ja cadastrado na base de dados', e, s);
        throw UserExistsException();
      }

      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException(message: 'Erro ao criar usuario', exception: e);

    } finally {
      conn?.close();
    }
  }
  
  @override
  Future<User> loginWithEmailPassword(String email, String password, bool supplierUser) async {

    late final MySqlConnection? conn;

    try {

      conn = await connection.openConnection();
      var query = '''
        select * from usuario 
        where 
          email = ? and 
          senha = ?
      ''';

      if(supplierUser) {
        query += 'and fornecedor_id is not null';
      } else {
        query += 'and fornecedor_id is null';
      }

      final result = await conn.query(query, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);
      if(result.isEmpty) {
        log.error('Usuario ou senha invalidos!!!!!');
        throw UserNotFoundException(message: 'Usuario ou senha invalidos');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          iostoken: {userSqlData['ios_token'] as Blob?}.toString(),
          androidToken: {userSqlData['android_token'] as Blob?}.toString(),
          refreshToken: {userSqlData['refresh_token'] as Blob?}.toString(),
          imageAvatar: {userSqlData['img_avatar'] as Blob?}.toString(),
          supplierId: userSqlData['fornecedor_id'],
        );
      }
    } on MySqlException catch(e, s) {
      log.error('Erro ao realizar login', e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }
  
  @override
  Future<User> loginByEmailSocialKey(String email, String socialKey, String socialType) async {

    late final MySqlConnection? conn;

    try {

      conn = await connection.openConnection();
      final result = await conn.query('select * from usuario where email = ?', [email]);

      if(result.isEmpty){ 
        throw UserNotFoundException(message: 'Usuario nao encontrado');
      } else {
        final dataMysql = result.first;
        if(dataMysql['social_id'] == null || dataMysql['social_id'] != socialKey) {
          await conn.query('''
            update usuario 
            set social_id = ?, tipo_cadastro = ? 
            where id = ?
          ''', [
            socialKey, socialType, dataMysql['id'],
          ]);
        }
        return User(
          id: dataMysql['id'] as int,
          email: dataMysql['email'],
          registerType: dataMysql['tipo_cadastro'],
          iostoken: {dataMysql['ios_token'] as Blob?}.toString(),
          androidToken: {dataMysql['android_token'] as Blob?}.toString(),
          refreshToken: {dataMysql['refresh_token'] as Blob?}.toString(),
          imageAvatar: {dataMysql['img_avatar'] as Blob?}.toString(),
          supplierId: dataMysql['fornecedor_id'],
        );
      }
    } finally {
      await conn?.close();
    }

  }

}