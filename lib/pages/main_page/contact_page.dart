import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class _StaffMember {
  final String name;
  final String role;
  final Color avatarColor;
  final String initials;
  final String? avatarEmoji;

  const _StaffMember({
    required this.name,
    required this.role,
    required this.avatarColor,
    required this.initials,
    // ignore: unused_element_parameter
    this.avatarEmoji,
  });
}

class _RecentSearch {
  final String label;
  final Color avatarColor;
  final String initials;

  const _RecentSearch({
    required this.label,
    required this.avatarColor,
    required this.initials,
  });
}

const List<_RecentSearch> _mockRecentSearches = [
  _RecentSearch(label: 'Alice', avatarColor: Color(0xFFD4A5C9), initials: 'A'),
  _RecentSearch(
    label: 'Board001',
    avatarColor: Color(0xFF7B68EE),
    initials: 'B',
  ),
  _RecentSearch(label: 'Qq', avatarColor: Color(0xFFE05A2B), initials: 'Qq'),
  _RecentSearch(label: 'Qq', avatarColor: Color(0xFFE8748A), initials: 'Qq'),
  _RecentSearch(
    label: 'Charlie',
    avatarColor: Color(0xFF5B8DB8),
    initials: 'C',
  ),
];

const List<_StaffMember> _mockOwnTeam = [
  _StaffMember(
    name: 'Praewa Nantapinij',
    role: 'Part-time Officer',
    avatarColor: Color(0xFFE8C97A),
    initials: 'PN',
  ),
  _StaffMember(
    name: 'Sarayut Pasakul',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF5B8DB8),
    initials: 'SP',
  ),
  _StaffMember(
    name: 'Rat Sangkrajang',
    role: 'IT',
    avatarColor: Color(0xFFD4A5C9),
    initials: 'RS',
  ),
  _StaffMember(
    name: 'Pornpawit Suttha',
    role: 'Department Manager',
    avatarColor: Color(0xFF2C2C3E),
    initials: 'PS',
  ),
  _StaffMember(
    name: 'Nakorn Sakorn',
    role: 'Department Manager',
    avatarColor: Color(0xFF78909C),
    initials: 'NS',
  ),
  _StaffMember(
    name: 'Test Onboard',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF5B3A8D),
    initials: 'บอก',
  ),
  _StaffMember(
    name: 'Nonta Kaornjak',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF3A8D6E),
    initials: 'สา',
  ),
  _StaffMember(
    name: 'Newfeed Feednew',
    role: 'Part-time Officer',
    avatarColor: Color(0xFF4CAF50),
    initials: 'NF',
  ),
  _StaffMember(
    name: 'Pong Thanakorn',
    role: 'All rounder',
    avatarColor: Color(0xFF9C7BB5),
    initials: 'PT',
  ),
  _StaffMember(
    name: 'Testtestwork Work',
    role: 'All rounder',
    avatarColor: Color(0xFF4A4A8A),
    initials: 'จี',
  ),
  _StaffMember(
    name: 'Testtest Nodataworkin',
    role: 'All rounder',
    avatarColor: Color(0xFF8D4A6E),
    initials: 'นน',
  ),
  _StaffMember(
    name: 'Thitaporn Longji',
    role: 'All rounder',
    avatarColor: Color(0xFF6A5ACD),
    initials: 'ธิตา',
  ),
  _StaffMember(
    name: 'Testonboard8 Onboard8',
    role: 'All rounder',
    avatarColor: Color(0xFF78909C),
    initials: 'T8',
  ),
  _StaffMember(
    name: 'Testonboard9 Testonboard9',
    role: 'All rounder',
    avatarColor: Color(0xFF607D8B),
    initials: 'T9',
  ),
];

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<_StaffMember> get _filteredTeam {
    if (_query.isEmpty) return _mockOwnTeam;
    final q = _query.toLowerCase();
    return _mockOwnTeam
        .where(
          (m) =>
              m.name.toLowerCase().contains(q) ||
              m.role.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (_query.isEmpty) ...[
                    const _SectionHeader(title: 'Recent Searches'),
                    SliverToBoxAdapter(
                      child: _RecentSearchesRow(items: _mockRecentSearches),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],
                  const _SectionHeader(title: 'Own Team'),
                  SliverList.builder(
                    itemCount: _filteredTeam.length,
                    itemBuilder: (context, index) =>
                        _StaffTile(member: _filteredTeam[index]),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(44),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        // labelLarge: fontSize 14, w500 — matches the input value style
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          hintText: 'Search staff name, role, or email',
          // bodyLarge: fontSize 13.5 — override color to hint
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: AppTheme.hint),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 15, right: 2.6),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.hint,
              size: 20,
              weight: 900,
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11),
          filled: false,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Text(
          title,
          style: Theme.of(context).extension<AppTextStyles>()!.sectionHeader,
        ),
      ),
    );
  }
}

class _RecentSearchesRow extends StatelessWidget {
  final List<_RecentSearch> items;
  const _RecentSearchesRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _RecentSearchChip(item: items[index]),
      ),
    );
  }
}

class _RecentSearchChip extends StatelessWidget {
  final _RecentSearch item;
  const _RecentSearchChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: item.avatarColor,
          child: Text(
            item.initials,
            style: Theme.of(
              context,
            ).extension<AppTextStyles>()!.avatarInitial.copyWith(fontSize: 14),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 62,
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            // bodyMedium: onSurface color — override size to 11 (smaller than default 13)
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _StaffTile extends StatelessWidget {
  final _StaffMember member;
  const _StaffTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // TODO: navigate to staff profile
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: member.avatarColor,
              child: Text(
                member.initials,
                style: Theme.of(context)
                    .extension<AppTextStyles>()!
                    .avatarInitial
                    .copyWith(fontSize: 13),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // labelLarge: fontSize 14, w500 — exact match for staff name
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.role,
                    // bodyMedium: w400 base — override size to 12 and color to hint
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      color: AppTheme.hint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
