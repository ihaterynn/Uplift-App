import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpliftAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final bool showBackButton;
  final List<Widget>? additionalActions;
  final PreferredSizeWidget? bottom;
 
  const UpliftAppBar({
    Key? key,
    this.showLogo = true,
    this.showBackButton = false,
    this.additionalActions,
    this.bottom,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: showBackButton ? BackButton(color: Colors.black) : null,
      title: showLogo ? buildLogo() : null,
      actions: [
        ...(additionalActions ?? []),
        // Wallet Icon
        IconButton(
          icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.grey[800]),
          onPressed: () {
            Navigator.pushNamed(context, '/wallet');
          },
        ),
        // Notifications Icon
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.grey[800]),
          onPressed: () {
            // Navigate to notifications
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        // Profile Icon
        IconButton(
          icon: Icon(Icons.person_outline, color: Colors.grey[800]),
          onPressed: () {
            // Navigate to profile
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
      bottom: bottom,
    );
  }
 
  Widget buildLogo() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: "Up",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          WidgetSpan(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF56E39F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: const Text(
                "l",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const TextSpan(
            text: "ift",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
 
  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight);
}