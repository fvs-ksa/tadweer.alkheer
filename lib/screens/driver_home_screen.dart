// Driver home page
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/task.dart';
import 'package:tadweer_alkheer/models/user.dart' as TKDUser;
import 'package:tadweer_alkheer/providers/users_provider.dart';
import '../providers/tasks_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriverHomeScreen extends StatelessWidget {
  List<dynamic> tasks;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final userProvider = Provider.of<UsersProvider>(context);
    List<dynamic> newTasks;
    List<dynamic> completed;
    List<dynamic> cancelled;
    User user;
    return Scaffold(
      body: FutureBuilder(
                future: userProvider.getUserById(FirebaseAuth.instance.currentUser.uid),
                builder: (ctx, userData) {
                  if (userData.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  user = userData.data;

                  return StreamBuilder(
                    stream:
                        tasksProvider.fetchTasksAsStream(FirebaseAuth.instance.currentUser.uid),
                    builder: (ctx, tasksSnapshot) {
                      if (tasksSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (tasksSnapshot.hasData) {
                        tasks = tasksSnapshot.data.documents
                            .map(
                                (doc) => Task.fromMap(doc.data, doc.documentID))
                            .toList();
                        newTasks = tasks
                            .where(
                              (element) =>
                                  element.status == "Ongoing" ||
                                  element.status == "Pickedup" ||
                                  element.status == "Delivered",
                            )
                            .toList();
                        completed = tasks
                            .where(
                              (element) => element.status == "Completed",
                            )
                            .toList();
                        cancelled = tasks
                            .where(
                              (element) => element.status == "Cancelled",
                            )
                            .toList();

                        List<Map<String, Object>> _groups = [
                          {
                            "name": AppLocalizations.of(context).currenttasks,
                            "number": newTasks.length,
                            "color": Colors.grey
                          },
                          {
                            "name": AppLocalizations.of(context).completedtasks,
                            "number": completed.length,
                            "color": Colors.blue[800],
                          },
                          {
                            "name": AppLocalizations.of(context).cancelledtasks,
                            "number": cancelled.length,
                            "color": Colors.yellow
                          },
                          {
                            "name": AppLocalizations.of(context).alltasks,
                            "number": tasks.length,
                            "color": Colors.lightGreen.shade900,
                          }
                        ];
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                margin: EdgeInsets.all(10),
                                child: Container(
                                  //color: Theme.of(context).primaryColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).primaryColor),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.displayName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: user.photoURL != null
                                            ? NetworkImage(user.photoURL)
                                            : AssetImage(
                                                'assets/images/profile.jpg'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.all(12),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20,
                                ),
                                //reverse: true,
                                itemCount: _groups.length,
                                itemBuilder: (ctx, index) => Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GridTile(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.of(context).pushNamed(
                                          //   AddDonationScreen.routeName,
                                          //   arguments: categories[index].name,
                                          // );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          color: _groups[index]['color'],
                                          child: Center(
                                            child: Text(
                                              _groups[index]['number']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      footer: GridTileBar(
                                        backgroundColor: _groups[index]
                                            ['color'],
                                        title: Text(
                                          _groups[index]['name'],
                                          style: TextStyle(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                })

    );
  }
}
