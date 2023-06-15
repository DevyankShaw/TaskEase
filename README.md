# TaskEase - A Convenient Task Management App

TaskEase is a user-friendly task management app designed to simplify and streamline day-to-day task organization. With TaskEase, users can effortlessly create, update, and delete tasks while enjoying a range of helpful features.

1. Task Creation and Management:

   - Users can easily create new tasks, specifying task names and any additional remarks for clarity.

   - Each task can be assigned a status, including options such as Not Started, In Progress, Under Review, or Completed.

   - Tasks can have set deadlines, allowing users to prioritize their work effectively.

   - The importance of tasks can be indicated, ensuring users stay focused on critical assignments.

2. Visual Organization:

   - Tasks are visually organized with appropriate color combinations based on their status, enabling users to quickly identify the state of each task.

   - At-a-glance icons are provided to represent the status, deadline, and importance of tasks, aiding efficient task management.

   - Search and Filter Functionality:

   - TaskEase offers a search feature, that allows users to find specific tasks by their names.

   - Users can filter tasks based on their status, helping them view and manage tasks based on their progress.

3. Seamless Mobile and Web Integration:

   - Mobile users can log in to TaskEase using their mobile numbers for authentication, ensuring secure access.

   - Web users can enjoy automatic authentication via Mobile-to-Web Cross Login Using QR, eliminating the need to repeat the authentication process from mobile to web.

   - Users can carry out the same task operations on the web as they would on mobile, providing a hassle-free experience and increasing productivity.

4. Undo Deletion Capability:

   TaskEase includes an undo feature for task deletions, allowing users to restore accidentally deleted tasks, reducing the risk of data loss, and providing peace of mind.

With TaskEase, task management becomes effortless and efficient, empowering users to stay organized, meet deadlines, and boost productivity.

## Tech Stack
- Flutter (Android, IOS, Web) - Build the app for all three platforms but have been tested for Android and Web only
- Firebase - Mainly used to set up FCM push notifications for cross-login mobile to web using QR and deploy flutter web app using hosting
    - Cloud Messaging - Server Side(Node.js)
    - Hosting
- Appwrite Cloud - The main backend as a service platform used to store and modify tasks, provide authentication, and trigger FCM push notifications via cloud function.
    - Authentication (Phone)
    - Database
    - Cloud Functions - Node.js
        
## Resources
- [Website Link](https://appwrite-hackathon.web.app)
- [Youtube Demo Link](https://youtu.be/j7BZmVQopEs)
- [Mobile APK Link]()
- [Hashnode Article Link]()

