import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/data/models/review.dart';
import 'package:sibaha_app/presentation/blocs/review_bloc/review_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class ReviewList extends StatelessWidget {
  final int academyId;
  final String academyName;

  const ReviewList({
    super.key,
    required this.academyId,
    required this.academyName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listenWhen: (_, s) => s is ReviewSubmitted || s is ReviewFailed,
      listener: (context, state) {
        if (state is ReviewFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: const Text(
            'Review academy',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            final reviews = _reviewsFromState(state);
            final isLoading =
                state is ReviewLoading || state is ReviewSubmitting;

            return Column(
              children: [
                _Header(
                    academyName: academyName, reviews: reviews),
                Expanded(
                  child: isLoading && reviews.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : reviews.isEmpty
                          ? const Center(
                              child: Text('No reviews yet. Be the first!',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) =>
                                  _ReviewItem(review: reviews[index]),
                            ),
                ),
                _AddReviewButton(academyId: academyId),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Review> _reviewsFromState(ReviewState state) {
    if (state is ReviewLoaded) return state.reviews;
    if (state is ReviewSubmitting) return state.reviews;
    if (state is ReviewSubmitted) return state.reviews;
    return [];
  }
}

class _Header extends StatelessWidget {
  final String academyName;
  final List<Review> reviews;

  const _Header({required this.academyName, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final avg = reviews.isEmpty
        ? null
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            academyName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: List.generate(5, (index) {
                  final filled = avg != null && index < avg.round();
                  return Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                avg != null
                    ? '${avg.toStringAsFixed(1)} (${reviews.length})'
                    : '--',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  color: AppColors.outlineVariant,
                  child: review.userPicture != null
                      ? Image.network(review.userPicture!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _avatarFallback(review.username))
                      : _avatarFallback(review.username),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${review.username} · ${_formatDate(review.createdAt)}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey[700], height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _AddReviewButton extends StatelessWidget {
  final int academyId;

  const _AddReviewButton({required this.academyId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _showReviewSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 2,
          ),
          child: const Text('Add Review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _showReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ReviewBloc>(),
        child: _AddReviewSheet(academyId: academyId),
      ),
    );
  }
}

class _AddReviewSheet extends StatefulWidget {
  final int academyId;

  const _AddReviewSheet({required this.academyId});

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listenWhen: (_, s) => s is ReviewSubmitted || s is ReviewFailed,
      listener: (context, state) {
        if (state is ReviewSubmitted) {
          Navigator.of(context).pop();
        }
        if (state is ReviewFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your rating',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      index < _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Comment (optional)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                final isSubmitting = state is ReviewSubmitting;
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSubmitting || _selectedRating == 0
                        ? null
                        : () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.outlineVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Submit',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit a review')),
      );
      return;
    }
    context.read<ReviewBloc>().add(SubmitReviewEvent(
          token: tokenState.token,
          academyId: widget.academyId,
          rating: _selectedRating,
          comment: _commentController.text.trim(),
        ));
  }
}
