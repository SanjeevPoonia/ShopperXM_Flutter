import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../payment_colors.dart';
class PaymentListCard extends StatelessWidget {
  const PaymentListCard({
    super.key,
    required this.payment,
  });

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final bool isPaid = payment.isPaid;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: PaymentColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildClientRow(),
                const SizedBox(height: 12),
                _buildStoreRow(),
                const SizedBox(height: 12),
                _buildApprovedDateRow(),
                const SizedBox(height: 12),
                _buildAmountSection(),
                const SizedBox(height: 12),
                _buildStatusSection(isPaid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: PaymentColors.shopperBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: PaymentColors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'Earned',
            style: TextStyle(
              color: PaymentColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Client
  // ---------------------------------------------------------------------------

  Widget _buildClientRow() {
    return _InfoRow(
      icon: Icons.business_outlined,
      label: 'Client',
      value: _displayValue(payment.client),
    );
  }

  // ---------------------------------------------------------------------------
  // Store
  // ---------------------------------------------------------------------------

  Widget _buildStoreRow() {
    final String storeName = _displayValue(payment.storeName);

    final String storeCode = payment.storeCode.trim();

    final String storeValue = storeCode.isEmpty
        ? storeName
        : '$storeName ($storeCode)';

    return _InfoRow(
      icon: Icons.store_outlined,
      label: 'Store',
      value: storeValue,
    );
  }

  // ---------------------------------------------------------------------------
  // Audit approved date
  // ---------------------------------------------------------------------------

  Widget _buildApprovedDateRow() {
    return _InfoRow(
      icon: Icons.event_available_outlined,
      label: 'Audit Approved On',
      value: _displayValue(payment.auditApprovedOn),
    );
  }

  // ---------------------------------------------------------------------------
  // Amounts
  // ---------------------------------------------------------------------------

  Widget _buildAmountSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaymentColors.screenBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _AmountRow(
            label: 'Audit Amount',
            amount: payment.auditPrice,
          ),
          const SizedBox(height: 8),
          _AmountRow(
            label: 'Transaction Claim',
            amount: payment.transPrice,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(
              height: 1,
              color: PaymentColors.divider,
            ),
          ),
          _AmountRow(
            label: 'Total Amount',
            amount: payment.totalAmount,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  Widget _buildStatusSection(bool isPaid) {
    final Color statusColor = isPaid
        ? Colors.green
        : PaymentColors.shopperOrange;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 18,
              color: PaymentColors.secondaryText,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  color: PaymentColors.secondaryText,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _displayValue(payment.status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),

        if (isPaid && payment.amountPaidOn.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Paid On',
            value: payment.amountPaidOn,
          ),
        ],
      ],
    );
  }

  String _displayValue(String value) {
    final String trimmed = value.trim();

    return trimmed.isEmpty ? '-' : trimmed;
  }
}


// =============================================================================
// Information Row
// =============================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: PaymentColors.shopperBlue,
        ),
        const SizedBox(width: 9),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: PaymentColors.secondaryText,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: PaymentColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}


// =============================================================================
// Amount Row
// =============================================================================

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              fontWeight:
              isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? PaymentColors.primaryText
                  : PaymentColors.secondaryText,
            ),
          ),
        ),
        Text(
          _formatAmount(amount),
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight:
            isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? PaymentColors.shopperBlue
                : PaymentColors.primaryText,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return '₹ ${amount.toStringAsFixed(0)}';
    }
    return '₹ ${amount.toStringAsFixed(2)}';
  }
}