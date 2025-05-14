# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains a Bash script (`python_project_generator.sh`) that generates a complete Python project boilerplate. The script creates a directory structure with essential files for a Python project following best practices.

## Commands

### Running the Generator

```bash
# To run the Python project generator
./python_project_generator.sh
```

### Working with Generated Projects

After generating a project, you would typically:

```bash
# Enter the project directory
cd <project_name>

# Set up the project environment
./install.sh

# Run the application
./main.py
```

## Project Structure Generated

The generator creates the following structure:

```
<project_name>/
├── main.py             # Main script with argument parsing, logging, and config
├── install.sh          # Installation script that sets up the virtual environment
├── requirements.txt    # Python dependencies including testing/linting tools
├── config.json         # Configuration file template
├── data/               # Data directory
├── .gitignore          # Git ignore file with Python patterns
└── README.md           # Project documentation
```

## Key Features

1. The generator creates a Python project with:
   - Automatic virtual environment setup
   - Configuration management (supports JSON, INI, and .env formats)
   - Proper logging configuration
   - Command-line argument parsing
   - Cross-platform compatibility (Windows, macOS, Linux)

2. The `main.py` template includes:
   - Automatic virtual environment creation and dependency installation
   - Configuration loading from different file formats
   - Logging setup
   - Command-line argument parsing

3. The `install.sh` script:
   - Checks for Python 3.6+ installation
   - Creates and activates a virtual environment
   - Installs dependencies from requirements.txt
   - Creates default configuration files

## Development Notes

When modifying the generator script, be mindful of:
- File paths and permissions for the generated scripts
- Cross-platform compatibility (Windows vs. Unix)
- Proper escaping of heredoc content
- Maintaining the project structure documentation in both the script output and README
- Use `python3` to run Python versus `python` to avoid excessive token usage

