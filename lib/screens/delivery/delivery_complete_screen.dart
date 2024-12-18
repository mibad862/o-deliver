import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/values/app_colors.dart';

class DeliveryCompleteScreen extends StatelessWidget {
  const DeliveryCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Task'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     context.goNamed('/deliveryDetailScreen');
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Address Section
            const Text(
              'RECIPIENT ADDRESS',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nemanja Bjelica',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              '338 Main Street\nSan Francisco, United States 94105',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Task Completed Section
            const Text(
              'TASK COMPLETED',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Success/Failure Options
            Row(
              children: [
                // Success Option
                const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('Success'),
                  ],
                ),
                const Spacer(),
                // Failure Option
                GestureDetector(
                  onTap: () {
                    // Open failure reasons dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FailureReasonDialog();
                      },
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text('Failure...'),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.check, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            // Attachments Section
            const Text(
              'ATTACHMENTS',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentIcon(Icons.camera_alt, 'Photo'),
                _buildAttachmentIcon(Icons.qr_code, 'Barcode'),
                _buildAttachmentIcon(Icons.edit, 'Signature'),
                _buildAttachmentIcon(Icons.verified_user, 'Verify Age'),
              ],
            ),
            const Spacer(),
            // Complete with Success Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Complete with success functionality
                  context.go('/mainScreen');

                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.appThemeColor,
                ),
                child: const Text(
                  'Complete with Success',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create the attachment icons
  Widget _buildAttachmentIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.grey),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Failure Reason Dialog
class FailureReasonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Failure Reason'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Recipient not available'),
            onTap: () {
              // Handle this failure reason
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Wrong address'),
            onTap: () {
              // Handle this failure reason
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Package damaged'),
            onTap: () {
              // Handle this failure reason
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Other reasons'),
            onTap: () {
              // Handle this failure reason
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}


