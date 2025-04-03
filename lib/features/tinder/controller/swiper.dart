import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SwipeRequest {
  final String swiperId;
  final String targetId;
  final bool isLike;

  SwipeRequest({
    required this.swiperId,
    required this.targetId,
    required this.isLike,
  });

  Map<String, dynamic> toJson() => {
        'swiperId': swiperId,
        'targetId': targetId,
        'isLike': isLike,
      };
}

final swipeProvider =
    FutureProvider.family<void, SwipeRequest>((ref, request) async {
  final response = await http.post(
    Uri.parse('https://gymbro.serveo.net/api/swipe'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(request.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to swipe');
  }
});
