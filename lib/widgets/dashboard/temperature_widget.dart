import 'package:flutter/material.dart';

class TemperatureWidget extends StatelessWidget {
  final double temperature = 37.2; // Simulé pour le MVP

  Color _getTemperatureColor(double temp) {
    if (temp < 36.0) {
      return Colors.blue;
    } else if (temp < 37.0) {
      return Colors.green;
    } else if (temp < 38.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tempColor = _getTemperatureColor(temperature);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Température',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: tempColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: tempColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: tempColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              temperature >= 38.0
                  ? 'Élevée'
                  : temperature >= 37.0
                      ? 'Légèrement élevée'
                      : temperature >= 36.0
                          ? 'Normale'
                          : 'Basse',
              style: TextStyle(
                color: tempColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}