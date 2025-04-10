import 'dart:ui';

import 'package:flutter/material.dart';

import '../mahas_type.dart';

class MahasBasicCard extends StatelessWidget {
  final String title;
  final String content;
  final BorderRadius borderRadius;

  const MahasBasicCard({
    super.key,
    required this.title,
    required this.content,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class MahasImageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final BorderRadius borderRadius;

  const MahasImageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: borderRadius.topLeft,
            ),
            child: Image.network(imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10.0),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MahasInteractiveCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  const MahasInteractiveCard({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10.0),
            Text(content),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Action'),
            ),
          ],
        ),
      ),
    );
  }
}

class MahasProfileCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String description;
  final BorderRadius borderRadius;

  const MahasProfileCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.description,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 30.0,
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5.0),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MahasNotificationCard extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final BorderRadius borderRadius;

  const MahasNotificationCard({
    super.key,
    required this.message,
    required this.timestamp,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(message),
        subtitle: Text(timestamp.toLocal().toString()),
        trailing: const Icon(Icons.notifications),
      ),
    );
  }
}

class MahasCustomizableCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius borderRadius;
  final double elevation;
  final double margin;
  final double padding;

  const MahasCustomizableCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = MahasBorderRadius.medium,
    this.elevation = 1.0,
    this.margin = 10.0,
    this.padding = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      elevation: elevation,
      margin: EdgeInsets.all(margin),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double blur;
  final Color color;
  final BorderRadius borderRadius;

  const GlassContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.blur = 10.0,
    this.color = Colors.white24,
    this.borderRadius = MahasBorderRadius.large,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          color: color,
          child: child,
        ),
      ),
    );
  }
}
