# CLI Forge Examples

Real-world examples of tools you can generate with CLI Forge.

## Quick Examples

### 1. JSON to YAML Converter

```bash
cli_forge "a tool that converts JSON files to YAML format"
```

Generated tool usage:
```bash
json-to-yaml input.json output.yaml
```

### 2. Disk Usage Analyzer

```bash
cli_forge "a tool that analyzes disk usage and displays top 10 largest directories"
```

Generated tool usage:
```bash
disk-analyzer /home/user
```

### 3. Git Branch Cleaner

```bash
cli_forge "a tool that lists merged git branches and offers to delete them"
```

Generated tool usage:
```bash
git-branch-cleaner
```

### 4. Log File Monitor

```bash
cli_forge "a tool that monitors log files for errors and sends notifications"
```

Generated tool usage:
```bash
log-monitor /var/log/app.log
```

### 5. Environment Variable Manager

```bash
cli_forge "a tool to manage and switch between different .env file configurations"
```

Generated tool usage:
```bash
env-manager switch production
env-manager list
```

## Advanced Examples

### 6. API Testing Tool

```bash
cli_forge "a tool that makes HTTP requests with different methods and pretty-prints JSON responses with syntax highlighting"
```

Features you might get:
- GET, POST, PUT, DELETE support
- Header management
- JSON response formatting
- Status code handling

### 7. Database Backup Script

```bash
cli_forge "a tool that creates timestamped backups of PostgreSQL databases with compression"
```

Features you might get:
- Automatic timestamping
- Gzip compression
- Cleanup of old backups
- Connection string handling

### 8. Code Statistics Generator

```bash
cli_forge "a tool that analyzes a codebase and generates statistics about lines of code, files by type, and code complexity"
```

Features you might get:
- Language detection
- Line counting
- File type breakdown
- Complexity metrics

### 9. Docker Container Manager

```bash
cli_forge "a tool to quickly start, stop, and monitor Docker containers with a simple interface"
```

Features you might get:
- Container listing
- Quick start/stop
- Resource monitoring
- Log tailing

### 10. Text File Diffing Tool

```bash
cli_forge "a tool that compares two text files and shows colored diff output"
```

Features you might get:
- Side-by-side comparison
- Colored output
- Line-by-line diff
- Summary statistics

## Creative Use Cases

### Development Workflow Tools

```bash
# Start your dev environment
cli_forge "a tool that starts all services needed for development (redis, postgres, etc.)"

# Code review helper
cli_forge "a tool that shows git diff statistics and generates a summary"

# Dependency updater
cli_forge "a tool that checks for outdated npm/gem packages and updates them"
```

### System Administration

```bash
# Service health checker
cli_forge "a tool that pings multiple URLs and reports their status"

# SSL certificate checker
cli_forge "a tool that checks SSL certificate expiration dates for a list of domains"

# Backup verifier
cli_forge "a tool that verifies backup files exist and are not corrupted"
```

### Data Processing

```bash
# CSV to JSON converter
cli_forge "a tool that converts CSV files to JSON with customizable mappings"

# Text processor
cli_forge "a tool that extracts email addresses from text files"

# Data validator
cli_forge "a tool that validates JSON files against a schema"
```

## Tips for Better Prompts

1. **Be Specific**: Include desired inputs and outputs
   ```bash
   cli_forge "a tool that takes a URL and saves the HTML to a file"
   ```

2. **Mention Features**: List key features you want
   ```bash
   cli_forge "a tool to resize images with options for width, height, and format"
   ```

3. **Specify Behavior**: Describe error handling or edge cases
   ```bash
   cli_forge "a tool that retries failed HTTP requests up to 3 times"
   ```

4. **Include Examples**: Give usage examples
   ```bash
   cli_forge "a tool like 'cat' but with syntax highlighting for code files"
   ```

## Combining Tools

Generated tools can be chained with pipes:

```bash
# Generate and use tools together
my-json-generator | json-to-yaml | less
log-monitor app.log | grep ERROR | alert-sender
```

## Customizing Generated Tools

All generated tools are editable. Find them at:
```bash
~/.local/bin/<tool-name>
```

Edit with your favorite editor:
```bash
vim ~/.local/bin/my-tool
nano ~/.local/bin/my-tool
```

## Sharing Tools

Generated tools are standalone Ruby scripts. Share them easily:

```bash
# Copy to another machine
scp ~/.local/bin/my-tool user@server:~/bin/

# Version control
cp ~/.local/bin/my-tool ~/projects/scripts/
git add my-tool
git commit -m "Add my custom tool"
```

## Next Steps

- Try generating tools for your daily workflows
- Combine multiple tools for complex tasks
- Share useful tools with your team
- Contribute examples back to the community

Happy tool building! 🔨
