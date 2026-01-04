class MatchStatusUtil {
  static const Map<String, String> matchStatusBackendValue = {
    "IN_PROGRESS": "Em andamento",
    "PENDING": "Pendente",
    "FINISHED": "Finalizada",
    "CANCELLED": "Cancelada",
    "WAITING_FOR_START": "Aguardando inicio",
  };
  static String toBackendValue(String localStatus) {
    return matchStatusBackendValue[localStatus] ?? localStatus;
  }
}
