import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/players_repository.dart';
import '../../models/dto/player_dto.dart';
import '../../common_widgets/error_view.dart';
import '../authentication/data/auth_repository.dart';
import '../authentication/domain/app_user.dart';
import '../../utils/ui_helpers.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final int playerId;

  const PlayerDetailsScreen({super.key, required this.playerId});

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      final playersRepo = context.read<PlayersRepository>();
      final authRepo = context.read<AuthRepository>();

      _dataFuture =
          Future.wait([
            playersRepo.getPlayer(widget.playerId),
            playersRepo.getPlayerStats(widget.playerId),
          ]).then((results) async {
            final player = results[0] as PlayerResponseDto;
            if (player.userId != null) {
              try {
                final user = await authRepo.getUser(player.userId!);
                return [...results, user];
              } catch (_) {
                return results;
              }
            }
            return results;
          });
    });
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
            return ErrorView(error: snapshot.error);
          }

          final data = snapshot.data;
          if (data == null || data.length < 2) {
            return const Center(
              child: Text(
                'Data not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final player = data[0] as PlayerResponseDto;
          final stats = data[1] as PlayerStatsResponseDto;
          final AppUser? assignedUser = data.length > 2
              ? data[2] as AppUser
              : null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF121212),
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        '#${player.jerseyNumber}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
                title: Text(
                  '${player.name} ${player.surname}'.toUpperCase(),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Player Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        Icons.person,
                        'Full Name',
                        '${player.name} ${player.surname}',
                      ),
                      const Divider(),
                      _buildEditableInfoRow(
                        Icons.account_circle,
                        'Assigned User',
                        assignedUser?.username ?? 'Unassigned',
                        onEdit: () => _showAssignUserDialog(
                          context,
                          player,
                          assignedUser,
                        ),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.sports_soccer,
                        'Position',
                        player.position,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.numbers,
                        'Jersey Number',
                        '${player.jerseyNumber}',
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Statistics',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        Icons.sports_score,
                        'Goals',
                        '${stats.totalGoals}',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.handshake,
                        'Assists',
                        '${stats.totalAssists}',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.style,
                        'Yellow/Red Cards',
                        '${stats.totalYellowCards} / ${stats.totalRedCards}',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.stadium,
                        'Games Played/Started',
                        '${stats.totalGamesPlayed} / ${stats.totalGamesStarted}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepOrange),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoRow(
    IconData icon,
    String title,
    String value, {
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orangeAccent),
            onPressed: onEdit,
            tooltip: 'Edit $title',
          ),
        ],
      ),
    );
  }

  Future<void> _showAssignUserDialog(
    BuildContext context,
    PlayerResponseDto player,
    AppUser? currentAssignedUser,
  ) async {
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;
    AppUser? selectedUser = currentAssignedUser;
    final authRepo = context.read<AuthRepository>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text(
                'Assign User',
                style: TextStyle(color: Colors.white),
              ),
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

                  return Form(
                    key: formKey,
                    child: Autocomplete<AppUser>(
                      initialValue: TextEditingValue(
                        text: selectedUser?.username ?? '',
                      ),
                      displayStringForOption: (AppUser option) =>
                          option.username,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<AppUser>.empty();
                        }
                        return users.where((AppUser option) {
                          return option.username.toLowerCase().contains(
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
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Search Username',
                                labelStyle: TextStyle(color: Colors.white70),
                                hintText: 'Type to search (clear to unassign)',
                                hintStyle: TextStyle(color: Colors.white30),
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
                  );
                },
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
                            });

                            final repo = context.read<PlayersRepository>();

                            try {
                              final request = PlayerRequestDto(
                                userId: selectedUser?.id,
                                leagueId: player.leagueId,
                                teamId: player.teamId,
                                name: player.name,
                                surname: player.surname,
                                position: player.position,
                                jerseyNumber: player.jerseyNumber,
                              );

                              await repo.updatePlayer(player.id, request);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                _refreshData();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Failed to update assigned user',
                                  e,
                                );
                                setDialogState(() {
                                  isSubmitting = false;
                                });
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
                          'Save',
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
}
