import 'dart:ui'; // For BackdropFilter
import 'dart:convert';
import 'dart:async'; // --- ADDED: For StreamSubscription
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '/home/models/appliance_model.dart';
import '/home/chat bot/chat_service.dart';
import '/home/chat bot/chat_window.dart';
import '/home/Device Control/mqtt_service.dart'; // --- REFINED: Direct import for the service

const Map<String, IconData> availableIcons = {
  'AC': Icons.ac_unit_rounded,
  'Fridge': Icons.kitchen_rounded,
  'TV': Icons.tv_rounded,
  'Light': Icons.lightbulb_outline_rounded,
  'Generic': Icons.devices_other_rounded,
};

// (The CustomAnimatedSwitch widget remains the same)
class CustomAnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomAnimatedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value ? theme.colorScheme.primary : Colors.grey.withOpacity(0.28),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Data/state
  bool _isMenuVisible = false;
  List<Appliance> _appliances = [];
  bool _isLoading = true;
  final Uuid _uuid = const Uuid();

  // --- REFINED: Use the singleton instance of the services
  final ChatService _chatService = ChatService(apiKey: 'AIzaSyDrHLRqX6jXBt-KYXxeDIuM7LWyye7vgGo');
  final MqttService _mqttService = MqttService(); 
  
  // --- ADDED: Subscription to listen for MQTT status updates
  StreamSubscription? _mqttDataSub;

  // FAB animation
  late final AnimationController _fabController;
  late final Animation<double> _fabScaleAnim;

  @override
  void initState() {
    super.initState();
    _loadAppliances();
    _chatService.initialize();

    _fabController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _fabScaleAnim = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );

    // Connect to MQTT and listen for real-time updates
    _mqttService.connect();
    
    // --- ADDED: Real-time state synchronization ---
    _mqttDataSub = _mqttService.dataStream.listen((data) {
      if (mounted && data.containsKey('relay')) {
        // Find the AC appliance in our list
        final acIndex = _appliances.indexWhere((app) => app.iconName == 'AC');
        if (acIndex != -1) {
          final bool isAcOn = data['relay']?.toString().toUpperCase() == 'ON';
          // Update its state only if it has changed
          if (_appliances[acIndex].isOn != isAcOn) {
            setState(() {
              _appliances[acIndex].isOn = isAcOn;
            });
            _saveAppliances(); // Persist the change
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _mqttService.disconnect(); 
    _mqttDataSub?.cancel(); // --- ADDED: Cancel the subscription
    super.dispose();
  }

  // --- Data Logic (_loadAppliances, _saveAppliances, _addAppliance, etc. remain the same) ---
  Future<void> _loadAppliances() async {
    final prefs = await SharedPreferences.getInstance();
    final String? applianceString = prefs.getString('appliances_list_v2');
    if (applianceString != null) {
      final List<dynamic> jsonList = json.decode(applianceString);
      _appliances = jsonList.map((json) => Appliance.fromJson(json)).toList();
    } else {
      _appliances = [
        Appliance(id: _uuid.v4(), name: 'Air Conditioner', iconName: 'AC', isOn: true),
        Appliance(id: _uuid.v4(), name: 'Refrigerator', iconName: 'Fridge'),
        Appliance(id: _uuid.v4(), name: 'Smart TV', iconName: 'TV'),
        Appliance(id: _uuid.v4(), name: 'Bedroom Light', iconName: 'Light'),
      ];
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveAppliances() async {
    final prefs = await SharedPreferences.getInstance();
    final String applianceString =
        json.encode(_appliances.map((app) => app.toJson()).toList());
    await prefs.setString('appliances_list_v2', applianceString);
  }

  void _addAppliance(String name, String iconName) {
    setState(() {
      _appliances.add(Appliance(id: _uuid.v4(), name: name, iconName: iconName));
    });
    _saveAppliances();
  }

  void _editAppliance(String id, String newName, String newIconName) {
    setState(() {
      final index = _appliances.indexWhere((app) => app.id == id);
      if (index != -1) {
        _appliances[index].name = newName;
        _appliances[index].iconName = newIconName;
      }
    });
    _saveAppliances();
  }

  void _deleteAppliance(String id) {
    setState(() {
      _appliances.removeWhere((app) => app.id == id);
    });
    _saveAppliances();
  }
  
  void _toggleSwitch(String id) {
    final index = _appliances.indexWhere((app) => app.id == id);
    if (index != -1) {
      final appliance = _appliances[index];
      final isCurrentlyOn = appliance.isOn;
      
      // If the appliance is the Air Conditioner, send an MQTT command
      if (appliance.iconName == 'AC') {
        final command = isCurrentlyOn ? 'off' : 'on';
        _mqttService.publishCommand(command);
      }
      
      // Optimistically toggle the state locally for immediate UI feedback.
      // The stream listener will correct this if the actual state differs.
      setState(() {
        appliance.isOn = !isCurrentlyOn;
      });
      _saveAppliances();
    }
  }


  // --- UI Building (The rest of the file remains the same) ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSoftIconButton(
                        icon: Icons.menu_rounded,
                        onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
                      ),
                      _buildSoftIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () => debugPrint('Notifications tapped'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Welcome Home,',
                      style: TextStyle(
                        fontSize: 26,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 120),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: _appliances.length,
                            itemBuilder: (context, index) {
                              final appliance = _appliances[index];
                              return AnimatedScale(
                                scale: 1,
                                duration: Duration(milliseconds: 300 + index * 40),
                                curve: Curves.easeOut,
                                child: _buildDeviceGridCard(appliance),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          _buildCreativeAddButton(),
          _buildChatButton(),
          Positioned(
            top: 100,
            left: 24,
            right: 80,
            child: _buildAnimatedDropdownMenu(),
          ),
        ],
      ),
    );
  }

  void _showChatDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, -5),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).cardColor.withOpacity(0.8),
                            Theme.of(context).cardColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "AI Home Assistant",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 28),
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, thickness: 0.5, indent: 20, endIndent: 20),
                          Expanded(
                            child: ChatWindow(chatService: _chatService),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatButton() {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 20,
      left: 20,
      child: GestureDetector(
        onTap: _showChatDialog,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface.withOpacity(0.5),
                theme.colorScheme.surface.withOpacity(0.2),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Center(
                child: Lottie.asset(
                  'assets/robot.json',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreativeAddButton() {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _fabScaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _fabScaleAnim.value,
          child: child,
        ),
        child: GestureDetector(
          onTap: () => _showEditOrAddDialog(),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.95),
                    theme.colorScheme.primary,
                  ]),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 36),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceGridCard(Appliance appliance) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (appliance.iconName == 'AC') {
          Navigator.pushNamed(context, '/ac_control');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${appliance.name} tapped. No action defined.')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: appliance.isOn ? Border.all(color: Colors.greenAccent, width: 2) : null,
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    availableIcons[appliance.iconName] ?? Icons.devices,
                    color: theme.textTheme.bodyLarge?.color,
                    size: 32,
                  ),
                  PopupMenuButton<String>(
                    color: Theme.of(context).cardColor,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditOrAddDialog(appliance: appliance);
                      } else if (value == 'delete') {
                        _deleteAppliance(appliance.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appliance.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomAnimatedSwitch(
                    value: appliance.isOn,
                    onChanged: (value) => _toggleSwitch(appliance.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditOrAddDialog({Appliance? appliance}) {
    final bool isEditing = appliance != null;
    final TextEditingController nameController =
        TextEditingController(text: appliance?.name ?? '');
    String selectedIconName = appliance?.iconName ?? 'Generic';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Appliance' : 'Add Appliance'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Appliance Name'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedIconName,
                    decoration: const InputDecoration(labelText: 'Icon'),
                    items: availableIcons.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Row(
                          children: [
                            Icon(availableIcons[key]),
                            const SizedBox(width: 10),
                            Text(key),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedIconName = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      if (isEditing) {
                        _editAppliance(appliance.id, name, selectedIconName);
                      } else {
                        _addAppliance(name, selectedIconName);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedDropdownMenu() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isMenuVisible ? 180 : 0,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: _isMenuVisible
              ? [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    offset: const Offset(4, 4),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildMenuItem(
                icon: Icons.devices_other_outlined,
                text: 'My Appliances',
                onTap: () => setState(() => _isMenuVisible = false),
                isSelected: true,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildMenuItem(
                icon: Icons.grid_view_outlined,
                text: 'Manage Homes',
                onTap: () => setState(() => _isMenuVisible = false),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildMenuItem(
                icon: Icons.home_work_outlined,
                text: 'My Homes',
                onTap: () => setState(() => _isMenuVisible = false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.textTheme.bodyLarge?.color?.withOpacity(0.7);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: color,
          fontSize: 16,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildSoftIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(3, 3),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(-3, -3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: theme.iconTheme.color,
          size: 28,
        ),
      ),
    );
  }
}