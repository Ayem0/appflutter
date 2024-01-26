import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerHomepageScreen extends StatefulWidget {
  const SellerHomepageScreen({
    super.key,
    required User user,
  })  : _user = user;

  final User _user;

  @override
  State<SellerHomepageScreen> createState() => _SellerHomepageScreenState();
}

class _SellerHomepageScreenState extends State<SellerHomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}