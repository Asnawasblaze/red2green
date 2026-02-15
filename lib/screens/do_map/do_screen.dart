import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../models/models.dart';

class DoScreen extends StatefulWidget {
  const DoScreen({Key? key}) : super(key: key);

  @override
  State<DoScreen> createState() => _DoScreenState();
}

class _DoScreenState extends State<DoScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).listenToIssues();
    });
  }

  BitmapDescriptor _getMarkerIcon(IssueStatus status) {
    switch (status) {
      case IssueStatus.reported:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case IssueStatus.claimed:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case IssueStatus.resolved:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  void _updateMarkers(List<IssueModel> issues) {
    setState(() {
      _markers = issues.map((issue) {
        return Marker(
          markerId: MarkerId(issue.id ?? ''),
          position: LatLng(issue.location.latitude, issue.location.longitude),
          icon: _getMarkerIcon(issue.status),
          infoWindow: InfoWindow(
            title: issue.title,
            snippet: issue.statusText,
          ),
        );
      }).toSet();
    });
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
            onPressed: () {},
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.6139, 77.2090), // Default to Delhi
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.list),
        label: const Text('View List'),
      ),
    );
  }
}