import 'package:flutter/material.dart';

class FreelancerAuditCard extends StatelessWidget {
  final Map<String, dynamic> audit;

  final VoidCallback onViewMap;
  final VoidCallback onSelfAssign;

  final String Function(String value) formatAuditDate;

  const FreelancerAuditCard({
    super.key,
    required this.audit,
    required this.onViewMap,
    required this.onSelfAssign,
    required this.formatAuditDate,
  });

  String _value(String key) {
    final value = audit[key];

    if (value == null) {
      return '';
    }

    final result = value.toString().trim();

    if (result.toLowerCase() == 'null') {
      return '';
    }

    return result;
  }

  String _displayValue(
      String key, {
        String fallback = '-',
      }) {
    final value = _value(key);

    return value.isEmpty ? fallback : value;
  }

  bool _isTrueValue(String key) {
    final value = audit[key];

    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    return value.toString() == '1' ||
        value.toString().toLowerCase() == 'true';
  }

  @override
  Widget build(BuildContext context) {
    final String companyName =
    _displayValue('company_name');

    final String storeName =
    _displayValue('store_name');

    final String storeAddress =
    _displayValue('store_address');

    final String auditDate =
    _value('audit_date');

    final String auditDuration =
    _displayValue(
      'audit_expiry',
      fallback: '-',
    );

    final String price =
    _displayValue('price');

    final String bonus =
    _displayValue('bonus');

    final String distance =
    _displayValue('distance');

    final bool showPrice =
    _isTrueValue('show_price');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // COMPANY / CLIENT
            // --------------------------------------------------

            _buildLabelValue(
              label: 'Client / Company',
              value: companyName,
            ),

            const SizedBox(height: 10),

            // --------------------------------------------------
            // STORE
            // --------------------------------------------------

            _buildLabelValue(
              label: 'Store',
              value: storeName,
            ),

            const SizedBox(height: 10),

            // --------------------------------------------------
            // ADDRESS
            // --------------------------------------------------

            _buildLabelValue(
              label: 'Address',
              value: storeAddress,
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // DATE / DURATION
            // --------------------------------------------------

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildLabelValue(
                    label: 'Audit Date',
                    value: auditDate.isEmpty
                        ? '-'
                        : formatAuditDate(
                      auditDate,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLabelValue(
                    label: 'Audit Duration',
                    value: auditDuration,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // PAYOUT / BONUS / DISTANCE
            // --------------------------------------------------

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                if (showPrice)
                  Expanded(
                    child: _buildLabelValue(
                      label: 'Payout',
                      value: price,
                    ),
                  ),

                if (showPrice)
                  const SizedBox(width: 12),

                Expanded(
                  child: _buildLabelValue(
                    label: 'Bonus',
                    value: bonus,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildLabelValue(
                    label: 'Distance',
                    value: '$distance Km',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(
              height: 1,
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // ACTION BUTTONS
            // --------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: _buildViewMapButton(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSelfAssignButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValue({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildViewMapButton() {
    return SizedBox(
      height: 42,
      child: OutlinedButton.icon(
        onPressed: onViewMap,
        style: OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xFF00407E),
          side: const BorderSide(
            color: Color(0xFF00407E),
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(7),
          ),
        ),
        icon: Image.asset(
          'assets/map_blue.png',
          width: 21,
          height: 21,
        ),
        label: const Text(
          'View Map',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSelfAssignButton() {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onSelfAssign,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF00407E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(7),
          ),
        ),
        icon: Image.asset(
          'assets/assign2.png',
          width: 21,
          height: 21,
        ),
        label: const Text(
          'Self Assign',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}