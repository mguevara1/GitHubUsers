# GitHub User Search App

## Overview

This is a Swift iOS app that allows users to search for GitHub users and view their details, including repositories.

## Features

- GitHub user search functionality.
- Detailed user information display.
- View user repositories with additional details.
- Show repository in web view.

## Configuration

To build and run this project, you need to provide a GitHub token. Create a `config.json` file with the following structure:

```json
{
  "githubToken": "your_actual_token_value"
}
```

## Key Frameworks

### Combine Framework

This project leverages the Combine framework, introduced by Apple to provide a declarative Swift API for processing values over time. Combine is used for handling asynchronous operations, data binding, and event handling. It plays a crucial role in creating reactive and responsive UIs.

### UIKit

The project uses UIKit for building the user interface components. UIKit is a fundamental framework for iOS app development, providing the building blocks for creating visual and interactive interfaces.

### Foundation

Foundation is extensively used for core functionality, including data handling, networking, and date formatting.
