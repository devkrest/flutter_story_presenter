## 1.0.1

- **:bug: setState Causes Controller to Restart**: Fixed
  :bug: Issue [#22](https://github.com/devkrest/flutter_story_presenter/issues/22) SetState unpauses the FlutterStoryController
  :boom: Breaking Changes : Renamed `FlutterStoryView` to `FlutterStoryPresenter`
## 1.0.0

- **:sparkles: Audio Story added**: Enhancement
  Feature Request [#11](https://github.com/devkrest/flutter_story_presenter/issues/11) fulfilled
  :boom: Also there is breaking changes for custom story as we have added audio player in customer
  view builder
  Feature Request [#12](https://github.com/devkrest/flutter_story_presenter/issues/12) Added an
  example
  according to feature request.

## 0.0.9

- **:bug: Bug Fixes**: Fixed
  Issue [#8](https://github.com/devkrest/flutter_story_presenter/issues/8) where
  smooth_video_progress depends on outdated flutter_hooks

## 0.0.8

- **:bug: Bug Fixes**: Fixed
  Issue [#6](https://github.com/devkrest/flutter_story_presenter/issues/6) with enabling Video
  Looping for video story if story item length is 1

## 0.0.7

- **:bug: Bug Fixes**: Fixed item length & merged PR
  for [fix items length bug](https://github.com/devkrest/flutter_story_presenter/pull/4)

## 0.0.6

- **:memo: Documentation**: Fixed Broken Link for Demo
- **:arrow_down: Flutter Version Downgrade** Flutter version downgraded to support more apps

## 0.0.5

- **:memo: Video Demo**: Fixed Broken Link for Demo

## 0.0.4

- **:memo: Video Demo**: Fixed Broken Link for Video

## 0.0.3

- **:memo: Example**: Added Main Example with all the types of story view and practical scenarios.

- **:bug: Video**: Fixed the issue for Video Story when given `fit` as `BoxFit.cover`.

- **:bug: Custom Widget**: Fixed the issue where story timer not starting for `StoryItem` which
  has `StoryItemType` as `StoryItemType.custom`.

- **:bug: Image Height/Width**: Fixed issue where Image with `SourceType.network` was not correctly
  loading with height & width

## 0.0.2

- :memo: Changed broken links in documentation

## 0.0.1

Initial Release of Package at 17 June 2024

- :tada: First Release












