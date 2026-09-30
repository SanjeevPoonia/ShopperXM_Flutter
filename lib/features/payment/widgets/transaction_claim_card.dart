import 'package:flutter/material.dart';

import '../models/transaction_claim_model.dart';
import '../payment_colors.dart';

class TransactionClaimCard extends StatelessWidget {
  const TransactionClaimCard({
    super.key,
    required this.transaction,
  });

  final TransactionClaimModel transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      elevation: 2,
      color: PaymentColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'Client',
                  value: _displayValue(transaction.client),
                ),

                const SizedBox(height: 10),

                _InfoRow(
                  label: 'Store',
                  value: _storeDisplayValue(),
                ),

                const SizedBox(height: 10),

                _InfoRow(
                  label: 'Audit Approved On',
                  value: _displayValue(transaction.auditApprovedOn),
                ),

                const SizedBox(height: 12),

                _buildTransactionAmount(),

                const SizedBox(height: 12),

                _buildStatus(),

                if (transaction.isPaid &&
                    transaction.amountPaidOn.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                    label: 'Paid On',
                    value: transaction.amountPaidOn.trim(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      color: PaymentColors.shopperBlue,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.currency_rupee,
              color: PaymentColors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Trans. Claim',
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

  Widget _buildTransactionAmount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: PaymentColors.screenBackground,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Transaction Amount',
              style: TextStyle(
                color: PaymentColors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatAmount(transaction.transPrice),
            style: const TextStyle(
              color: PaymentColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    final bool isPaid = transaction.isPaid;

    final Color statusColor =
    isPaid ? Colors.green : PaymentColors.shopperOrange;

    return Row(
      children: [
        const Text(
          'Status',
          style: TextStyle(
            color: PaymentColors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
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
            _displayValue(transaction.status),
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _storeDisplayValue() {
    final String storeName = transaction.storeName.trim();
    final String storeCode = transaction.storeCode.trim();

    if (storeName.isEmpty && storeCode.isEmpty) {
      return '-';
    }

    if (storeName.isEmpty) {
      return storeCode;
    }

    if (storeCode.isEmpty) {
      return storeName;
    }

    return '$storeName ($storeCode)';
  }

  String _displayValue(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty ? '-' : trimmed;
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return '₹ ${amount.toStringAsFixed(0)}';
    }

    return '₹ ${amount.toStringAsFixed(2)}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: const TextStyle(
              color: PaymentColors.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: PaymentColors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}