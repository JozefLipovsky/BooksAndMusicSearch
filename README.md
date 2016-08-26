# iOS Quiz

### Instructions
Create a simple, single-page application that allows users to search for books or music.

The view in this app is a UITableView with a search field at the top. When the search field is empty, the table view displays no cells. It only displays a single placeholder message telling the user to search for something.

When the user types in the search field, the first section of the table view should populate with music that match the user’s query (you can use the iTunes Search API), and the second section should populate with books that match the user’s query (you can use the Google Books API).

### Note
The data for both sections should be fetched asynchronously, and the table view should not show anything until data for BOTH sections are ready. Use NSOperation s to achieve this.

### Rules
For this project, your code must follow these rules:
- A class cannot be longer than 200 lines of code. 
- A function cannot be longer than 15 lines of code.
