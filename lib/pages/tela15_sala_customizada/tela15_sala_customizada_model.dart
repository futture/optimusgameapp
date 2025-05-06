import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/room_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela15_sala_customizada/tela15_sala_customizada_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class Tela15SalaCustomizadaViewModel
    extends FlutterFlowModel<Tela15SalaCustomizadaViewWidget> {
  int TIME_TO_RESPONSE = 10;
  UserResponse? user;
  bool isSimpleQuestion = true;
  bool onlyOneWinner = true;

  final formKey = GlobalKey<FormState>();
  List<Map<String, String>> addedUsers = [];

  TextEditingController? idTextController;
  FocusNode? idFocusNode;

  TextEditingController? numberPlayerTextController;
  FocusNode? numberPlayerFocusNode;

  TextEditingController? numberQuestionTextController;
  FocusNode? numberQuestionFocusNode;

  TextEditingController? numberOptionAnswerTextController;
  FocusNode? numberOptionAnswerFocusNode;

  TextEditingController? montanteTextController;
  FocusNode? montanteFocusNode;

  bool isShowWaitingDialogOpen = false;
  late BuildContext currentShowWaitingDialog;
  bool isLoadingRooms = false;
  final roomService = RoomService();
  final matchService = MatchService();
  late BuildContext context;
  String userId = "";
  int minPlayers = 1;
  int numberOfPlayers = 1;
  String matchId = "";
  MatchResponse? matchInfo;
  int playersConnected = 0;
  bool isWaitingPlayers = false;
  List<RoomResponse> rooms = List.empty();
  MatchWebSocketService? _matchWebSocketService;
  List<String> playerIds = [];

  List<String> phoneNumbers = [];

  VoidCallback? onWaitingPlayersCallback;

  Map<String, String> listContacts = {};

  String? _validarCampo(BuildContext context, String? val, String campo) {
    if (val == null || val.isEmpty) {
      return '$campo é obrigatório';
    }
    return null;
  }

  final UserService userService = UserService();

  @override
  void initState(BuildContext context) {
    this.context = context;

    idTextController = TextEditingController();
    numberPlayerTextController = TextEditingController();
    numberQuestionTextController = TextEditingController();
    numberOptionAnswerTextController = TextEditingController();
    montanteTextController = TextEditingController();

    idFocusNode = FocusNode();
    numberPlayerFocusNode = FocusNode();
    numberQuestionFocusNode = FocusNode();
    numberOptionAnswerFocusNode = FocusNode();
    montanteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    idTextController?.dispose();
    numberPlayerTextController?.dispose();
    numberQuestionTextController?.dispose();
    numberOptionAnswerTextController?.dispose();
    montanteTextController?.dispose();

    idFocusNode?.dispose();
    numberPlayerFocusNode?.dispose();
    numberQuestionFocusNode?.dispose();
    numberOptionAnswerFocusNode?.dispose();
    montanteFocusNode?.dispose();
    _matchWebSocketService?.disconnect();
  }

  String? validateId(BuildContext context, String? val) {
    return _validarCampo(context, val, 'ID do Jogador');
  }

  String? validateNumberPlayer(BuildContext context, String? val) {
    return _validarCampo(context, val, 'Número de Jogadores');
  }

  String? validateNumberQuestion(BuildContext context, String? val) {
    return _validarCampo(context, val, 'Número de Questões');
  }

  String? validateNumberOptionAnswer(BuildContext context, String? val) {
    return _validarCampo(context, val, 'Número de Opções de Resposta');
  }

  String? validateMontante(BuildContext context, String? val) {
    return _validarCampo(context, val, 'Montante da Aposta');
  }

  Future<void> getPlayerByIdAsync(
      String playerId, void Function(VoidCallback fn) setState) async {
    var result = await userService.getPlayerByIdAsync(playerId);
    if (result["isSuccess"]) {
      setState(() {
        user = result["data"];
      });
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getPlayerByPhoneNumberAsync(
      String phoneNumber, void Function(VoidCallback fn) setState) async {
    var result = await userService.getUserByPhoneNumbrAsync(phoneNumber);
    if (result["isSuccess"]) {
      setState(() {
        user = result["data"];
      });
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getUserIdAsync(VoidCallback? callback) async {
    userId = await UserUtil.getUserId() ?? "";
    callback?.call();
  }

  Future<void> getRoomAsync(void Function(VoidCallback) setState) async {
    setState(() {
      isLoadingRooms = true;
    });
    final resultRoom = await roomService.getAllRoomAsync(false, false);

    if (resultRoom["isSuccess"] == true) {
      final fetchedRooms = resultRoom["data"];
      setState(() {
        rooms = fetchedRooms;
        isLoadingRooms = false;
      });
    } else {
      final error = resultRoom["error"].detail;
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        error.message,
        error.details,
      );
    }
  }

  Future<String?> createRoomAsync() async {
    var result = await roomService.createRoomAsync(CreateRoomRequest(
        isCustomized: true,
        nameRoom: "SALA-CUSTOMIZADA",
        roomConfiguration: CreateRoomConfigurationRequest(
            isEvent: false,
            isSingleWinner: onlyOneWinner,
            isSimpleQuestions: isSimpleQuestion,
            timeToRespond: TIME_TO_RESPONSE,
            numberOfPlayers: int.parse(numberPlayerTextController.text),
            numberOfQuestions: int.parse(numberQuestionTextController.text),
            numberOfAnswerOptions:
                int.parse(numberOptionAnswerTextController.text),
            minimumNumberOfPlayers: int.parse(numberPlayerTextController.text),
            minimumAmountToPlay: double.parse(montanteTextController.text),
            premiumRate: 0.1)));
    if (result["isSuccess"]) {
      return result["data"]["id"];
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
      return null;
    }
  }

  Future<void> createMatchAsync() async {
    try {
      final roomResult = await createRoomAsync();
      if (roomResult != null) {
        final matchRequest = CreateMatchRequest(
            matchStartDate: DateTime.now(),
            endDateOfMatch: DateTime.now().add(Duration(
                seconds: TIME_TO_RESPONSE *
                    int.parse(numberQuestionTextController.text))));

        final matchResult =
            await matchService.createMatchAsync(roomResult, matchRequest);

        if (matchResult["isSuccess"] != true) {
          await Warning00ErrorUtil.showDialogMessageError(
            context,
            matchResult["error"].detail.message,
            matchResult["error"].detail.details,
          );
          return;
        }

        matchId = matchResult["data"]["id"];

        final playerResult = await matchService.addPlayerMatchAsync(
          matchId,
          AddPlayerMatchRequest(playerId: userId, playerIds: playerIds),
        );

        if (playerResult["isSuccess"] != true) {
          await Warning00ErrorUtil.showDialogMessageError(
            context,
            playerResult["error"].detail.message,
            playerResult["error"].detail.details,
          );
          return;
        }

        await getMatchByMatchIdAsync();
        await getWebSocketWaitForPlayerAsync();
      }
    } catch (e) {
      print("Erro inesperado ao criar partida: $e");
    }
  }

  Future<void> getMatchByMatchIdAsync() async {
    final resultMatch = await matchService.getMatchByMatchIdAsync(matchId);
    if (resultMatch["isSuccess"]) {
      matchInfo = resultMatch["data"];
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchId,
      userId: userId,
      context: context,
      matchInfo: matchInfo!,
      onOther: (match) {
        if (!isWaitingPlayers) return;

        isWaitingPlayers = false;

        if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
          Navigator.of(currentShowWaitingDialog).pop();
          isShowWaitingDialogOpen = false;
        }

        //_matchWebSocketService?.disconnect();

        onWaitingPlayersCallback?.call();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela06SaladeJogoWidget(
                matchInfo: matchInfo,
                recebeuNotificaca: false,
                nextQuestion: match.nextQuestion,
              ),
            ),
          );
        }
      },
      onMatchUpdate: (match) {
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        numberOfPlayers = match.numberOfPlayers;
        isWaitingPlayers = true;
        showWaitingDialog();
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connect();
  }

  Future<void> leaveTheMatchAsync(context) async {
    var result = await matchService.leaveTheMatchAsync(matchId, userId);
    if (result["isSuccess"]) {
      _matchWebSocketService?.disconnect();
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  void showWaitingDialog() {
    if (isShowWaitingDialogOpen) return;

    isShowWaitingDialogOpen = true;
    currentShowWaitingDialog = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Aguardando jogadores..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Esperando participantes conectarem, Participante conectados: $playersConnected / $numberOfPlayers",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(currentShowWaitingDialog).pop();
              await leaveTheMatchAsync(context);
              _matchWebSocketService?.disconnect();
              isShowWaitingDialogOpen = false;
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Future<void> addUser(String phoneNumber, setState) async {
    phoneNumber = phoneNumber.replaceAll("+244", "");

    await getPlayerByPhoneNumberAsync(phoneNumber, setState);
    if (user == null) return;
    final nome = user?.name ?? 'Usuário Desconhecido';
    if (addedUsers.length < int.parse(numberPlayerTextController.text) - 1) {
      setState(() {
        addedUsers.add({'id': user!.id, 'nome': nome});
        idTextController?.clear();
      });
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        "Falha ao adicionar participante para a partida",
        "Numero de jogador atingido",
      );
    }
  }

  Future<void> fetchContactsAsync(Function setState) async {
    var contacts = await userService.fetchContactsAsync();

    listContacts.clear();

    for (var e in contacts) {
      String phone = (e.phones.isNotEmpty)
          ? e.phones.first.number.replaceAll(RegExp(r'\s+|\-|\(|\)'), '')
          : '';

      String name = e.displayName.isNotEmpty ? e.displayName : 'Sem Nome';

      if (phone.isNotEmpty) {
        listContacts[phone] = name;
      }
    }

    setState(() {});
  }
}
