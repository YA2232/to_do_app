import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as serviceController;

class SendNotification {
  void getTokenAndSendNotification(
      {required String title, required String body}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();
    String? token = await messaging.getToken();
    print(token);
    sendNotify(deviceToken: token!, title: title, body: body);
  }

  static Future<String> getAccessToken() async {
    final Map<String, dynamic> serviceAccountJson = {
      "type": dotenv.env['SERVICE_ACCOUNT_TYPE'],
      "project_id": dotenv.env['SERVICE_ACCOUNT_PROJECT_ID'],
      "private_key_id": dotenv.env['SERVICE_ACCOUNT_PROJECT_KEY_ID'],
      "private_key": dotenv.env['SERVICE_ACCOUNT_PROJECT_KEY'],
      "client_email": dotenv.env['SERVICE_ACCOUNT_CLIENT_EMAIL'],
      "client_id": dotenv.env['SERVICE_ACCOUNT_CLIENT_ID'],
      "auth_uri": dotenv.env['SERVICE_ACCOUNT_AUTH_URI'],
      "token_uri": dotenv.env['SERVICE_ACCOUNT_TOKEN_URI'],
      "auth_provider_x509_cert_url":
          dotenv.env['SERVICE_ACCOUNT_AUTH_PROVIDER_X509_CERT_URL'],
      "client_x509_cert_url":
          dotenv.env['SERVICE_ACCOUNT_CLIENT_X509_CERT_URL'],
      "universe_domain": dotenv.env['SERVICE_ACCOUNT_UNIVERSE_DOMAIN'],
    };
    List<String> scopes = [
      "http://www.googleapis.com/auth/userinfo.email",
      "http://www.googleapis.com/auth/firebase.database",
      "http://www.googleapis.com/auth/firebase.messaging",
    ];

    var credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    var client = await auth.clientViaServiceAccount(credentials, scopes);

    var token = await client.credentials.accessToken;
    return token?.data ?? '';
  }

  static Future<void> sendNotify(
      {required String deviceToken,
      required String title,
      required String body}) async {
    String accessToken = await getAccessToken();
    final String endpoint =
        'https://fcm.googleapis.com/v1/projects/to-do-app-a52be/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {"route": "serviceScreen"},
      }
    };
    final response = await http.post(Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message));
    if (response.statusCode == 200) {
      print("it is done");
    } else {
      print("faild");
    }
  }
}
