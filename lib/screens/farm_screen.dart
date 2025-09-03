import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '/theme_provider.dart';
import '/models/worker_stats.dart';

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  Future<WorkerStats?>? _futureStats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final address = Provider.of<ThemeProvider>(context).vrscAddress;
    if (address.isNotEmpty) {
      _futureStats = fetchWorkerStats(address);
    }
  }

  Future<WorkerStats?> fetchWorkerStats(String address) async {
    final url = 'https://verus.farm/api/worker_stats?$address';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return WorkerStats.fromRawJson(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching worker stats: $e');
    }
    return null;
  }

  Widget buildStatCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildWorkerCard(Worker w) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Hashrate: ${w.hashrateString}'),
            Text('Shares: ${w.shares} | Invalid: ${w.invalidShares}'),
            Text('Round Shares: ${w.currRoundShares}'),
            Text('Round Time: ${w.currRoundTime.toStringAsFixed(2)} s'),
            Text('Paid: ${w.paid} | Balance: ${w.balance}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<ThemeProvider>(context).vrscAddress;
    if (address.isEmpty) {
      return const Center(
        child: Text('Please enter your VRSC address in Settings.'),
      );
    }

    return FutureBuilder<WorkerStats?>(
      future: _futureStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found for this address.'));
        }

        final stats = snapshot.data!;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ), // space between title and status bar
                Center(
                  child: Text(
                    'Farm Stats',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // General stats
                buildStatCard('Miner', stats.miner),
                buildStatCard('Total Hash', stats.totalHash.toStringAsFixed(2)),
                buildStatCard('Total Shares', stats.totalShares.toString()),
                buildStatCard('Network Sols', stats.networkSols),
                buildStatCard('Immature', stats.immature.toStringAsFixed(8)),
                buildStatCard('Balance', stats.balance.toStringAsFixed(8)),
                buildStatCard('Paid', stats.paid.toStringAsFixed(8)),
                buildStatCard('Total Workers', stats.totalWorkers.toString()),
                buildStatCard('Active Workers', stats.activeWorkers.toString()),

                const SizedBox(height: 16),
                Text(
                  'Workers',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Workers list
                ...stats.workers.values.map(buildWorkerCard).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
