class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
  });
  
  // Créer depuis un json (pour l'API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }
  
  // Convertir en json (pour l'API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
  
  // Créer une copie avec mise à jour possible
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}