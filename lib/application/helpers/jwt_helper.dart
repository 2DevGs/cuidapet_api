
import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  
  JwtHelper._();

  static JwtClaim getClaims(String token) {

    final env = DotEnv(includePlatformEnvironment: true)..load();
    final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

      return verifyJwtHS256Signature(token, _jwtSecret);

  }

}