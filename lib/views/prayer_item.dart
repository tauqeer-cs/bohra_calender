import 'package:flutter/material.dart';

import '../core/colors.dart';


class PrayerItem extends StatelessWidget {
  final String icon;
  final String time;
  final String name;
  final bool isNotificationOn;

  final VoidCallback onTap;

  const PrayerItem({
    Key? key,
    required this.icon,
    required this.time,
    required this.name,
    required this.onTap,
    this.isNotificationOn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/$icon.png",
                width: 24,
              ),

              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(name),
              ),
              //const Icon(Icons.notifications_off_outlined ),
              const SizedBox(
                width: 16,
              ),
              Text(
                time,
                style: const TextStyle(
                    fontFamily: 'Number',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 16,
              ),
              if (isNotificationOn) ...[
                GestureDetector(
                  onTap: onTap,
                  child: const ImageIcon(
                    AssetImage("assets/icons/bell_on.png"),
                    color: CColors.green_main,
                  ),
                ),
              ] else ...[
                GestureDetector(
                  onTap: onTap,
                  child: const ImageIcon(
                    AssetImage("assets/icons/bell-off.png"),
                    color: CColors.green_main,
                  ),
                ),
              ],
              const SizedBox(
                width: 4,
              ),
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
