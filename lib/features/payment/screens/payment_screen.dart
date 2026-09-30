import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/payment_model.dart';
import '../models/transaction_claim_model.dart';
import '../payment_colors.dart';
import '../services/payment_api_service.dart';
import '../widgets/payment_list_card.dart';
import '../widgets/payment_summary.dart';
import '../widgets/transaction_claim_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.userId,
    this.accessToken,
  });

  final String? userId;
  final String? accessToken;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PaymentApiService _apiService;

  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');

  late DateTime _startDate;
  late DateTime _endDate;

  List<PaymentModel> _paymentList = <PaymentModel>[];
  List<TransactionClaimModel> _transactionList =
  <TransactionClaimModel>[];

  bool _paymentLoading = false;
  bool _transactionLoading = false;

  String? _paymentError;
  String? _transactionError;

  int _lastLoadedTab = -1;

  @override
  void initState() {
    super.initState();

    _apiService = PaymentApiService();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);

    final DateTime today = _dateOnly(DateTime.now());

    _startDate = DateTime(
      today.year,
      today.month,
      1,
    );

    _endDate = today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadCurrentTab();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _apiService.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // TAB HANDLING
  // ---------------------------------------------------------------------------

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }

    if (!mounted) {
      return;
    }

    _loadCurrentTab();
  }

  void _loadCurrentTab({
    bool force = false,
  }) {
    final int currentTab = _tabController.index;

    if (!force && _lastLoadedTab == currentTab) {
      return;
    }

    _lastLoadedTab = currentTab;

    if (currentTab == 0) {
      _loadPaymentList();
    } else {
      _loadTransactionList();
    }
  }

  // ---------------------------------------------------------------------------
  // API
  // ---------------------------------------------------------------------------

  bool get _hasCredentials {
    return widget.userId != null &&
        widget.userId!.trim().isNotEmpty &&
        widget.accessToken != null &&
        widget.accessToken!.trim().isNotEmpty;
  }

  Future<void> _loadPaymentList({
    bool showLoader = true,
  }) async {
    if (!_hasCredentials) {
      if (!mounted) {
        return;
      }

      setState(() {
        _paymentLoading = false;
        _paymentError =
        'User session is not available. Please login again.';
      });

      return;
    }

    if (mounted && showLoader) {
      setState(() {
        _paymentLoading = true;
        _paymentError = null;
      });
    } else if (mounted) {
      setState(() {
        _paymentError = null;
      });
    }

    try {
      final PaymentListResponse response =
      await _apiService.getPaymentList(
        userId: widget.userId!.trim(),
        startDate: _apiDateFormat.format(_startDate),
        endDate: _apiDateFormat.format(_endDate),
        accessToken: widget.accessToken!.trim(),
      );

      if (!mounted) {
        return;
      }

      if (!response.success) {
        setState(() {
          _paymentLoading = false;
          _paymentError = response.message.isNotEmpty
              ? response.message
              : 'Unable to load payment details.';
        });

        return;
      }

      setState(() {
        _paymentList = response.data;
        _paymentLoading = false;
        _paymentError = null;
      });
    } on PaymentApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _paymentLoading = false;
        _paymentError = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _paymentLoading = false;
        _paymentError =
        'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _loadTransactionList({
    bool showLoader = true,
  }) async {
    if (!_hasCredentials) {
      if (!mounted) {
        return;
      }

      setState(() {
        _transactionLoading = false;
        _transactionError =
        'User session is not available. Please login again.';
      });

      return;
    }

    if (mounted && showLoader) {
      setState(() {
        _transactionLoading = true;
        _transactionError = null;
      });
    } else if (mounted) {
      setState(() {
        _transactionError = null;
      });
    }

    try {
      final TransactionClaimListResponse response =
      await _apiService.getTransactionClaimList(
        userId: widget.userId!.trim(),
        startDate: _apiDateFormat.format(_startDate),
        endDate: _apiDateFormat.format(_endDate),
        accessToken: widget.accessToken!.trim(),
      );

      if (!mounted) {
        return;
      }

      if (!response.success) {
        setState(() {
          _transactionLoading = false;
          _transactionError = response.message.isNotEmpty
              ? response.message
              : 'Unable to load transaction claims.';
        });

        return;
      }

      setState(() {
        _transactionList = response.data;
        _transactionLoading = false;
        _transactionError = null;
      });
    } on PaymentApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _transactionLoading = false;
        _transactionError = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _transactionLoading = false;
        _transactionError =
        'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _refreshCurrentTab() async {
    if (_tabController.index == 0) {
      await _loadPaymentList();
    } else {
      await _loadTransactionList();
    }
  }

  // ---------------------------------------------------------------------------
  // DATE FILTER
  // ---------------------------------------------------------------------------

  Future<void> _selectStartDate() async {
    final DateTime today = _dateOnly(DateTime.now());

    final DateTime minimumDate = DateTime(
      today.year,
      today.month - 2,
      1,
    );

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: minimumDate,
      lastDate: today,
      helpText: 'Select Start Date',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final DateTime selected = _dateOnly(selectedDate);

    setState(() {
      _startDate = selected;

      if (_endDate.isBefore(_startDate)) {
        _endDate = _startDate;
      }
    });

    await _refreshCurrentTab();
  }

  Future<void> _selectEndDate() async {
    final DateTime today = _dateOnly(DateTime.now());

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate)
          ? _startDate
          : _endDate,
      firstDate: _startDate,
      lastDate: today,
      helpText: 'Select End Date',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _endDate = _dateOnly(selectedDate);
    });

    await _refreshCurrentTab();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ---------------------------------------------------------------------------
  // PAYMENT CALCULATIONS
  // ---------------------------------------------------------------------------

  double get _paymentTotalAmount {
    return _paymentList.fold<double>(
      0,
          (double total, PaymentModel payment) {
        return total + payment.totalAmount;
      },
    );
  }

  double get _paymentPaidAmount {
    return _paymentList
        .where((PaymentModel payment) => payment.isPaid)
        .fold<double>(
      0,
          (double total, PaymentModel payment) {
        return total + payment.totalAmount;
      },
    );
  }

  double get _paymentPendingAmount {
    return _paymentList
        .where((PaymentModel payment) => !payment.isPaid)
        .fold<double>(
      0,
          (double total, PaymentModel payment) {
        return total + payment.totalAmount;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // TRANSACTION CLAIM CALCULATIONS
  // ---------------------------------------------------------------------------

  double get _transactionTotalAmount {
    return _transactionList.fold<double>(
      0,
          (double total, TransactionClaimModel transaction) {
        return total + transaction.transPrice;
      },
    );
  }

  double get _transactionPaidAmount {
    return _transactionList
        .where(
          (TransactionClaimModel transaction) =>
      transaction.isPaid,
    )
        .fold<double>(
      0,
          (double total, TransactionClaimModel transaction) {
        return total + transaction.transPrice;
      },
    );
  }

  double get _transactionPendingAmount {
    return _transactionList
        .where(
          (TransactionClaimModel transaction) =>
      !transaction.isPaid,
    )
        .fold<double>(
      0,
          (double total, TransactionClaimModel transaction) {
        return total + transaction.transPrice;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaymentColors.screenBackground,
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: PaymentColors.shopperBlue,
        foregroundColor: PaymentColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: PaymentColors.white,
          indicatorWeight: 3,
          labelColor: PaymentColors.white,
          unselectedLabelColor:
          PaymentColors.white.withValues(alpha: 0.70),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(
              text: 'Earned',
            ),
            Tab(
              text: 'Trans. Claim',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentTab(),
                _buildTransactionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE FILTER UI
  // ---------------------------------------------------------------------------

  Widget _buildDateFilter() {
    return Container(
      color: PaymentColors.white,
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: 'Start Date',
              value: _displayDateFormat.format(_startDate),
              onTap: _selectStartDate,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DateField(
              label: 'End Date',
              value: _displayDateFormat.format(_endDate),
              onTap: _selectEndDate,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EARNED TAB
  // ---------------------------------------------------------------------------

  Widget _buildPaymentTab() {
    if (_paymentLoading && _paymentList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: PaymentColors.shopperBlue,
        ),
      );
    }

    if (_paymentError != null && _paymentList.isEmpty) {
      return _buildErrorState(
        message: _paymentError!,
        onRetry: () => _loadPaymentList(),
      );
    }

    if (_paymentList.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshCurrentTab,
        color: PaymentColors.shopperBlue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildPaymentSummary(),
            _buildEmptyState(
              message: 'No earned payments found.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCurrentTab,
      color: PaymentColors.shopperBlue,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 2,
          bottom: 20,
        ),
        itemCount: _paymentList.length + 1,
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          if (index == 0) {
            return _buildPaymentSummary();
          }

          final PaymentModel payment =
          _paymentList[index - 1];

          return PaymentListCard(
            payment: payment,
          );
        },
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return PaymentSummary(
      title: 'Earned Summary',
      totalAmount: _paymentTotalAmount,
      itemCount: _paymentList.length,
      paidAmount: _paymentPaidAmount,
      pendingAmount: _paymentPendingAmount,
      countLabel: 'Total Audits',
    );
  }

  // ---------------------------------------------------------------------------
  // TRANSACTION CLAIM TAB
  // ---------------------------------------------------------------------------

  Widget _buildTransactionTab() {
    if (_transactionLoading && _transactionList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: PaymentColors.shopperBlue,
        ),
      );
    }

    if (_transactionError != null && _transactionList.isEmpty) {
      return _buildErrorState(
        message: _transactionError!,
        onRetry: () => _loadTransactionList(),
      );
    }

    if (_transactionList.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshCurrentTab,
        color: PaymentColors.shopperBlue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildTransactionSummary(),
            _buildEmptyState(
              message: 'No transaction claims found.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCurrentTab,
      color: PaymentColors.shopperBlue,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 2,
          bottom: 20,
        ),
        itemCount: _transactionList.length + 1,
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          if (index == 0) {
            return _buildTransactionSummary();
          }

          final TransactionClaimModel transaction =
          _transactionList[index - 1];

          return TransactionClaimCard(
            transaction: transaction,
          );
        },
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return PaymentSummary(
      title: 'Transaction Claim Summary',
      totalAmount: _transactionTotalAmount,
      itemCount: _transactionList.length,
      paidAmount: _transactionPaidAmount,
      pendingAmount: _transactionPendingAmount,
      countLabel: 'Total Claims',
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR STATE
  // ---------------------------------------------------------------------------

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshCurrentTab,
      color: PaymentColors.shopperBlue,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 70),
          const Icon(
            Icons.cloud_off_outlined,
            size: 52,
            color: PaymentColors.lightText,
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Unable to load data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PaymentColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PaymentColors.secondaryText,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PaymentColors.shopperBlue,
                foregroundColor: PaymentColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                'Retry',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState({
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60,
        left: 25,
        right: 25,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 50,
            color: PaymentColors.lightText,
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PaymentColors.secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try changing the selected date range.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PaymentColors.lightText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DATE FIELD
// =============================================================================

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: PaymentColors.screenBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: PaymentColors.divider,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 17,
              color: PaymentColors.shopperBlue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: PaymentColors.secondaryText,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PaymentColors.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: PaymentColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}