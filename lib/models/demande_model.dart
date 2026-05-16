class DemandeModel {
  final String nom;
  final String email;
  final String tel;
  final String adresse;
  final String motDePasse;

  DemandeModel({
    required this.nom,
    required this.email,
    required this.tel,
    required this.adresse,
    required this.motDePasse,
  });

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'email': email,
    'tel': tel,
    'adresse': adresse,
    'mot_de_passe': motDePasse,
  };
}
