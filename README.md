# GitHub Analytics CLI

This is a simple command-line interface (CLI) tool to fetch and display analytics for a GitHub user's repositories. It uses the GitHub API to gather data about repositories, including star counts, fork counts, and open issues.

## Features

- Fetch all repositories for a specified GitHub user.
- Display the number of stars, forks, and open issues for each repository.
- Display summary statistics for all repositories.

## Prerequisites

- Ruby installed on your system.
- A GitHub personal access token with the necessary permissions.
- The `httparty` and `dotenv` gems.

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Falkern/gitcli.git
   cd github_cli
   ```

2. Install the required gems:

   ```sh
   bundle install
   ```

3. Create a `.env` file in the root directory and add your GitHub username and token:
   ```sh
   GITHUB_USERNAME=your_github_username
   GITHUB_TOKEN=your_github_token
   ```

## Usage

Run the script with the desired options:

```sh
ruby app.rb [options]
```

### Options

- `--stars`: Show star counts (default: true)
- `--forks`: Show fork counts (default: true)
- `--issues`: Show open issues count (default: true)
- `--help`: Displays the help message

### Example

```sh
ruby app.rb --stars --forks --issues
```

This will display the star counts, fork counts, and open issues for each repository of the specified GitHub user, along with summary statistics.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
