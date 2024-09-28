import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';


String jwtGen(String uuid){
  var payload = {
    'iss':'bdmobility-sdk',
    'sub': uuid,
  };
  var secret = 'MKsUhiLizsw7M64JtZOypoqG2XondBRI';

  var jwt = JWT(payload);
  var token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256, noIssueAt: true);
  return token;
}

String jwtGenwWithoutData(String uuid){
  var payload = {
    'aud': 'read',
    'sub': uuid,
  };
  var secret = 'MKsUhiLizsw7M64JtZOypoqG2XondBRI';

  var jwt = JWT(payload);
  var token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256, noIssueAt: true);
  return token;
}

String jwtGenwPurpose(String uuid){
  var payload = {
    'aud': 'read',
    'sub': uuid,
    'exp': 10000000,
  };
  var secret = 'MKsUhiLizsw7M64JtZOypoqG2XondBRI';

  var jwt = JWT(payload);
  var token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256, noIssueAt: true);
  return token;
}

String jwtGenwSync(){
  var payload = {
    'sub': 'sync',
    'exp': DateTime.now().millisecondsSinceEpoch + 200,
  };
  var secret = 'MKsUhiLizsw7M64JtZOypoqG2XondBRI';

  var jwt = JWT(payload);
  var token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256, noIssueAt: true);
  return token;
}

String jwtGenPatch(String uuid){
  var payload = {
    'sub': uuid,
    'aud': 'read',
    'exp': DateTime.now().millisecondsSinceEpoch + 200,
  };
  var secret = 'MKsUhiLizsw7M64JtZOypoqG2XondBRI';

  var jwt = JWT(payload);
  var token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256, noIssueAt: true);
  return token;
}
