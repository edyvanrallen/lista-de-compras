import 'package:bd_app/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  List<Map<String, dynamic>> _users = [];

  final _userBox = Hive.box('user_box');

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  //void validateUser() {
  //  final usesrAccess = _users;
  //  if()
//  }

  void _refreshUser() {
    final data = _userBox.keys.map((key) {
      final value = _userBox.get(key);
      return {"key": key, "email": value["email"], "pass": value['pass']};
    }).toList();

    setState(() {
      _users = data.reversed.toList();
    });
  }

  Future<void> _createUser(Map<String, dynamic> newUser) async {
    await _userBox.add(newUser);
    _refreshUser();
  }

  Map<String, dynamic> _readUser(int key) {
    final user = _userBox.get(key);
    return user;
  }

  Future<void> _updateUser(int userKey, Map<String, dynamic> user) async {
    await _userBox.put(userKey, user);
    _refreshUser();
  }

  Future<void> _deleteUser(int userKey) async {
    await _userBox.delete(userKey);
    _refreshUser();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  void verify(BuildContext context) async {
    if (_emailController.text == _userBox.get(0)["email"].toString() &&
        _passController.text == _userBox.get(0)['pass'].toString()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('E-mail e senha incorretos. Tente novamente')));
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _showForm(BuildContext ctx, int? uesrKey) async {
// itemKey == null -> create new item
// itemKey != null -> update an existing item

    if (uesrKey != null) {
      final existingItem =
          _users.firstWhere((element) => element['key'] == uesrKey);
      _emailController.text = existingItem['email'];
      _passController.text = existingItem['pass'];
    }
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Senha'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (uesrKey == null) {
                          _createUser({
                            "email": _emailController.text,
                            "pass": _passController.text
                          });
                        }
                        if (uesrKey != null) {
                          _updateUser(uesrKey, {
                            'email': _emailController.text.trim(),
                            'pass': _passController.text.trim()
                          });
                        }

                        _emailController.text = '';
                        _passController.text = '';

                        Navigator.of(context).pop();
                      },
                      child: Text(uesrKey == null ? 'Cadastrar' : 'Update'),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'E-mail'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Senha'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                verify(context);

                _emailController.text = '';
                _passController.text = '';
              },
              child: Text('Login'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
//Scaffold(
  //    appBar: AppBar(
    //    title: const Text('Login'),
      //),
     // body: _users.isEmpty
     //     ? const Center(
     //         child: Text(
      //          'No user',
      //          style: TextStyle(fontSize: 30),
      //        ),
       //     )
        //  : ListView.builder(
         //     itemCount: _users.length,
          //    itemBuilder: (_, index) {
        //        final currentUser = _users[index];
        //        return Card(
         //         color: Colors.orange.shade100,
          //        margin: EdgeInsets.all(10),
           //       elevation: 3,
            //      child: ListTile(
             //         title: Text(currentUser['email']),
              //        subtitle: Text(currentUser['pass'].toString()),
               //       trailing: Row(
                //        mainAxisSize: MainAxisSize.min,
                 //       children: [
                  //        IconButton(
                   //           icon: const Icon(Icons.edit),
                    //          onPressed: () =>
                     //             _showForm(context, currentUser['key'])),
                      //    IconButton(
                //            icon: const Icon(Icons.delete),
                 //           onPressed: () => _deleteUser(currentUser['key']),
                  //        ),
                   //     ],
                    //  )),
  //              );
   //           }),
    //  floatingActionButton: FloatingActionButton(
     ///   onPressed: () => _showForm(context, null),
  //      child: const Icon(Icons.add),
   //   ),
  //  );