import 'package:flutter/material.dart';
import 'package:rota_app/modules/routes/domain/models/rota_model.dart';
import 'package:rota_app/modules/routes/widgets/status_badge.dart';

class RotaListTile extends StatelessWidget {
  final RotaModel rota;
  final VoidCallback? onTap;

  const RotaListTile({
    super.key,
    required this.rota,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple[100],
              child: const Icon(Icons.route, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rota ${rota.codigo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('De: ${rota.origem} → Para: ${rota.destino}'),
                  Text('Data: ${rota.dataEnvio}'),
                ],
              ),
            ),
            StatusBadge(status: rota.status),
          ],
        ),
      ),
    );
  }
}
