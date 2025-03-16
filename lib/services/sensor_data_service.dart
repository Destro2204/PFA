
class AuthService {
  // Pour le MVP, nous utilisons une simple simulation
  // Dans une version réelle, cela se connecterait à une API ou à Firebase
  
  static Future<bool> signIn(String email, String password) async {
    // Simule un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Pour le MVP, accepte n'importe quel email/mot de passe valide
    if (email.contains('@') && password.length >= 6) {
      return true;
    }
    
    return false;
  }
  
  static Future<bool> register(String name, String email, String password) async {
    // Simule un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Pour le MVP, accepte n'importe quelle inscription valide
    if (name.isNotEmpty && email.contains('@') && password.length >= 6) {
      return true;
    }
    
    return false;
  }
  
  static Future<void> signOut() async {
    // Simule un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Dans une vraie application, effacerait les tokens et les données de session
    return;
  }
  
  static Future<Map<String, dynamic>> getUserProfile() async {
    // Simule un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Renvoie des données simulées pour le MVP
    return {
      'name': 'Utilisateur Test',
      'email': 'test@example.com',
      'profilePicture': null,
    };
  }
}