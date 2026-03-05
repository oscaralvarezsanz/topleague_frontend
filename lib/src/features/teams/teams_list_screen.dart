import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/teams_repository.dart';
import '../../models/dto/team_dto.dart';
import 'team_list_tile.dart';
import 'team_table_header.dart';
import '../games/data/games_repository.dart';
import '../../models/dto/game_dto.dart';
import '../../common_widgets/error_view.dart';
import '../../utils/ui_helpers.dart';
import '../games/game_list_tile.dart';
import '../games/game_details_screen.dart';

class TeamsListScreen extends StatefulWidget {
  final int leagueId;

  const TeamsListScreen({super.key, required this.leagueId});

  @override
  State<TeamsListScreen> createState() => _TeamsListScreenState();
}

class _TeamsListScreenState extends State<TeamsListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<TeamResponseDto>> _teamsFuture;
  late Future<List<GameResponseDto>> _gamesFuture;
  late TabController _tabController;
  int _selectedMatchday = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _refreshTeams();
    _refreshGames();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshTeams() {
    setState(() {
      _teamsFuture = context.read<TeamsRepository>().getTeamsByLeague(
        widget.leagueId,
      );
    });
  }

  void _refreshGames() {
    setState(() {
      _gamesFuture = context.read<GamesRepository>().getGamesByLeague(
        widget.leagueId,
        matchday: _selectedMatchday,
      );
    });
  }

  Future<void> _showCreateTeamDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;
    String? errorMessage;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text(
                'Create New Team',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Team Name',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        enabled: !isSubmitting,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setDialogState(() {
                              isSubmitting = true;
                              errorMessage = null;
                            });

                            final repo = context.read<TeamsRepository>();

                            try {
                              final request = TeamRequestDto(
                                leagueId: widget.leagueId,
                                name: nameController.text,
                              );
                              await repo.createTeam(request);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                _refreshTeams();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setDialogState(() {
                                  isSubmitting = false;
                                });
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Failed to create team',
                                  e,
                                );
                              }
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showCreateGameDialog(BuildContext context) async {
    final matchdayController = TextEditingController(
      text: _selectedMatchday.toString(),
    );
    final homeScoreController = TextEditingController();
    final awayScoreController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;
    String? errorMessage;
    TeamResponseDto? selectedHomeTeam;
    TeamResponseDto? selectedAwayTeam;

    final teams = await _teamsFuture;
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text(
                'Create New Game',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<TeamResponseDto>(
                        decoration: const InputDecoration(
                          labelText: 'Home Team',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        dropdownColor: const Color(0xFF3C3C3C),
                        style: const TextStyle(color: Colors.white),
                        initialValue: selectedHomeTeam,
                        items: teams
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ),
                            )
                            .toList(),
                        onChanged: isSubmitting
                            ? null
                            : (v) => setDialogState(() => selectedHomeTeam = v),
                        validator: (v) => v == null ? 'Select home team' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TeamResponseDto>(
                        decoration: const InputDecoration(
                          labelText: 'Away Team',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        dropdownColor: const Color(0xFF3C3C3C),
                        style: const TextStyle(color: Colors.white),
                        initialValue: selectedAwayTeam,
                        items: teams
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ),
                            )
                            .toList(),
                        onChanged: isSubmitting
                            ? null
                            : (v) => setDialogState(() => selectedAwayTeam = v),
                        validator: (v) {
                          if (v == null) return 'Select away team';
                          if (v == selectedHomeTeam) {
                            return 'Cannot play against itself';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: matchdayController,
                        decoration: const InputDecoration(
                          labelText: 'Matchday',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        enabled: !isSubmitting,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: homeScoreController,
                              decoration: const InputDecoration(
                                labelText: 'Home Score',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              enabled: !isSubmitting,
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: awayScoreController,
                              decoration: const InputDecoration(
                                labelText: 'Away Score',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              enabled: !isSubmitting,
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setDialogState(() {
                              isSubmitting = true;
                              errorMessage = null;
                            });

                            final repo = context.read<GamesRepository>();
                            try {
                              final request = GameRequestDto(
                                leagueId: widget.leagueId,
                                homeTeamId: selectedHomeTeam!.id,
                                awayTeamId: selectedAwayTeam!.id,
                                homeScore: int.parse(homeScoreController.text),
                                awayScore: int.parse(awayScoreController.text),
                                matchday: int.tryParse(matchdayController.text),
                              );

                              await repo.createGame(request);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                _refreshGames(); // Also update standings conceptually, but we'll refresh teams too
                                _refreshTeams();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setDialogState(() {
                                  isSubmitting = false;
                                });
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Failed to create game',
                                  e,
                                );
                              }
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF121212),
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.shield, size: 28, color: Colors.white30),
                ),
              ],
              title: const Text(
                'LEAGUE DETAILS',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2C1A14), Color(0xFF121212)],
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.orangeAccent,
                labelColor: Colors.orangeAccent,
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(text: 'Teams', icon: Icon(Icons.format_list_numbered)),
                  Tab(text: 'Games', icon: Icon(Icons.sports_soccer)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [_buildTeamsTab(), _buildGamesTab()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tabController.index == 0
            ? () => _showCreateTeamDialog(context)
            : () => _showCreateGameDialog(context),
        backgroundColor: Colors.orangeAccent,
        child: Icon(
          _tabController.index == 0 ? Icons.add_moderator : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTeamsTab() {
    return Column(
      children: [
        const TeamTableHeader(),
        Expanded(
          child: FutureBuilder<List<TeamResponseDto>>(
            future: _teamsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorView(error: snapshot.error, onRetry: _refreshTeams);
              }
              final teams = List<TeamResponseDto>.from(snapshot.data ?? []);
              teams.sort((a, b) {
                int cmp = b.points.compareTo(a.points);
                if (cmp == 0) return a.name.compareTo(b.name);
                return cmp;
              });

              if (teams.isEmpty) {
                return const Center(
                  child: Text(
                    'No teams found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return TeamListTile(
                    team: team,
                    index: index + 1,
                    onTap: () {
                      context.go(
                        '/leagues/${widget.leagueId}/teams/${team.id}/players',
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGamesTab() {
    return Column(
      children: [
        _buildMatchdaySelector(),
        Expanded(
          child: FutureBuilder(
            future: Future.wait([_teamsFuture, _gamesFuture]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorView(error: snapshot.error, onRetry: _refreshGames);
              }

              final teams = snapshot.data![0] as List<TeamResponseDto>;
              final games = snapshot.data![1] as List<GameResponseDto>;

              if (games.isEmpty) {
                return const Center(
                  child: Text(
                    'No games found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 80,
                  left: 16,
                  right: 16,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  final homeTeam = teams.firstWhere(
                    (t) => t.id == game.homeTeamId,
                    orElse: () => TeamResponseDto(
                      id: 0,
                      leagueId: 0,
                      name: 'Unknown',
                      gamesPlayed: 0,
                      points: 0,
                    ),
                  );
                  final awayTeam = teams.firstWhere(
                    (t) => t.id == game.awayTeamId,
                    orElse: () => TeamResponseDto(
                      id: 0,
                      leagueId: 0,
                      name: 'Unknown',
                      gamesPlayed: 0,
                      points: 0,
                    ),
                  );

                  return GameListTile(
                    game: game,
                    homeTeamName: homeTeam.name,
                    awayTeamName: awayTeam.name,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetailsScreen(game: game),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchdaySelector() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: _selectedMatchday > 1
                ? () {
                    setState(() {
                      _selectedMatchday--;
                    });
                    _refreshGames();
                  }
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            'Jornada $_selectedMatchday',
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedMatchday++;
              });
              _refreshGames();
            },
          ),
        ],
      ),
    );
  }
}
