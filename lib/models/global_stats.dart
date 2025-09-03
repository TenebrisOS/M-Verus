import 'dart:convert';

GlobalStats globalStatsFromJson(String str) {
  print('[LOG] globalStatsFromJson: Decoding JSON string...');
  print('[LOG] RAW JSON: $str');
  final jsonData = json.decode(str);
  return GlobalStats.fromJson(jsonData);
}

class GlobalStats {
  final String networkhashps;
  final double difficulty;
  final int height;
  final int validShares;
  final int validBlocks;
  final int invalidShares;
  final String totalPaid;
  final int networkConnections;
  final String networkVersion;
  final String networkProtocolVersion;

  GlobalStats({
    required this.networkhashps,
    required this.difficulty,
    required this.height,
    required this.validShares,
    required this.validBlocks,
    required this.invalidShares,
    required this.totalPaid,
    required this.networkConnections,
    required this.networkVersion,
    required this.networkProtocolVersion,
  });

  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    print('[LOG] GlobalStats.fromJson: Received JSON map: $json');
    final pools = json['pools'] as Map<String, dynamic>? ?? {};
    final verusPool = pools['verus'] as Map<String, dynamic>? ?? {};
    final poolStats = verusPool['poolStats'] as Map<String, dynamic>? ?? {};
    print('[LOG] GlobalStats.fromJson: Extracted poolStats object: $poolStats');

    final hashrate = poolStats["networkSols"]?.toString() ?? "0";
    final diffValue = poolStats["networkDiff"];
    final diff = (diffValue is String)
        ? (double.tryParse(diffValue) ?? 0.0)
        : (diffValue?.toDouble() ?? 0.0);
    final blockHeightValue = poolStats["networkBlocks"];
    final blockHeight = (blockHeightValue is String)
        ? int.tryParse(blockHeightValue) ?? 0
        : (blockHeightValue ?? 0);

    final validShares = poolStats["validShares"] is String
        ? int.tryParse(poolStats["validShares"]) ?? 0
        : (poolStats["validShares"] ?? 0);
    final validBlocks = poolStats["validBlocks"] is String
        ? int.tryParse(poolStats["validBlocks"]) ?? 0
        : (poolStats["validBlocks"] ?? 0);
    final invalidShares = poolStats["invalidShares"] is String
        ? int.tryParse(poolStats["invalidShares"]) ?? 0
        : (poolStats["invalidShares"] ?? 0);
    final totalPaid = poolStats["totalPaid"]?.toString() ?? "0";
    final networkConnections = poolStats["networkConnections"] is String
        ? int.tryParse(poolStats["networkConnections"]) ?? 0
        : (poolStats["networkConnections"] ?? 0);
    final networkVersion = poolStats["networkVersion"]?.toString() ?? "";
    final networkProtocolVersion =
        poolStats["networkProtocolVersion"]?.toString() ?? "";

    print('[LOG] GlobalStats.fromJson: Parsed hashrate: $hashrate');
    print('[LOG] GlobalStats.fromJson: Parsed difficulty: $diff');
    print('[LOG] GlobalStats.fromJson: Parsed block_height: $blockHeight');
    print('[LOG] GlobalStats.fromJson: Parsed validShares: $validShares');
    print('[LOG] GlobalStats.fromJson: Parsed validBlocks: $validBlocks');
    print('[LOG] GlobalStats.fromJson: Parsed invalidShares: $invalidShares');
    print('[LOG] GlobalStats.fromJson: Parsed totalPaid: $totalPaid');
    print(
      '[LOG] GlobalStats.fromJson: Parsed networkConnections: $networkConnections',
    );
    print('[LOG] GlobalStats.fromJson: Parsed networkVersion: $networkVersion');
    print(
      '[LOG] GlobalStats.fromJson: Parsed networkProtocolVersion: $networkProtocolVersion',
    );

    return GlobalStats(
      networkhashps: hashrate,
      difficulty: diff,
      height: blockHeight,
      validShares: validShares,
      validBlocks: validBlocks,
      invalidShares: invalidShares,
      totalPaid: totalPaid,
      networkConnections: networkConnections,
      networkVersion: networkVersion,
      networkProtocolVersion: networkProtocolVersion,
    );
  }
}
