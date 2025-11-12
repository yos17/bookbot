#!/bin/bash
# CLI Forge Installation Script

set -e

echo "🔧 Installing CLI Forge..."

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    *)          OS_TYPE="UNKNOWN:$OS";;
esac

echo "📋 Detected OS: $OS_TYPE"

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "❌ Error: Ruby is not installed"
    echo "Please install Ruby first:"
    if [ "$OS_TYPE" = "Mac" ]; then
        echo "  brew install ruby"
    elif [ "$OS_TYPE" = "Linux" ]; then
        echo "  sudo apt-get install ruby (Debian/Ubuntu)"
        echo "  sudo yum install ruby (RedHat/CentOS)"
    fi
    exit 1
fi

RUBY_VERSION=$(ruby -v)
echo "✅ Ruby found: $RUBY_VERSION"

# Set installation directory
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Copy the main script and learning module
echo "📦 Installing cli_forge to $INSTALL_DIR..."
cp cli_forge.rb "$INSTALL_DIR/cli_forge"
cp dynamic_tutor.rb "$INSTALL_DIR/dynamic_tutor.rb"
chmod +x "$INSTALL_DIR/cli_forge"

echo "✅ CLI Forge installed successfully!"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Add the installation directory to your PATH (if not already):"
echo "   echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.bashrc"
echo "   source ~/.bashrc"
echo ""
echo "2. Set your Anthropic API key (required):"
echo "   export ANTHROPIC_API_KEY='your-api-key-here'"
echo "   # Add to ~/.bashrc or ~/.zshrc to make it permanent"
echo ""
echo "3. Choose your mode:"
echo ""
echo "   🎓 LEARNING MODE - Learn by building what YOU want!"
echo "   Describe your project and AI creates a custom tutorial:"
echo "     cli_forge learn build 'a JSON to YAML converter'"
echo "     cli_forge learn build 'a grep clone with colors'"
echo ""
echo "   🚀 GENERATE MODE - Get instant results"
echo "   Generate a complete tool:"
echo "     cli_forge 'a tool that shows disk usage in a pretty format'"
echo ""
echo "4. Get help anytime:"
echo "   cli_forge --help"
echo ""
echo "🎉 Happy coding!"
