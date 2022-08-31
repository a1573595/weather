import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/edge_util.dart';

class DetailCard extends StatelessWidget {
  const DetailCard(this.color, this.icon, this.title, this.subtitle, {Key? key})
      : super(key: key);

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        alignment: Alignment.center,
        width: 140.0,
        height: 120.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: edgeUtil.cardPadding,
              child: Container(
                height: 5.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0), color: color),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(icon, color: color),
                SizedBox(width: 8.r),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ),
      ),
    );
  }
}
