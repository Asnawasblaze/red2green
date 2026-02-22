import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class IssueProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<IssueModel> _issues = [];
  List<IssueModel> _userReports = [];
  bool _isLoading = false;
  String? _error;
  IssueStatus? _statusFilter;

  List<IssueModel> get issues => _issues;
  List<IssueModel> get userReports => _userReports;
  bool get isLoading => _isLoading;
  String? get error => _error;
  IssueStatus? get statusFilter => _statusFilter;

  // Stream subscription
  Stream<List<IssueModel>>? _issuesStream;
  Stream<List<IssueModel>>? _userReportsStream;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void setStatusFilter(IssueStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void listenToIssues() {
    _issuesStream = _databaseService.getIssuesStream(statusFilter: _statusFilter);
    _issuesStream?.listen((issues) {
      _issues = issues;
      notifyListeners();
    });
  }

  void listenToUserReports(String userId) {
    _userReportsStream = _databaseService.getUserReportsStream(userId);
    _userReportsStream?.listen((reports) {
      _userReports = reports;
      notifyListeners();
    });
  }

  Future<String?> createIssue(IssueModel issue) async {
    try {
      setLoading(true);
      setError(null);
      String issueId = await _databaseService.createIssue(issue);
      setLoading(false);
      return issueId;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return null;
    }
  }

  Future<void> claimIssue(String issueId, String ngoId, String ngoName) async {
    try {
      setLoading(true);
      await _databaseService.claimIssue(issueId, ngoId, ngoName);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError(e.toString());
    }
  }

  Future<void> toggleLike(String issueId, String userId) async {
    try {
      await _databaseService.toggleLike(issueId, userId);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> markAsResolved(String issueId) async {
    try {
      setLoading(true);
      await _databaseService.updateIssueStatus(issueId, IssueStatus.resolved);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError(e.toString());
    }
  }

  // Force refresh issues
  Future<void> refreshIssues() async {
    try {
      // Cancel existing stream
      await _issuesStream?.drain();
      // Restart listening
      listenToIssues();
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }
}