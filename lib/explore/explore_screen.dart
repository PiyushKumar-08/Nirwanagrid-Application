import 'package:flutter/material.dart';

// --- DATA MODELS ---

// Represents a single feature with a title and description for the detail page.
class FeatureInfo {
  final String title;
  final String description;

  const FeatureInfo({required this.title, required this.description});
}

// Represents a complete service, including its details and features.
class ServiceInfo {
  final String title;
  final String shortDescription; // For the main list card
  final String mainDescription; // For the detail page header
  final IconData icon;
  final Color color;
  final List<FeatureInfo> features;

  const ServiceInfo({
    required this.title,
    required this.shortDescription,
    required this.mainDescription,
    required this.icon,
    required this.color,
    required this.features,
  });
}

// --- DATA SOURCE ---

// A centralized list holding all the enhanced content for the services.
final List<ServiceInfo> nirwanaGridServices = [
  const ServiceInfo(
    title: 'AI Enabled Alert System',
    shortDescription:
        'Get real-time notifications for your appliances and their internal components to prevent issues before they start.',
    mainDescription:
        'Stay ahead of potential issues with NirwanaGrid’s intelligent alert system, designed to provide real-time notifications for both your main appliances and their critical internal components. By identifying abnormalities such as overheating, excessive energy consumption, or decreased efficiency, the system empowers you to prevent accidents, minimize waste, and take corrective action immediately.',
    icon: Icons.notifications_active,
    color: Colors.blue,
    features: [
      FeatureInfo(
          title: 'Real-Time Alerts for Devices and Sub-Parts',
          description:
              'The system monitors not just the appliance but also its essential components like compressors, motors, and coils. You receive instant alerts for any unusual behavior, such as abnormal vibrations or overheating, allowing for immediate intervention.'),
      FeatureInfo(
          title: 'Predictive Fault Detection',
          description:
              'Leveraging advanced AI algorithms, the system can predict potential faults before they escalate into significant failures. This allows you to schedule preventive maintenance, which helps in reducing downtime and avoiding expensive repairs.'),
      FeatureInfo(
          title: 'Energy Usage Notifications',
          description:
              'NirwanaGrid actively tracks the energy consumption of appliances and their sub-parts. You will be alerted if energy use exceeds normal levels, helping you pinpoint inefficiencies and optimize performance to lower your electricity bills.'),
      FeatureInfo(
          title: 'Enhanced Safety & Mishap Prevention',
          description:
              'The alert system is integrated with safety mechanisms to prevent accidents. You get instant notifications regarding voltage fluctuations, electrical surges, or overheating, giving you the ability to remotely shut down devices as a preventive measure.'),
      FeatureInfo(
          title: 'Actionable Insights',
          description:
              'Each alert is accompanied by clear, actionable guidance on the next steps to take. Whether it\'s shutting down a device or scheduling maintenance, you receive the information needed to resolve issues quickly and efficiently.'),
      FeatureInfo(
          title: 'Historical Tracking & Reports',
          description:
              'The system maintains a comprehensive log of all alerts and issues, allowing you to analyze performance trends over time. This data helps with long-term planning and ensuring the longevity of your appliances.'),
    ],
  ),
  const ServiceInfo(
    title: 'Energy Consumption Tracking',
    shortDescription:
        'Gain complete visibility into your electricity usage with detailed analytics to optimize energy use and reduce bills.',
    mainDescription:
        'Gain complete visibility into your electricity usage with NirwanaGrid, which helps you monitor how energy is consumed across all your appliances and devices. By analyzing detailed consumption data, the system identifies inefficiencies and empowers you to make informed decisions that optimize energy use and reduce your electricity bills.',
    icon: Icons.show_chart_rounded,
    color: Colors.teal,
    features: [
      FeatureInfo(
          title: 'Comprehensive Energy Tracking',
          description:
              'NirwanaGrid monitors energy consumption on a weekly, monthly, and yearly basis, providing a complete overview of your usage patterns. This helps you detect unnecessary consumption and make smarter energy choices.'),
      FeatureInfo(
          title: 'Appliance-Level Monitoring',
          description:
              'The system tracks each appliance individually, from heavy-load devices like air conditioners down to their specific components. This granular insight allows you to see exactly which appliances consume the most power, helping you reduce waste and extend the lifespan of your devices.'),
      FeatureInfo(
          title: 'Graphical Dashboards & Analytics',
          description:
              'All energy data is presented in interactive and intuitive dashboards. You can view consumption patterns through charts and graphs, making it easy to spot spikes, irregular usage, or inefficient devices at a glance. The platform also offers comparative analytics to track your performance over time.'),
      FeatureInfo(
          title: 'Informed Decision-Making',
          description:
              'By transforming raw energy data into actionable intelligence, NirwanaGrid empowers you to make strategic decisions about your electricity use. These data-driven insights allow you to optimize appliance schedules and adopt eco-friendly practices, leading to significant cost savings and environmental benefits.'),
    ],
  ),
  const ServiceInfo(
    title: 'Reduce Electricity Bill',
    shortDescription:
        'Significantly cut down on electricity bills with intelligent insights, and AI-driven recommendations for your home or business.',
    mainDescription:
        'NirwanaGrid is designed to help you significantly cut down on electricity bills by providing intelligent insights into your energy usage. By identifying areas of unnecessary power consumption, detecting inefficiencies, and offering AI-driven recommendations, the system ensures that energy is used only when and where it is needed.',
    icon: Icons.receipt_long_rounded,
    color: Colors.green,
    features: [
      FeatureInfo(
          title: 'Smart Energy Monitoring',
          description:
              'The system tracks your electricity usage in real-time and provides weekly, monthly, and yearly consumption reports. This helps you identify patterns of waste that directly impact your bills.'),
      FeatureInfo(
          title: 'Appliance-Level Insights',
          description:
              'NirwanaGrid monitors each device individually to detect idle or inefficient appliances that consume extra power. It highlights which devices are contributing the most to your energy costs.'),
      FeatureInfo(
          title: 'AI-Driven Recommendations',
          description:
              'Using advanced analytics, the platform offers real-time suggestions to optimize your appliance usage. Recommendations may include adjusting operating schedules or switching off devices during low-use periods to reduce waste.'),
      FeatureInfo(
          title: 'Load Management & Optimization',
          description:
              'By analyzing consumption patterns, NirwanaGrid helps you balance electrical loads across your devices. Preventing usage spikes not only lowers bills but also helps avoid overloading circuits.'),
    ],
  ),
  const ServiceInfo(
    title: 'Device Diagnosis',
    shortDescription:
        'Use AI-powered automation to perform comprehensive diagnostics on your appliances, ensuring they run efficiently.',
    mainDescription:
        'NirwanaGrid uses AI-powered automation to perform comprehensive diagnostics on your appliances. The system can detect issues in individual components of devices like ACs and refrigerators, ensuring they run efficiently and extending their lifespan.',
    icon: Icons.health_and_safety_rounded,
    color: Colors.orange,
    features: [
      FeatureInfo(
          title: 'Appliance & Sub-Part Health',
          description:
              'The platform’s AI-powered diagnostics monitor the condition of your appliances and their critical sub-parts. By predicting faults before they escalate, the system enables predictive maintenance, which reduces downtime and saves you from expensive repairs.'),
      FeatureInfo(
          title: 'Advanced Safety & Protection',
          description:
              'NirwanaGrid is built with robust safety protocols. A "mishappening control" feature can instantly shut down devices in case of fire risks, and built-in voltage control stabilizes electrical fluctuations, safeguarding appliances from damage.'),
      FeatureInfo(
          title: 'Cost Optimization',
          description:
              'Through smart energy insights and AI-driven recommendations, NirwanaGrid leads to significant reductions in electricity bills by detecting energy waste and suggesting optimized usage patterns.'),
    ],
  ),
  const ServiceInfo(
    title: 'Smart Control Devices',
    shortDescription:
        'Manage and monitor your appliances from anywhere, with real-time updates and advanced automation features.',
    mainDescription:
        'With NirwanaGrid’s Smart Device Control, you can manage and monitor your appliances from anywhere in India. This intelligent system combines convenience, efficiency, and security, providing you with real-time updates and remote access to make energy management simple and stress-free.',
    icon: Icons.settings_remote_rounded,
    color: Colors.purple,
    features: [
      FeatureInfo(
          title: 'Remote On/Off Control',
          description:
              'Switch your appliances on or off from anywhere using the NirwanaGrid mobile app. This gives you complete control over devices like air conditioners, heaters, and industrial machines, even when you are away.'),
      FeatureInfo(
          title: 'Scheduling & Automation',
          description:
              'Set schedules or timers for your devices to turn on and off automatically. You can have your AC start before you get home or ensure lights are off during office hours, optimizing energy use without manual effort.'),
      FeatureInfo(
          title: 'Real-Time Status Monitoring',
          description:
              'Every connected device reports its operational status, energy consumption, and health metrics in real time. You receive instant notifications if a device is running inefficiently, enabling proactive management.'),
      FeatureInfo(
          title: 'Group & Zone Control',
          description:
              'For larger spaces, you can group devices into zones to control multiple appliances simultaneously. Manage all the lights on a floor or all the ACs in a building with a single command for improved convenience.'),
    ],
  ),
  const ServiceInfo(
    title: 'Eco-Friendly',
    shortDescription:
        'Reduce your carbon footprint by monitoring consumption and eliminating unnecessary power use for a greener home.',
    mainDescription:
        'NirwanaGrid actively helps you reduce your carbon footprint by monitoring electricity consumption and identifying areas of unnecessary power use. The system detects idle appliances that are still drawing power and provides real-time suggestions to switch them off. By optimizing energy usage, you not only save money but also contribute to a greener, more sustainable environment.',
    icon: Icons.eco_rounded,
    color: Colors.lightGreen,
    features: [
      FeatureInfo(
          title: 'Identify and Eliminate Waste',
          description:
              'The system identifies wasteful energy usage and encourages eco-friendly practices, empowering you to make informed decisions about when and where energy is truly needed.'),
      FeatureInfo(
          title: 'Track Your Progress',
          description:
              'You can track your carbon emissions monthly, with data showing the exact percentage your emissions have decreased over time. By calculating the percentage reduction in your carbon footprint, the system allows you to measure your eco-friendly progress.'),
      FeatureInfo(
          title: 'Promote a Sustainable Future',
          description:
              'Ultimately, NirwanaGrid empowers you to save power, reduce carbon emissions, and promote a sustainable future.'),
    ],
  ),
  const ServiceInfo(
    title: 'AI Bot Assistant',
    shortDescription:
        'Get instant information, personalized suggestions, and step-by-step guidance from our 24/7 AI-powered chatbot.',
    mainDescription:
        'NirwanaGrid includes an AI-powered chatbot designed to provide you with instant information, personalized suggestions, and step-by-step guidance for your system.',
    icon: Icons.support_agent_rounded,
    color: Colors.indigo,
    features: [
      FeatureInfo(
          title: 'Instant Information Access',
          description:
              'The chatbot can answer your questions about devices, energy consumption, and system features in real time. This makes troubleshooting faster and easier, as you don\'t have to search through manuals or wait for support.'),
      FeatureInfo(
          title: 'Personalized Suggestions',
          description:
              'Based on your unique usage patterns, the chatbot provides custom recommendations to optimize appliance performance, reduce electricity bills, and adopt eco-friendly practices.'),
      FeatureInfo(
          title: 'Step-by-Step Guidance',
          description:
              'For tasks like setup or maintenance, the chatbot offers clear, easy-to-follow instructions, helping you perform actions correctly without needing technical expertise.'),
      FeatureInfo(
          title: '24/7 Availability',
          description:
              'The chatbot is always available to provide round-the-clock assistance, ensuring you can get support whenever you need it.'),
    ],
  ),
];

