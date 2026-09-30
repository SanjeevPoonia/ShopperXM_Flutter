import 'package:flutter/material.dart';

import '../payment_colors.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.itemCount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.countLabel,
  });

  final String title;
  final double totalAmount;
  final int itemCount;
  final double paidAmount;
  final double pendingAmount;

  /// Label shown below the count.
  ///
  /// Earned tab:
  ///   Audit Count
  ///
  /// Transaction Claim tab:
  ///   Claim Count
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        6,
      ),
      decoration: BoxDecoration(
        color: PaymentColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 1),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: PaymentColors.primaryText,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    title: 'Total Amount',
                    value: _formatAmount(totalAmount),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryItem(
                    title: countLabel,
                    value: itemCount.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    title: 'Paid',
                    value: _formatAmount(paidAmount),
                    valueColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryItem(
                    title: 'Pending',
                    value: _formatAmount(pendingAmount),
                    valueColor: PaymentColors.shopperOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return '₹ ${amount.toStringAsFixed(0)}';
    }

    return '₹ ${amount.toStringAsFixed(2)}';
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: PaymentColors.screenBackground,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: PaymentColors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor ?? PaymentColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}