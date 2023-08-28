import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../components/flutter_toast.dart';


class Evidence extends StatefulWidget {
  final String evidenceTrip;
  Evidence({Key? key, required this.evidenceTrip});

  @override
  _EvidenceState createState() => _EvidenceState();
}

class _EvidenceState extends State<Evidence> {
  final firestoreInstance = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  List<Module> incidents = [];

  @override
  void initState() {
    super.initState();
    fetchModulesData();
  }

  Future<void> fetchModulesData() async {
    try {
      final snapshot = await firestoreInstance
          .collection("users")
          .doc(user!.uid)
          .collection("trips")
          .doc(widget.evidenceTrip)
          .collection("incident")
          .get();

      incidents = snapshot.docs.map((doc) {
        return Module(
          incidentId: doc.id,
          ridespeed: doc.get("speed").toDouble(),
        );
      }).toList();
    } catch (e) {
      AppToastmsg.appToastMeassage("Error fetching modules data: $e");
      print(e);
    }
  }

  Future<void> _handleRefresh() async {
    // Perform the refresh logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evidence'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(width: 1.0, color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text("Kandy to Colombo"),
                              Image.network(
                                "https://picsum.photos/170/100",
                                width: 170,
                                height: 100,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(incidents[index]
                                  .ridespeed
                                  .toStringAsFixed(2)),
                              CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 12.0,
                                animation: true,
                                percent: 0.7,
                                center: const Text(
                                  "70.0%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                footer: const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Risk Ride",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                circularStrokeCap:
                                    CircularStrokeCap.butt,
                                progressColor: Colors.blue,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Module {
  final String incidentId;
  final double ridespeed;

  Module({
    required this.incidentId,
    required this.ridespeed,
  });
}
