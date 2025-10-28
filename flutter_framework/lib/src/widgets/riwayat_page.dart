import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sensor_reading.dart';
import '../services/sensor_service.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  SensorReading? _getLatestReading(List<SensorReading> readings) {
    if (readings.isEmpty) return null;
    return readings.first; // Sudah sorted descending di service
  }

  String _formatLastUpdate(SensorReading? latest) {
    if (latest == null) return '-';

    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(latest.tanggal);
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return StreamBuilder<List<SensorReading>>(
      stream: SensorService.streamReadings(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _buildAppBar(isMobile),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _buildAppBar(isMobile),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        final readings = snapshot.data ?? [];
        final latest = _getLatestReading(readings);
        
        return _buildContent(context, isMobile, latest);
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile, SensorReading? latest) {
    final phText = latest != null ? latest.ph.toStringAsFixed(1) : '-';
    final suhuText = latest != null ? '${latest.suhu.toStringAsFixed(1)}°C' : '-';
    final mineralText = latest != null ? '${latest.mineral.toStringAsFixed(0)} ppm' : '-';

    final isPhOk = latest != null ? (latest.ph >= 6.5 && latest.ph <= 8.5) : false;
    final isSuhuOk = latest != null ? (latest.suhu >= 25 && latest.suhu <= 30) : false;
    final isMineralOk = latest != null ? (latest.mineral < 500) : false;
    final isAirLayak = latest != null ? (isPhOk && isSuhuOk && isMineralOk) : false;

    // warna untuk tiap indikator: hijau jika normal, merah jika tidak normal (hanya dua warna)
    final pHLegendColor = isPhOk ? Colors.green : const Color.fromARGB(255, 255, 0, 0);
    final suhuLegendColor = isSuhuOk ? Colors.green : const Color.fromARGB(255, 255, 0, 0);
    final mineralLegendColor = isMineralOk ? Colors.green : const Color.fromARGB(255, 255, 0, 0);

    final lastUpdateFormatted = _formatLastUpdate(latest);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(isMobile),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Status Kelayakan Air',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A5F),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _miniLegend('pH', pHLegendColor),
                      const SizedBox(width: 8),
                      _miniLegend('Suhu', suhuLegendColor),
                      const SizedBox(width: 8),
                      _miniLegend('Mineral', mineralLegendColor),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 18 : 28),
                _statusCircle(isAirLayak, isMobile),
                SizedBox(height: isMobile ? 18 : 28),
                isMobile
                    ? Column(children: [
                        SizedBox(width: double.infinity, child: _dataCard('pH', phText, 'Normal: 6.5 - 8.5', Icons.science, const Color(0xFFF6F3EE))),
                        const SizedBox(height: 12),
                        SizedBox(width: double.infinity, child: _dataCard('Suhu', suhuText, 'Normal: 25 - 30°C', Icons.thermostat, const Color(0xFFD9CEC5))),
                        const SizedBox(height: 12),
                        SizedBox(width: double.infinity, child: _dataCard('Mineral (TDS)', mineralText, 'Normal: < 500 ppm', Icons.opacity, const Color(0xFF123B5B))),
                      ])
                    : Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 320, child: _dataCard('pH', phText, 'Normal: 6.5 - 8.5', Icons.science, const Color(0xFFF6F3EE))),
                            const SizedBox(width: 16),
                            SizedBox(width: 320, child: _dataCard('Suhu', suhuText, 'Normal: 25 - 30°C', Icons.thermostat, const Color(0xFFD9CEC5))),
                            const SizedBox(width: 16),
                            SizedBox(width: 320, child: _dataCard('Mineral (TDS)', mineralText, 'Normal: < 500 ppm', Icons.opacity, const Color(0xFF123B5B))),
                          ],
                        ),
                      ),
                const SizedBox(height: 18),
                Center(
                  child: Container(
                    width: isMobile ? double.infinity : 700,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 6)],
                    ),
                    child: Text(
                      latest != null ? 'Terakhir update: $lastUpdateFormatted' : 'Terakhir update: -',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    final double logoSize = isMobile ? 120.0 : 160.0;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      centerTitle: false,
      actions: null,
    );
  }

  Widget _miniLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _statusCircle(bool isOk, bool isMobile) {
    // gunakan merah spesifik saat tidak normal
    final ringColor = isOk ? Colors.green : const Color.fromARGB(255, 255, 0, 0);
  const textColor = Colors.black87;
    final size = isMobile ? 160.0 : 220.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 6),
        color: Colors.white,
  boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 12, offset: Offset(0,4))],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isOk ? 'AIR LAYAK' : 'TIDAK LAYAK', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 18)),
            const SizedBox(height: 6),
            Text(isOk ? 'DIGUNAKAN' : 'TIDAK DIGUNAKAN', style: TextStyle(color: Colors.grey[600], fontSize: isMobile ? 12 : 14)),
          ],
        ),
      ),
    );
  }

  Widget _dataCard(String title, String value, String subtitle, IconData icon, Color bg) {
    final isDark = bg.computeLuminance() < 0.5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
  boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 10, offset: Offset(0,2))],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E3A5F), fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(value, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700])),
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: isDark ? Color.fromRGBO(255, 255, 255, 0.15) : Colors.white,
              child: Icon(icon, size: 28, color: isDark ? Colors.white : Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
