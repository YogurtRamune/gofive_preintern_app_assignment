import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/core/mock/contact_data.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<Contact> get _filteredTeam {
    if (_query.isEmpty) return mockOwnTeam;
    final q = _query.toLowerCase();
    return mockOwnTeam
        .where(
          (m) =>
              m.name.toLowerCase().contains(q) ||
              (m.role?.toLowerCase().contains(q) ?? false),
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
                    const SliverToBoxAdapter(
                      child: _RecentSearchesRow(items: mockRecentSearches),
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
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          hintText: 'Search staff name, role, or email',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: AppTheme.hint),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 2.6),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.hint,
              size: 20,
              weight: 900,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
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
  final List<Contact> items;
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
  final Contact item;
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
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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
  final Contact member;
  const _StaffTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.copyWith(color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  if (member.role != null)
                    Text(
                      member.role!,
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
