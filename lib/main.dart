import 'package:flutter/material.dart';

void main() {
  runApp(const TodayEarnApp());
}

class TodayEarnApp extends StatelessWidget {
  const TodayEarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today Earn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOtpSent = false;

  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নম্বরে ৬ ডিজিটের OTP পাঠানো হয়েছে! (টেস্ট কোড: 123456)')),
      );
    }
  }

  void _verifyOTP() {
    if (_otpController.text == '123456' || _otpController.text.length == 6) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userIdentifier: '+880 ${_phoneController.text}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক ৬ ডিজিটের OTP কোড দিন')),
      );
    }
  }

  void _showGoogleAccountPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'অ্যাকাউন্ট বেছে নিন',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const CircleAvatar(child: Text('N')),
                title: const Text('Md. Nayeem'),
                subtitle: const Text('nayeem@gmail.com'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(userIdentifier: 'nayeem@gmail.com'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('অন্য অ্যাকাউন্ট যোগ করুন'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('লগইন / রেজিস্টার')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.account_balance_wallet, size: 80, color: Colors.teal),
                const SizedBox(height: 20),
                const Text(
                  'Today Earn-এ স্বাগতম',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'মোবাইল নম্বর',
                    prefixText: '+880 ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'মোবাইল নম্বর দিন';
                    }
                    if (value.length != 10) {
                      return 'সঠিক ১০ ডিজিটের নম্বর দিন (যেমন: 17xxxxxxxx)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                if (!_isOtpSent)
                  ElevatedButton(
                    onPressed: _sendOTP,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                    child: const Text('OTP পাঠান', style: TextStyle(fontSize: 16)),
                  ),

                if (_isOtpSent) ...[
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: '৬ ডিজিটের OTP কোড (123456)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_clock),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('ভেরিফাই ও প্রবেশ করুন', style: TextStyle(color: Colors.white)),
                  ),
                ],

                const SizedBox(height: 25),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('অথবা'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 25),

                OutlinedButton.icon(
                  onPressed: _showGoogleAccountPicker,
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                  label: const Text('Google / জিমেইল দিয়ে লগইন করুন', style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userIdentifier;
  const HomeScreen({super.key, required this.userIdentifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Center(child: Text('মূল হোম পেজ (কাজ ও আর্নিং)', style: TextStyle(fontSize: 18))),
      ProfileScreen(userIdentifier: widget.userIdentifier),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'প্রোফাইল'),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String userIdentifier;
  const ProfileScreen({super.key, required this.userIdentifier});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "মোঃ নাঈমুল ইসলাম";

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _updateProfile() {
    _nameController.text = userName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('প্রোফাইল আপডেট করুন'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'নতুন নাম'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'নতুন পাসওয়ার্ড'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_nameController.text.isNotEmpty) {
                    userName = _nameController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('প্রোফাইল তথ্য সফলভাবে পরিবর্তন হয়েছে!')),
                );
              },
              child: const Text('সেভ করুন'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আমার প্রোফাইল')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        body: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(widget.userIdentifier, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('নাম ও পাসওয়ার্ড পরিবর্তন'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _updateProfile,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('লগআউট', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
