import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedInquiry = 'General Inquiry';
  bool _isSubmitting = false;

  final List<String> _inquiryTypes = [
    'General Inquiry',
    'Product Demo',
    'Sales Question',
    'Technical Support',
    'Partnership Opportunity',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Thank you for your message! We\'ll get back to you soon.'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );

          // Clear form
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _messageController.clear();
          setState(() {
            _selectedInquiry = 'General Inquiry';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'contact'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFE8F5E9),
              child: Column(
                children: const [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Have questions or ready to transform your practice?\nWe\'re here to help.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Contact Information and Form
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Contact Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get in Touch',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "We'd love to hear from you. Here's how you can reach us.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Contact details
                        _buildContactDetail(
                          icon: Icons.email_outlined,
                          title: 'Email Us',
                          detail: 'contact@physioflow.com',
                        ),
                        const SizedBox(height: 24),

                        _buildContactDetail(
                          icon: Icons.phone_outlined,
                          title: 'Call Us',
                          detail: '+1 (800) 123-4567',
                        ),
                        const SizedBox(height: 24),

                        _buildContactDetail(
                          icon: Icons.location_on_outlined,
                          title: 'Visit Us',
                          detail:
                              '123 Innovation Drive, Suite 400\nSan Francisco, CA 94107',
                        ),

                        const SizedBox(height: 40),

                        // Office Hours
                        const Text(
                          'Office Hours',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildOfficeHours(
                            'Monday - Friday', '9:00 AM - 6:00 PM EST'),
                        const SizedBox(height: 8),
                        _buildOfficeHours('Saturday', '10:00 AM - 2:00 PM EST'),
                        const SizedBox(height: 8),
                        _buildOfficeHours('Sunday', 'Closed'),

                        const SizedBox(height: 40),

                        // Map placeholder
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFE8F5E9),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.map,
                              size: 64,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 64),

                  // Right side - Contact Form
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Send Us a Message',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Name field
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email field
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone field
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone (optional)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Inquiry type dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedInquiry,
                              decoration: const InputDecoration(
                                labelText: 'Inquiry Type',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: _inquiryTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedInquiry = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Message field
                            TextFormField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                labelText: 'Your Message',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.message_outlined),
                                alignLabelWithHint: true,
                              ),
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your message';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _isSubmitting ? null : _submitForm,
                                child: _isSubmitting
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Send Message',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FAQ Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Find quick answers to common questions',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // FAQ items
                  _buildFaqItem(
                    question: 'How quickly can we implement PhysioFlow?',
                    answer:
                        'Most clinics are fully onboarded within 2 weeks. Our implementation team will guide you through setup, data migration, and staff training to ensure a smooth transition.',
                  ),
                  _buildFaqItem(
                    question: 'Is my patient data secure?',
                    answer:
                        'Absolutely. PhysioFlow is HIPAA compliant and uses enterprise-grade encryption for all data. We conduct regular security audits and never share your data with third parties.',
                  ),
                  _buildFaqItem(
                    question: 'Do you offer training for our staff?',
                    answer:
                        'Yes! All plans include comprehensive training sessions for your team. We also provide ongoing support, tutorial videos, and a knowledge base to ensure you get the most from PhysioFlow.',
                  ),
                ],
              ),
            ),

            // Footer
            const WebsiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetail({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeHours(String day, String hours) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            hours,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF424242),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
