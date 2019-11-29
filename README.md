# Unofficial YRDSB Teach Assist Mobile Client

One of the three programs in the project. Other two: [Fetch TA Data](https://github.com/PegasisForever/Fetch-TA-Data), [YRDSB Teach Assist Web](https://github.com/PegasisForever/YRDSB-Teach-Assist-Web).

This is an unofficial YRDSB Teach Assist mobile app for checking marks, you can get it from [Google Play]() and [App Store](). 

Made by a grade 11 student in MCI.

Uses [Flutter framework](https://flutter.dev/) to achieve cross platform support.

---

It doesn't fetch data from official TA website, but from [Fetch TA Data](https://github.com/PegasisForever/Fetch-TA-Data) server, which fetches data from official TA periodically.

`My YRDSB Teach Assist` <-----> `Fetch TA Data` <-----> [Official TA Website](https://ta.yrdsb.ca/yrdsb/index.php)

The server I wrote also provides a public API which you can get JSON-formatted data from someone's TA. Here is the [API documentation](). I built a web version of TA using this public API: [YRDSB Teach Assist Web](https://github.com/PegasisForever/YRDSB-Teach-Assist-Web).

The server acts as a "compatibility layer" allows me to update TA-fetching-algorithm without updating my app. Also, it allows me to fetches data from official TA periodically and send notifications (Using FCM).

## Key Features:

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

Donate: [patreon](https://www.patreon.com/yrdsbta)

Feedback: Create a GitHub issue, email me [admin@pegasis.site](mailto:admin@pegasis.site) or use the in-app feedback page

Development: Create a pull request or email me [admin@pegasis.site](mailto:admin@pegasis.site)