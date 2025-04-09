import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class MatchInfoScreen extends StatefulWidget {
  final String matchId;
  final bool showDialogOnOpen;

  const MatchInfoScreen({
    super.key,
    this.showDialogOnOpen = false,
    required this.matchId,
  });

  @override
  State<MatchInfoScreen> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  MatchResponse? matchInfo;
  final _matchService = MatchService();

  @override
  void initState() {
    super.initState();
    fetchMatchById();
    if (widget.showDialogOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWarningDialog();
      });
    }
  }

  Future<void> fetchMatchById() async {
    final result = await _matchService.getMatchByMatchIdAsync(widget.matchId);
    if (result["isSuccess"] == true) {
      setState(() => matchInfo = result["data"]);
    }
  }

  void showWarningDialog() {
    if (matchInfo == null) return;
    final fee = matchInfo!.matchConfiguration!.minimumAmountToPlay;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        const TextSpan(
                          text: 'Atenção: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              'ao se inscrever neste jogo será deduzido do seu saldo a taxa de ',
                        ),
                        TextSpan(
                          text: '${fee}kz',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' para poder jogar.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Confirmar\nInscrição e entrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Partida")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: matchInfo == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    '🏆 Partida de Trivia',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Jogadores: ${matchInfo!.matchConfiguration!.numberOfPlayers}\n'
                    'Prêmio: ${(matchInfo!.matchConfiguration!.minimumAmountToPlay * matchInfo!.matchConfiguration!.numberOfPlayers) * 0.75}kz\n'
                    'Taxa de entrada: ${matchInfo!.matchConfiguration!.minimumAmountToPlay}kz\n'
                    'Duração: ${(matchInfo!.matchConfiguration!.timeToRespond * matchInfo!.matchConfiguration!.numberOfQuestions)}s',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Recusar',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: showWarningDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Aceitar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
