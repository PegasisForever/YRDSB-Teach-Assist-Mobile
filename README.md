# Unofficial YRDSB Teach Assist Mobile Client

One of the three programs in the project. Other two: [Fetch TA Data](https://github.com/PegasisForever/Fetch-TA-Data), [YRDSB Teach Assist Web](https://github.com/PegasisForever/YRDSB-Teach-Assist-Web).

This is an unofficial YRDSB Teach Assist mobile app for checking marks, you can get it from [Google Play]() and [App Store](). (not yet)

Made by a grade 11 student in MCI.

Uses [Flutter framework](https://flutter.dev/) to achieve cross platform support.

---

It doesn't fetch data from official TA website, but from [Fetch TA Data](https://github.com/PegasisForever/Fetch-TA-Data) server, which fetches data from official TA periodically.

`My YRDSB Teach Assist APP` <-----> `Fetch TA Data` <-----> [Official TA Website](https://ta.yrdsb.ca/yrdsb/index.php)

## Key Features

- Beautiful UIs and Animations
- Notifications
- Add, Edit and Remove assessments (What If Mode)
- Time Line
- Archived and cached courses (still able to view marks after teacher hides the mark or the course get removed)
- Fast loading speed
- Multi-account support

## To Compile

1. Create a Firebase project and put `google-services.json` in Android project and `GoogleService-Info.plist` in iOS project.
2. Go to [Syncfusion](https://www.syncfusion.com/products/communitylicense) to get a community licence and put it in `lib/licence.dart`.
3. (Optional) Follow `flutter modify list.txt` to change the source code of Flutter.

## Support Me

I spent hundreds of hours on this project, consider buy me a cup of coffee?

Donate: [patreon](https://www.patreon.com/yrdsbta)

Feedback: Create a GitHub issue, email me [admin@pegasis.site](mailto:admin@pegasis.site) or use the in-app feedback page

Development: Create a pull request or email me [admin@pegasis.site](mailto:admin@pegasis.site)