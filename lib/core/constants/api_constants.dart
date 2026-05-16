class ApiConstants {
  // Émulateur Android
  static const String baseUrl = 'http://192.168.1.5:3000/api';
  // Appareil réel → remplacer par IP du PC
  // static const String baseUrl = 'http://192.168.1.X:3000/api';

  static const String login = '$baseUrl/auth/login';
  static const String inscrireVisiteur = '$baseUrl/visiteur/inscrire';
  static const String demandeProprietaire = '$baseUrl/proprietaire/demande';
  static const String adminDemandes = '$baseUrl/admin/demandes';
  static const String conducteurs = '$baseUrl/conducteurs';
  static const String vehicules = '$baseUrl/vehicule';
  static const String lignes = '$baseUrl/ligne';
  static const String affectati1ons = '$baseUrl/affectation';
  static const String annonces = '$baseUrl/annonce';
}
