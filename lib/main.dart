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
        primarySwatch: Colors.teal,
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
        const SnackBar(content: Text('নম্বরে OTP পাঠানো হয়েছে!')),
      );
    }
  }

  void _verifyOTP() {
    if (_otpController.text.length == 6) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক ৬ ডিজিটের OTP দিন')),
      );
    }
  }

  void _loginWithGoogle() {
    // ফোনের সব জিমেইল দেখানোর প্রসেস
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('জিমেইল দিয়ে লগইন হচ্ছে...')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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

                // মোবাইল নম্বর ইনপুট ও সঠিক নম্বর চেক
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
                      return 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন (যেমন: 017xxxxxxxx)';
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

                // OTP ইনপুট ফিল্ড
                if (_isOtpSent) ...[
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: '৬ ডিজিটের OTP কোড',
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

                // জিমেইল দিয়ে লগইন
                OutlinedButton.icon(
                  onPressed: _loginWithGoogle,
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

// হোম স্ক্রিন ও প্রোফাইল সেকশন
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('মূল হোম পেজ (কাজ ও আর্নিং)', style: TextStyle(fontSize: 18))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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

// প্রোফাইল পেজ (নাম, পাসওয়ার্ড ও ছবি পরিবর্তন)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "মোঃ নাঈম";
  String userPhone = "+8801700000000";

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _updateProfile() {
    showDialog(
      context: context,
      builder: (context) {
        _nameController.text = userName;
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
                  const SnackBar(content: Text('প্রোফাইল সফলভাবে আপডেট হয়েছে!')),
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
            Text(userPhone, style: const TextStyle(color: Colors.grey)),
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
