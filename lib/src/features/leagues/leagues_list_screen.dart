import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/leagues_repository.dart';
import '../../models/dto/league_dto.dart';
import '../../common_widgets/error_view.dart';
import '../../utils/ui_helpers.dart';
import 'league_list_tile.dart';

class LeaguesListScreen extends StatefulWidget {
  const LeaguesListScreen({super.key});

  @override
  State<LeaguesListScreen> createState() => _LeaguesListScreenState();
}

class _LeaguesListScreenState extends State<LeaguesListScreen> {
  late Future<List<LeagueResponseDto>> _leaguesFuture;

  @override
  void initState() {
    super.initState();
    _refreshLeagues();
  }

  void _refreshLeagues() {
    setState(() {
      _leaguesFuture = context.read<LeaguesRepository>().getLeagues();
    });
  }

  Future<void> _showCreateLeagueDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New League'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'League Name'),
                  enabled: !isSubmitting,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
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
                            });

                            final repo = context.read<LeaguesRepository>();

                            try {
                              final request = LeagueRequestDto(
                                name: nameController.text,
                              );

                              debugPrint(
                                'Attempting to create league: ${request.toJson()}',
                              );
                              await repo.createLeague(request);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                _refreshLeagues(); // Refresh the FutureBuilder safely
                              }
                            } catch (e) {
                              debugPrint('Failed to create league: $e');
                              if (context.mounted) {
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Failed to create league',
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.emoji_events,
                  size: 28,
                  color: Colors.white30,
                ),
              ),
            ],
            title: const Text(
              'LEAGUES',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.2,
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
          FutureBuilder<List<LeagueResponseDto>>(
            future: _leaguesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: ErrorView(
                    error: snapshot.error,
                    onRetry: _refreshLeagues,
                  ),
                );
              }
              final leagues = snapshot.data ?? [];
              if (leagues.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No leagues found',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final league = leagues[index];
                  return LeagueListTile(
                    league: league,
                    onTap: () {
                      context.go('/leagues/${league.id}/teams');
                    },
                  );
                }, childCount: leagues.length),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateLeagueDialog(context),
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
