import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/navigation_bloc.dart';
import 'package:tripcompanion/models/user.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_flat_icon_button.dart';

class NavigationDrawer extends StatelessWidget {
  Future<void> signOutUser(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e);
    }
  }

  void _navigateTo(Navigation screen, BuildContext context) {
    var navigationBloc = Provider.of<NavigationBloc>(context, listen: false);
    navigationBloc.navigate(Navigation.FRIENDS);
  }

  Widget _buildUserDetailsImage(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Column(
            // User Image
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (user.imageUrl.isEmpty)
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red[600],
                          ),
                          color: Colors.red),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            user.displayName[0].toUpperCase(),
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              CircularProgressIndicator(
                            value: progress.progress,
                          ),
                          imageUrl: user.imageUrl,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                //User display name
                children: <Widget>[
                  Text(
                    user.displayName,
                    style: TextStyle(
                      color: Color.fromARGB(200, 0, 0, 0),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                //User email
                children: <Widget>[
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Color.fromARGB(125, 0, 0, 0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    return Drawer(
      elevation: 2.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              _buildUserDetailsImage(user),
              SizedBox(
                height: 20,
              ),
              Divider(),
              CustomFlatIconButton(
                iconData: Icons.home,
                text: 'Home',
                textColor: Colors.black54,
                iconColor: Colors.black54,
                color: Colors.transparent,
                onTapped: () async {
                  Navigator.pop(context);
                  _navigateTo(Navigation.HOME, context);
                },
              ),
              CustomFlatIconButton(
                iconData: Icons.people,
                text: 'Friends',
                textColor: Colors.black54,
                iconColor: Colors.black54,
                color: Colors.transparent,
                onTapped: () async {
                  Navigator.pop(context);
                  _navigateTo(Navigation.FRIENDS, context);
                },
              ),
              CustomFlatIconButton(
                iconData: Icons.event,
                text: 'Events',
                textColor: Colors.black54,
                iconColor: Colors.black54,
                color: Colors.transparent,
                onTapped: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Divider(),
              CustomFlatIconButton(
                iconData: Icons.settings,
                text: 'Settings',
                textColor: Colors.black54,
                iconColor: Colors.black54,
                color: Colors.transparent,
                onTapped: () async {
                  Navigator.pop(context);
                },
              ),
              CustomFlatIconButton(
                iconData: Icons.exit_to_app,
                text: 'Log Out',
                textColor: Colors.black54,
                iconColor: Colors.black54,
                color: Colors.transparent,
                onTapped: () async {
                  Navigator.pop(context);
                  await signOutUser(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
