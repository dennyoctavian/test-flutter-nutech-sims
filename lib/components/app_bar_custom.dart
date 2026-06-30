import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims_denny/provider/bottom_navigation_bar_provider.dart';
import 'package:sims_denny/utils/shared.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarCustom(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: titleHeader,
      ),
      leading: SizedBox(
        child: InkWell(
          onTap: () {
            context.read<BottomNavigationBarProvider>().reset();
          },
          child: Row(
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Text(
                "Kembali",
                style: backHeader,
              ),
            ],
          ),
        ),
      ),
      leadingWidth: 120,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
