import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/data/models/pool.dart';

class PoolCard extends StatelessWidget {
  final Pool pool;

  const PoolCard({super.key, required this.pool});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/poolList/${pool.id}'),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                image: pool.image != null && pool.image!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(pool.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: pool.image == null || pool.image!.isEmpty
                  ? const Center(
                      child: Icon(Icons.pool, size: 64, color: Colors.white54),
                    )
                  : null,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pool.heated
                      ? Colors.orange.withOpacity(0.85)
                      : Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pool.heated ? Icons.whatshot : Icons.ac_unit,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pool.heated ? 'Heated' : 'Unheated',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pool.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    pool.academyName,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
