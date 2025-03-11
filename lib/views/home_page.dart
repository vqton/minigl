import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/blocs/transaction/transaction_bloc.dart';
import 'package:minigl/blocs/transaction/transaction_state.dart';
import 'package:minigl/views/add_transaction_page.dart';
import 'package:minigl/widgets/balance_card.dart';
import 'package:minigl/widgets/transaction_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        title: Text(
          'My Finances',
          style: TextStyle(color: Colors.white), // White text
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white), // White icon
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white), // White icon
            onPressed: () {
              // Handle profile
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.orange)); // Orange loading indicator
          }
          if (state is TransactionLoaded) {
            return Column(
              children: [
                // Welcome Message
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, User!', // Replace with dynamic user name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Here\'s your financial overview for today.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Balance Card
                BalanceCard(balance: state.balance),
                // Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('Income', '\$5,000', Colors.green), // Replace with dynamic data
                      _buildStatItem('Expenses', '\$3,200', Colors.red), // Replace with dynamic data
                      _buildStatItem('Savings', '\$1,800', Colors.green), // Replace with dynamic data
                    ],
                  ),
                ),
                // Recent Transactions Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all transactions
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                // Transaction List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionListItem(
                        transaction: state.transactions[index],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransactionPage()),
        ),
        backgroundColor: Colors.orange, // Orange FAB
        child: Icon(Icons.add, color: Colors.white), // White icon
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Black background
        selectedItemColor: Colors.orange, // Orange selected item
        unselectedItemColor: Colors.white, // White unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  // Helper method to build quick stat items
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}