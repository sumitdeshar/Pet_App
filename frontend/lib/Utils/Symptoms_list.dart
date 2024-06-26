import 'package:flutter/material.dart';

class SymptomList extends StatelessWidget {
  final List<String> selectedSymptoms;
  final void Function(String symptom) onRemove; // Add onRemove parameter

  const SymptomList({
    super.key,
    required this.selectedSymptoms,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: selectedSymptoms.length,
        itemBuilder: (context, index) {
          final symptom = selectedSymptoms[index];
          return ListTile(
            title: Text(symptom),
            trailing: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onRemove(
                  symptom), // Call onRemove when the clear button is pressed
            ),
          );
        },
      ),
    );
  }
}
