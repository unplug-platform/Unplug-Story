/// Type definitions for the UnPlug Story package.
///
/// This file contains common type definitions used throughout the package
/// for building and customizing story widgets.
import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/model/story_media.dart';

/// A function type for building custom story preview widgets.
///
/// Used to customize how each story is displayed in the story list.
/// The function takes a [Story] instance and returns a [Widget].
typedef StoryWidgetBuilder = Widget Function(Story story);

/// A function type for building custom story media content widgets.
///
/// Used to customize how each media item is displayed within a story.
/// The function takes a [StoryMedia] instance and returns a [Widget].
typedef StoryMediaWidgetBuilder = Widget Function(StoryMedia storyMedia);
