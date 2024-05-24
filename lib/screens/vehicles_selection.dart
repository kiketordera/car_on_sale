import 'package:car_on_sale/models/vehicle_options.dart';
import 'package:flutter/material.dart';

class VehicleSelectionScreen extends StatelessWidget {
  final List<VehicleOption> options;

  const VehicleSelectionScreen(this.options, {super.key});

  @override
  Widget build(BuildContext context) {
    // Sort options by similarity
    options.sort((a, b) => b.similarity.compareTo(a.similarity));

    return Scaffold(
      appBar: AppBar(title: const Text("Select Vehicle")),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            title: Text('${option.make} ${option.model}'),
            subtitle: Text(
                'Similarity: ${option.similarity}\nContainer: ${option.containerName}'),
            onTap: () {
              Navigator.pop(context, option.externalId);
            },
          );
        },
      ),
    );
  }
}
