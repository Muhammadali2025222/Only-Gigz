import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'widgets/add_funds_sheet.dart';
import 'widgets/withdraw_funds_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with WidgetsBindingObserver {
  double _balance = 2500.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadWalletData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadWalletData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadWalletData() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final organizerId = authService.currentUser?.uid;

      if (organizerId != null) {
        final walletData = await apiService.getWalletData(organizerId);
        
        if (mounted) {
          setState(() {
            if (walletData['wallet_balance'] != null) {
              _balance = (walletData['wallet_balance']).toDouble();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading wallet data: $e');
    }
  }

  Future<void> _openStripePaymentSheet() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final organizerId = authService.currentUser?.uid;

      if (organizerId == null) throw Exception('User not logged in');

      final setupIntentData = await apiService.createSetupIntent(organizerId);
      final clientSecret = setupIntentData['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          merchantDisplayName: 'OnlyGigz',
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
            colors: const PaymentSheetAppearanceColors(
              primary: Color(0xFF00C950),
              background: Color(0xFF0A0A0F),
              componentBackground: Color(0xFF3A3A3F),
              componentDivider: Color(0xFF2A2A2F),
              primaryText: Color(0xFFFFFFFF),
              secondaryText: Color(0xFFFFFFFF),
              placeholderText: Color(0xFF888888),
              icon: Color(0xFF00C950),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: const Color(0xFF00C950),
                  text: const Color(0xFF000000),
                ),
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: const Color(0xFF00C950),
                  text: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        _loadWalletData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment method added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
          ),
        ),
        title: const Text('Wallet',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFA2F301),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/wallet_icon.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Available Balance',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => AddFundsSheet(
                                onAddFunds: (amount) {
                                  setState(() => _balance += amount);
                                },
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.black, size: 16),
                                  SizedBox(width: 6),
                                  Text('Add Funds',
                                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => WithdrawFundsSheet(
                                availableBalance: _balance,
                                onWithdraw: (amount) {
                                  setState(() => _balance -= amount);
                                },
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_downward, color: Colors.black, size: 16),
                                  SizedBox(width: 6),
                                  Text('Withdraw',
                                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader('Payment Methods', onAddNew: _openStripePaymentSheet),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _paymentMethodCard(
                  icon: Icons.credit_card_outlined,
                  title: 'Visa •••• 4532',
                  subtitle: 'Default',
                  subtitleColor: const Color(0xFFA2F301),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _paymentMethodCard(
                  icon: Icons.credit_card_outlined,
                  title: 'Mastercard •••• 8921',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader('Bank Accounts', onAddNew: () {}),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _paymentMethodCard(
                  iconPath: 'assets/bank_icon.svg',
                  icon: Icons.account_balance_outlined,
                  title: 'Chase Bank •••• 7845',
                  subtitle: 'Checking',
                  subtitleColor: const Color(0xFF888888),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),
              const Text('Recent Transactions',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _transactionRow(
                'Added Funds',
                'Feb 9, 2026',
                '+\$2000',
                isPositive: true,
              ),
              _transactionRow(
                'Added Funds',
                'Feb 9, 2026',
                '+\$500',
                isPositive: true,
              ),
              _transactionRow(
                'Payment to Sarah Johnson',
                'Feb 4, 2026',
                '\$750',
                isPositive: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onAddNew}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        GestureDetector(
          onTap: onAddNew,
          child: const Text('+ Add New',
              style: TextStyle(color: Color(0xFFA2F301), fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _paymentMethodCard({
    IconData? icon,
    String? iconPath,
    required String title,
    String? subtitle,
    Color subtitleColor = const Color(0xFF888888),
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1F),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF242429),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: iconPath != null
                    ? SvgPicture.asset(iconPath,
                        width: 20, height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFFA2F301), BlendMode.srcIn))
                    : Icon(icon ?? Icons.credit_card_outlined, color: const Color(0xFFA2F301), size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF555555), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _transactionRow(
    String title,
    String date,
    String amount, {
    String status = 'Completed',
    bool isPositive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Text(
                amount,
                style: TextStyle(
                  color: isPositive ? const Color(0xFFA2F301) : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
              Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
