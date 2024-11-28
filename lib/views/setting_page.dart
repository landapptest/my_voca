import 'package:flutter/material.dart';
import 'package:my_voca/models/setting_model.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/setting_provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Column(
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
