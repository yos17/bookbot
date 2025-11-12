# CLI Forge Learning Mode 🎓

Learn Ruby programming by building real command-line tools! CLI Forge's learning mode provides interactive, step-by-step tutorials that teach you Ruby fundamentals through practical projects.

## Why Learning Mode?

- **Learn by Doing**: Build real CLI tools, not toy examples
- **Instant Feedback**: Test your code as you write it
- **Progressive Difficulty**: Start simple, build up skills
- **No Setup Required**: No API key needed for learning mode
- **Real-World Skills**: Learn patterns used in production code

## Two Ways to Use CLI Forge

### 🚀 Generate Mode (Default)
Want a tool instantly? Just describe it and AI generates the code.

```bash
cli_forge "a tool that converts JSON to YAML"
```

**Perfect for**: Getting work done quickly, seeing examples, production use

### 🎓 Learning Mode
Want to learn Ruby? Follow interactive tutorials and build tools yourself.

```bash
cli_forge learn list
cli_forge learn start hello-world
```

**Perfect for**: Learning Ruby, understanding how CLI tools work, skill building

## Getting Started with Learning Mode

### 1. See Available Lessons

```bash
cli_forge learn list
```

This shows all lessons, their IDs, and what concepts they teach.

### 2. Start Your First Lesson

```bash
cli_forge learn start hello-world
```

This will:
- Display lesson objectives and concepts
- Create a workspace file with starter code
- Show you what to build

### 3. Work on Your Code

Open the workspace file (location shown when you start):

```bash
# Usually at:
vim ~/.cli_forge/workspace/hello-world.rb
# or
code ~/.cli_forge/workspace/hello-world.rb
```

Complete the TODOs and implement the features.

### 4. Test Your Solution

```bash
cli_forge learn test hello-world
```

This runs automated tests against your code and shows:
- ✅ Tests that pass
- ❌ Tests that fail (with details)
- What to fix

### 5. Get Help When Stuck

```bash
cli_forge learn hint hello-world
```

Shows progressive hints without giving away the solution.

### 6. Check Your Progress

```bash
cli_forge learn status
```

Shows which lessons you've completed and what's in progress.

## Learning Path

### Lesson 1: Hello CLI World
**Concepts**: puts, variables, string interpolation, shebang
**Build**: A greeting tool that introduces Ruby basics

Start here if you're new to Ruby!

### Lesson 2: File Reader
**Concepts**: File I/O, ARGV, error handling, begin/rescue
**Build**: A tool that reads and displays file contents

Learn to work with files and handle errors gracefully.

### Lesson 3: Argument Parser
**Concepts**: ARGV parsing, conditionals, case/when, flags
**Build**: A tool with --help and --version flags

Make your tools user-friendly with proper argument handling.

### Lesson 4: JSON Processor
**Concepts**: JSON parsing, hashes, arrays, iteration
**Build**: A tool that reads and manipulates JSON data

Essential for modern CLI tools that work with structured data.

### Lesson 5: Text Processor
**Concepts**: Regular expressions, gsub, scan, string methods
**Build**: A tool that searches and transforms text

Master text manipulation and pattern matching.

### Lesson 6: System Monitor
**Concepts**: System calls, backticks, formatting, loops
**Build**: A tool that displays system statistics

Learn to interact with the operating system and format output.

## How Each Lesson Works

### Lesson Structure

1. **Introduction**: What you'll build and why it matters
2. **Objectives**: Specific skills you'll learn
3. **Tutorial**: Explanation of concepts with examples
4. **Starter Code**: File with TODOs to guide you
5. **Tests**: Automated tests to check your work
6. **Hints**: Progressive help when you're stuck
7. **Solution**: Full working code (last resort!)

### Learning Workflow

```
Start Lesson → Read Tutorial → Write Code → Test → (Fail?) → Get Hints → Iterate → Pass!
```

### Testing Philosophy

Tests check that your code:
- Works correctly
- Handles errors
- Follows Ruby conventions
- Implements required features

Don't worry about failing tests - that's part of learning!

