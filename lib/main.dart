import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/services/api_service.dart';
import 'src/features/leagues/data/leagues_repository.dart';
import 'src/features/teams/data/teams_repository.dart';
import 'src/features/players/data/players_repository.dart';
import 'src/features/games/data/games_repository.dart';
import 'src/features/participations/data/participations_repository.dart';
import 'src/features/users/data/users_repository.dart';
import 'src/features/authentication/data/auth_repository.dart';
import 'src/features/authentication/presentation/auth_provider.dart';
import 'src/features/authentication/presentation/login_screen.dart';

import 'src/features/leagues/leagues_list_screen.dart';
import 'src/features/teams/teams_list_screen.dart';
import 'src/features/players/players_list_screen.dart';
import 'src/features/players/player_details_screen.dart';

void main() {
  runApp(const TopLeagueApp());
}

class TopLeagueApp extends StatefulWidget {
  const TopLeagueApp({super.key});

  @override
  State<TopLeagueApp> createState() => _TopLeagueAppState();
}

class _TopLeagueAppState extends State<TopLeagueApp> {
  late final ApiService apiService;
  late final AuthRepository authRepository;
  late final AuthProvider authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'https://topleague.onrender.com/api');
    authRepository = AuthRepository(apiService);
    authProvider = AuthProvider(authRepository)..checkLoginStatus();

    _router = GoRouter(
      initialLocation: '/leagues',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';

        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }
        if (isAuthenticated && isLoginRoute) {
          return '/leagues';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/leagues',
          builder: (context, state) => const LeaguesListScreen(),
          routes: [
            GoRoute(
              path: ':leagueId/teams',
              builder: (context, state) {
                final leagueId = int.parse(state.pathParameters['leagueId']!);
                return TeamsListScreen(leagueId: leagueId);
              },
              routes: [
                GoRoute(
                  path: ':teamId/players',
                  builder: (context, state) {
                    final teamId = int.parse(state.pathParameters['teamId']!);
                    return PlayersListScreen(teamId: teamId);
                  },
                  routes: [
                    GoRoute(
                      path: ':playerId',
                      builder: (context, state) {
                        final playerId = int.parse(
                          state.pathParameters['playerId']!,
                        );
                        return PlayerDetailsScreen(playerId: playerId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<AuthRepository>.value(value: authRepository),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        Provider<LeaguesRepository>(
          create: (_) => LeaguesRepository(apiService),
        ),
        Provider<TeamsRepository>(create: (_) => TeamsRepository(apiService)),
        Provider<PlayersRepository>(
          create: (_) => PlayersRepository(apiService),
        ),
        Provider<GamesRepository>(create: (_) => GamesRepository(apiService)),
        Provider<ParticipationsRepository>(
          create: (_) => ParticipationsRepository(apiService),
        ),
        Provider<UsersRepository>(create: (_) => UsersRepository(apiService)),
      ],
      child: MaterialApp.router(
        title: 'TopLeague',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ).copyWith(surface: const Color(0xFF1E1E1E)),
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF2C2C2C),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
