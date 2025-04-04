import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
  });

  test('Mock HTTP client returns expected data', () async {
    // Настраиваем мок ответа
    when(() => mockClient.get(Uri.parse('https://example.com')))
        .thenAnswer((_) async => http.Response('{"data": "test"}', 200));

    // Выполняем запрос
    final response = await mockClient.get(Uri.parse('https://example.com'));

    // Проверяем результат
    expect(response.statusCode, 200);
    expect(response.body, '{"data": "test"}');
  });
}