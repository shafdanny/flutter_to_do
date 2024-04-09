# flutter_to_do

A new Flutter project.

## Getting Started

Open the project in IDE of your choice, and run it on a Simulator/Emulator per the Flutter documentation.

## Explanation

We use the following library:
1. Riverpod - state management
2. Hive - local key-value database

The idea is as follows:
1. Every CRUD transaction will be done using Hive (hence stored locally)
2. If it is possible (connection is available), we will push all the data from Hive to Firebase

## Caveat
1. The local database is the final source of truth. Since we did not differentiate the sessions with users, if another new device is running the application with empty data, it will overwrite the existing data in Firebase, thus making it empty also.
2. To check on the content of Firebase, we can simply do a GET query to the URL defined inside provider.dart (in production app, this URL should not be publicly available).

## To Improve
1. As of now, the sync between local and remote happens only when there is a transaction. We can add a service with regular interval (for example hourly) which can do the synchronization in the background.
2. Due to time constraint, a lot of errors are not handled correctly.
3. Refactor. There are a few duplicate codes, variables that could be defined globally and other improvements that can be made to make the code more readable.
4. The UI is quite basic, the delete button ideally should not appear by default (an idea is to make it available on swipe left/right on an item)
