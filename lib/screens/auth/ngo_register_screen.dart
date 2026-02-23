import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class NGORegisterScreen extends StatefulWidget {
  const NGORegisterScreen({Key? key}) : super(key: key);

  @override
  State<NGORegisterScreen> createState() => _NGORegisterScreenState();
}

class _NGORegisterScreenState extends State<NGORegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ngoIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showNgoIdInfo = false;

  @override
  void dispose() {
    _orgNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ngoIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.registerNGO(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        organizationName: _orgNameController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        phone: _phoneController.text.trim(),
        ngoUin: _ngoIdController.text.trim(),
      );
      
      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Teal Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF115E59), Color(0xFF0F766E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.business_outlined, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'NGO Partner Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(16),
                        border: const Border(
                          left: BorderSide(color: Color(0xFF0F766E), width: 4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, color: Color(0xFF0F766E), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Official Partner Registration',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF115E59),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Register your NGO to claim and organize cleanup events for reported issues.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Organization Name
                    _buildLabel('Organization Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _orgNameController,
                      decoration: _buildInputDecoration(
                        hint: 'Green Warriors NGO',
                        icon: Icons.business_outlined,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter organization name' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Contact Person
                    _buildLabel('Contact Person'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: _buildInputDecoration(
                        hint: 'John Doe',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter contact person name' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Email
                    _buildLabel('Official Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        hint: 'org@example.com',
                        icon: Icons.mail_outline,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please enter email';
                        if (!value!.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Phone
                    _buildLabel('Phone Number'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                        hint: '+91 9876543210',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter phone number' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // NGO Darpan UIN
                    _buildLabel('NGO Darpan Unique ID'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _ngoIdController,
                      decoration: InputDecoration(
                        hintText: 'e.g. DL/2023/0123456',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child: Icon(Icons.shield_outlined, color: Color(0xFF0F766E), size: 20),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: Icon(
                              _showNgoIdInfo ? Icons.expand_less : Icons.info_outline,
                              color: const Color(0xFF0F766E),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _showNgoIdInfo = !_showNgoIdInfo),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter NGO ID' : null,
                    ),
                    if (_showNgoIdInfo) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Your NGO Darpan Unique ID can be found on NGO Darpan portal. This is required for verification.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    
                    // Password
                    _buildLabel('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Min. 6 characters',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child: Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 20),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please enter a password';
                        if (value!.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Verification Notice
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFFD97706), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Verification may take 24-48 hours',
                              style: TextStyle(fontSize: 13, color: Colors.amber[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Error Message
                    if (authProvider.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                authProvider.error!,
                                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.shield_outlined, size: 20),
                                  SizedBox(width: 8),
                                  Text('Verify & Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Login Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already registered? ',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: Color(0xFF0F766E),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    );
  }
}