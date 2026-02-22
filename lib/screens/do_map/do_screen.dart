import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/models.dart';
import '../../services/database_service.dart';
import '../../widgets/event_card_popup.dart';

class DoScreen extends StatefulWidget {
  const DoScreen({Key? key}) : super(key: key);

  @override
  State<DoScreen> createState() => _DoScreenState();
}

class _DoScreenState extends State<DoScreen> {
  final MapController _mapController = MapController();
  final DatabaseService _databaseService = DatabaseService();
  List<Marker> _markers = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).listenToIssues();
    });
  }

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
        return Marker(
          point: LatLng(
            issue.location.latitude,
            issue.location.longitude
          ),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showIssuePopup(issue),
            child: _buildStatusMarker(_getMarkerColor(issue.status), issue.statusText),
          ),
        );
      }).toList();
    });
  }

  void _showIssuePopup(IssueModel issue) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final userRole = user?.role ?? UserRole.public;
    final userId = user?.uid ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return EventCardPopup(
            issue: issue,
            userRole: userRole,
            currentUserId: userId,
            isProcessing: _isProcessing,
            onClose: () => Navigator.pop(context),
            onJoinEvent: () => _handleJoinEvent(issue, userId),
            onClaimEvent: () => _handleClaimEvent(issue, userId, user?.displayName ?? 'NGO'),
          );
        },
      ),
    );
  }

  Future<void> _handleClaimEvent(IssueModel issue, String ngoId, String ngoName) async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    Navigator.pop(context);
    
    try {
      final result = await _databaseService.claimIssue(issue.id!, ngoId, ngoName);
      
      if (result != null && result['success'] == true) {
        // Refresh issues list
        await Provider.of<IssueProvider>(context, listen: false).refreshIssues();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event claimed successfully! Chat room created.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // TODO: Navigate to chat room or event details
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to claim event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleJoinEvent(IssueModel issue, String userId) async {
    if (_isProcessing) return;
    if (issue.eventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This event has not been claimed by an NGO yet.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isProcessing = true);
    Navigator.pop(context);
    
    try {
      // Join the event
      await _databaseService.joinEvent(issue.eventId!, userId);
      
      // Add user to chat room
      await _databaseService.joinChatRoom(issue.eventId!, userId);
      
      // Refresh chat provider
      Provider.of<ChatProvider>(context, listen: false).listenToEvents(userId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You joined the cleanup event! Check the Message tab for chat.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
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
          
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(28.6139, 77.2090),
                initialZoom: 12,
                onMapReady: () {
                  if (issueProvider.issues.isNotEmpty) {
                    _updateMarkers(issueProvider.issues);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=mNF5pA1LtosL7VXepBW2H394JeoH8muG',
                  userAgentPackageName: 'com.example.red2green',
                ),
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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