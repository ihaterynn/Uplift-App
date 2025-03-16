import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Incoming", "Outgoing"];
  
  // Mock transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      "title": "Payment Received",
      "subtitle": "From David Wilson",
      "amount": "\$120.00",
      "isIncoming": true,
      "date": "Mar 8, 2025",
      "time": "2:45 PM",
    },
    {
      "title": "Withdrawal",
      "subtitle": "To Bank Account ****1234",
      "amount": "\$500.00",
      "isIncoming": false,
      "date": "Mar 5, 2025",
      "time": "11:30 AM",
    },
    {
      "title": "Payment Received",
      "subtitle": "From Sarah Johnson",
      "amount": "\$85.50",
      "isIncoming": true,
      "date": "Mar 1, 2025",
      "time": "4:15 PM",
    },
    {
      "title": "Deposit",
      "subtitle": "From Credit Card ****5678",
      "amount": "\$1000.00",
      "isIncoming": true,
      "date": "Feb 28, 2025",
      "time": "10:20 AM",
    },
    {
      "title": "Payment Received",
      "subtitle": "From Michael Brown",
      "amount": "\$250.00",
      "isIncoming": true,
      "date": "Feb 25, 2025",
      "time": "3:30 PM",
    },
    {
      "title": "Withdrawal",
      "subtitle": "To Bank Account ****1234",
      "amount": "\$700.00",
      "isIncoming": false,
      "date": "Feb 20, 2025",
      "time": "9:15 AM",
    },
    {
      "title": "Payment Received",
      "subtitle": "From Emma Davis",
      "amount": "\$150.00",
      "isIncoming": true,
      "date": "Feb 18, 2025",
      "time": "5:45 PM",
    },
    {
      "title": "Deposit",
      "subtitle": "From Bank Account ****9876",
      "amount": "\$500.00",
      "isIncoming": true,
      "date": "Feb 15, 2025",
      "time": "1:20 PM",
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (_selectedFilter == "All") return _transactions;
    return _transactions.where((tx) => 
      (_selectedFilter == "Incoming" && tx["isIncoming"]) || 
      (_selectedFilter == "Outgoing" && !tx["isIncoming"])
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: const Color(0xFF4ECDC4).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[800],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Transactions list
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No transactions found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];
                      return _buildTransactionItem(
                        tx["title"],
                        tx["subtitle"],
                        tx["amount"],
                        tx["isIncoming"],
                        tx["date"],
                        tx["time"],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionItem(
    String title,
    String subtitle,
    String amount,
    bool isIncoming,
    String date,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isIncoming ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncoming ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isIncoming ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),  // Just for spacing
              Text(
                "$date · $time",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}