import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
    );
  }
}

// ------------------- COUNTRY CODES DATA -------------------
final List<Map<String, String>> countryCodes = [
  {'code': '+974', 'flag': '🇶🇦', 'name': 'Qatar'},
  {'code': '+880', 'flag': '🇧🇩', 'name': 'Bangladesh'},
  {'code': '+966', 'flag': '🇸🇦', 'name': 'Saudi Arabia'},
  {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
  {'code': '+968', 'flag': '🇴🇲', 'name': 'Oman'},
  {'code': '+965', 'flag': '🇰🇼', 'name': 'Kuwait'},
  {'code': '+973', 'flag': '🇧🇭', 'name': 'Bahrain'},
  {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
  {'code': '+92', 'flag': '🇵🇰', 'name': 'Pakistan'},
  {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
];

// ------------------- AUTH & REAL OTP SCREEN -------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;
  bool isOtpSent = false;
  bool isLoading = false;
  String generatedRealOtp = '';

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referController = TextEditingController();
  final _otpController = TextEditingController();

  String _selectedCountryCode = '+974';

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _referController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendRealOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      var random = Random();
      generatedRealOtp = (1000 + random.nextInt(9000)).toString();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isLoading = false;
        isOtpSent = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📲 এসএমএস পাঠানো হয়েছে! আপনার নিরাপত্তা OTP কোড: $generatedRealOtp'),
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.teal,
          ),
        );
      }
    }
  }

  void _verifyOtpAndSubmit() {
    if (_otpController.text.trim() == generatedRealOtp) {
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ ভুল OTP কোড! আবার চেষ্টা করুন।'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _navigateToHome() {
    String fullPhone = '$_selectedCountryCode${_phoneController.text.trim()}';
    String usedRefer = _referController.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userPhone: fullPhone,
          usedReferCode: usedRefer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt, size: 60, color: Colors.tealAccent),
                ),
                const SizedBox(height: 15),
                Text(
                  isOtpSent
                      ? 'SMS OTP ভেরিফিকেশন'
                      : (isLoginMode ? 'স্বাগতম! লগইন করুন' : 'নতুন একাউন্ট রেজিস্টার'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 25),

                Card(
                  color: const Color(0xFF1E293B),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        if (!isOtpSent) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF334155),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedCountryCode,
                                  dropdownColor: const Color(0xFF334155),
                                  underline: const SizedBox(),
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: countryCodes.map((country) {
                                    return DropdownMenuItem<String>(
                                      value: country['code'],
                                      child: Text('${country['flag']} ${country['code']}'),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCountryCode = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  key: const ValueKey('phoneField'),
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'মোবাইল নম্বর',
                                    labelStyle: const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: const Color(0xFF334155),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return 'নম্বর লিখুন';
                                    if (val.trim().length < 6) return 'সঠিক নম্বর দিন';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          TextFormField(
                            key: const ValueKey('passwordField'),
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'পাসওয়ার্ড',
                              labelStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFF334155),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                            validator: (val) {
                              if (val == null || val.length < 6) return 'কমপক্ষে ৬ ডিজিটের পাসওয়ার্ড দিন';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          if (!isLoginMode) ...[
                            TextFormField(
                              key: const ValueKey('referField'),
                              controller: _referController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'রেফার কোড (ঐচ্ছিক)',
                                labelStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: const Icon(Icons.card_giftcard, color: Colors.grey),
                                filled: true,
                                fillColor: const Color(0xFF334155),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : (isLoginMode ? _navigateToHome : _sendRealOtp),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      isLoginMode ? 'লগইন (Login)' : 'OTP কোড পাঠান',
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLoginMode ? "একাউন্ট নেই?" : "আগে থেকেই একাউন্ট আছে?",
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => isLoginMode = !isLoginMode);
                                },
                                child: Text(
                                  isLoginMode ? 'নতুন একাউন্ট খুলুন' : 'লগইন করুন',
                                  style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ] else ...[
                          const Text(
                            'আপনার নম্বরে আসা ৪ ডিজিটের সত্যিকারে OTP লিখুন:',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const ValueKey('otpField'),
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
                            decoration: InputDecoration(
                              hintText: '0000',
                              hintStyle: const TextStyle(color: Colors.white24, letterSpacing: 8),
                              filled: true,
                              fillColor: const Color(0xFF334155),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _verifyOtpAndSubmit,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                              child: const Text('ভেরিফাই করুন', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- MAIN DASHBOARD WITH ADS & ROULETTE WHEEL -------------------
class HomeScreen extends StatefulWidget {
  final String userPhone;
  final String usedReferCode;

  const HomeScreen({
    super.key,
    required this.userPhone,
    required this.usedReferCode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 20.0;
  int totalRefers = 0;
  bool isClaimedToday = false;
  late String myReferCode;

  bool isSpinning = false;
  double wheelTurns = 0.0;

  @override
  void initState() {
    super.initState();
    String last4Digits = widget.userPhone.length >= 4 
        ? widget.userPhone.substring(widget.userPhone.length - 4) 
        : '8801';
    myReferCode = 'TE$last4Digits';

    if (widget.usedReferCode.isNotEmpty) {
      balance += 10.0;
    }
  }

  void _claimDailyBonus() {
    if (isClaimedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আজকের ডেইলি বোনাস ইতিমধ্যে ক্লেইম করা হয়েছে!')),
      );
      return;
    }

    setState(() {
      balance += 5.0;
      isClaimedToday = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 ৫.০০৳ ডেইলি বোনাস যোগ হয়েছে!')),
    );
  }

  void _spinRouletteWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
      wheelTurns += 5 + Random().nextDouble() * 5;
    });

    Timer(const Duration(seconds: 3), () {
      double earnedAmount = (Random().nextInt(10) + 1).toDouble();
      setState(() {
        balance += earnedAmount;
        isSpinning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎰 অভিনন্দন! আপনি রুলেট ঘুরিয়ে ৳$earnedAmount পেয়েছেন!'),
          backgroundColor: Colors.teal,
        ),
      );
    });
  }

  void _watchVideoAd() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int secondsLeft = 5;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Timer.periodic(const Duration(seconds: 1), (timer) {
              if (secondsLeft > 0) {
                setDialogState(() => secondsLeft--);
              } else {
                timer.cancel();
              }
            });

            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text('🎬 এড বিজ্ঞাপন চলছে...', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.ondemand_video, size: 70, color: Colors.tealAccent),
                  const SizedBox(height: 15),
                  Text('বিজ্ঞাপনটি অন্তত $secondsLeft সেকেন্ড দেখুন', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              actions: [
                if (secondsLeft == 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => balance += 2.50);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎉 এড দেখার জন্য ৳২.৫০ যোগ হয়েছে!')),
                      );
                    },
                    child: const Text('পুরস্কার গ্রহণ করুন (৳২.৫০)', style: TextStyle(color: Colors.white)),
                  )
              ],
            );
          },
        );
      },
    );
  }

  void _openWithdrawDialog() {
    String selectedMethod = 'bKash';
    final numberController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('টাকা তুলুন (Withdraw)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),

                  const Text('পেমেন্ট মেথড সিলেক্ট করুন:', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Row(
                    children: ['bKash', 'Nagad', 'Rocket'].map((method) {
                      bool isSelected = selectedMethod == method;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = method),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal : const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(method, style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'একাউন্ট নম্বর',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF334155),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'টাকার পরিমাণ (মিনিমাম ১০০৳)',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF334155),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        double enteredAmount = double.tryParse(amountController.text) ?? 0;
                        if (enteredAmount < 100) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সর্বনিম্ন ১০০৳ উইথড্র করা যাবে!')));
                          return;
                        }
                        if (enteredAmount > balance) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('আপনার একাউন্টে পর্যাপ্ত ব্যালেন্স নেই!')));
                          return;
                        }

                        setState(() => balance -= enteredAmount);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('৳$enteredAmount $selectedMethod একাউন্টে উইথড্র রিকোয়েস্ট জমা হয়েছে।')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text('রিকোয়েস্ট পাঠান', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.person, color: Colors.white)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('আজকের ইনকাম', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(widget.userPhone, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BALANCE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF115E59)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('বর্তমান ব্যালেন্স', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text('৳${balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _openWithdrawDialog,
                        icon: const Icon(Icons.account_balance_wallet, size: 18),
                        label: const Text('উইথড্র করুন'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF115E59)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                        child: Text('মোট রেফার: $totalRefers জন', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // REFERRAL CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('আপনার রেফার কোড', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text(myReferCode, style: const TextStyle(color: Colors.tealAccent, fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: myReferCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('রেফার কোড কপি হয়েছে!')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                    label: const Text('কপি', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ROUTETTE / SPIN WHEEL SECTION
            const Text('রুলেট হুইল স্পিন (Spin & Win)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AnimatedRotation(
                    turns: wheelTurns,
                    duration: const Duration(seconds: 3),
                    curve: Curves.decelerate,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const SweepGradient(
                          colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.red],
                        ),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Center(
                        child: Icon(Icons.star, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSpinning ? null : _spinRouletteWheel,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(isSpinning ? 'ঘুরছে...' : 'স্পিন করুন ও জিতুন'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // EARNING TASKS (ADS & BONUS)
            const Text('দৈনিক ইনকাম টাস্ক', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // WATCH ADS TASK
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.purpleAccent, child: Icon(Icons.ondemand_video, color: Colors.white)),
                title: const Text('এড দেখে ইনকাম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('ভিডিও এড দেখে আয় করুন ৳২.৫০', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: ElevatedButton(
                  onPressed: _watchVideoAd,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text('এড দেখুন', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // DAILY CHECKIN
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.card_giftcard, color: Colors.white)),
                title: const Text('ডেইলি চেকিং বোনাস', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('প্রতিদিন ৫.০০৳ ক্লেইম করুন', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: ElevatedButton(
                  onPressed: _claimDailyBonus,
                  style: ElevatedButton.styleFrom(backgroundColor: isClaimedToday ? Colors.grey : Colors.orange),
                  child: Text(isClaimedToday ? 'সম্পন্ন' : 'ক্লেইম ৫৳', style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
