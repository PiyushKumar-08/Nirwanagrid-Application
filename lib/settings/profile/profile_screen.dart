import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data variables
  String _name = 'Enter Name';
  String _email = 'Enter Email';
  String _phone = 'Enter Phone';
  String _dob = '2000-01-01';
  String? _selectedGender;

  bool _isPhoneVerified = false;
  bool _isEmailVerified = false;

  // Shows a custom neumorphic dialog for text input
  Future<void> _showEditDialog(String title, String currentValue, Function(String) onSave) async {
    final String initialValue = currentValue.startsWith('Enter') ? '' : currentValue;
    final controller = TextEditingController(text: initialValue);
    final theme = Theme.of(context);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your $title',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: title == 'Phone' ? TextInputType.phone : TextInputType.text,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black, // Black border by default
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor, // Highlight border when focused
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Save', style: theme.textTheme.labelLarge),
                      onPressed: () {
                        setState(() => onSave(controller.text));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Gender & DOB functions stay the same (no changes)
  void _showGenderBottomSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Gender',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.male, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                title: const Text('Male'),
                onTap: () {
                  setState(() => _selectedGender = 'Male');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.female, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                title: const Text('Female'),
                onTap: () {
                  setState(() => _selectedGender = 'Female');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.transgender, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                title: const Text('Other'),
                onTap: () {
                  setState(() => _selectedGender = 'Other');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.close, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDobBottomSheet() async {
    final initialDate = DateTime.tryParse(_dob) ?? DateTime(1990, 1, 1);
    final theme = Theme.of(context);

    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) => _DatePickerSheet(initialDate: initialDate),
    );

    if (pickedDate != null) {
      setState(() {
        _dob = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final darkShadow = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.shade500;
    final lightShadow = isDarkMode ? Colors.grey.shade800 : Colors.white;

    final gradientStart = isDarkMode ? Colors.grey[800] : Colors.white;
    final gradientEnd = isDarkMode ? Colors.grey[850] : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gradientStart!, gradientEnd!],
                        ),
                        boxShadow: [
                          BoxShadow(color: darkShadow, offset: const Offset(4, 4), blurRadius: 15, spreadRadius: 1),
                          BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
                        ],
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        child: Icon(Icons.person, size: 60, color: theme.textTheme.headlineSmall?.color),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image picker tapped!')),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withAlpha(150),
                                offset: const Offset(-2, -2),
                                blurRadius: 5,
                                spreadRadius: 0.5,
                              ),
                              BoxShadow(
                                color: theme.primaryColor.withAlpha(255),
                                offset: const Offset(2, 2),
                                blurRadius: 5,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildProfileOptionRow(
              context: context,
              label: 'Name',
              value: _name,
              onTap: () => _showEditDialog('Name', _name, (val) => _name = val),
            ),
            _buildProfileOptionRow(
              context: context,
              label: 'Phone',
              value: _phone.startsWith('+91') ? _phone.substring(3) : _phone,
              onTap: () => _showEditDialog(
                'Phone',
                _phone.startsWith('+91') ? _phone.substring(3) : _phone,
                (newValue) {
                  String cleanedNumber = newValue.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleanedNumber.length == 10) {
                    _phone = '+91$cleanedNumber';
                  } else {
                    _phone = newValue;
                  }
                  _isPhoneVerified = false;
                },
              ),
              isVerified: _isPhoneVerified,
              onVerify: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone verification started...')),
                );
              },
            ),
            _buildProfileOptionRow(
              context: context,
              label: 'Email',
              value: _email,
              onTap: () => _showEditDialog('Email', _email, (val) {
                _email = val;
                _isEmailVerified = false;
              }),
              isVerified: _isEmailVerified,
              onVerify: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification email sent...')),
                );
              },
            ),
            _buildProfileOptionRow(
              context: context,
              label: 'Gender',
              value: _selectedGender ?? 'Select',
              onTap: _showGenderBottomSheet,
            ),
            _buildProfileOptionRow(
              context: context,
              label: 'Date of birth',
              value: _dob,
              onTap: _showDobBottomSheet,
            ),
            const Spacer(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptionRow({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool? isVerified,
    VoidCallback? onVerify,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final darkShadow = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.shade400;
    final lightShadow = isDarkMode ? Colors.grey.shade800 : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(color: darkShadow, offset: const Offset(4, 4), blurRadius: 10, spreadRadius: 1),
            BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 10, spreadRadius: 1),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.headlineSmall),
            Row(
              children: [
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value.startsWith('Enter') || value == 'Select'
                        ? theme.textTheme.headlineSmall?.color
                        : theme.colorScheme.onBackground,
                  ),
                ),
                if (isVerified != null && !isVerified)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: onVerify,
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Date picker sheet stays unchanged
class _DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;

  const _DatePickerSheet({required this.initialDate});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDate.day;
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;
  }

  int getDaysInMonth(int year, int month) {
    if (month == 2) {
      return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
    }
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInCurrentMonth = getDaysInMonth(selectedYear, selectedMonth);

    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Select date of birth',
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDay = index + 1;
                      });
                    },
                    children: List.generate(daysInCurrentMonth, (index) => Center(child: Text('${index + 1}'))),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = index + 1;
                        if (selectedDay > getDaysInMonth(selectedYear, selectedMonth)) {
                          selectedDay = getDaysInMonth(selectedYear, selectedMonth);
                        }
                      });
                    },
                    children: months.map((month) => Center(child: Text(month))).toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(initialItem: selectedYear - 1900),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = 1900 + index;
                        if (selectedDay > getDaysInMonth(selectedYear, selectedMonth)) {
                          selectedDay = getDaysInMonth(selectedYear, selectedMonth);
                        }
                      });
                    },
                    children: List.generate(DateTime.now().year - 1899,
                        (index) => Center(child: Text('${1900 + index}'))),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final finalDate = DateTime(selectedYear, selectedMonth, selectedDay);
                  Navigator.pop(context, finalDate);
                },
                child: Text('Select', style: theme.textTheme.labelLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
