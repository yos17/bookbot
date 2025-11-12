# Dynamic Learning Mode 🎓

## The Ultimate Personalized Ruby Learning Experience

CLI Forge's Dynamic Learning Mode uses AI to create **custom step-by-step tutorials** based on exactly what YOU want to build. No more generic lessons - learn by building projects that interest you!

## How It Works

```
You: "I want to build a grep-like tool with regex"
  ↓
AI: Analyzes your request
  ↓
AI: Creates 4-6 progressive steps
  ↓
You: Build each step with guidance
  ↓
AI: Tests your code at each step
  ↓
You: Learn by doing!
```

## Quick Start

### 1. Describe What You Want to Build

```bash
cli_forge learn build "a tool that converts JSON to YAML"
```

The AI will:
- Break your project into 4-6 learning steps
- Identify Ruby concepts you'll learn
- Create starter code for each step
- Generate tests to validate your work
- Provide progressive hints

### 2. Build Step by Step

The AI creates a workspace file for you:
```bash
~/.cli_forge/learning/json-yaml-converter.rb
```

Open it and complete the TODOs for the current step.

### 3. Test Your Code

```bash
cli_forge learn test
```

Get instant feedback:
- ✅ Tests pass → Move to next step!
- ❌ Tests fail → See what needs fixing

### 4. Get Help When Stuck

```bash
cli_forge learn hint
```

Progressive hints that guide without spoiling:
- Hint 1: General direction
- Hint 2: More specific
- Hint 3: Almost the solution

### 5. Move Forward

```bash
cli_forge learn next
```

Advances to the next step in your curriculum.

### 6. Track Progress

```bash
cli_forge learn status
```

See your learning journey:
- ✅ Completed steps
- 🔄 Current step
- ⭕ Upcoming steps

### 7. Compare Solutions

```bash
cli_forge learn code
```

See how the AI would implement it:
- Compare approaches
- Learn alternative techniques
- Understand different patterns

## Example Learning Session

```bash
# Start learning
$ cli_forge learn build "a system monitor with colored output"

🎓 Creating your personalized learning path...
📝 Project: a system monitor with colored output

============================================================
📚 Step 1/5: Basic Ruby Setup and Output
============================================================

📖 Overview:
  Create the basic script structure with colored output support

💡 Concepts You'll Learn:
  • Ruby script structure and shebang
  • String formatting
  • ANSI color codes
  • Basic output with puts

✅ Your Tasks:
  1. Add proper shebang line
  2. Define color constants using ANSI codes
  3. Create a method to print colored text
  4. Test colored output

📁 Workspace: ~/.cli_forge/learning/system-monitor.rb

▶️  Next Steps:
  1. Edit: ~/.cli_forge/learning/system-monitor.rb
  2. Complete the tasks above
  3. Test: cli_forge learn test
  4. When tests pass: cli_forge learn next

💭 Need help? cli_forge learn hint

# You edit the file...

# Test your work
$ cli_forge learn test

🧪 Testing Step 1: Basic Ruby Setup and Output
✅ All tests passed!
🎉 Great job! Ready for the next step?
   Run: cli_forge learn next

# Move forward
$ cli_forge learn next

============================================================
📚 Step 2/5: System Information Gathering
============================================================
...
```

## What You Can Learn to Build

### System Tools
```bash
cli_forge learn build "a process monitor like top"
cli_forge learn build "a disk usage analyzer with charts"
cli_forge learn build "a network connection tracker"
```

### Text Processing
```bash
cli_forge learn build "a grep clone with regex and colors"
cli_forge learn build "a markdown to HTML converter"
cli_forge learn build "a log file analyzer"
```

### Data Tools
```bash
cli_forge learn build "a JSON to YAML converter"
cli_forge learn build "a CSV processor and filter"
cli_forge learn build "a config file manager"
```

### Development Tools
```bash
cli_forge learn build "a git wrapper with shortcuts"
cli_forge learn build "a code snippet manager"
cli_forge learn build "a test result formatter"
```

### Custom Projects
Literally anything! Describe your idea and the AI will teach you how to build it.

## Learning Philosophy

### Learn What YOU Want
No forced curriculum. Build tools that actually interest you.

### Progressive Difficulty
The AI breaks complex projects into manageable steps, teaching concepts in logical order.

### Real-World Skills
Learn by building actual tools, not contrived examples. Your projects are usable when done!

### Instant Feedback
Test after each step. Know immediately if you're on the right track.

### Multiple Attempts
Failed tests aren't failures - they're learning opportunities. Try again with hints!

