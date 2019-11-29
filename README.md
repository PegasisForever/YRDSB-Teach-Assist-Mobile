# Unofficial YRDSB Teach Assist

This is an unofficial YRDSB Teach Assist mobile app for checking marks, you can get it from Google Play and App Store. 

Made by a grade 11 student in MCI.

Uses Flutter framework to achieve cross platform support.

---

It doesn't fetch data from official TA website, but from a server written by myself, which fetches data from official TA periodically.

My YRDSB Teach Assist <-----> My custom server <-----> Official TA Website

The server I wrote also provides a public API which you can get JSON-formatted data from someone's TA. Here is the API documentation.

The custom server acts as a "compatibility layer" allows me to update TA-fetching-algorithm without updating the app. Also, it allows me to fetches data from official TA periodically and send notifications (Using FCM).

---

Key Features:

- Notifications
- Add, Edit and Remove assessments (What If Mode)
- Time Line
- Archived and cached courses (still able to view marks after teacher hides the mark or the course get removed)
- Fast loading speed
- Multi-account support

---

Screen Shots: 

Donate: 