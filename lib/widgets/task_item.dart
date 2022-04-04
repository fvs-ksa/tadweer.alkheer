import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/donation.dart';
import 'package:tadweer_alkheer/models/task.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/providers/donations_provider.dart';
import 'package:intl/intl.dart';
import 'package:tadweer_alkheer/screens/task_details_screen.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  TaskItem(this.task);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Donation donation;

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationsProvider>(context);

    return FutureBuilder(
        future: donationProvider.getDonationById(widget.task.donationId),
        builder: (ctx, donationSnapshot) {
          if (donationSnapshot.connectionState == ConnectionState.waiting) {
            return Center();
          }

          if (donationSnapshot.hasData) {
            donation = donationSnapshot.data;

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => TaskDetailsScreen(donation, widget.task),
                ));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    padding: EdgeInsets.all(10),
                    //height: MediaQuery.of(context).size.height * 0.12,
                    child: ListTile(
                      leading: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            donation.imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      title: Text(
                        donation.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        'Pickup Date:' +
                            DateFormat('dd/MM/yyyy, HH:mm')
                                .format(donation.pickupDateTime),
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            );

            // return Container(
            //   padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //   decoration: BoxDecoration(
            //       border: Border.all(
            //         width: 1,
            //         color: Colors.grey,
            //       ),
            //       borderRadius: BorderRadius.circular(15)),
            //   child: Column(children: <Widget>[
            //     ListTile(
            //       leading: CircleAvatar(
            //         radius: 40,
            //         backgroundColor: Colors.grey,
            //         backgroundImage: donation.imageUrl != null
            //             ? NetworkImage(donation.imageUrl)
            //             : null,
            //       ),
            //       subtitle: Text(DateFormat('dd/MM/yyyy, HH:mm')
            //           .format(donation.pickupDateTime)),
            //       title: Text(donation.location.address),
            //       trailing: IconButton(
            //         onPressed: donation.location == null
            //             ? null
            //             : () {
            //                 Navigator.of(context).push(
            //                   MaterialPageRoute(
            //                     fullscreenDialog: true,
            //                     builder: (ctx) => MapScreen(
            //                       initialLocation: donation.location,
            //                       isSelecting: false,
            //                     ),
            //                   ),
            //                 );
            //               },
            //         icon: Icon(Icons.place),
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //     SizedBox(
            //       height: 10,
            //     ),
            // if (widget.task.status == "ongoing")
            //   ElevatedButton.icon(
            //     onPressed: () {
            //       isPickup = true;
            //       _pickedupDelivered();
            //     },
            //     icon: Icon(Icons.local_shipping),
            //     label: Text(AppLocalizations.of(context).pickedup),
            //   ),
            // if (widget.task.status == "pickedup")
            //   ElevatedButton.icon(
            //     onPressed: () {
            //       isPickup = false;
            //       _pickedupDelivered();
            //     },
            //     icon: Icon(Icons.all_inbox),
            //     label: Text(AppLocalizations.of(context).delivered),
            //   ),
            // if (widget.task.status == "delivered")
            //   Container(
            //     width: MediaQuery.of(context).size.width * 0.4,
            //     child: Text(
            //       'Delivered! Waiting for confirmation of complition.',
            //       style: TextStyle(color: Theme.of(context).primaryColor),
            //       textAlign: TextAlign.center,
            //     ),
            //   )
            //   ]),
            // );
          }

          return Center();
        });
  }
}
