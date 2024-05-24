import 'dart:convert';

import 'package:flutter/material.dart';

class AuctionDataScreen extends StatelessWidget {
  final String data;

  const AuctionDataScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final auctionData = json.decode(data);

    return Scaffold(
      appBar: AppBar(title: const Text("Auction Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ${auctionData['price']}",
                style: const TextStyle(fontSize: 18)),
            Text("Model: ${auctionData['model']}",
                style: const TextStyle(fontSize: 18)),
            Text("UUID: ${auctionData['_fk_uuid_auction']}",
                style: const TextStyle(fontSize: 18)),
            if (auctionData['feedback'] != null)
              Text(
                "${auctionData['positiveCustomerFeedback'] ? "Positive" : "Negative"} Feedback: ${auctionData['feedback']}",
                style: TextStyle(
                  fontSize: 18,
                  color: auctionData['positiveCustomerFeedback']
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
