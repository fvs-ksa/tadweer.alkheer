import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/providers/tasks_provider.dart';
import 'package:tadweer_alkheer/widgets/task_item.dart';
import '../widgets/empty_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class MyTasksScreen extends StatelessWidget {
  List<dynamic> tasks;
  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    return Scaffold(
      body: StreamBuilder(
            stream: tasksProvider
                .fetchTasksAsStream(FirebaseAuth.instance.currentUser.uid),
            builder: (ctx, donationsSnapshot) {
              if (donationsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (donationsSnapshot.hasData) {
                tasks = donationsSnapshot.data.documents
                    .map((doc) => Task.fromMap(doc.data, doc.documentID))
                    .toList();

                var notCompletedOrCancelled = tasks
                            .where(
                              (element) => element.status != "Completed" && element.status != "Cancelled",
                            )
                            .toList();
                print(tasks);
                return tasks.isEmpty
                    ? EmptyList(false)
                    : Container(
                      padding: EdgeInsets.only(top: 30,right: 10),
                      child: ListView.builder(
                          itemCount: notCompletedOrCancelled.length,
                          itemBuilder: (buildContext, index) {
                            return Container(
                              child: TaskItem(notCompletedOrCancelled[index]),
                            );
                          },
                        ),
                    );
              }

              return CircularProgressIndicator();
            },
          )

    );
  }
}
