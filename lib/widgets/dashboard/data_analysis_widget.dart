import 'package:flutter/material.dart';

class DataAnalysisWidget extends StatelessWidget {
  const DataAnalysisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse des données',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          
          // Statut global
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statut physiologique normal',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Tous les paramètres sont dans les plages normales',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(height: 30),
          
          // Données détaillées
          AnalysisDetailItem(
            icon: Icons.favorite,
            title: 'Fréquence cardiaque',
            value: '72 BPM',
            status: 'Normal',
            context: context,
          ),
          
          const SizedBox(height: 10),
          
          AnalysisDetailItem(
            icon: Icons.thermostat,
            title: 'Température',
            value: '37.2°C',
            status: 'Légèrement élevée',
            isWarning: true,
            context: context,
          ),
          
          const SizedBox(height: 10),
          
          AnalysisDetailItem(
            icon: Icons.speed,
            title: 'Activité',
            value: 'Repos',
            status: 'Normal',
            context: context,
          ),
          
          const SizedBox(height: 20),
          
          // Recommandations
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommandations:',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Surveillance de la température à poursuivre. Maintenir une bonne hydratation.',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnalysisDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String status;
  final bool isWarning;
  final BuildContext context;

  const AnalysisDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.status,
    this.isWarning = false,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isWarning ? Colors.orange[100] : Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isWarning ? Colors.orange[800] : Colors.green[800],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
   );
  }
}