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
        return const Color(0xFFEF4444);
      case IssueStatus.claimed:
        return const Color(0xFFF59E0B);
      case IssueStatus.resolved:
        return const Color(0xFF059669);
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
    try {
      final result = await _databaseService.claimIssue(issue.id!, ngoId, ngoName);
      if (result != null && result['success'] == true) {
        await Provider.of<IssueProvider>(context, listen: false).refreshIssues();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event claimed successfully! Chat room created.'),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to claim event'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        SnackBar(
          content: const Text('This event has not been claimed by an NGO yet.'),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    try {
      await _databaseService.joinEvent(issue.eventId!, userId);
      await _databaseService.joinChatRoom(issue.eventId!, userId);
      Provider.of<ChatProvider>(context, listen: false).listenToEvents(userId);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You joined the cleanup event! Check the Message tab for chat.'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining event: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        _getStatusIcon(status),
        color: Colors.white,
        size: 18,
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
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Map
          FlutterMap(
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
          
          // Header overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F766E),
                    const Color(0xFF0F766E).withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore Issues',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.navigation_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Legend card
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(const Color(0xFFEF4444), 'Urgent'),
                  const SizedBox(height: 8),
                  _buildLegendItem(const Color(0xFFF59E0B), 'Claimed'),
                  const SizedBox(height: 8),
                  _buildLegendItem(const Color(0xFF059669), 'Resolved'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
      ],
    );
  }
}