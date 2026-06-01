import 'package:firebaseesp32/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
        ),
        title: const Text(
          "Chart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('EspData')
            .orderBy('Timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          List<FlSpot> gasData = [];
          List<String> timeStamps = [];

          snapshot.data!.docs.asMap().forEach((index, document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            double gasLevel = (data['GasLevel'] as num).toDouble();

            // Parse the Timestamp string into a DateTime object
            DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(data['Timestamp'] as String);

            gasData.add(FlSpot(index.toDouble(), gasLevel));
            timeStamps.add(DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime));
          });

          return Container(
            color: Colors.black, // Set background color to black
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                backgroundColor:
                    Colors.black, // Set chart background color to black
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50, // Adjusted interval for Y-axis
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                    axisNameWidget: Text(
                      'Gas Level',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < timeStamps.length) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0), // Increased space for bottom labels
                            child: Transform.rotate(
                              angle: 0.7854, // 45 degrees in radians
                              child: Text(
                                timeStamps[value.toInt()],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                      reservedSize:
                          120, // Increased reserved size for bottom titles
                    ),
                    axisNameWidget: Text(
                      'Timestamp',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.blueAccent, width: 2),
                    bottom: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: gasData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    ),
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.3),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ],
                minX: 0,
                maxX: gasData.length.toDouble() - 1,
                minY: 0,
                maxY: 300, // Set max Y-axis value to 300
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {}); // Refresh the data
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
