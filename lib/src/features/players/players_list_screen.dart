import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/players_repository.dart';
import '../teams/data/teams_repository.dart';
import '../../models/dto/player_dto.dart';
import '../../models/dto/team_dto.dart';
import '../authentication/data/auth_repository.dart';
import '../authentication/domain/app_user.dart';
import '../authentication/presentation/auth_provider.dart';
import '../../common_widgets/error_view.dart';
import '../../utils/ui_helpers.dart';
import 'player_list_tile.dart';

class PlayersListScreen extends StatefulWidget {
  final int teamId;

  const PlayersListScreen({super.key, required this.teamId});

  @override
  State<PlayersListScreen> createState() => _PlayersListScreenState();
}

class _PlayersListScreenState extends State<PlayersListScreen> {
  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _dataFuture = Future.wait([
        context.read<TeamsRepository>().getTeam(widget.teamId),
        context.read<PlayersRepository>().getPlayersByTeam(widget.teamId),
      ]);
    });
  }

  Future<void> _showCreatePlayerDialog(
    BuildContext context,
    TeamResponseDto team,
  ) async {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final positionController = TextEditingController();
    final jerseyController = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;
    String? errorMessage;
    AppUser? selectedUser;
    final authRepo = context.read<AuthRepository>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Player'),
              content: FutureBuilder<List<AppUser>>(
                future: authRepo.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Failed to load users',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  final users = snapshot.data!;
                  return SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            enabled: !isSubmitting,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          TextFormField(
                            controller: surnameController,
                            decoration: const InputDecoration(
                              labelText: 'Surname',
                            ),
                            enabled: !isSubmitting,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          TextFormField(
                            controller: positionController,
                            decoration: const InputDecoration(
                              labelText: 'Position',
                            ),
                            enabled: !isSubmitting,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          TextFormField(
                            controller: jerseyController,
                            decoration: const InputDecoration(
                              labelText: 'Jersey Number',
                            ),
                            enabled: !isSubmitting,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value == null || int.tryParse(value) == null
                                ? 'Invalid number'
                                : null,
                          ),
                          Autocomplete<AppUser>(
                            displayStringForOption: (AppUser option) =>
                                option.username,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<AppUser>.empty();
                                  }
                                  return users.where((AppUser option) {
                                    return option.username
                                        .toLowerCase()
                                        .contains(
                                          textEditingValue.text.toLowerCase(),
                                        );
                                  });
                                },
                            onSelected: (AppUser selection) {
                              selectedUser = selection;
                            },
                            fieldViewBuilder:
                                (
                                  context,
                                  textEditingController,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      labelText: 'Search Username (Optional)',
                                      hintText: 'Type to search users',
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        selectedUser = null;
                                      } else {
                                        try {
                                          selectedUser = users.firstWhere(
                                            (u) =>
                                                u.username.toLowerCase() ==
                                                value.toLowerCase(),
                                          );
                                        } catch (_) {
                                          selectedUser = null;
                                        }
                                      }
                                    },
                                    enabled: !isSubmitting,
                                  );
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
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setDialogState(() {
                              isSubmitting = true;
                              errorMessage = null;
                            });

                            final authProvider = context.read<AuthProvider>();
                            final repo = context.read<PlayersRepository>();

                            try {
                              final request = PlayerRequestDto(
                                userId:
                                    selectedUser?.id ??
                                    (authProvider.user?.id ?? 1),
                                leagueId: team.leagueId,
                                teamId: team.id,
                                name: nameController.text,
                                surname: surnameController.text,
                                position: positionController.text,
                                jerseyNumber: int.parse(jerseyController.text),
                              );

                              debugPrint(
                                'Attempting to create player: ${request.toJson()}',
                              );
                              await repo.createPlayer(request);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                _refreshData(); // Refresh the parent view safely
                              }
                            } catch (e) {
                              debugPrint('Failed to create player: $e');
                              if (context.mounted) {
                                setDialogState(() {
                                  isSubmitting = false;
                                });
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Failed to create player',
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
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
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _refreshData);
          }

          final team = snapshot.data![0] as TeamResponseDto;
          final players = snapshot.data![1] as List<PlayerResponseDto>;

          return Scaffold(
            // using an inner scaffold for the FAB positioning to avoid covering content weirdly, but outer is okay since slivers manage it. Wait, previously outer was scaffold with FAB.
            backgroundColor: Colors
                .transparent, // keeping transparency so the parent color works
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 110.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: const Color(0xFF121212),
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  actions: const [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.groups,
                        size: 28,
                        color: Colors.white30,
                      ),
                    ),
                  ],
                  title: Text(
                    team.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2C1A14), Color(0xFF121212)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatChip('Pts', '${team.points}'),
                              const SizedBox(width: 8),
                              _buildStatChip('PJ', '${team.gamesPlayed}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.0),
                    child: Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orangeAccent.withOpacity(0.1),
                            Colors.orange.withOpacity(0.8),
                            Colors.orangeAccent.withOpacity(0.1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
                if (players.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No players found',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 600,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 2.2,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final player = players[index];
                        return PlayerListTile(
                          player: player,
                          onTap: () {
                            context.go(
                              '/leagues/${team.leagueId}/teams/${team.id}/players/${player.id}',
                            );
                          },
                        );
                      }, childCount: players.length),
                    ),
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreatePlayerDialog(context, team),
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
