# Contributing to CLI Forge

Thank you for considering contributing to CLI Forge! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes
6. Commit with clear messages
7. Push to your fork
8. Open a Pull Request

## Development Setup

### Prerequisites

- Ruby 2.7 or higher
- Git
- An Anthropic API key for testing

### Local Development

```bash
# Clone the repo
git clone <your-fork>
cd bookbot

# Make cli_forge executable
chmod +x cli_forge.rb

# Test locally
./cli_forge.rb --help
```

## Code Style

- Follow Ruby best practices
- Use 2 spaces for indentation
- Keep lines under 100 characters when possible
- Add comments for complex logic
- Use meaningful variable names

## Testing

Before submitting a PR:

1. **Syntax Check**
   ```bash
   ruby -c cli_forge.rb
   ```

2. **Basic Functionality**
   ```bash
   ./cli_forge.rb --help
   ./cli_forge.rb --version
   ./cli_forge.rb list
   ```

3. **Generate a Test Tool**
   ```bash
   export ANTHROPIC_API_KEY='your-key'
   ./cli_forge.rb "a simple test tool that echoes hello world"
   ```

## What to Contribute

### Bug Fixes
- Fix issues listed in GitHub Issues
- Include test case if applicable
- Explain the bug and your fix in the PR

### New Features
- Discuss large features in an issue first
- Keep features focused and modular
- Update documentation
- Add examples if applicable

### Documentation
- Fix typos or unclear explanations
- Add examples
- Improve setup instructions
- Add troubleshooting tips

### Examples
- Add real-world use cases to EXAMPLES.md
- Include the prompt and expected output
- Explain when to use the example

## Pull Request Process

1. **Update Documentation**: If you change functionality, update README.md
2. **Add Examples**: If applicable, add to EXAMPLES.md
3. **Test**: Ensure your changes work
4. **Clear Description**: Explain what and why in the PR description
5. **Single Purpose**: One feature/fix per PR

## Commit Messages

Write clear commit messages:

```
Good:
- "Add support for custom installation directory"
- "Fix API error handling for rate limits"
- "Update README with troubleshooting section"

Bad:
- "fix bug"
- "update stuff"
- "changes"
```

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn

## Feature Requests

Have an idea? Open an issue with:
- Clear description of the feature
- Use case / why it's needed
- Proposed implementation (if you have one)

## Bug Reports

Found a bug? Open an issue with:
- What you expected
- What actually happened
- Steps to reproduce
- Ruby version and OS
- CLI Forge version

## Questions

- Check existing issues first
- Open a new issue for questions
- Tag with "question" label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Every contribution helps make CLI Forge better. Thank you for your time and effort! 🙏
