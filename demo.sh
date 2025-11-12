#!/bin/bash
# CLI Forge Demo Script
# This script demonstrates CLI Forge capabilities

echo "========================================"
echo "CLI Forge Demo"
echo "========================================"
echo ""

# Check if cli_forge is installed
if ! command -v cli_forge &> /dev/null; then
    echo "⚠️  cli_forge is not installed or not in PATH"
    echo "Run ./install.sh first"
    exit 1
fi

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "⚠️  ANTHROPIC_API_KEY is not set"
    echo "Set it with: export ANTHROPIC_API_KEY='your-key'"
    exit 1
fi

echo "🔧 CLI Forge is ready!"
echo ""

# Demo 1: Show help
echo "📖 Demo 1: Showing help"
echo "Command: cli_forge --help"
echo ""
cli_forge --help
echo ""
read -p "Press Enter to continue..."
echo ""

# Demo 2: Generate a simple tool
echo "🎨 Demo 2: Generate a sample tool"
echo "Command: cli_forge 'a tool that displays a random motivational quote'"
echo ""
read -p "Ready to generate? Press Enter..."
cli_forge "a tool that displays a random motivational quote"
echo ""
read -p "Press Enter to continue..."
echo ""

# Demo 3: List tools
echo "📋 Demo 3: List generated tools"
echo "Command: cli_forge list"
echo ""
cli_forge list
echo ""
read -p "Press Enter to continue..."
echo ""

# Demo 4: Show what tools you could create
echo "💡 Demo 4: Ideas for tools you can create"
echo ""
echo "Try these commands:"
echo ""
echo "  cli_forge 'a tool that converts markdown to HTML'"
echo "  cli_forge 'a tool that monitors CPU usage'"
echo "  cli_forge 'a tool that renames files in batch'"
echo "  cli_forge 'a tool that prettifies JSON files'"
echo "  cli_forge 'a tool that generates random passwords'"
echo ""

echo "========================================"
echo "Demo complete! 🎉"
echo "========================================"
echo ""
echo "Now try creating your own tools!"
