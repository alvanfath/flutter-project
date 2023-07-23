import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihanpost/page/profile/profile_bloc.dart';
import 'package:latihanpost/page/profile/update_profile/update_bloc.dart';
import 'package:latihanpost/page/profile/update_profile/update_event.dart';
import 'package:latihanpost/page/profile/update_profile/update_state.dart';

import '../../services/api_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Profil bro'),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UserProfileBloc>(
            create: (context) => UserProfileBloc(ApiServices())
              ..add(
                FetchUserProfileEvent(),
              ),
          ),
          BlocProvider<UpdateProfileBloc>(
            create: (context) => UpdateProfileBloc(ApiServices()),
          ),
        ],
        child: BodyContent(),
      ),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProfileBloc>(context).add(FetchUserProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: ((context, state) {
        if (state is LoadingUserProfileState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedUserProfileState) {
          final user = state.userProfile;
          _nameController.text = user['name'];
          _emailController.text = user['email'];
          return Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formControl(context, 'Name', _nameController),
                  SizedBox(height: 16),
                  formControl(context, 'Email', _emailController),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<UpdateProfileBloc>(context).add(
                        UpdateButtonPressed(
                          name: _nameController.text,
                          email: _emailController.text,
                        ),
                      );
                    },
                    child: Text('Save'),
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                    builder: (context, updateState) {
                      if (updateState is UpdatingProfileState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (updateState is UpdatedProfileState) {
                        return alert(context, updateState.message as String,
                            Colors.green);
                      } else if (updateState is UpdateProfileStateError) {
                        // print(updateState.errorMessage);
                        return Column(
                          children: [
                            for (var error in updateState.errorMessage.values)
                              alert(context, error[0].toString(), Colors.red)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is ErrorUserProfileState) {
          return Text(state.errorMessage);
        }
        return Container();
      }),
    );
  }
}

Widget formControl(
    BuildContext context, String label, TextEditingController _controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 4),
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: _controller,
      ),
    ],
  );
}

Widget alert(BuildContext context, String message, Color bgColor) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: bgColor)),
    child: Text(
      message,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
  );
}
