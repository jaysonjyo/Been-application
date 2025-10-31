import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String message, {bool success = false, bool warning = false}) async {
  await Fluttertoast.cancel(); // avoid overlapping toasts

  Color bgColor;

  if (warning) {
    bgColor = Colors.orange.shade600;
  } else if (success) {
    bgColor = Colors.green.shade600;
  } else {
    bgColor = Colors.red.shade600;
  }

  Fluttertoast.showToast(
    msg: " ${String.fromCharCode(0x2022)} $message", // adds a clean bullet prefix
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: bgColor,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}


//  if (provider.error != null)
//               Expanded(
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.wifi_off,
//                             color: Colors.grey, size: 60),
//                         const SizedBox(height: 16),
//                         Text(
//                           "Unable to load data.\nPlease check your connection or try again later.",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             context
//                                 .read<PersonnelProvider>()
//                                 .fetchPersonnel(widget.token);
//                           },
//                           icon: const Icon(Icons.refresh),
//                           label: const Text("Retry"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber,
//                             foregroundColor: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             else if (personnelList.isEmpty && ! provider.loading)
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     'No person found.',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               )
//             else