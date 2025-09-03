import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/global_stats.dart';

class GlobalStatsScreen extends StatefulWidget {
  const GlobalStatsScreen({super.key});

  @override
  State<GlobalStatsScreen> createState() => _GlobalStatsScreenState();
}

class _GlobalStatsScreenState extends State<GlobalStatsScreen> {
  late Future<GlobalStats> futureGlobalStats;

  @override
  void initState() {
    super.initState();
    futureGlobalStats = fetchGlobalStats();
  }

  Future<GlobalStats> fetchGlobalStats() async {
    final url = 'https://verus.farm/api/stats';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return globalStatsFromJson(response.body);
      } else {
        throw Exception('Failed to load global stats');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<GlobalStats>(
        future: futureGlobalStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final stats = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                Text(
                  'Global Stats',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.speed, color: Colors.green),
                    title: const Text('Network Hashrate'),
                    subtitle: Text(
                      '${(double.parse(stats.networkhashps) / 1e9).toStringAsFixed(2)} GH/s',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.bar_chart, color: Colors.blue),
                    title: const Text('Difficulty'),
                    subtitle: Text(stats.difficulty.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.layers, color: Colors.orange),
                    title: const Text('Block Height'),
                    subtitle: Text(stats.height.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.teal),
                    title: const Text('Valid Shares'),
                    subtitle: Text(stats.validShares.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.check_box, color: Colors.teal),
                    title: const Text('Valid Blocks'),
                    subtitle: Text(stats.validBlocks.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: const Text('Invalid Shares'),
                    subtitle: Text(stats.invalidShares.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.attach_money,
                      color: Colors.amber,
                    ),
                    title: const Text('Total Paid'),
                    subtitle: Text(stats.totalPaid),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.link, color: Colors.purple),
                    title: const Text('Network Connections'),
                    subtitle: Text(stats.networkConnections.toString()),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.info, color: Colors.grey),
                    title: const Text('Network Version'),
                    subtitle: Text(stats.networkVersion),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.code, color: Colors.grey),
                    title: const Text('Network Protocol Version'),
                    subtitle: Text(stats.networkProtocolVersion),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
