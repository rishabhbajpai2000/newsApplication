# News Application using Provider statemanagement

# App Overview
## Screen 1 - Splash Screen
The splash screen displays the FlashNews logo along with a brief introduction to the app.

## Screen 2 - Home Screen
The home screen comprises several components:

- Search Bar: Currently disabled and not functional.

- Categories Section: Offers various news categories like Technology, Health, Business, etc. Users can select a category of interest.

- News Cards: Each card displays an image, title, and summary of a news item. Users can swipe left or right to navigate through news items.

- "Read More" Button: Allows users to access the full article on the web.

- "Add Bookmark" Button: Enables users to save and bookmark news items for later access.

# Usage
- On the home screen, select a news category from the categories section.
- Swipe left or right to navigate through different news items in the selected category.
- Tap the "Read More" button to open the full article in a web browser.
- Tap the "Add Bookmark" button to bookmark the current news item for later access.
- To view bookmarked news items, swipe right to access the bookmarked section.
- State Management
- The app uses the Provider package for state management, allowing efficient and organized data flow between different parts of the app.

# Data Storage
Bookmarking functionality is achieved using a local database solution. Bookmarked news items are stored locally for easy access.

# API Integration
The app fetches the latest news from a remote API. API calls are made to retrieve news items and display them in the app's feed.

# Error Handling
The app handles errors that might occur during API calls, database operations, or other potential issues. Users are provided with appropriate feedback in case of errors.