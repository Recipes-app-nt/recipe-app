import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthService authService;
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockDio = MockDio();
    mockSharedPreferences = MockSharedPreferences();
    authService = AuthService();
    authService.dio = mockDio;
  });

  group('AuthService', () {
    test('logout should remove user data from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'userData': 'mock_user_data'});

      await authService.logout();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('userData'), isNull);
    });

    test('checkTokenExpiry should return null for expired token', () async {
      SharedPreferences.setMockInitialValues({
        'userData':
            '{"idToken":"mock_token","email":"test@example.com","refreshToken":"mock_refresh_token","expiresIn":"2000-01-01T00:00:00.000","localId":"mock_local_id"}'
      });

      final user = await authService.checkTokenExpiry();

      expect(user, isNull);
    });

    test('checkTokenExpiry should return User for valid token', () async {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      SharedPreferences.setMockInitialValues({
        'userData':
            '{"idToken":"mock_token","email":"test@example.com","refreshToken":"mock_refresh_token","expiresIn":"${futureDate.toIso8601String()}","localId":"mock_local_id"}'
      });

      final user = await authService.checkTokenExpiry();

      expect(user, isA<User>());
      expect(user?.email, 'test@example.com');
    });
  });

  group('User', () {
    test('fromMap should create a valid User object', () {
      final map = {
        'idToken': 'mock_token',
        'email': 'test@example.com',
        'refreshToken': 'mock_refresh_token',
        'expiresIn': '3600',
        'localId': 'mock_local_id'
      };

      final user = User.fromMap(map);

      expect(user.idToken, 'mock_token');
      expect(user.email, 'test@example.com');
      expect(user.refreshToken, 'mock_refresh_token');
      expect(user.localId, 'mock_local_id');
      expect(user.expiresIn.isAfter(DateTime.now()), isTrue);
    });

    test('toMap should return a valid map', () {
      final user = User(
          idToken: 'mock_token',
          email: 'test@example.com',
          refreshToken: 'mock_refresh_token',
          expiresIn: DateTime.now().add(const Duration(hours: 1)),
          localId: 'mock_local_id');

      final map = user.toMap();

      expect(map['idToken'], 'mock_token');
      expect(map['email'], 'test@example.com');
      expect(map['refreshToken'], 'mock_refresh_token');
      expect(map['localId'], 'mock_local_id');
      expect(map['expiresIn'], isA<String>());
    });
  });
}
