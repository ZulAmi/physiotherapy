import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'pricing'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFE8F5E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    'Simple, Transparent Pricing',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Choose the plan that fits your practice needs',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Pricing plans
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Plan
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Basic',
                      price: '\$49',
                      period: 'per month',
                      description:
                          'Perfect for solo practitioners and small clinics',
                      features: [
                        'Up to 3 therapist accounts',
                        '100 active patients',
                        'Basic appointment scheduling',
                        'Patient records management',
                        'Exercise prescription',
                        'Email support',
                      ],
                      buttonText: 'Start Free Trial',
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Professional Plan
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Professional',
                      price: '\$99',
                      period: 'per month',
                      description:
                          'Ideal for growing practices with multiple therapists',
                      features: [
                        'Up to 10 therapist accounts',
                        'Unlimited patients',
                        'Advanced scheduling with reminders',
                        'Online booking portal',
                        'AI-powered exercise monitoring',
                        'Custom forms and assessments',
                        'Analytics and reporting',
                        'Priority email and phone support',
                      ],
                      buttonText: 'Get Started',
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Enterprise Plan
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Enterprise',
                      price: 'Custom',
                      period: 'tailored pricing',
                      description: 'For large clinics and hospital systems',
                      features: [
                        'Unlimited therapist accounts',
                        'Multi-location support',
                        'Custom integrations',
                        'White-labeling options',
                        'Advanced analytics and business intelligence',
                        'All Professional features',
                        'API access',
                        'Dedicated account manager',
                        '24/7 priority support',
                      ],
                      buttonText: 'Contact Sales',
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
            ),

            // Comparison table
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFE8F5E9),
              child: Column(
                children: [
                  const Text(
                    'Feature Comparison',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Compare plans to find the right fit for your practice',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Feature comparison table
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildComparisonHeader(),
                        _buildComparisonRow(
                            'Therapist accounts', '3', '10', 'Unlimited'),
                        _buildComparisonRow(
                            'Active patients', '100', 'Unlimited', 'Unlimited'),
                        _buildComparisonRow('Appointment scheduling', 'Basic',
                            'Advanced', 'Advanced'),
                        _buildComparisonRow('Patient records', '✓', '✓', '✓'),
                        _buildComparisonRow(
                            'Exercise prescription', '✓', '✓', '✓'),
                        _buildComparisonRow('Online booking', '✗', '✓', '✓'),
                        _buildComparisonRow(
                            'AI exercise monitoring', '✗', '✓', '✓'),
                        _buildComparisonRow(
                            'Analytics & reporting', '✗', '✓', '✓'),
                        _buildComparisonRow(
                            'Custom integrations', '✗', '✗', '✓'),
                        _buildComparisonRow('White-labeling', '✗', '✗', '✓'),
                        _buildComparisonRow('Dedicated support', '✗', '✗', '✓'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
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
                  const SizedBox(height: 48),

                  // FAQs
                  _buildFaqItem(
                    question: 'Can I switch plans later?',
                    answer:
                        'Yes, you can upgrade or downgrade your plan at any time. Changes take effect at the start of your next billing cycle.',
                  ),
                  _buildFaqItem(
                    question: 'Is there a setup fee?',
                    answer:
                        'No, PhysioFlow has no setup fees or hidden costs. You only pay the advertised monthly subscription price.',
                  ),
                  _buildFaqItem(
                    question: 'Do you offer discounts for annual billing?',
                    answer:
                        'Yes, you can save 20% by choosing annual billing on any of our plans.',
                  ),
                  _buildFaqItem(
                    question: 'What kind of support is included?',
                    answer:
                        'All plans include email support. The Professional plan adds phone support, while Enterprise includes a dedicated account manager.',
                  ),
                  _buildFaqItem(
                    question: 'Can I cancel my subscription anytime?',
                    answer:
                        'Yes, you can cancel at any time. Your subscription will remain active until the end of your current billing period.',
                  ),
                ],
              ),
            ),

            // CTA Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
              color: const Color(0xFFE8F5E9),
              child: Column(
                children: [
                  const Text(
                    'Not sure which plan is right for you?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Our team is happy to help you choose the best option for your practice',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Schedule a Consultation'),
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

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String period,
    required String description,
    required List<String> features,
    required String buttonText,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary ? const Color(0xFF2E7D32) : Colors.grey.shade200,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  isPrimary ? const Color(0xFF1B5E20) : const Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  period,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          ...features
              .map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isPrimary ? const Color(0xFF2E7D32) : Colors.white,
                foregroundColor:
                    isPrimary ? Colors.white : const Color(0xFF2E7D32),
                side: isPrimary
                    ? null
                    : const BorderSide(color: Color(0xFF2E7D32)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: const [
                  Text(
                    'Basic',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$49/month',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE8F5E9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: const [
                  Text(
                    'Professional',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$99/month',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE8F5E9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: const [
                  Text(
                    'Enterprise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Custom',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE8F5E9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String feature,
    String basicValue,
    String proValue,
    String enterpriseValue,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                basicValue,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: basicValue == '✗'
                      ? Colors.grey.shade400
                      : const Color(0xFF424242),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                proValue,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: proValue == '✗'
                      ? Colors.grey.shade400
                      : const Color(0xFF424242),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                enterpriseValue,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: enterpriseValue == '✗'
                      ? Colors.grey.shade400
                      : const Color(0xFF424242),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        expandedAlignment: Alignment.topLeft,
        childrenPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
        iconColor: const Color(0xFF2E7D32),
        collapsedIconColor: const Color(0xFF2E7D32),
        children: [
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }
}
