import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This widget:
///
/// Displays a horizontally scrollable row of selectable date tiles.
/// Allows users to scroll left (past) or right (future).
/// Dynamically loads more dates as the user scrolls close to either end.
/// Has arrow buttons to quickly navigate left/right.
/// Ensures past dates before today are not loaded.
///
class BidirectionalDateSelector extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final int visibleDates;

  const BidirectionalDateSelector({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.visibleDates = 5,
  });

  @override
  State<BidirectionalDateSelector> createState() =>
      _BidirectionalDateSelectorState();
}

class _BidirectionalDateSelectorState extends State<BidirectionalDateSelector> {
  late ScrollController _scrollController; //Controls and listens to scroll events on the horizontal ListView.
  final List<DateTime> _dates = []; //Stores the current _dynamic_ range of visible dates.
  final int _initialLoadCount = 15;
  final int _loadMoreCount = 10; //Number of dates added each time the user scrolls to an edge.
  bool _isLoadingMore = false;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    //1- declare the scroll controller
    _scrollController = ScrollController();
    //2- attach a listener function, why? to monitor the user scroll
    _scrollController.addListener(_scrollListener);
    //3- load initial range of dates
    _loadInitialDates();
  }

  void _loadInitialDates() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < _initialLoadCount; i++) {
      _dates.add(startDate.add(Duration(days: i)));
    }
  }

  void _scrollListener() {
    //Runs every time the list scrolls.
    if (_isLoadingMore || !_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Update arrow visibility
    setState(() {
      _canScrollLeft = position.pixels > 0; //position.pixels: current horizontal scroll offset.
      _canScrollRight = position.pixels < position.maxScrollExtent - 10;
    });

    // Load more future dates
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMoreFutureDates();
    }

    // Load more past dates
    if (position.pixels <= 200) {
      _loadMorePastDates();
    }
  }
  void _loadMoreFutureDates() {
    setState(() {
      _isLoadingMore = true;
      final lastDate = _dates.last; //in the current loaded list and then increment 3aleih
      for (int i = 1; i <= _loadMoreCount; i++) {
        _dates.add(lastDate.add(Duration(days: i)));
      }
      _isLoadingMore = false;
    });
  }

  void _loadMorePastDates() {
    final now = DateTime.now();
    final firstDate = _dates.first;

    // Don't load dates before today
    if (firstDate.isBefore(now) || firstDate.isAtSameMomentAs(now)) {
      return; //don't keep on triggering this loading function, nth to load here.
    }

    setState(() {
      _isLoadingMore = true;
      final currentScrollPosition = _scrollController.position.pixels;

      //34an elmfrud el list decrements until it reaches the first date.
      for (int i = _loadMoreCount; i > 0; i--) {
        final newDate = firstDate.subtract(Duration(days: i)); //awel wa7ed and then decrement mennu
        if (!newDate.isBefore(now)) {
          _dates.insert(0, newDate);
        }
      }

      // Maintain scroll position after adding items at the beginning
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(currentScrollPosition + (73 * _loadMoreCount));
        }
      });

      _isLoadingMore = false;
    });
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final itemWidth = 73.0; // 65 width + 8 padding
      final scrollAmount = itemWidth * widget.visibleDates;

      _scrollController.animateTo(
        (currentPosition - scrollAmount).clamp(0.0, double.infinity),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final itemWidth = 73.0; // 65 width + 8 padding
      final scrollAmount = itemWidth * widget.visibleDates;

      _scrollController.animateTo(
        (currentPosition + scrollAmount).clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          // Left Arrow
          IconButton(
            onPressed: _canScrollLeft ? _scrollLeft : null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: _canScrollLeft ? Colors.black : Colors.grey[300],
            ),
          ),

          // Date List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = widget.selectedDate != null &&
                    date.year == widget.selectedDate!.year &&
                    date.month == widget.selectedDate!.month &&
                    date.day == widget.selectedDate!.day;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _DateItem(
                    date: date,
                    isSelected: isSelected,
                    onTap: () => widget.onDateSelected(date),
                  ),
                );
              },
            ),
          ),

          // Right Arrow
          IconButton(
            onPressed: _canScrollRight ? _scrollRight : null,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _canScrollRight ? Colors.black : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}