### Compare and Learn
See how an expert (AI) would solve it. Learn alternative approaches.

## Commands Reference

```bash
# Start a new learning project
cli_forge learn build "<description>"

# Test your current step
cli_forge learn test

# Get a hint
cli_forge learn hint

# Move to next step
cli_forge learn next

# Check progress
cli_forge learn status

# See AI's complete solution
cli_forge learn code

# Start over
cli_forge learn reset
```

## Tips for Success

### 1. Be Specific in Your Description
**Good:**
```bash
cli_forge learn build "a grep tool that searches files with regex and highlights matches"
```

**Less Good:**
```bash
cli_forge learn build "a search tool"
```

### 2. Test Frequently
Don't wait until you think everything is done. Test after small changes.

### 3. Read Error Messages
Ruby's error messages are helpful! They tell you what's wrong and where.

### 4. Use Hints Strategically
Stuck for 5-10 minutes? Get a hint. Learning is about progress, not suffering.

### 5. Experiment
Try different approaches. Break things. See what happens. That's learning!

### 6. Compare Solutions
After completing, look at the AI's solution. Notice differences. Learn alternative patterns.

### 7. Build Multiple Projects
The more you build, the more you learn. Try variations on themes.

## How the AI Creates Your Curriculum

When you request a project, the AI:

1. **Analyzes Complexity** - Determines appropriate difficulty level
2. **Identifies Concepts** - Lists Ruby features needed
3. **Creates Steps** - Breaks into 4-6 progressive steps
4. **Sequences Learning** - Orders concepts logically
5. **Generates Code** - Creates starter code with TODOs
6. **Designs Tests** - Builds validation for each step
7. **Crafts Hints** - Prepares progressive guidance

Each curriculum is **unique to your project**!

## What You'll Learn

Depending on your projects, you'll master:

- Ruby fundamentals (variables, methods, classes)
- Command-line argument parsing
- File I/O and manipulation
- Error handling and exceptions
- Regular expressions
- Data structures (arrays, hashes)
- JSON/YAML/CSV parsing
- System interaction
- String manipulation
- Testing and debugging
- Code organization
- Ruby idioms and best practices

## Workflow Example

```
Day 1: Build a file searcher
  → Learn: File I/O, recursion, filtering

Day 2: Build a JSON formatter
  → Learn: JSON parsing, pretty printing, error handling

Day 3: Build a system monitor
  → Learn: System calls, formatting, loops, colors

Day 4: Build a git helper
  → Learn: Running commands, parsing output, user interaction

Week 2: Build your own ideas!
```

## Advantages Over Static Lessons

| Static Lessons | Dynamic Learning |
|----------------|------------------|
| Fixed curriculum | You choose projects |
| Generic examples | Your interests |
| One path | Infinite paths |
| May bore you | Always engaging |
| Linear difficulty | Adaptive to you |

## Troubleshooting

### AI Creates Too Many/Few Steps
The AI adapts to project complexity. Trust the process - you can always ask for hints if a step is too hard.

### Tests Are Too Strict
Tests validate core functionality. If tests fail, there's usually a real issue to fix.

### Want to Skip a Step
Use `cli_forge learn next` but try completing steps - they build on each other!

### Stuck on a Step
1. Run tests to see what's failing
2. Get hints: `cli_forge learn hint`
3. Review step objectives
4. Try a simpler approach
5. Check the AI solution: `cli_forge learn code`

## After Completing a Project

### You've Built Something Real!
Your tool works! Install it, use it, share it!

### Compare Approaches
```bash
cli_forge learn code  # See AI's solution
# Compare with your code
# Notice differences
# Learn alternative patterns
```

### Try Variations
```bash
cli_forge learn build "a grep tool with case-insensitive search"
cli_forge learn build "a grep tool with line numbers"
cli_forge learn build "a grep tool with context lines"
```

### Build Something New
```bash
cli_forge learn build "<your next idea>"
```

## Philosophy

**Dynamic Learning Mode believes:**

- You learn best when motivated by YOUR interests
- Building real projects > abstract exercises
- Immediate feedback accelerates learning
- Multiple attempts are part of learning
- Seeing expert solutions enhances understanding
- Every developer's path is unique
- Ruby is beautiful when learned through creation

## Ready to Start?

```bash
# Describe ANY CLI tool you want to build
cli_forge learn build "your amazing project idea"

# The AI will teach you step by step!
```

---

**Remember:** Every expert started as a beginner. The difference? They kept building and learning. Your journey starts now! 🚀
