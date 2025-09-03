import 'dart:convert';

class WorkerStats {
  final String miner;
  final double totalHash;
  final int totalShares;
  final String networkSols;
  final double immature;
  final double balance;
  final double paid;
  final Map<String, Worker> workers;
  final Map<String, List<HistoryEntry>> history;

  WorkerStats({
    required this.miner,
    required this.totalHash,
    required this.totalShares,
    required this.networkSols,
    required this.immature,
    required this.balance,
    required this.paid,
    required this.workers,
    required this.history,
  });

  factory WorkerStats.fromRawJson(String str) {
    final jsonData = json.decode(str);
    final workerMap = <String, Worker>{};
    if (jsonData['workers'] != null) {
      (jsonData['workers'] as Map<String, dynamic>).forEach((k, v) {
        workerMap[k] = Worker.fromJson(v);
      });
    }

    final historyMap = <String, List<HistoryEntry>>{};
    if (jsonData['history'] != null) {
      (jsonData['history'] as Map<String, dynamic>).forEach((k, v) {
        historyMap[k] = (v as List)
            .map(
              (e) => HistoryEntry(
                time: e['time'],
                hashrate: (e['hashrate'] as num).toDouble(),
              ),
            )
            .toList();
      });
    }

    return WorkerStats(
      miner: jsonData['miner'] ?? '',
      totalHash: (jsonData['totalHash'] as num?)?.toDouble() ?? 0,
      totalShares: jsonData['totalShares'] ?? 0,
      networkSols: jsonData['networkSols'] ?? '0',
      immature: (jsonData['immature'] as num?)?.toDouble() ?? 0,
      balance: (jsonData['balance'] as num?)?.toDouble() ?? 0,
      paid: (jsonData['paid'] as num?)?.toDouble() ?? 0,
      workers: workerMap,
      history: historyMap,
    );
  }

  int get totalWorkers => workers.length;

  int get activeWorkers {
    int count = 0;
    for (var w in workers.values) {
      if (w.hashrate > 0) count++;
    }
    return count;
  }
}

class Worker {
  final String name;
  final double hashrate;
  final int shares;
  final int invalidShares;
  final int diff;
  final int currRoundShares;
  final double currRoundTime;
  final String hashrateString;
  final double paid;
  final double balance;

  Worker({
    required this.name,
    required this.hashrate,
    required this.shares,
    required this.invalidShares,
    required this.diff,
    required this.currRoundShares,
    required this.currRoundTime,
    required this.hashrateString,
    required this.paid,
    required this.balance,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
    name: json['name'] ?? '',
    hashrate: (json['hashrate'] as num?)?.toDouble() ?? 0,
    shares: json['shares'] ?? 0,
    invalidShares: json['invalidshares'] ?? 0,
    diff: json['diff'] ?? 0,
    currRoundShares: json['currRoundShares'] ?? 0,
    currRoundTime: (json['currRoundTime'] as num?)?.toDouble() ?? 0,
    hashrateString: json['hashrateString'] ?? '',
    paid: (json['paid'] as num?)?.toDouble() ?? 0,
    balance: (json['balance'] as num?)?.toDouble() ?? 0,
  );
}

class HistoryEntry {
  final int time;
  final double hashrate;

  HistoryEntry({required this.time, required this.hashrate});
}
