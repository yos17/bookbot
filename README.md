# CLI Forge 🔨

An AI-powered tool generator for Unix command line utilities, built with Ruby. Similar to Bolt/Lovable but specifically designed for creating CLI tools through natural language descriptions.

**NEW**: 🎓 **Dynamic Learning Mode** - AI creates personalized Ruby tutorials based on what YOU want to build!

## What is CLI Forge?

CLI Forge has **two modes** to help you build amazing CLI tools:

### 🚀 Generate Mode (Default)
AI (Claude) generates production-ready command line tools instantly from natural language descriptions. Just describe what you want, and CLI Forge creates a fully functional Unix CLI tool for you!

### 🎓 Learning Mode (NEW!)
Want to learn instead of just generate? Describe any CLI tool you want to build, and AI creates a **personalized step-by-step curriculum** just for you! Learn Ruby by building exactly what interests you.

## Features

### Generate Mode
✨ **AI-Powered Generation** - Describe your tool in plain English
🚀 **Production Ready** - Generated tools include proper error handling, help text, and Unix conventions
📦 **Self-Contained** - Minimal dependencies, tools just work
🔧 **Easy Management** - List, install, and remove generated tools
💎 **Ruby-Based** - Clean, readable, maintainable code

### Learning Mode
🎯 **Custom Curriculum** - AI generates lessons based on YOUR project idea
📚 **Step-by-Step Guidance** - Break complex tools into manageable steps
✅ **Automated Testing** - Test each step with instant feedback
💡 **Dynamic Hints** - AI-generated hints specific to your project
📊 **Progress Tracking** - Track your journey through each step
🔄 **Compare & Learn** - See AI's solution vs yours
🛠️ **Your Choice** - Learn by building what YOU want to build

## Installation

### Prerequisites

- Ruby 2.7 or higher
- An Anthropic API key ([get one here](https://console.anthropic.com/)) - Required for both modes

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

### Learning Mode - Learn by Building What You Want

Describe what you want to learn to build, and AI creates a custom curriculum:

```bash
# Start learning - describe YOUR project
cli_forge learn build "a tool that converts JSON to YAML"

# Work through the steps
# Edit your code: ~/.cli_forge/learning/<project>.rb

# Test your current step
cli_forge learn test

# Get hints when stuck
cli_forge learn hint

# Move to next step when ready
cli_forge learn next

# Check your progress
cli_forge learn status

# Compare with AI's solution
cli_forge learn code
```

**The AI adapts to YOUR learning goals!** Want to build a grep clone? System monitor? JSON parser? Just describe it and start learning!

**Examples:**
```bash
cli_forge learn build "a grep-like tool with regex support"
cli_forge learn build "a system resource monitor with colors"
cli_forge learn build "a markdown to HTML converter"
cli_forge learn build "a git wrapper with shortcuts"
```

📚 **[Read the Dynamic Learning Guide](DYNAMIC_LEARNING.md)** for complete details, tips, and examples.

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
