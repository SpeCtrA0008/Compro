import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sensor_reading.dart';
import '../services/sensor_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<SensorReading> _allReadings = [];
  List<SensorReading> _filteredReadings = [];
  bool _isLoading = true;
  DateTime? _selectedDate;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final readings = await SensorService.getAllReadings();
      setState(() {
        _allReadings = readings;
        _filteredReadings = readings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _filterByDate() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal terlebih dahulu')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final readings = await SensorService.getReadingsByDate(_selectedDate!);
      setState(() {
        _filteredReadings = readings;
        _currentPage = 1;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _reset() {
    setState(() {
      _selectedDate = null;
      _filteredReadings = _allReadings;
      _currentPage = 1;
    });
  }

  List<SensorReading> get _paginatedReadings {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredReadings.length) return [];
    return _filteredReadings.sublist(
      startIndex,
      endIndex > _filteredReadings.length ? _filteredReadings.length : endIndex,
    );
  }

  int get _totalPages => (_filteredReadings.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(isMobile),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Data Sensor',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A5F),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 24),
                _buildFilterCard(isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _buildDataView(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Icon(Icons.water_drop, color: Colors.blue, size: isMobile ? 24 : 32),
          const SizedBox(width: 8),
          Text(
            'WATRIE',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 18 : 20,
            ),
          ),
        ],
      ),
      actions: isMobile
          ? null
          : [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.home, color: Color(0xFF1E3A5F)),
                label: const Text('BERANDA', style: TextStyle(color: Color(0xFF1E3A5F))),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history),
                label: const Text('RIWAYAT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 16),
            ],
    );
  }

  Widget _buildFilterCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) ...[
            const Text('Filter Tanggal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
          ] else
            const SizedBox.shrink(),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!isMobile)
                const Text('Tanggal:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: isMobile ? 120 : 100,
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                              : 'dd/mm/yyyy',
                          style: TextStyle(
                            color: _selectedDate != null ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _filterByDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Telusuri'),
              ),
              OutlinedButton(
                onPressed: _isLoading ? null : _reset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _filteredReadings.isEmpty
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur export segera hadir')),
                      ),
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Simpan Riwayat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ] else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _filteredReadings.isEmpty
                      ? null
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur export segera hadir')),
                          ),
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Simpan Riwayat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDataView(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A5F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: isMobile
                ? const Center(
                    child: Text(
                      'Data Sensor',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(child: _headerText('pH')),
                      Expanded(child: _headerText('Suhu')),
                      Expanded(child: _headerText('Mineral')),
                      Expanded(flex: 2, child: _headerText('Tanggal')),
                      Expanded(child: _headerText('Pukul')),
                    ],
                  ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filteredReadings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Text('Menampilkan 0-0 dari 0 data', style: TextStyle(color: Colors.grey[600])),
              ),
            )
          else
            isMobile ? _buildMobileList() : _buildDesktopTable(),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: [
        ..._paginatedReadings.map((r) => Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _mobileRow('pH', r.ph.toStringAsFixed(1)),
                  const Divider(height: 20),
                  _mobileRow('Suhu', '${r.suhu.toStringAsFixed(1)}°C'),
                  const Divider(height: 20),
                  _mobileRow('Mineral', '${r.mineral.toStringAsFixed(0)} ppm'),
                  const Divider(height: 20),
                  _mobileRow('Tanggal', r.tanggalFormatted),
                  const Divider(height: 20),
                  _mobileRow('Pukul', r.pukul),
                ],
              ),
            )),
        _buildPagination(true),
      ],
    );
  }

  Widget _mobileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return Column(
      children: [
        ..._paginatedReadings.map((r) => Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _dataCell(r.ph.toStringAsFixed(1))),
                    Expanded(child: _dataCell('${r.suhu.toStringAsFixed(1)}°C')),
                    Expanded(child: _dataCell('${r.mineral.toStringAsFixed(0)} ppm')),
                    Expanded(flex: 2, child: _dataCell(r.tanggalFormatted)),
                    Expanded(child: _dataCell(r.pukul)),
                  ],
                ),
              ),
            )),
        _buildPagination(false),
      ],
    );
  }

  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _buildPagination(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: isMobile
          ? Column(
              children: [
                Text(
                  '${(_currentPage - 1) * _itemsPerPage + 1}-${_currentPage * _itemsPerPage > _filteredReadings.length ? _filteredReadings.length : _currentPage * _itemsPerPage} dari ${_filteredReadings.length}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 12),
                _paginationButtons(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menampilkan ${(_currentPage - 1) * _itemsPerPage + 1}-${_currentPage * _itemsPerPage > _filteredReadings.length ? _filteredReadings.length : _currentPage * _itemsPerPage} dari ${_filteredReadings.length} data',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                _paginationButtons(),
              ],
            ),
    );
  }

  Widget _paginationButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
          child: const Text('« Prev'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$_currentPage / $_totalPages', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        OutlinedButton(
          onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
          child: const Text('Next »'),
        ),
      ],
    );
  }
}
