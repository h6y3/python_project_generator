#!/bin/bash
# project_generator.sh - Generate a complete Python project boilerplate

set -e  # Exit immediately if a command exits with a non-zero status

# Define project directory
read -p "Enter project name (default: 'python-boilerplate'): " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-python-boilerplate}

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "Creating project structure for $PROJECT_NAME..."

# Create main.py
cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
A script boilerplate following Python best practices.

This template includes configuration management, virtual environment setup,
dependency management, and other best practices.
"""

import argparse
import configparser
import json
import logging
import os
import subprocess
import sys
from pathlib import Path
from typing import Dict, Any, Optional, Union


def setup_logging(log_level: str = "INFO") -> None:
    """Set up logging configuration."""
    numeric_level = getattr(logging, log_level.upper(), None)
    if not isinstance(numeric_level, int):
        raise ValueError(f"Invalid log level: {log_level}")
    
    logging.basicConfig(
        level=numeric_level,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def load_config(config_path: Union[str, Path]) -> Dict[str, Any]:
    """
    Load configuration from a file.
    Supports .ini, .json, and .env file formats.
    """
    config_path = Path(config_path)
    
    if not config_path.exists():
        logging.error(f"Configuration file not found: {config_path}")
        sys.exit(1)
    
    # Determine file type and load accordingly
    if config_path.suffix == '.ini':
        config = configparser.ConfigParser()
        config.read(config_path)
        # Convert to dict for consistency
        return {s: dict(config.items(s)) for s in config.sections()}
    
    elif config_path.suffix == '.json':
        with open(config_path, 'r') as f:
            return json.load(f)
    
    elif config_path.suffix == '.env':
        # Simple .env parser
        result = {}
        with open(config_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                key, value = line.split('=', 1)
                result[key.strip()] = value.strip().strip('"\'')
        return result
    
    else:
        logging.error(f"Unsupported configuration file format: {config_path.suffix}")
        sys.exit(1)


def ensure_venv() -> None:
    """
    Ensure we're running in a virtual environment.
    If not, create one and relaunch the script within it.
    """
    # Check if we're already in a virtual environment
    if sys.prefix == sys.base_prefix:
        script_dir = Path(__file__).parent.absolute()
        venv_dir = script_dir / "venv"
        
        # Create a virtual environment if it doesn't exist
        if not venv_dir.exists():
            logging.info("Creating virtual environment...")
            subprocess.run([sys.executable, "-m", "venv", str(venv_dir)], check=True)
        
        # Determine the path to the Python interpreter in the virtual environment
        if sys.platform == "win32":
            python_path = venv_dir / "Scripts" / "python.exe"
        else:
            python_path = venv_dir / "bin" / "python"
        
        # Install dependencies
        requirements_path = script_dir / "requirements.txt"
        if requirements_path.exists():
            logging.info("Installing dependencies...")
            subprocess.run(
                [str(python_path), "-m", "pip", "install", "-r", str(requirements_path)],
                check=True
            )
        
        # Re-run the script with the same arguments but using the virtual environment's Python
        logging.info("Relaunching script in virtual environment...")
        os.execv(str(python_path), [str(python_path)] + sys.argv)


def parse_arguments() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    
    parser.add_argument(
        "--config", 
        type=str, 
        default="config.json",
        help="Path to the configuration file (default: config.json)"
    )
    
    parser.add_argument(
        "--log-level",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        default="INFO",
        help="Set the logging level (default: INFO)"
    )
    
    parser.add_argument(
        "--skip-venv",
        action="store_true",
        help="Skip virtual environment check and setup"
    )
    
    # Add your custom arguments here
    
    return parser.parse_args()


def main() -> int:
    """Main function."""
    args = parse_arguments()
    
    # Set up logging
    setup_logging(args.log_level)
    
    # Ensure we're in a virtual environment (unless skipped)
    if not args.skip_venv:
        ensure_venv()
    
    # Load configuration
    try:
        config = load_config(args.config)
        logging.debug(f"Loaded configuration: {config}")
    except Exception as e:
        logging.error(f"Failed to load configuration: {e}")
        return 1
    
    # Your application logic here
    logging.info("Starting application...")
    
    # Example: Access configuration values
    # app_name = config.get('app', {}).get('name', 'Default App Name')
    
    logging.info("Application completed successfully")
    return 0


if __name__ == "__main__":
    sys.exit(main())
EOF

# Create install.sh
cat > install.sh << 'EOF'
#!/bin/bash
# install.sh - Setup script for the project

set -e  # Exit immediately if a command exits with a non-zero status

# Detect the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check for Python 3.6+ installation
echo "Checking Python version..."
if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_VERSION=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    PYTHON_CMD="python"
else
    echo "Error: Python 3.6+ is required but not found."
    exit 1
fi

# Compare versions (requires Python 3.6+)
if (( $(echo "$PYTHON_VERSION < 3.6" | bc -l) )); then
    echo "Error: Python 3.6+ is required, but $PYTHON_VERSION was found."
    exit 1
fi

echo "Using Python $PYTHON_VERSION"

# Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    $PYTHON_CMD -m venv venv
fi

# Activate the virtual environment
if [ -f "venv/bin/activate" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
elif [ -f "venv/Scripts/activate" ]; then
    echo "Activating virtual environment..."
    source venv/Scripts/activate
else
    echo "Error: Virtual environment activation script not found."
    exit 1
fi

# Install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies..."
    pip install -r requirements.txt
else
    echo "Warning: requirements.txt file not found."
    echo "Creating example requirements.txt file..."
    cat > requirements.txt << END_OF_REQUIREMENTS
# Core packages
requests>=2.25.1
pyyaml>=5.4.1

# Development packages
pytest>=6.2.5
black>=21.5b2
flake8>=3.9.2
mypy>=0.812
END_OF_REQUIREMENTS
    pip install -r requirements.txt
fi

# Create an example configuration file if it doesn't exist
if [ ! -f "config.json" ]; then
    echo "Creating example configuration file..."
    cat > config.json << END_OF_CONFIG
{
    "app": {
        "name": "MyApp",
        "version": "0.1.0",
        "environment": "development"
    },
    "logging": {
        "level": "INFO",
        "file": "app.log"
    },
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "myapp_db",
        "user": "myapp_user",
        "password": ""
    }
}
END_OF_CONFIG
fi

# Make the main script executable
chmod +x main.py

echo "Setup completed successfully!"
echo "To run the application:"
echo "  ./main.py"
echo ""
echo "If you're on Windows, use:"
echo "  python main.py"
EOF

# Create requirements.txt
cat > requirements.txt << 'EOF'
# Core packages
requests>=2.25.1
pyyaml>=5.4.1

# Development packages
pytest>=6.2.5
black>=21.5b2
flake8>=3.9.2
mypy>=0.812
EOF

# Create config.json
cat > config.json << 'EOF'
{
    "app": {
        "name": "MyApp",
        "version": "0.1.0",
        "environment": "development"
    },
    "logging": {
        "level": "INFO",
        "file": "app.log"
    },
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "myapp_db",
        "user": "myapp_user",
        "password": ""
    }
}
EOF

# Create README.md
cat > README.md << EOF
# $PROJECT_NAME

A Python project boilerplate with best practices.

## Features

- Automatic virtual environment setup
- Configuration management (supports JSON, INI, and .env formats)
- Proper logging configuration
- Command-line argument parsing
- Cross-platform compatibility (Windows, macOS, Linux)

## Installation

### Option 1: Automatic Installation

Run the included installation script:

\`\`\`bash
# On Unix-like systems (Linux, macOS)
./install.sh

# On Windows (using Git Bash or similar)
bash install.sh
\`\`\`

### Option 2: Manual Installation

1. Ensure you have Python 3.6+ installed
2. Create a virtual environment:
   \`\`\`bash
   python3 -m venv venv
   \`\`\`
3. Activate the virtual environment:
   \`\`\`bash
   # On Unix-like systems
   source venv/bin/activate
   
   # On Windows
   venv\\Scripts\\activate
   \`\`\`
4. Install dependencies:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

## Usage

\`\`\`bash
# Basic usage
./main.py

# With custom configuration file
./main.py --config my_config.json

# With custom logging level
./main.py --log-level DEBUG

# Skip virtual environment check
./main.py --skip-venv
\`\`\`

## Configuration

The application supports the following configuration file formats:
- JSON (.json)
- INI (.ini)
- Environment variables (.env)

Example configuration structure:

\`\`\`json
{
    "app": {
        "name": "MyApp",
        "version": "0.1.0"
    },
    "database": {
        "host": "localhost",
        "port": 5432
    }
}
\`\`\`

## Project Structure

\`\`\`
$PROJECT_NAME/
├── main.py             # Main script
├── install.sh          # Installation script
├── requirements.txt    # Python dependencies
├── config.json         # Configuration file
├── venv/               # Virtual environment (created on installation)
└── README.md           # Project documentation
\`\`\`
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Virtual environment
venv/
env/
ENV/

# Log files
*.log

# Environment variables
.env

# IDE files
.idea/
.vscode/
*.swp
*.swo

# Distribution / packaging
dist/
build/
*.egg-info/
EOF

# Create a data directory
mkdir -p data

# Make scripts executable
chmod +x main.py
chmod +x install.sh

echo "Project '$PROJECT_NAME' created successfully!"
echo ""
echo "To set up the project environment:"
echo "  cd $PROJECT_NAME"
echo "  ./install.sh"
echo ""
echo "To run the application:"
echo "  ./main.py"
echo ""
echo "Directory structure:"
echo "  $PROJECT_NAME/"
echo "  ├── main.py             # Main script"
echo "  ├── install.sh          # Installation script"
echo "  ├── requirements.txt    # Python dependencies"
echo "  ├── config.json         # Configuration file"
echo "  ├── data/               # Data directory"
echo "  ├── .gitignore          # Git ignore file"
echo "  └── README.md           # Project documentation"
