import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/utils/static_data.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyCard extends StatelessWidget {
  final int index;
  final Academy academy;

  const AcademyCard({super.key, required this.index, required this.academy});

  @override
  Widget build(BuildContext context) {
    final staticAcademy = academies[index % academies.length];

    return GestureDetector(
      onTap: () => context.push("/AcademyDetails/${academy.id}"),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[200],
                  image: academy.image != null && academy.image!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(academy.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: academy.image == null || academy.image!.isEmpty
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${staticAcademy['rating']} (${staticAcademy['reviewCount']})',
                        style: TextStyle(
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
                        academy.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      academy.city,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
