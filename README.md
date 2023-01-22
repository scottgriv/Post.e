![App Logo](./images/demo_banner.png)

![Swift](https://img.shields.io/badge/Swift-5-orange?style=for-the-badge&logo=swift)
![iOS](https://img.shields.io/badge/iOS-16.2-red?style=for-the-badge&logo=apple)
![watchOS](https://img.shields.io/badge/watchOS-9.1-yellow?style=for-the-badge&logo=apple)
[![Contact](https://img.shields.io/badge/contact-scott.grivner@gmail.com-9cf?style=for-the-badge&logo=gmail)](mailto:scott.grivner@gmail.com)

**Post.e** is a multi-language "how-to" social media application.

- [Background Story](#background-story)
- [Definitions](#definitions)
- [Limitations](#limitations)
- [Features](#features)
- [Getting Started](#getting-started)
- [Programming Languages](#programming-languages)
- [Project](#project)
- [Future Plans](#future-plans)
- [Contribution](#contribution)
- [License](#license)
- [Credit](#credit)

<img src="./images/phone_feed.gif" width="19%" height="19%"/> <!-- Done -->
<img src="./images/phone_post.gif" width="19%" height="19%"/> <!-- Done -->
<img src="./images/phone_splash.png" width="19%" height="19%"/> <!-- Done -->
<img src="./images/phone_profile.gif" width="19%" height="19%"/> <!-- Done -->
<img src="./images/phone_interaction.gif" width="19%" height="19%"/> <!-- Done -->

## Background Story

I had two goals when I originally started this project:
1. Demonstrate how to make a "Twitter-esque" social media application.
    - A lot of people underestimate the amount of time and work involved making a social media application.
    - There's a lot of confusion around the tech stack consisting of: client side code, back-end code, a database, and a web server of some kind.
    - I wanted to shine a light on the above processes and the technology involved.
2. Create the application in as many languages as possible and use the project as a learning tool for myself.
    - I wrote the application with a mix of both `Objective-C` and `Swift` to demonstrate how a `Bridging Header` file allows the two languages to share classes/files between each other. 
    - I'm constantly learning new programming languages and frameworks. I wanted to build a "one stop shop" mobile application as a sandbox for all of these languages.
    - I started building the application back-end with ``PHP`` because its easy to understand and learn for new developers. With that said, I'm going to try to utilize languages like ``Go`` and ``Node.js`` in the future; the multi-threading capabilties of these languages to significantly speed up server request & response processing makes them an obvious choice to work on next.
    - I've realized now, by open-sourcing it, there's an opportunity for others to learn and contribute to it as well.
    
*I know this is a lengthy README, but I want to explain every detail of the application for teaching/learning purposes. If this repo gains attraction, I will add a lot of these details into github-pages/documentation to remove clutter in the README. I appreciate it if you make it to the end!*

## Definitions:
> A **Post** is any message posted to **Post.e** which contains text and/or attachments that may contain photos, videos, or a wide variety of file types. View the `extension` table in the database to view the supported file types. Tap the Post button to post the message to your profile.

> **Posts** are the defacto form of communication in **Post.e** (similar to a [Tweet](https://help.twitter.com/en/resources/new-user-faq)).

> **Posts** were inspired by the popular office supply product [Post-It Notes](https://en.wikipedia.org/wiki/Post-it_Note) due to their ability to easily communicate messages and attach them to surfaces. Virtual **Posts** in **Post.e** offer a similar functionality. 

## Limitations:
**Posts** are limited to:
- Post character limit: There is no hard limit for the number of characters, however, the database type and length is `VARCHAR(250)` and it cannot be `NULL`.
- Attachment limit per Post: 9.
- Max file size per Attachment: 1 gigabyte (GB) or 1,073,741,824 bytes.

Currently, the `Post.swift` file contains the static values mentioned above. In the future, I'd like to sync this to the `parameter` table in the database for a more dynamic approach, including a max character limit for Posts and an alert message if the Post limit has been exceeded.

## Features:
<img src="./images/phone_login-register.gif" width="19%" height="19%"/>

- **Login & Register Screens:** 
    - Single Sign-On (SSO) capabilties by using a combination of Swift's [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) class and server side session handling using. Login once then then automatically login in the future without signing in (unless, of course, you logout of the app which kills the active session in the `session` table).
    - Username & Password validations.
        - Checks for minimum password length, min/max user name length, missing or empty fields, matching paswords, and invalid characters using `REGEX` patterns. 
    - Registering a User will create a new folder in the `server/uploads` folder using the new `Prof_ID` column value, which is an `AUTO_INCREMENT` column in the database (Posts work in this same fashion).
    - A unique `ID` is also generated using the `encoder.[language]` file using `Base 64 Encoding` to produce a unique external facing `ID`, stored in the database under the `Prof_Key` or `Post_Key` columns, that can be used to share Posts or Profiles in the future.

<img src="./images/phone_config.gif" width="19%" height="19%"/>

- **Configure Programming Language Screens:** <br>
    - Pick the server side language you want Post.e to use. This will route the requests to the toggled language folder.

<img src="./images/phone_feed.gif" width="19%" height="19%"/>

- **Feed Screen:** <br>
    - Sort Posts by *Newest*:
        - *Newest* consists of the most *recent* posts using the `Post_Created` date column in descending order.
        - `WHERE Post_Created DESC`.
    - Sort Posts by *Home* experience:
        - *Home* uses a number of columns to create a fun user feed experience using the below `WHERE` clause:
        - `WHERE Post_Love_Count DESC, Post_Pin_Count DESC, Post_Reply_Count, Post_Created DESC`.
    - Click on the Profile name to segue to their Profile screen.

<img src="./images/phone_interaction.gif" width="19%" height="19%"/>

- **Interaction Screen:** <br>
    - View New Users on the App.
    - Click on the Profile name to segue to their Profile screen.
    - Follow or Unfollow users directly from this screen.

<img src="./images/phone_profile.gif" width="19%" height="19%"/>

- **Profile Screen:** <br>
    - Interactive Follower, Following, and Post count buttons that will segue to the Interaction screen when clicked.
    - Profile picture display.
    - Click the Profile tab icon to scroll to the top.
    - Pull refresh to get the most recent Posts.
    - Post button to create new Posts.
    - Order your Posts on your Profile Feed by: Newest, Oldest, Loved, Pinned, Replied counts in descending order.
    - Edit Profile
        - Change your Profile picture (take a photo or select one from your library).
        - Remove your Profile picture - setting it to the default placeholder image.
        - Update your Profile Username (it must be unique) and Profile Name.
        - Delete your Profile.
    - Scroll to the bottom of the Table, Posts will load in 25 Post chunks. If the Post # > 25, a request will be sent to the server and an activity indicator will be shown in the Table footer as it fetches the next chunk of 25.
    - Within the Post Cell:
        - Preview & Save Attachments.
        - Pin a Post (which will be displayed on your own Profile).
        - Reply to a Post.
        - Love a Post.
    - Click on the Profile name to segue to their Profile screen.

<img src="./images/phone_post.gif" width="19%" height="19%"/><img src="./images/phone_attachments.png" width="19%" height="19%"/>

- **Post Screen:** <br>
    - Type up a Post.
    - Cancel the Post by clicking the Cancel button or the visible Profile Screen.
    - Add Photos/Videos from your Camera or Photo Library.
    - Add Attachments (**Post.e** comes with a demo directory with a few files ready to select) - see screenshot below.
    - Submit the Post to the server.

<img src="./images/phone_settings-logout.gif" width="19%" height="19%"/>

- **Settings:** <br>
    - About section to view the current Post.e version number (derived from the `info.plist` value of `CFBundleShortVersionString`).
    - Open Source Libraries used to create `Post.e` and their related LICENSE files.
    - Language Selection displays your current Device Language, available Languages supported by **Post.e** as well as a link to your Settings screen to change your device language (this will cause the application to re-start per Apple).
    - Directory Settings displays your current folder directory used to select files for Post Attachments. Toggle the "Use Sample Directory" switch to use the sample files provided with **Post.e** by default or not.
    - Change your Password
    - Logout of the Application (which will also kill the session on the server).

 <img src="./images/watch_support.gif" width="30%" height="30%"/>

- **watchOS Support:** <br>
    - Post to your Profile using a audio to text message or by typing in the text using the watch keyboard.

<img src="./images/phone_language_support.gif" width="19%" height="19%"/><img src="./images/watch_language_support.png" width="19%" height="19%"/>

- **Language Support:** <br>
    - English and Russian language support using [Localization](https://developer.apple.com/localization/). View the `language` table in the database to view the supported languages.

<img src="./images/phone_dark_support.gif" width="19%" height="19%"/>

- **Dark Mode Support:** <br>
    - Easily toggle Designs between Light and Dark Mode.

- **API:**
    - Navigate to the `api` file to access the settings `.json` file used to import APIs into Postman. 
    - View the `apis.[language]` file to view the list of available APIs and usage. 
    
## Getting Started
- Download the application from here, Github.
- Place the `server` file on your web server.
- Ensure you have the proper languages and versions installed that you're integrating **Post.e** with. 
    - See [Programming Languages](#programming-languages) below for the current version numbers.
- Import the provided `MySQL` database structure to your database using either the `db/mysql/post-e.sql` file or the `db/mysql/post-e_demo.sql` file.
    - The `post-e.sql` file is a blank/empty database/sandbox.
    - The `post-e_demo.sql` file contains sample data (recommended for demoing or learning purposes).
- Edit the `resources/config.ini` file with your database credentials.
    - This will be used to connect to the database in all language variations. 
- Ensure the proper ports are open for your `localhost` web server and database.
- Run the **Post.e** app in `Xcode` located in the `mobile/ios` folder.
    - Change your scehme to `Post.e-Test` to view Profile ID and Post ID values on the Tableview.
    - **Post.e** was tested with the following devices/simulators:
        - iPhone 14 Pro Max
        - iPhone 14 Plus
        - Apple Watch Series 8 (41mm)
        - Apple Watch Series 8 (45mm)
        - More Devices to be added in the future (layouts due to constraint issues may vary depending on your unsupported Device)
- Login with the following:
    - If you're using the Demo database, login with the following credentials: 
        - **User:** Demo123
        - **Password:** appdev123
    - If you're using the empty database, you will have to build up the app database by registering new users.
- Click Login! Enjoy!

**NOTE:** 
- All of the demo accounts in the database uses this same password above. 
- Passwords are hashed using `SHA512` and `Salted`.
- The demo accounts consist of quotes from famous individals that have inspired me through their works and words.

## Programming Languages

Below is a running list of languages currently supported by **Post.e**:

| **Language & Progress:**                                                                                            | **Version** |
|---------------------------------------------------------------------------------------------------------------------|-------------|
|  ![Swift](https://img.shields.io/badge/Swift-complete-success?style=for-the-badge&logo=swift)                       | 5.7         |
|  ![Obj-C](https://img.shields.io/badge/Obj--C-complete-success?style=for-the-badge&logo=apple)                      | 4.0         |
|  ![PHP](https://img.shields.io/badge/PHP-complete-success?style=for-the-badge&logo=php)                             | 8.1.6       |
|  ![Python](https://img.shields.io/badge/Python-in_progress-important?style=for-the-badge&logo=python)               | 3.11.0      |
|  ![Node.js](https://img.shields.io/badge/Node.js-in_progress-important?style=for-the-badge&logo=nodejs)             | 18.12.1     |
|  ![Ruby](https://img.shields.io/badge/Ruby-in_progress-important?style=for-the-badge&logo=ruby)                     | 2.6.10      |
|  ![Go](https://img.shields.io/badge/Go-in_progress-important?style=for-the-badge&logo=go)                           | 1.19.3      |
|  ![Rust](https://img.shields.io/badge/Rust-open-critical?style=for-the-badge&logo=rust)                             | 1.64.0      |
|  ![Perl](https://img.shields.io/badge/Perl-open-critical?style=for-the-badge&logo=perl)                             | 5.30.3      |
|  ![Java](https://img.shields.io/badge/Java-open-critical?style=for-the-badge)                                       | 17.0.5      |
|  ![MariaDB](https://img.shields.io/badge/MySQL-complete-success?style=for-the-badge&logo=mysql)                     | 10.4.21     |

## Project

Please reference the GitHub Project tab inside this Repo to get a good understanding where I'm currently at with the overall project. Issues and enhancements will also be tracked there as well.

## Future Plans

- Besides making it compatible with more back-end languages, device constraints, and the tasks mentioned in the Backlog (i.e. Editing Posts, Push Notifications, etc.), I'm considering eventually hosting it on a server so its not constrainted to a local environment. This way, the demo will have a sandbox for everyone to interact in. I don't plan on making it an actual social media app - it was created as a learning tool for all, and I'd like to keep it that way.
- I designed the app icons and banners myself, however, as you all know - Design is a full time job and hard to balance with programming. A lot of the buttons and interactive icons were taken from free design websites. I'd like to eventually create and plug in custom designs into the application for a better user experience and flow.
- I'd like to add more documentation around app navigation as well as an in-depth dive into the underlying technology used within the app. As I mentioned above, I want this to be used as a learning tool and solid documentation is a must have as a teaching tool. I will probably utilize github-pages for this.

## Contribution

I'm looking forward to working with others on this project over time (of course, when time is permitted) and seeing where it goes. Feel free to Fork the Repo and submit a Pull Request if you've contributed to it in some way. If you're going to Fork the project or Clone it for your own purposes, all I ask is that you follow the attached license as well as giving me credit using the below **Credit** block. I spent a lot of time on this and I'm proud of how it turned out, I'm more than happy to open-source it to help others as long as credit is given and no profit is gained from it in return; this is "the people's" social media app. 

Feel free to reach out to me using my email below if you have any questions or suggestions.

Thanks and enjoy! (and I appreciate if you've read this far - you're a legend!)

## License
**Post.e** is released under the **GNU GPLv3 License**. [See LICENSE](LICENSE) for details.

## Credit
**Author:** Scott Grivner <br>
**Email:** scott.grivner@gmail.com <br>
**Website:** [scottgrivner.dev](https://www.scottgriv.dev) <br>
**Reference:** [Main Branch](https://github.com/scottgriv/Post.e) <br>
<img src="./images/demo_icon.png" width="5%" height="5%"/>