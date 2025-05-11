// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:social_swap/Controllers/Services/Chat/chat_services.dart';

// class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? currentChatId;
//   final VoidCallback onBackPressed;

//   const ChatAppBar({
//     Key? key,
//     required this.currentChatId,
//     required this.onBackPressed,
//   }) : super(key: key);

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0.5,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       centerTitle: currentChatId != null,
//       title: _buildTitle(context),
//       leading: currentChatId != null
//           ? IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new),
//               onPressed: onBackPressed,
//             )
//           : null,
//       actions: [
//         if (currentChatId != null)
//           IconButton(
//             icon: const Icon(Iconsax.info_circle),
//             onPressed: () {
//               // Chat info functionality could be added here
//               HapticFeedback.lightImpact();
//             },
//           ),
//         if (currentChatId == null)
//           IconButton(
//             icon: const Icon(Iconsax.search_normal),
//             onPressed: () {
//               // Search functionality could be added here
//               HapticFeedback.lightImpact();
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildTitle(BuildContext context) {
//     if (currentChatId != null) {
//       return Consumer<ChatServices>(
//         builder: (context, chatServices, _) {
//           final chat = chatServices.chats.firstWhere(
//             (chat) => chat['chatId'] == currentChatId,
//             orElse: () => {'otherParticipantUsername': 'Chat'},
//           );

//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor:
//                     Theme.of(context).colorScheme.primary.withOpacity(0.2),
//                 child: Text(
//                   chat['otherParticipantUsername']?.toString().isNotEmpty ==
//                           true
//                       ? chat['otherParticipantUsername'][0].toUpperCase()
//                       : '?',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.primary,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     chat['otherParticipantUsername'] ?? 'Chat',
//                     style: GoogleFonts.urbanist(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Online',
//                         style: GoogleFonts.urbanist(
//                           fontSize: 12,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       return Row(
//         children: [
//           // Logo as an icon since we don't have the asset
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: Container(
//               height: 32,
//               width: 32,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.group,
//                 size: 20,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           Text(
//             'Chats',
//             style: GoogleFonts.urbanist(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
