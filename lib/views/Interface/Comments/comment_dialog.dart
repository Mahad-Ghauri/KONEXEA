// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Feed%20Database/feed_services.dart';

class CommentDialog extends StatefulWidget {
  final String postId;
  final String posterUsername;

  const CommentDialog({
    Key? key,
    required this.postId,
    required this.posterUsername,
  }) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  Comment? _replyingTo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<FeedServices>(context, listen: false)
        .fetchComments(widget.postId);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _setReplyingTo(Comment? comment) {
    setState(() {
      _replyingTo = comment;
      if (comment != null) {
        // Focus the text field when replying
        FocusScope.of(context).requestFocus(FocusNode());
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    final feedService = Provider.of<FeedServices>(context, listen: false);

    final comment = await feedService.addComment(
      widget.postId,
      _commentController.text.trim(),
      parentId: _replyingTo?.id,
    );

    if (comment != null) {
      _commentController.clear();
      _setReplyingTo(null);
      HapticFeedback.mediumImpact();
    }
  }

  String _getUsername(String email) {
    return email.contains('@') ? email.split('@')[0] : email;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom app bar for bottom sheet
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    'Comments',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        // Reply indicator
        if (_replyingTo != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.urbanist(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Replying to '),
                        TextSpan(
                          text: _getUsername(_replyingTo!.userEmail),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _setReplyingTo(null),
                ),
              ],
            ),
          ),

        // Comments list
        Expanded(
          child: Consumer<FeedServices>(
            builder: (context, feedService, _) {
              if (_isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final comments = feedService.comments[widget.postId] ?? [];

              if (comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.message,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No comments yet',
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to comment on this post',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group comments by parent ID for threaded view
              final Map<String?, List<Comment>> groupedComments = {};

              // First, add all top-level comments (parentId is null)
              groupedComments[null] =
                  comments.where((c) => c.parentId == null).toList();

              // Then, group replies by their parent comment ID
              for (final comment in comments.where((c) => c.parentId != null)) {
                if (!groupedComments.containsKey(comment.parentId)) {
                  groupedComments[comment.parentId] = [];
                }
                groupedComments[comment.parentId]!.add(comment);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: groupedComments[null]?.length ?? 0,
                itemBuilder: (context, index) {
                  final comment = groupedComments[null]![index];
                  final replies = groupedComments[comment.id] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parent comment
                      _buildCommentTile(comment, feedService),

                      // Replies with indentation
                      if (replies.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            children: replies.map((reply) {
                              return _buildCommentTile(reply, feedService);
                            }).toList(),
                          ),
                        ),

                      const Divider(),
                    ],
                  );
                },
              );
            },
          ),
        ),

        // Comment input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: _replyingTo != null
                          ? 'Reply to ${_getUsername(_replyingTo!.userEmail)}...'
                          : 'Add a comment...',
                      hintStyle: GoogleFonts.urbanist(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.05),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    style: GoogleFonts.urbanist(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    maxLines: 4,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _submitComment,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(Comment comment, FeedServices feedService) {
    final isLiked = feedService.isCommentLikedByCurrentUser(comment);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and timestamp
                Row(
                  children: [
                    Text(
                      _getUsername(comment.userEmail),
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(comment.timestamp),
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Comment text
                Text(
                  comment.text,
                  style: GoogleFonts.urbanist(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 8),

                // Like and reply buttons
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await feedService.toggleLikeComment(comment);
                      },
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isLiked
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            comment.likes.length.toString(),
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _setReplyingTo(comment);
                      },
                      child: Text(
                        'Reply',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
