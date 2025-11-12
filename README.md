# CLI Forge 🔨

An AI-powered tool generator for Unix command line utilities, built with Ruby. Similar to Bolt/Lovable but specifically designed for creating CLI tools through natural language descriptions.

**NEW**: 🎓 **Interactive Learning Mode** - Learn Ruby programming by building CLI tools step-by-step!

## What is CLI Forge?

CLI Forge has **two modes** to help you build amazing CLI tools:

### 🚀 Generate Mode (Default)
AI (Claude) generates production-ready command line tools instantly from natural language descriptions. Just describe what you want, and CLI Forge creates a fully functional Unix CLI tool for you!

### 🎓 Learning Mode (NEW!)
Learn Ruby programming through interactive tutorials. Build real CLI tools step-by-step with instant feedback, automated testing, and progressive hints. **No API key required!**

## Features

### Generate Mode
✨ **AI-Powered Generation** - Describe your tool in plain English
🚀 **Production Ready** - Generated tools include proper error handling, help text, and Unix conventions
📦 **Self-Contained** - Minimal dependencies, tools just work
🔧 **Easy Management** - List, install, and remove generated tools
💎 **Ruby-Based** - Clean, readable, maintainable code

### Learning Mode
🎓 **Interactive Tutorials** - 6 comprehensive lessons from basics to advanced
✅ **Automated Testing** - Test your code instantly with built-in tests
💡 **Progressive Hints** - Get help when stuck without spoiling the solution
📊 **Progress Tracking** - See your learning journey
🛠️ **Real Projects** - Build actual CLI tools, not toy examples
📚 **No API Key Needed** - Start learning immediately

## Installation

### Prerequisites

- Ruby 2.7 or higher
- An Anthropic API key ([get one here](https://console.anthropic.com/))

### Quick Install

```bash
git clone <this-repo>
cd bookbot
./install.sh
```

### Manual Install

```bash
mkdir -p ~/.local/bin
cp cli_forge.rb ~/.local/bin/cli_forge
chmod +x ~/.local/bin/cli_forge

# Add to PATH (if not already)
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```

## Configuration

Set your Anthropic API key:

```bash
export ANTHROPIC_API_KEY='your-api-key-here'
```

Make it permanent by adding to your `~/.bashrc` or `~/.zshrc`:

```bash
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
```

## Usage

### Generate Mode - Get Tools Instantly

Simply describe what you want:

```bash
cli_forge "a tool that converts JSON to YAML"
```

```bash
cli_forge "a tool that monitors CPU usage and alerts when above 80%"
```

```bash
cli_forge "a tool to batch rename files using regex patterns"
```

Manage your generated tools:

```bash
cli_forge list              # List all generated tools
cli_forge remove <name>     # Remove a tool
```

### Learning Mode - Learn Ruby by Building

Start your Ruby learning journey:

```bash
# See all lessons
cli_forge learn list

# Start the first lesson
cli_forge learn start hello-world

# Test your solution
cli_forge learn test hello-world

# Get hints when stuck
cli_forge learn hint hello-world

# Check your progress
cli_forge learn status
```

**No API key needed for learning mode!** Jump right in:

```bash
cli_forge learn list
```

📚 **[Read the Complete Learning Guide](LEARNING_GUIDE.md)** for detailed tutorials and tips.

### Get Help

```bash
cli_forge --help
```

## Examples

### Example 1: System Monitor

```bash
cli_forge "create a system monitor that shows CPU, memory, and disk usage"
```

This generates a tool that displays real-time system statistics.

### Example 2: File Converter

```bash
cli_forge "a tool that converts between JSON, YAML, and XML formats"
```

Creates a multi-format file converter with proper error handling.

### Example 3: Git Helper

```bash
cli_forge "a tool that shows git branch status with pretty colors"
```

Generates a git utility with colored output.

### Example 4: Text Processor

```bash
cli_forge "a tool that counts words, lines, and characters in files"
```

Creates a text analysis tool similar to `wc` but with more features.

## Generated Tool Features

All generated tools include:

- ✅ Proper shebang (`#!/usr/bin/env ruby`)
- ✅ `--help` and `--version` flags
- ✅ Error handling with meaningful messages
- ✅ Unix exit codes (0 for success, non-zero for errors)
- ✅ Proper stdout/stderr usage
- ✅ Clear code comments
- ✅ Self-contained with minimal dependencies

## How It Works

1. **Describe** - You provide a natural language description of your CLI tool
2. **Generate** - CLI Forge sends your description to Claude AI
3. **Create** - The AI generates complete, production-ready Ruby code
4. **Install** - The tool is automatically installed to `~/.local/bin`
5. **Use** - Your new CLI tool is ready to use!

## Architecture

```
cli_forge.rb          # Main application
├── CLIForge class    # Core logic
├── AI Integration    # Claude API calls
├── Code Parser       # Extract and validate generated code
└── Tool Manager      # Install, list, and remove tools
```

## Advanced Usage

### Custom Installation Directory

By default, tools are installed to `~/.local/bin`. This is set in the `CLIForge` class and can be modified if needed.

### Tool Metadata

CLI Forge tracks generated tools in `~/.local/bin/.cli_forge_tools.json` with metadata including:
- Tool name
- Description
- Creation timestamp
- Generator version

## Troubleshooting

### "ANTHROPIC_API_KEY not set"

Make sure you've exported your API key:
```bash
export ANTHROPIC_API_KEY='your-key'
```

### "Command not found: cli_forge"

Ensure `~/.local/bin` is in your PATH:
```bash
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```

### "Permission denied"

Make sure the script is executable:
```bash
chmod +x ~/.local/bin/cli_forge
```

## Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## License

MIT License - feel free to use and modify as needed.

## Credits

Built with ❤️ using Ruby and Claude AI.

---

**Note**: This tool generates code using AI. Always review generated tools before use in production environments.