// --- MAIN APPLICATION WIDGET ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NirwanaGrid Services',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F6F8),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 24),
          titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 20),
          titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 18),
          bodyMedium: TextStyle(
              color: Colors.black54, fontSize: 16, height: 1.5),
        ),
      ),
      home: const ExploreScreen(),
    );
  }
}

// --- SCREEN WIDGETS ---

// The main screen displaying the list of all services.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: nirwanaGridServices.length,
        itemBuilder: (context, index) {
          final service = nirwanaGridServices[index];
          return _ServiceCard(service: service);
        },
      ),
    );
  }
}

// The detail screen showing comprehensive information about a selected service.
class ServiceDetailPage extends StatelessWidget {
  final ServiceInfo service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(service.title, style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(service.icon, size: 48, color: service.color),
                  const SizedBox(height: 16),
                  Text(
                    service.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: service.color),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Main Description
            Text(
              service.mainDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Features List
            Text(
              'Key Features',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...service.features.map(
              (feature) => _FeatureListItem(feature: feature),
            ),
          ],
        ),
      ),
    );
  }
}

// --- REUSABLE UI WIDGETS ---

// A card widget for the main list on the ExploreScreen.
class _ServiceCard extends StatelessWidget {
  final ServiceInfo service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailPage(service: service),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(color: service.color.withOpacity(0.1)),
              child: Icon(service.icon, size: 48, color: service.color),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.title, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          service.shortDescription,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A list item widget for displaying features on the ServiceDetailPage.
class _FeatureListItem extends StatelessWidget {
  final FeatureInfo feature;
  const _FeatureListItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            feature.description,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
