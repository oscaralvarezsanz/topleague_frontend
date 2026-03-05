import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dto/game_dto.dart';
import '../../models/dto/participation_dto.dart';
import '../../models/dto/player_dto.dart';
import '../../models/dto/team_dto.dart';
import '../participations/data/participations_repository.dart';
import '../players/data/players_repository.dart';
import '../teams/data/teams_repository.dart';
import '../../utils/ui_helpers.dart';
import '../players/player_details_screen.dart';

class GameDetailsScreen extends StatefulWidget {
  final GameResponseDto game;

  const GameDetailsScreen({super.key, required this.game});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  late ParticipationsRepository _participationsRepository;
  late PlayersRepository _playersRepository;
  late TeamsRepository _teamsRepository;

  List<ParticipationResponseDto> _participations = [];
  List<PlayerResponseDto> _homePlayers = [];
  List<PlayerResponseDto> _awayPlayers = [];
  TeamResponseDto? _homeTeam;
  TeamResponseDto? _awayTeam;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _participationsRepository = context.read<ParticipationsRepository>();
    _playersRepository = context.read<PlayersRepository>();
    _teamsRepository = context.read<TeamsRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _participationsRepository.getParticipationsByGame(widget.game.id),
        _playersRepository.getPlayersByTeam(widget.game.homeTeamId),
        _playersRepository.getPlayersByTeam(widget.game.awayTeamId),
        _teamsRepository.getTeam(widget.game.homeTeamId),
        _teamsRepository.getTeam(widget.game.awayTeamId),
      ]);

      setState(() {
        _participations = results[0] as List<ParticipationResponseDto>;
        _homePlayers = results[1] as List<PlayerResponseDto>;
        _awayPlayers = results[2] as List<PlayerResponseDto>;
        _homeTeam = results[3] as TeamResponseDto;
        _awayTeam = results[4] as TeamResponseDto;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        UIHelpers.showErrorSnackBar(context, 'Error loading data', e);
      }
    }
  }

  void _showAddParticipationDialog(PlayerResponseDto player) {
    final formKey = GlobalKey<FormState>();
    final goalsController = TextEditingController(text: '0');
    final assistsController = TextEditingController(text: '0');
    final yellowController = TextEditingController(text: '0');
    final redController = TextEditingController(text: '0');
    bool isStarter = true;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(
                'Add Participation for ${player.name}',
                style: const TextStyle(color: Colors.white),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: goalsController,
                              decoration: const InputDecoration(
                                labelText: 'Goals',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: assistsController,
                              decoration: const InputDecoration(
                                labelText: 'Assists',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: yellowController,
                              decoration: const InputDecoration(
                                labelText: 'Yellow Cards',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: redController,
                              decoration: const InputDecoration(
                                labelText: 'Red Cards',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Starter?',
                          style: TextStyle(color: Colors.white),
                        ),
                        value: isStarter,
                        activeThumbColor: Colors.deepOrange,
                        onChanged: (val) {
                          setModalState(() => isStarter = val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setModalState(() => isSubmitting = true);
                            try {
                              final request = ParticipationRequestDto(
                                gameId: widget.game.id,
                                playerId: player.id,
                                goals: int.parse(goalsController.text),
                                assists: int.parse(assistsController.text),
                                yellowCards: int.parse(yellowController.text),
                                redCards: int.parse(redController.text),
                                starter: isStarter,
                              );
                              final response = await _participationsRepository
                                  .createParticipation(request);
                              setState(() {
                                _participations.add(response);
                              });
                              if (context.mounted) Navigator.pop(context);
                            } catch (e) {
                              setModalState(() => isSubmitting = false);
                              if (context.mounted) {
                                UIHelpers.showErrorSnackBar(
                                  context,
                                  'Error saving participation',
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
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'SAVE',
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text(
              'MATCHDAY ${widget.game.matchday ?? "-"}',
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C1A14), Color(0xFF121212)],
                ),
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.sports_soccer,
                  size: 28,
                  color: Colors.white30,
                ),
              ),
            ],
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
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            SliverToBoxAdapter(child: _buildScoreboard()),
            SliverToBoxAdapter(child: _buildLineups()),
          ],
        ],
      ),
    );
  }

  Widget _buildLineups() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _homeTeam?.name ?? 'Home Team',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._homePlayers.map((player) => _buildPlayerLineupTile(player)),
          const SizedBox(height: 24),
          Text(
            _awayTeam?.name ?? 'Away Team',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._awayPlayers.map((player) => _buildPlayerLineupTile(player)),
        ],
      ),
    );
  }

  Widget _buildPlayerLineupTile(PlayerResponseDto player) {
    final participation = _participations
        .cast<ParticipationResponseDto?>()
        .firstWhere((p) => p?.playerId == player.id, orElse: () => null);

    Widget subtitleWidget;
    if (participation != null) {
      subtitleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            player.position,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: '⚽ ${participation.goals} | ',
                  style: const TextStyle(color: Colors.white70),
                ),
                TextSpan(
                  text: '👟 ${participation.assists} | ',
                  style: const TextStyle(color: Colors.white70),
                ),
                TextSpan(
                  text: '🟨 ${participation.yellowCards} | ',
                  style: const TextStyle(color: Colors.yellow),
                ),
                TextSpan(
                  text: '🟥 ${participation.redCards}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                if (participation.starter)
                  const TextSpan(
                    text: ' | ⭐ Titular',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      subtitleWidget = Text(
        player.position,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      );
    }

    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            '${player.jerseyNumber}',
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          '${player.name} ${player.surname}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitleWidget,
        trailing: participation == null
            ? IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.deepOrange,
                ),
                onPressed: () => _showAddParticipationDialog(player),
              )
            : const Icon(Icons.check_circle, color: Colors.green),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailsScreen(playerId: player.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreboard() {
    final dateStr = widget.game.date;
    String formattedDate = 'Unknown Date';
    if (dateStr != null) {
      try {
        final date = DateTime.parse(dateStr);
        formattedDate =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (_) {
        formattedDate = dateStr;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C1A14), Color(0xFF121212)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.shield, color: Colors.white54, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      _homeTeam?.name ?? 'Team ${widget.game.homeTeamId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${widget.game.homeScore} - ${widget.game.awayScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  letterSpacing: 2.0,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.shield, color: Colors.white54, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      _awayTeam?.name ?? 'Team ${widget.game.awayTeamId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
