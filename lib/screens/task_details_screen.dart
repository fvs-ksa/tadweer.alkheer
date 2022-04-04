//information about the delivery service and the whole information.
// need to change the widgets and the color of the page and everything.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/donation.dart';
import 'package:tadweer_alkheer/models/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/tasks_provider.dart';
import '../providers/donations_provider.dart';

import 'package:tadweer_alkheer/screens/map_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Donation donation;
  TaskDetailsScreen(this.donation, this.task);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isPickup = true;

  void _pickedupDelivered() async {
    final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
    final donationsProvider =
        Provider.of<DonationsProvider>(context, listen: false);
    try {
      tasksProvider.updateTask(
        Task(
            donationId: widget.task.donationId,
            driverId: widget.task.driverId,
            status: isPickup ? "Pickedup" : "Delivered"),
        widget.task.id,
      );

      //to update the status of that donation as well
      donationsProvider.updateDonation(
        Donation(
          category: widget.donation.category,
          date: widget.donation.date,
          description: widget.donation.description,
          imageUrl: widget.donation.imageUrl,
          location: widget.donation.location,
          name: widget.donation.name,
          pickupDateTime: widget.donation.pickupDateTime,
          quantity: widget.donation.quantity,
          userId: widget.donation.userId,
          status: isPickup ? "Picked up by Driver" : "Recieved",
        ),
        widget.donation.id,
      );

      Donation updatedDonation = Donation(
        id: widget.donation.id,
        category: widget.donation.category,
        date: widget.donation.date,
        description: widget.donation.description,
        imageUrl: widget.donation.imageUrl,
        location: widget.donation.location,
        name: widget.donation.name,
        pickupDateTime: widget.donation.pickupDateTime,
        quantity: widget.donation.quantity,
        userId: widget.donation.userId,
        status: isPickup ? "Picked up by Driver" : "Recieved",
      );
      Task updatedTask = Task(
          id: widget.task.id,
          donationId: widget.task.donationId,
          driverId: widget.task.driverId,
          status: isPickup ? "Pickedup" : "Delivered");

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => TaskDetailsScreen(updatedDonation, updatedTask),
      ));
    } catch (error) {
      print('error$error');
    }
  }

  void _goToMap() {}

  @override
  Widget build(BuildContext context) {
    var detailsList = [
      {
        'name': AppLocalizations.of(context).pickupdate,
        'value':
            DateFormat('dd/MM/yyyy').format(widget.donation.date).toString()
      },
      {
        'name': AppLocalizations.of(context).pickuptime,
        'value': DateFormat('HH:mm').format(widget.donation.date).toString()
      },
      {
        'name': AppLocalizations.of(context).itemdescription,
        'value': widget.donation.description
      },
      {
        'name': AppLocalizations.of(context).pickupaddress,
        'value': widget.donation.location.address
      },
      {'name': AppLocalizations.of(context).staus, 'value': widget.task.status},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).mytasks),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 80,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                            Text(widget.donation.name),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.grey.shade700,
                              ),
                              label: Text(
                                AppLocalizations.of(context).checklocation,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (ctx) => MapScreen(
                                      initialLocation: widget.donation.location,
                                      isSelecting: false,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.donation.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card(
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         width: MediaQuery.of(context).size.width * 0.4,
            //         height: MediaQuery.of(context).size.height * 0.2,
            //         padding: EdgeInsets.all(10),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(10),
            //           child: Image.network(
            //             widget.donation.imageUrl,
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //       ),
            //       Text(widget.donation.name)
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       FlatButton.icon(
            //         icon: Icon(
            //           Icons.location_on,
            //           color: Colors.grey.shade700,
            //         ),
            //         label: Text(
            //           AppLocalizations.of(context).checklocation,
            //           style: TextStyle(color: Colors.grey.shade700),
            //         ),
            //         onPressed: () {

            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               fullscreenDialog: true,
            //               builder: (ctx) => MapScreen(
            //                 initialLocation: widget.donation.location,
            //                 isSelecting: false,
            //               ),
            //             ),
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: detailsList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 1),
                    // ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          detailsList[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(child: Text(detailsList[index]['value'], style: Theme.of(context).textTheme.bodyText1,))
                      ],
                    ),
                  );
                },
              ),
            ),
            if (widget.task.status == "Ongoing")
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton.icon(
                  onPressed: () {
                    isPickup = true;
                    _pickedupDelivered();
                  },
                  icon: Icon(Icons.local_shipping),
                  label: Text(AppLocalizations.of(context).pickedup),
                ),
              ),
            if (widget.task.status == "Pickedup")
              Container(
                //height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.only(bottom: 110),
                child: ElevatedButton.icon(
                  onPressed: () {
                    isPickup = false;
                    _pickedupDelivered();
                  },
                  icon: Icon(Icons.all_inbox),
                  label: Text(AppLocalizations.of(context).delivered),
                ),
              ),
            if (widget.task.status == "Delivered")
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.only(bottom: 110),
                child: Text(
                  AppLocalizations.of(context).deliveredcontent,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (widget.task.status == "Completed")
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.only(bottom: 110),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (widget.task.status == "Cancelled")
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.only(bottom: 110),
                child: Text(
                  'Cancelled',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
