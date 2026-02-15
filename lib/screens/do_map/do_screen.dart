import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../models/models.dart';

class DoScreen extends StatefulWidget {
  const DoScreen({Key? key}) : super(key: key);

  @override
  State<DoScreen> createState() => _DoScreenState();
}

class _DoScreenState extends State<DoScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).listenToIssues();
    });
  }

  // Get marker color based on issue status
  Color _getMarkerColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.reported:
        return Colors.red;
      case IssueStatus.claimed:
        return Colors.amber;
      case IssueStatus.resolved:
        return Colors.green;
    }
  }

  void _updateMarkers(List<IssueModel> issues) {
    setState(() {
      _markers = issues.map((issue) {
        // Convert GeoPoint (Firestore) to LatLng (flutter_map)
        return Marker(
          point: LatLng(
            issue.location.latitude, 
            issue.location.longitude
          ),
          width: 40,
          height: 40,
          child: _buildStatusMarker(_getMarkerColor(issue.status), issue.statusText),
        );
      }).toList();
    });
  }

  Widget _buildStatusMarker(Color color, String status) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        _getStatusIcon(status),
        color: Colors.white,
        size: 20,
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Reported':
        return Icons.report_problem;
      case 'Claimed':
        return Icons.work;
      case 'Resolved':
        return Icons.check_circle;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = Provider.of<IssueProvider>(context);
    
    if (issueProvider.issues.isNotEmpty) {
      _updateMarkers(issueProvider.issues);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.red, 'Reported'),
                _buildLegendItem(Colors.amber, 'Claimed'),
                _buildLegendItem(Colors.green, 'Resolved'),
              ],
            ),
          ),
          
          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(28.6139, 77.2090), // Default to Delhi
                initialZoom: 12,
                onMapReady: () {
                  if (issueProvider.issues.isNotEmpty) {
                    _updateMarkers(issueProvider.issues);
                  }
                },
              ),
              children: [
                // TomTom Map Tiles - REPLACE WITH YOUR API KEY
                TileLayer(
                  urlTemplate: 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=mNF5pA1LtosL7VXepBW2H394JeoH8muG',
                  userAgentPackageName: 'com.example.red2green',
                ),
                // Markers layer
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show list view
        },
        icon: const Icon(Icons.list),
        label: const Text('View List'),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}