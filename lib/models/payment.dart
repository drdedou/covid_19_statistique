import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:square_in_app_payments/models.dart';

class Payment {
  //madjidi idris

  Future<void> setPayment(BuyerVerificationDetails result, int amount) async {
    final String url = 'https://connect.squareup.com/v2/payments';

    final headers = {
      'Square-Version': '2020-06-25',
      'Authorization':
          'Bearer EAAAEJNf5P3ts_zMdLmnJnmEJfdjuedTYlQQ7-2sCZTery6jpRnPbYpTzJPEAkV0',
      'Content-Type': 'application/json',
    };

    final body = json.encode(
      {
        'source_id': result.nonce,
        'idempotency_key': result.token,
        'amount_money': {
          'amount': amount,
          'currency': 'USD',
        },
      },
    );

    final String testUrl = 'https://explorer-gateway.squareup.com/v2/payments';

    final testHeaders = {
      'sandbox-mode': 'true',
      'Square-Version': '2020-06-25',
      'Authorization':
          'Bearer EAAAEFYKDhou59zC6enlKj-uBN63_utGvcNbWvAlDGPd7MJToPuxyNc5QDrnDmWg',
      'Content-Type': 'application/json',
    };

    final testBody = json.encode({
      'source_id': result.nonce,
      'idempotency_key': result.token,
      'amount_money': {
        'amount': amount,
        'currency': "USD",
      }
    });

    try {
      final responce = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // final responce = await http.post(
      //   testUrl,
      //   headers: testHeaders,
      //   body: testBody,
      // );

      print(responce.body);
    } catch (e) {
      print('--------------------- $e -------------------');
    }
  }
}
