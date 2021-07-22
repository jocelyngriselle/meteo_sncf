import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_sncf/authentication/authentication.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  late LoginBloc loginBloc;
  late AuthenticationService authenticationRepository;

  setUpAll(() {
    authenticationRepository = MockAuthenticationService();
    GetIt.I.registerSingleton<AuthenticationService>(
      authenticationRepository,
    );
  });

  setUp(() {
    loginBloc = LoginBloc();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when login succeeds',
        build: () {
          when(
            () => authenticationRepository.logIn(
              email: 'email@email.com',
              password: 'password',
            ),
          ).thenAnswer((_) => Future.value('user'));
          return loginBloc;
        },
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('email@email.com'))
            ..add(
              const LoginPasswordChanged('password'),
            )
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            email: Email.dirty('email@email.com'),
            status: FormzStatus.invalid,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.valid,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionInProgress,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionSuccess,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        build: () {
          when(() => authenticationRepository.logIn(
                email: 'email@email.com',
                password: 'password',
              )).thenThrow(Exception('oops'));
          return loginBloc;
        },
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('email@email.com'))
            ..add(const LoginPasswordChanged('password'))
            ..add(
              const LoginSubmitted(),
            );
        },
        expect: () => const <LoginState>[
          LoginState(
            email: Email.dirty('email@email.com'),
            status: FormzStatus.invalid,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.valid,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionInProgress,
          ),
          LoginState(
            email: Email.dirty('email@email.com'),
            password: Password.dirty('password'),
            status: FormzStatus.submissionFailure,
          ),
        ],
      );
    });
  });
}
