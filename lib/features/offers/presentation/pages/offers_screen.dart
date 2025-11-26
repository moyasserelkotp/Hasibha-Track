import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/services/recommendation_engine.dart';
import '../../domain/entities/offer.dart';
import '../widgets/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _recommendationEngine = RecommendationEngine();
  final List<Offer> _allOffers = [];
  List<Offer> _personalizedOffers = [];
  final List<Offer> _savedOffers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOffers();
  }

  void _loadOffers() {
    // Mock user spending data
    final userSpending = {
      'food': 450.0,
      'shopping': 280.0,
      'transport': 150.0,
    };

    _personalizedOffers = _recommendationEngine.generatePersonalizedOffers(
      userSpending: userSpending,
      frequentMerchants: [],
    );

    // Add all personalized offers to the all offers list
    _allOffers.addAll(_personalizedOffers);

    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Deals'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'For You'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOffersList(_allOffers),
          _buildOffersList(_personalizedOffers),
          _buildOffersList(_savedOffers),
        ],
      ),
    );
  }

  Widget _buildOffersList(List<Offer> offers) {
    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No offers available',
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: OfferCard(
            offer: offers[index],
            onSave: () {
              setState(() {
                if (!_savedOffers.contains(offers[index])) {
                  _savedOffers.add(offers[index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Offer saved!')),
                  );
                }
              });
            },
            onUse: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Using: ${offers[index].title}')),
              );
            },
          ),
        );
      },
    );
  }
}
