import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/setting_provider.dart';
import 'package:my_voca/providers/auth_provider.dart';
import 'package:my_voca/views/login_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SwitchListTile(
                title: Text('알림 활성화'),
                value: settingProvider.setting.notificationEnabled,
                onChanged: (value) {
                  settingProvider.updateSetting(
                    value,
                    settingProvider.setting.notificationFrequency,
                  );
                },
              ),
              ListTile(
                title: Text('알림 주기'),
                subtitle: Text(settingProvider.setting.notificationFrequency),
                onTap: () {
                  _showFrequencyDialog(context);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await authProvider.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              icon: Icon(Icons.logout),
              label: Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFrequencyDialog(BuildContext context) {
    final settingProvider =
    Provider.of<SettingProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('알림 주기 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('30분'),
                onTap: () {
                  settingProvider.updateSetting(
                    settingProvider.setting.notificationEnabled,
                    '30min',
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('1시간'),
                onTap: () {
                  settingProvider.updateSetting(
                    settingProvider.setting.notificationEnabled,
                    '1hour',
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('3시간'),
                onTap: () {
                  settingProvider.updateSetting(
                    settingProvider.setting.notificationEnabled,
                    '3hours',
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
