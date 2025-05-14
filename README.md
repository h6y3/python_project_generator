# Python Project Generator

A Bash script that quickly generates a complete Python project boilerplate with best practices.

## Features

- Creates a complete Python project structure in seconds
- Includes automated virtual environment setup
- Configures proper logging and argument parsing
- Supports multiple configuration formats (JSON, INI, .env)
- Cross-platform compatibility (Windows, macOS, Linux)
- Generates essential files (.gitignore, requirements.txt)

## Usage

```bash
# Simply run the script and follow the prompts
./python_project_generator.sh
```

## Generated Project Structure

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

## Key Features of Generated Projects

1. **Smart Python Environment Management**
   - Automatic virtual environment creation and activation
   - Dependency management via requirements.txt

2. **Flexible Configuration**
   - Support for JSON, INI, and .env file formats
   - Sensible defaults with clear examples

3. **Best Practices Built-in**
   - Proper logging configuration
   - Command-line argument parsing
   - Type hints with mypy support
   - Testing and linting tools included

4. **Cross-Platform Compatibility**
   - Works on Linux, macOS, and Windows

## Requirements

- Bash shell environment
- Python 3.6 or higher

## License

This project is licensed under the MIT License - see the LICENSE file for details.