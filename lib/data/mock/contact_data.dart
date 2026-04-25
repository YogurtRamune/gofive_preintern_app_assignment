import 'package:flutter/material.dart';

class Contact {
  final String name;
  final String? role;
  final Color avatarColor;
  final String initials;
  final String? avatarEmoji;

  const Contact({
    required this.name,
    this.role,
    required this.avatarColor,
    required this.initials,
    this.avatarEmoji,
  });
}

const List<Contact> mockRecentSearches = [
  Contact(name: 'Alice', avatarColor: Color(0xFFD4A5C9), initials: 'A'),
  Contact(name: 'Board001', avatarColor: Color(0xFF7B68EE), initials: 'B'),
  Contact(name: 'Qq', avatarColor: Color(0xFFE05A2B), initials: 'Qq'),
  Contact(name: 'Qq', avatarColor: Color(0xFFE8748A), initials: 'Qq'),
  Contact(name: 'Charlie', avatarColor: Color(0xFF5B8DB8), initials: 'C'),
];

const List<Contact> mockOwnTeam = [
  Contact(
    name: 'Praewa Nantapinij',
    role: 'Part-time Officer',
    avatarColor: Color(0xFFE8C97A),
    initials: 'PN',
  ),
  Contact(
    name: 'Sarayut Pasakul',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF5B8DB8),
    initials: 'SP',
  ),
  Contact(
    name: 'Rat Sangkrajang',
    role: 'IT',
    avatarColor: Color(0xFFD4A5C9),
    initials: 'RS',
  ),
  Contact(
    name: 'Pornpawit Suttha',
    role: 'Department Manager',
    avatarColor: Color(0xFF2C2C3E),
    initials: 'PS',
  ),
  Contact(
    name: 'Nakorn Sakorn',
    role: 'Department Manager',
    avatarColor: Color(0xFF78909C),
    initials: 'NS',
  ),
  Contact(
    name: 'Test Onboard',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF5B3A8D),
    initials: 'บอก',
  ),
  Contact(
    name: 'Nonta Kaornjak',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF3A8D6E),
    initials: 'สา',
  ),
  Contact(
    name: 'Newfeed Feednew',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF4CAF50),
    initials: 'NF',
  ),
  Contact(
    name: 'Pong Thanakorn',
    role: 'All rounder',
    avatarColor: Color(0xFF9C7BB5),
    initials: 'PT',
  ),
  Contact(
    name: 'Testtestwork Work',
    role: 'All rounder',
    avatarColor: Color(0xFF4A4A8A),
    initials: 'จี',
  ),
  Contact(
    name: 'Testtest Nodataworkin',
    role: 'All rounder',
    avatarColor: Color(0xFF8D4A6E),
    initials: 'นน',
  ),
  Contact(
    name: 'Thitaporn Longji',
    role: 'All rounder',
    avatarColor: Color(0xFF6A5ACD),
    initials: 'ธิตา',
  ),
  Contact(
    name: 'Testonboard8 Onboard8',
    role: 'All rounder',
    avatarColor: Color(0xFF78909C),
    initials: 'T8',
  ),
  Contact(
    name: 'Testonboard9 Testonboard9',
    role: 'All rounder',
    avatarColor: Color(0xFF607D8B),
    initials: 'T9',
  ),
];