## Tips for Success

### 1. Read the Tutorial First
Each lesson includes a tutorial section with examples. Read it before coding!

### 2. Test Early and Often
Run tests frequently to catch mistakes early:
```bash
cli_forge learn test <lesson-id>
```

### 3. Use Hints Strategically
Stuck for 10+ minutes? Get a hint:
```bash
cli_forge learn hint <lesson-id>
```

### 4. Try Before Looking at Solutions
The solution is always available, but try to solve it yourself first!
```bash
cli_forge learn solution <lesson-id>
```

### 5. Experiment
Modify the code, break things, see what happens. That's how you learn!

### 6. Read Error Messages
Ruby's error messages are helpful. They tell you:
- What went wrong
- Where it happened (file and line)
- How to fix it

### 7. Compare with Generate Mode
After completing a lesson, generate a similar tool with AI and compare approaches:
```bash
cli_forge "a tool that reads files and displays them"
```

## Command Reference

```bash
# List all lessons
cli_forge learn list

# Start a lesson
cli_forge learn start <lesson-id>

# Test your solution
cli_forge learn test <lesson-id>

# Get hints
cli_forge learn hint <lesson-id>

# Show solution
cli_forge learn solution <lesson-id>

# Check progress
cli_forge learn status

# Reset a lesson
cli_forge learn reset <lesson-id>

# Reset all progress
cli_forge learn reset
```

## Workspace Organization

Your work is saved in `~/.cli_forge/`:

```
~/.cli_forge/
├── lessons/          # Lesson data (auto-created)
│   ├── hello-world.json
│   ├── file-reader.json
│   └── ...
├── workspace/        # Your code
│   ├── hello-world.rb
│   ├── file-reader.rb
│   └── ...
└── progress.json     # Your progress tracking
```

## After Completing Lessons

### You'll Know How To:
- Write Ruby CLI tools from scratch
- Handle command-line arguments
- Work with files and JSON
- Process text with regex
- Interact with the system
- Handle errors gracefully
- Write clean, maintainable code

### Next Steps:
1. **Build Your Own Tool**: Use the generate mode for inspiration, but code it yourself
2. **Read Real Code**: Explore Ruby gems and CLI tools on GitHub
3. **Contribute**: Make your tools open source
4. **Keep Learning**: Ruby has much more to explore (classes, modules, gems, testing)

## Troubleshooting

### "Lesson not found"
Check available lessons:
```bash
cli_forge learn list
```

### "Workspace file not found"
Start the lesson first:
```bash
cli_forge learn start <lesson-id>
```

### Tests failing
1. Read the error message carefully
2. Check what was expected vs what you got
3. Use hints: `cli_forge learn hint <lesson-id>`
4. Review the tutorial section

### Want to start over
Reset a lesson:
```bash
cli_forge learn reset <lesson-id>
```

### Ruby syntax errors
- Check for matching quotes, parentheses, and end keywords
- Make sure variables are defined before use
- Check indentation (Ruby is sensitive to structure)

## Learning Resources

### Ruby Documentation
- [Ruby-Doc.org](https://ruby-doc.org/)
- [Ruby API](https://rubyapi.org/)

### Style Guide
- [Ruby Style Guide](https://rubystyle.guide/)

### More Practice
- [Exercism Ruby Track](https://exercism.org/tracks/ruby)
- [Ruby Koans](http://rubykoans.com/)

## Philosophy

**CLI Forge Learning Mode believes:**
- Real projects are better than contrived exercises
- Immediate feedback accelerates learning
- Struggling is part of the process
- Building tools you can use is motivating
- Ruby is a beautiful language worth learning well

## Community and Support

Have questions? Found a bug? Want to suggest a lesson?
- Open an issue on GitHub
- Share what you've built
- Help other learners

## Ready to Start?

```bash
# See all lessons
cli_forge learn list

# Begin your journey
cli_forge learn start hello-world

# Happy learning! 🚀
```

---

Remember: Every expert was once a beginner. The only difference is they kept learning and practicing. You've got this! 💪
