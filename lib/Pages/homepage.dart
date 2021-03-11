import 'package:flutter/material.dart';
import '../Widgets/navigation_bloc.dart';

// import 'package:flutter/material.dart';
import '/services/network_status_service.dart';
// import '/Widgets/network_aware_widget.dart';
import 'package:provider/provider.dart';

// class HomePage extends StatelessWidget with NavigationStates {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Network Aware App"),
//       ),
//       body: StreamProvider<NetworkStatus>(
//         create: (context) =>
//             NetworkStatusService().networkStatusController.stream,
//         child: NetworkAwareWidget(
//           onlineChild: Container(
//             child: Center(
//               child: Text(
//                 "I am online",
//                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//           offlineChild: Container(
//             child: Center(
//               child: Text(
//                 "No internet connection!",
//                 style: TextStyle(
//                     color: Colors.grey[400],
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20.0),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class HomePage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Bienvenido",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
