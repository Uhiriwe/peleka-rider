import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: RiderDashboard()));
}

class RiderDashboard extends StatelessWidget {
  Future<List<DeliveryRequest>> fetchDeliveryRequests() async {
    final response = await http.get(Uri.parse('https://peleka-api.up.railway.app/api/rider-deliveries/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DeliveryRequest.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load delivery requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none, color: Colors.black, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Allan Smith",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(35),
                child: const Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      "\$750.45",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Requests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View all", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<DeliveryRequest>>(
              future: fetchDeliveryRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: ListTile(
                          title: Text(snapshot.data![index].packageName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Recipient: ${snapshot.data![index].recipient}\nDrop-off: ${snapshot.data![index].dropOffLocation}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300], // Light grey background color for 'Reject' button
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                ),
                                child: const Text('Reject', style: TextStyle(color: Colors.black)),
                              ),
                              SizedBox(width: 8),  // Space between buttons
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Blue background color for 'Accept' button
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                ),
                                child: const Text('Accept', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryRequest {
  final String packageName;
  final String recipient;
  final String dropOffLocation;

  DeliveryRequest({required this.packageName, required this.recipient, required this.dropOffLocation});

  factory DeliveryRequest.fromJson(Map<String, dynamic> json) {
    return DeliveryRequest(
      packageName: json['packageName'] as String,
      recipient: json['recipient'] as String,
      dropOffLocation: json['dropOffLocation'] as String,
    );
  }
}
