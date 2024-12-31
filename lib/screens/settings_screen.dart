import 'package:flutter/material.dart';
import 'package:o_deliver/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _orderUpdatesEnabled = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            title: const Text('John Doe'),
            subtitle: const Text('johndoe@example.com'),
            trailing: const Icon(Icons.edit),
            onTap: () {
            },
          ),
          const Divider(),

          // Account Settings
          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.lock),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),

          const Divider(),

          // Notifications
          SwitchListTile(
            title: const Text('Order Updates'),
            value: _orderUpdatesEnabled,
            onChanged: (bool value) {
              setState(() {
                _orderUpdatesEnabled = value;

              });
            },
            secondary: const Icon(Icons.notifications),
          ),

          const Divider(),


          ListTile(
            title: const Text('Terms & Conditions'),
            leading: const Icon(Icons.description),
            onTap: () {
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Contact Support'),
            leading: const Icon(Icons.support_agent),
            onTap: () {
            },
          ),
          ListTile(
            title: const Text('FAQs'),
            leading: const Icon(Icons.help_outline),
            onTap: () {
              // Show FAQs
            },
          ),
          const Divider(),


          const ListTile(
            title: Text('App Version'),
            leading: Icon(Icons.info),
            subtitle: Text('1.0.0'),
          ),

          const Divider(),

          Consumer<SettingsProvider>(
            builder: (context, provider, child){
              return ListTile(
                onTap: (){
                  provider.logoutUser(context);
                  // context.go("/signIn");
                },
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
              );
            },
          ),

        ],
      ),
    );
  }
}
