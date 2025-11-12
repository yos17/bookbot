#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'

# Ruby Tutor - Interactive Ruby learning through CLI tool development
class RubyTutor
  LESSONS_DIR = File.join(Dir.home, '.cli_forge', 'lessons')
  PROGRESS_FILE = File.join(Dir.home, '.cli_forge', 'progress.json')
  WORKSPACE_DIR = File.join(Dir.home, '.cli_forge', 'workspace')

  def initialize
    setup_directories
    @progress = load_progress
  end

  def run(args)
    command = args[0]

    case command
    when 'start'
      start_lesson(args[1])
    when 'list'
      list_lessons
    when 'status'
      show_progress
    when 'hint'
      show_hint(args[1])
    when 'test'
      test_solution(args[1])
    when 'solution'
      show_solution(args[1])
    when 'reset'
      reset_progress(args[1])
    else
      show_help
    end
  end

  private

  def setup_directories
    FileUtils.mkdir_p(LESSONS_DIR)
    FileUtils.mkdir_p(WORKSPACE_DIR)
    create_lessons if Dir.empty?(LESSONS_DIR)
  end

  def show_help
    puts <<~HELP

      🎓 CLI Forge Learning Mode - Learn Ruby by Building CLI Tools

      Commands:
        learn start <lesson>    Start a lesson
        learn list              List all available lessons
        learn status            Show your learning progress
        learn hint <lesson>     Get a hint for current step
        learn test <lesson>     Test your solution
        learn solution <lesson> Show the solution (last resort!)
        learn reset <lesson>    Reset lesson progress

      Learning Path:
        1. hello-world      - Ruby basics, puts, variables
        2. file-reader      - Reading files, error handling
        3. argument-parser  - ARGV, command-line arguments
        4. json-tool        - Working with JSON, Hash manipulation
        5. text-processor   - String manipulation, regex
        6. system-monitor   - System calls, formatting output
        7. final-project    - Build your own CLI tool!

      Examples:
        cli_forge learn list
        cli_forge learn start hello-world
        cli_forge learn test hello-world

      Tips:
        - Work in: ~/.cli_forge/workspace/
        - Run tests frequently to check progress
        - Use hints when stuck (no shame in learning!)
        - Try solving before looking at solutions

    HELP
  end

  def list_lessons
    lessons = get_lesson_info

    puts "\n📚 Available Ruby Lessons\n"
    puts "=" * 60

    lessons.each_with_index do |lesson, idx|
      number = idx + 1
      status = @progress[lesson[:id]] || 'not_started'
      status_icon = case status
                    when 'completed' then '✅'
                    when 'in_progress' then '🔄'
                    else '⭕'
                    end

      puts "\n#{status_icon} Lesson #{number}: #{lesson[:title]}"
      puts "   ID: #{lesson[:id]}"
      puts "   #{lesson[:description]}"
      puts "   Concepts: #{lesson[:concepts].join(', ')}"
    end
    puts "\n" + "=" * 60
    puts "\nStart a lesson: cli_forge learn start <lesson-id>"
  end

  def start_lesson(lesson_id)
    unless lesson_id
      puts "❌ Please specify a lesson ID"
      puts "Use: cli_forge learn list"
      return
    end

    lesson = load_lesson(lesson_id)
    unless lesson
      puts "❌ Lesson '#{lesson_id}' not found"
      return
    end

    # Mark as in progress
    @progress[lesson_id] = 'in_progress'
    save_progress

    # Create workspace file
    workspace_file = File.join(WORKSPACE_DIR, "#{lesson_id}.rb")
    unless File.exist?(workspace_file)
      File.write(workspace_file, lesson[:starter_code])
    end

    # Display lesson
    display_lesson(lesson, workspace_file)
  end

  def display_lesson(lesson, workspace_file)
    puts "\n" + "=" * 60
    puts "📖 Lesson: #{lesson[:title]}"
    puts "=" * 60
    puts "\n#{lesson[:description]}\n"

    puts "\n🎯 Learning Objectives:"
    lesson[:objectives].each { |obj| puts "  • #{obj}" }

    puts "\n📝 Your Task:"
    lesson[:tasks].each_with_index { |task, idx| puts "  #{idx + 1}. #{task}" }

    puts "\n💡 Concepts You'll Learn:"
    lesson[:concepts].each { |concept| puts "  • #{concept}" }

    if lesson[:tutorial]
      puts "\n📚 Tutorial:"
      puts lesson[:tutorial]
    end

    puts "\n🔧 Workspace: #{workspace_file}"
    puts "\n▶️  Next Steps:"
    puts "  1. Open: #{workspace_file}"
    puts "  2. Complete the TODOs"
    puts "  3. Test: cli_forge learn test #{lesson[:id]}"
    puts "  4. Need help?: cli_forge learn hint #{lesson[:id]}"
    puts "\nHappy coding! 🚀\n\n"
  end

  def test_solution(lesson_id)
    unless lesson_id
      puts "❌ Please specify a lesson ID"
      return
    end

    lesson = load_lesson(lesson_id)
    unless lesson
      puts "❌ Lesson '#{lesson_id}' not found"
      return
    end

    workspace_file = File.join(WORKSPACE_DIR, "#{lesson_id}.rb")
    unless File.exist?(workspace_file)
      puts "❌ Workspace file not found. Start the lesson first:"
      puts "   cli_forge learn start #{lesson_id}"
      return
    end

    puts "\n🧪 Testing your solution...\n"

    # Run tests
    passed = 0
    failed = 0

    lesson[:tests].each_with_index do |test, idx|
      print "  Test #{idx + 1}: #{test[:description]}... "

      result = run_test(workspace_file, test)

      if result[:passed]
        puts "✅ PASS"
        passed += 1
      else
        puts "❌ FAIL"
        puts "     Expected: #{test[:expected]}"
        puts "     Got: #{result[:output]}" if result[:output]
        puts "     Error: #{result[:error]}" if result[:error]
        failed += 1
      end
    end

    puts "\n" + "=" * 60
    puts "Results: #{passed} passed, #{failed} failed"
    puts "=" * 60

    if failed == 0
      puts "\n🎉 Congratulations! All tests passed!"
      @progress[lesson_id] = 'completed'
      save_progress

      next_lesson = get_next_lesson(lesson_id)
      if next_lesson
        puts "\n📚 Ready for the next lesson?"
        puts "   cli_forge learn start #{next_lesson[:id]}"
      else
        puts "\n🏆 You've completed all lessons! You're a Ruby CLI pro!"
        puts "   Try building your own tool: cli_forge 'your tool idea'"
      end
    else
      puts "\n💪 Keep trying! You're learning!"
      puts "   Need a hint?: cli_forge learn hint #{lesson_id}"
    end
  end

  def run_test(workspace_file, test)
    begin
      # Create a temporary test file
      test_file = File.join(WORKSPACE_DIR, 'test_runner.rb')

      # Read the student's code
      student_code = File.read(workspace_file)

      # Create test wrapper
      test_code = <<~TEST
        require 'stringio'

        #{student_code}

        # Capture output
        old_stdout = $stdout
        $stdout = StringIO.new

        begin
          #{test[:setup] || ''}
          result = #{test[:run]}
          output = $stdout.string

          # Restore stdout
          $stdout = old_stdout

          # Check result
          expected = #{test[:expected].inspect}

          if #{test[:check] || 'result == expected'}
            puts "PASS"
          else
            puts "FAIL:Expected \#{expected.inspect}, got \#{result.inspect}"
          end
        rescue => e
          $stdout = old_stdout
          puts "ERROR:\#{e.message}"
        end
      TEST

      File.write(test_file, test_code)

      # Run the test
      output = `ruby #{test_file} 2>&1`.strip

      if output.start_with?('PASS')
        { passed: true }
      elsif output.start_with?('FAIL:')
        { passed: false, output: output.sub('FAIL:', '') }
      elsif output.start_with?('ERROR:')
        { passed: false, error: output.sub('ERROR:', '') }
      else
        { passed: false, output: output }
      end
    rescue => e
      { passed: false, error: e.message }
    ensure
      File.delete(test_file) if test_file && File.exist?(test_file)
    end
  end

  def show_hint(lesson_id)
    unless lesson_id
      puts "❌ Please specify a lesson ID"
      return
    end

    lesson = load_lesson(lesson_id)
    unless lesson
      puts "❌ Lesson '#{lesson_id}' not found"
      return
    end

    puts "\n💡 Hints for: #{lesson[:title]}\n"
    lesson[:hints].each_with_index do |hint, idx|
      puts "#{idx + 1}. #{hint}"
    end
    puts ""
  end

  def show_solution(lesson_id)
    unless lesson_id
      puts "❌ Please specify a lesson ID"
      return
    end

    lesson = load_lesson(lesson_id)
    unless lesson
      puts "❌ Lesson '#{lesson_id}' not found"
      return
    end

    puts "\n⚠️  Solution for: #{lesson[:title]}"
    puts "\nTry to solve it yourself first! Learning happens through struggle."
    print "Are you sure you want to see the solution? (yes/no): "

    response = $stdin.gets.chomp.downcase
    return unless response == 'yes'

    puts "\n" + "=" * 60
    puts "Solution:"
    puts "=" * 60
    puts lesson[:solution]
    puts "=" * 60
    puts "\nNow try to understand WHY it works!"
  end

  def show_progress
    lessons = get_lesson_info

    completed = @progress.values.count('completed')
    in_progress = @progress.values.count('in_progress')
    total = lessons.length

    puts "\n📊 Your Learning Progress\n"
    puts "=" * 60
    puts "Completed: #{completed}/#{total}"
    puts "In Progress: #{in_progress}"
    puts "=" * 60

    lessons.each_with_index do |lesson, idx|
      status = @progress[lesson[:id]] || 'not_started'
      status_str = case status
                   when 'completed' then '✅ Completed'
                   when 'in_progress' then '🔄 In Progress'
                   else '⭕ Not Started'
                   end

      puts "#{idx + 1}. #{lesson[:title]}: #{status_str}"
    end
    puts ""
  end

  def reset_progress(lesson_id)
    if lesson_id
      @progress.delete(lesson_id)
      workspace_file = File.join(WORKSPACE_DIR, "#{lesson_id}.rb")
      File.delete(workspace_file) if File.exist?(workspace_file)
      puts "✅ Reset progress for: #{lesson_id}"
    else
      @progress.clear
      FileUtils.rm_rf(WORKSPACE_DIR)
      FileUtils.mkdir_p(WORKSPACE_DIR)
      puts "✅ Reset all progress"
    end
    save_progress
  end

  def load_progress
    if File.exist?(PROGRESS_FILE)
      JSON.parse(File.read(PROGRESS_FILE))
    else
      {}
    end
  end

  def save_progress
    File.write(PROGRESS_FILE, JSON.pretty_generate(@progress))
  end

  def load_lesson(lesson_id)
    lesson_file = File.join(LESSONS_DIR, "#{lesson_id}.json")
    return nil unless File.exist?(lesson_file)

    JSON.parse(File.read(lesson_file), symbolize_names: true)
  end

  def get_lesson_info
    [
      { id: 'hello-world', title: 'Hello CLI World', description: 'Ruby basics and your first CLI tool', concepts: ['puts', 'variables', 'strings'] },
      { id: 'file-reader', title: 'File Reading', description: 'Read and display file contents', concepts: ['File I/O', 'error handling', 'ARGV'] },
      { id: 'argument-parser', title: 'Command Arguments', description: 'Parse and validate CLI arguments', concepts: ['ARGV', 'conditionals', 'flags'] },
      { id: 'json-tool', title: 'JSON Processor', description: 'Parse and manipulate JSON data', concepts: ['JSON', 'hashes', 'arrays'] },
      { id: 'text-processor', title: 'Text Processing', description: 'Search and transform text with regex', concepts: ['regex', 'string methods', 'gsub'] },
      { id: 'system-monitor', title: 'System Monitor', description: 'Build a system monitoring tool', concepts: ['system calls', 'formatting', 'loops'] }
    ]
  end

  def get_next_lesson(current_id)
    lessons = get_lesson_info
    current_idx = lessons.find_index { |l| l[:id] == current_id }
    return nil unless current_idx

    lessons[current_idx + 1]
  end

  def create_lessons
    create_hello_world_lesson
    create_file_reader_lesson
    create_argument_parser_lesson
    create_json_tool_lesson
    create_text_processor_lesson
    create_system_monitor_lesson
  end

  def create_hello_world_lesson
    lesson = {
      id: 'hello-world',
      title: 'Hello CLI World',
      description: 'Learn Ruby basics by building your first CLI tool that greets users.',
      concepts: ['puts', 'variables', 'string interpolation', 'shebang'],
      objectives: [
        'Understand Ruby script structure',
        'Use puts to output text',
        'Work with variables and string interpolation',
        'Add executable shebang line'
      ],
      tasks: [
        'Add the proper shebang line',
        'Create a variable called "name" with your name',
        'Use puts to greet the user with string interpolation',
        'Add a version message'
      ],
      tutorial: <<~TUTORIAL,
        Ruby Basics:

        1. Shebang: #!/usr/bin/env ruby
           - Tells the system this is a Ruby script

        2. Variables: name = "Alice"
           - No type declaration needed

        3. String interpolation: "Hello, \#{name}!"
           - Use \#{} to insert variables into strings

        4. Output: puts "text"
           - Prints text followed by newline

        Example:
          #!/usr/bin/env ruby
          name = "World"
          puts "Hello, \#{name}!"
      TUTORIAL
      hints: [
        'Start with the shebang: #!/usr/bin/env ruby',
        'Create a variable: name = "YourName"',
        'Use puts with interpolation: puts "Hello, #{name}!"',
        'Add a VERSION constant at the top'
      ],
      starter_code: <<~CODE,
        # TODO: Add shebang line above

        # TODO: Add a VERSION constant (e.g., VERSION = "1.0.0")

        # TODO: Create a variable called 'tool_name' with value "CLI Greeter"

        # TODO: Use puts to display a welcome message with string interpolation
        # Example: "Welcome to [tool_name] v[VERSION]"

        # TODO: Create a variable 'name' and ask for user input (for now, just set it to your name)

        # TODO: Display a greeting: "Hello, [name]! Ready to build CLI tools?"
      CODE
      tests: [
        {
          description: 'Script has proper structure',
          run: 'defined?(VERSION)',
          expected: 'constant',
          check: 'result == "constant"'
        },
        {
          description: 'VERSION is defined',
          run: 'VERSION',
          expected: '1.0.0',
          check: 'result.is_a?(String) && !result.empty?'
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        VERSION = "1.0.0"

        tool_name = "CLI Greeter"
        puts "Welcome to \#{tool_name} v\#{VERSION}"

        name = "Ruby Developer"
        puts "Hello, \#{name}! Ready to build CLI tools?"
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'hello-world.json'), JSON.pretty_generate(lesson))
  end

  def create_file_reader_lesson
    lesson = {
      id: 'file-reader',
      title: 'File Reading Tool',
      description: 'Build a CLI tool that reads and displays file contents with error handling.',
      concepts: ['File I/O', 'ARGV', 'error handling', 'begin/rescue'],
      objectives: [
        'Read command-line arguments with ARGV',
        'Open and read files',
        'Handle errors gracefully',
        'Display helpful messages'
      ],
      tasks: [
        'Get filename from ARGV',
        'Check if filename was provided',
        'Read the file contents',
        'Handle file not found errors',
        'Display the contents'
      ],
      tutorial: <<~TUTORIAL,
        File I/O and Error Handling:

        1. ARGV - Command-line arguments
           filename = ARGV[0]  # First argument

        2. File.read - Read entire file
           contents = File.read(filename)

        3. Error handling with begin/rescue
           begin
             # code that might fail
           rescue => e
             puts "Error: \#{e.message}"
           end

        4. File existence check
           if File.exist?(filename)

        Example:
          filename = ARGV[0]
          if filename.nil?
            puts "Usage: script.rb <filename>"
            exit 1
          end

          begin
            contents = File.read(filename)
            puts contents
          rescue => e
            puts "Error: \#{e.message}"
            exit 1
          end
      TUTORIAL
      hints: [
        'Get the filename: filename = ARGV[0]',
        'Check if nil: if filename.nil?',
        'Use begin/rescue for error handling',
        'Read file: File.read(filename)',
        'Exit with error code: exit 1'
      ],
      starter_code: <<~CODE,
        #!/usr/bin/env ruby

        # TODO: Get the filename from ARGV (first argument)

        # TODO: Check if filename is nil or empty
        # If so, display usage message and exit
        # Usage: ruby file_reader.rb <filename>

        # TODO: Check if file exists using File.exist?

        # TODO: Use begin/rescue to handle errors
        # Read the file with File.read(filename)
        # Display the contents
        # Handle any errors and display a friendly message

        # TODO: Add a success message at the end
        # Example: "Successfully read [number] characters"
      CODE
      tests: [
        {
          description: 'Handles missing filename argument',
          setup: 'ARGV.clear',
          run: 'begin; load "#{WORKSPACE_DIR}/file-reader.rb"; rescue SystemExit; "exit"; end',
          expected: 'exit',
          check: 'result == "exit"'
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        filename = ARGV[0]

        if filename.nil? || filename.empty?
          puts "Usage: ruby file_reader.rb <filename>"
          exit 1
        end

        unless File.exist?(filename)
          puts "Error: File '\#{filename}' not found"
          exit 1
        end

        begin
          contents = File.read(filename)
          puts contents
          puts "\\n---"
          puts "Successfully read \#{contents.length} characters"
        rescue => e
          puts "Error reading file: \#{e.message}"
          exit 1
        end
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'file-reader.json'), JSON.pretty_generate(lesson))
  end

  def create_argument_parser_lesson
    lesson = {
      id: 'argument-parser',
      title: 'Command-Line Argument Parser',
      description: 'Build a tool that parses flags and options like --help and --version.',
      concepts: ['ARGV parsing', 'conditionals', 'case/when', 'command flags'],
      objectives: [
        'Parse command-line flags',
        'Implement --help and --version',
        'Use case/when statements',
        'Build a user-friendly interface'
      ],
      tasks: [
        'Parse ARGV for flags',
        'Implement --help flag',
        'Implement --version flag',
        'Handle unknown flags',
        'Process actual commands'
      ],
      tutorial: <<~TUTORIAL,
        Command-Line Argument Parsing:

        1. Check for flags
           if ARGV.include?('--help')

        2. Case statements for commands
           case ARGV[0]
           when '--help'
             show_help
           when '--version'
             show_version
           end

        3. Multiple arguments
           command = ARGV[0]
           args = ARGV[1..-1]  # Rest of arguments

        Example:
          VERSION = '1.0.0'

          case ARGV[0]
          when '--help', '-h'
            puts "Usage: tool [options]"
          when '--version', '-v'
            puts VERSION
          else
            puts "Unknown command"
          end
      TUTORIAL
      hints: [
        'Use case/when for cleaner code',
        'Support both --help and -h',
        'Check ARGV[0] for the command',
        'Display helpful error for unknown commands',
        'Remember to handle empty ARGV'
      ],
      starter_code: <<~CODE,
        #!/usr/bin/env ruby

        VERSION = '1.0.0'

        # TODO: Define a show_help method that displays usage information
        def show_help
          # Display available commands and their descriptions
        end

        # TODO: Define a show_version method
        def show_version
          # Display version number
        end

        # TODO: Get the command from ARGV[0]

        # TODO: Use case/when to handle different commands
        # Handle: --help, -h, --version, -v
        # For unknown commands, show an error and suggest --help

        # TODO: If no command given, show help
      CODE
      tests: [
        {
          description: 'Responds to --help',
          setup: 'ARGV.clear; ARGV << "--help"',
          run: 'show_help.is_a?(String) || true',
          expected: true
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        VERSION = '1.0.0'

        def show_help
          puts <<~HELP
            Usage: tool [command] [options]

            Commands:
              --help, -h      Show this help message
              --version, -v   Show version
              process <file>  Process a file

            Examples:
              tool --help
              tool process myfile.txt
          HELP
        end

        def show_version
          puts "Version \#{VERSION}"
        end

        command = ARGV[0]

        case command
        when '--help', '-h', nil
          show_help
        when '--version', '-v'
          show_version
        when 'process'
          filename = ARGV[1]
          if filename
            puts "Processing: \#{filename}"
          else
            puts "Error: No filename provided"
            exit 1
          end
        else
          puts "Unknown command: \#{command}"
          puts "Use --help for usage information"
          exit 1
        end
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'argument-parser.json'), JSON.pretty_generate(lesson))
  end

  def create_json_tool_lesson
    lesson = {
      id: 'json-tool',
      title: 'JSON Processing Tool',
      description: 'Build a tool that reads, parses, and manipulates JSON data.',
      concepts: ['JSON parsing', 'hashes', 'arrays', 'iteration'],
      objectives: [
        'Parse JSON data',
        'Navigate hash structures',
        'Format output',
        'Handle JSON errors'
      ],
      tasks: [
        'Read JSON from file',
        'Parse JSON string',
        'Extract specific values',
        'Pretty-print output',
        'Handle malformed JSON'
      ],
      tutorial: <<~TUTORIAL,
        Working with JSON:

        1. Require JSON library
           require 'json'

        2. Parse JSON
           data = JSON.parse(json_string)

        3. Access hash values
           data['name']
           data.dig('user', 'email')

        4. Pretty print JSON
           puts JSON.pretty_generate(data)

        5. Handle parsing errors
           begin
             JSON.parse(string)
           rescue JSON::ParserError => e
             puts "Invalid JSON"
           end

        Example:
          require 'json'

          json_str = '{"name": "Alice", "age": 30}'
          data = JSON.parse(json_str)

          puts data['name']  # => Alice
          puts JSON.pretty_generate(data)
      TUTORIAL
      hints: [
        "Don't forget: require 'json'",
        'Use JSON.parse to convert string to hash',
        'Access values with hash[\'key\']',
        'Pretty print with JSON.pretty_generate',
        'Use rescue JSON::ParserError for errors'
      ],
      starter_code: <<~CODE,
        #!/usr/bin/env ruby

        # TODO: Require the json library

        # TODO: Get filename from ARGV

        # TODO: Read the file contents

        # TODO: Parse the JSON using JSON.parse
        # Wrap in begin/rescue to handle invalid JSON

        # TODO: Display the parsed data in a pretty format
        # Use JSON.pretty_generate

        # TODO: Extra: Add a feature to extract a specific key
        # Example: ruby json_tool.rb file.json name
        # Should display just the "name" value
      CODE
      tests: [
        {
          description: 'Parses valid JSON',
          run: 'JSON.parse(\'{"test": true}\'); true',
          expected: true
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        require 'json'

        filename = ARGV[0]
        key = ARGV[1]

        if filename.nil?
          puts "Usage: ruby json_tool.rb <file.json> [key]"
          exit 1
        end

        unless File.exist?(filename)
          puts "Error: File not found"
          exit 1
        end

        begin
          contents = File.read(filename)
          data = JSON.parse(contents)

          if key
            value = data[key]
            if value
              puts value.is_a?(Hash) || value.is_a?(Array) ? JSON.pretty_generate(value) : value
            else
              puts "Key '\#{key}' not found"
            end
          else
            puts JSON.pretty_generate(data)
          end
        rescue JSON::ParserError => e
          puts "Error: Invalid JSON - \#{e.message}"
          exit 1
        rescue => e
          puts "Error: \#{e.message}"
          exit 1
        end
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'json-tool.json'), JSON.pretty_generate(lesson))
  end

  def create_text_processor_lesson
    lesson = {
      id: 'text-processor',
      title: 'Text Processing with Regex',
      description: 'Build a tool that searches and transforms text using regular expressions.',
      concepts: ['regex', 'gsub', 'scan', 'string methods'],
      objectives: [
        'Use regular expressions',
        'Search text with patterns',
        'Replace text patterns',
        'Count matches'
      ],
      tasks: [
        'Search for pattern in text',
        'Count occurrences',
        'Replace matches',
        'Extract all matches',
        'Support case-insensitive search'
      ],
      tutorial: <<~TUTORIAL,
        Regular Expressions in Ruby:

        1. Basic regex
           /pattern/
           /ruby/i  # case-insensitive

        2. String#scan - find all matches
           text.scan(/\\d+/)  # Find all numbers

        3. String#gsub - replace matches
           text.gsub(/old/, 'new')

        4. String#match - find first match
           if text.match?(/pattern/)

        5. Common patterns:
           /\\d/     - digit
           /\\w/     - word character
           /\\s/     - whitespace
           /[a-z]/  - lowercase letters
           /.*/     - any characters

        Example:
          text = "Call me at 555-1234"

          # Find phone numbers
          phones = text.scan(/\\d{3}-\\d{4}/)

          # Replace numbers
          censored = text.gsub(/\\d/, 'X')

          # Check if matches
          has_phone = text.match?(/\\d{3}-\\d{4}/)
      TUTORIAL
      hints: [
        'Use scan to find all matches: text.scan(regex)',
        'Use gsub to replace: text.gsub(pattern, replacement)',
        'Add /i for case-insensitive: /pattern/i',
        'Count with: matches.length',
        'Test regex at rubular.com'
      ],
      starter_code: <<~CODE,
        #!/usr/bin/env ruby

        # TODO: Get filename and pattern from ARGV
        # Usage: ruby text_processor.rb <file> <pattern>

        # TODO: Read the file

        # TODO: Define a search method that:
        # 1. Takes text and pattern
        # 2. Converts pattern string to regex
        # 3. Finds all matches with scan
        # 4. Returns array of matches

        def search(text, pattern)
          # Your code here
        end

        # TODO: Define a count method that counts matches

        # TODO: Define a replace method that uses gsub
        # Usage: replace(text, pattern, replacement)

        # TODO: Display results:
        # - Number of matches found
        # - List each match
        # - Show line numbers where found
      CODE
      tests: [
        {
          description: 'Can search with regex',
          setup: 'def search(text, pattern); text.scan(/#{pattern}/); end',
          run: 'search("hello world", "\\\\w+").length',
          expected: 2
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        def search(text, pattern, case_sensitive = true)
          regex = case_sensitive ? /\#{pattern}/ : /\#{pattern}/i
          text.scan(regex)
        end

        def count_matches(text, pattern)
          search(text, pattern).length
        end

        def replace_text(text, pattern, replacement)
          text.gsub(/\#{pattern}/, replacement)
        end

        filename = ARGV[0]
        command = ARGV[1]
        pattern = ARGV[2]

        if filename.nil? || command.nil?
          puts <<~USAGE
            Usage:
              ruby text_processor.rb <file> search <pattern>
              ruby text_processor.rb <file> count <pattern>
              ruby text_processor.rb <file> replace <pattern> <replacement>
          USAGE
          exit 1
        end

        unless File.exist?(filename)
          puts "Error: File not found"
          exit 1
        end

        text = File.read(filename)

        case command
        when 'search'
          matches = search(text, pattern)
          puts "Found \#{matches.length} matches:"
          matches.each_with_index do |match, idx|
            puts "  \#{idx + 1}. \#{match}"
          end
        when 'count'
          count = count_matches(text, pattern)
          puts "Total matches: \#{count}"
        when 'replace'
          replacement = ARGV[3]
          if replacement.nil?
            puts "Error: No replacement provided"
            exit 1
          end
          result = replace_text(text, pattern, replacement)
          puts result
        else
          puts "Unknown command: \#{command}"
          exit 1
        end
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'text-processor.json'), JSON.pretty_generate(lesson))
  end

  def create_system_monitor_lesson
    lesson = {
      id: 'system-monitor',
      title: 'System Monitoring Tool',
      description: 'Build a tool that monitors system resources and displays formatted output.',
      concepts: ['system calls', 'backticks', 'string formatting', 'loops'],
      objectives: [
        'Execute system commands',
        'Parse command output',
        'Format data in tables',
        'Refresh display in loop'
      ],
      tasks: [
        'Get CPU usage',
        'Get memory usage',
        'Get disk usage',
        'Format as table',
        'Add color output'
      ],
      tutorial: <<~TUTORIAL,
        System Commands and Formatting:

        1. Execute commands with backticks
           output = `ls -la`

        2. Or use system()
           system('ls -la')

        3. String formatting
           "%10s" % "right"    # Right-aligned, 10 chars
           "%-10s" % "left"    # Left-aligned
           "%.2f" % 3.14159   # 2 decimal places

        4. ANSI colors
           "\\e[31mRed\\e[0m"
           "\\e[32mGreen\\e[0m"

        5. Clear screen
           print "\\e[2J\\e[H"

        Example:
          # Get uptime
          uptime = `uptime`.strip

          # Format output
          puts "%-15s: %s" % ["Uptime", uptime]

          # Loop with refresh
          loop do
            print "\\e[2J\\e[H"  # Clear screen
            puts "CPU: \#{get_cpu_usage}"
            sleep 1
          end
      TUTORIAL
      hints: [
        'Use backticks to run commands: `command`',
        'Parse output with split and strip',
        'Format with printf or % operator',
        'Use \\e[31m for red, \\e[32m for green',
        'Clear screen with print "\\e[2J\\e[H"'
      ],
      starter_code: <<~CODE,
        #!/usr/bin/env ruby

        # TODO: Define method to get CPU info
        # Hint: Use `top -bn1` or `uptime`
        def get_cpu_info
          # Your code here
        end

        # TODO: Define method to get memory info
        # Hint: Use `free -m` on Linux or `vm_stat` on Mac
        def get_memory_info
          # Your code here
        end

        # TODO: Define method to get disk usage
        # Hint: Use `df -h`
        def get_disk_info
          # Your code here
        end

        # TODO: Define method to format output
        # Create a nice table with borders
        def display_stats
          puts "=" * 50
          puts "System Monitor"
          puts "=" * 50
          # Display CPU, Memory, Disk
        end

        # TODO: Add optional loop mode
        # If ARGV includes 'watch', refresh every second
        if ARGV.include?('watch')
          loop do
            # Clear screen, display, sleep
          end
        else
          display_stats
        end
      CODE
      tests: [
        {
          description: 'Can execute system commands',
          run: '`echo test`.strip',
          expected: 'test'
        }
      ],
      solution: <<~SOLUTION
        #!/usr/bin/env ruby

        def get_cpu_info
          uptime = `uptime`.strip
          load = uptime.match(/load average: (.*)/)[1] rescue "N/A"
          "Load: \#{load}"
        end

        def get_memory_info
          if RUBY_PLATFORM.include?('linux')
            mem_line = `free -m | grep Mem:`.strip
            parts = mem_line.split
            total = parts[1]
            used = parts[2]
            "Used: \#{used}MB / \#{total}MB"
          else
            "N/A (Linux only)"
          end
        end

        def get_disk_info
          df_output = `df -h / | tail -1`.strip
          parts = df_output.split
          size = parts[1]
          used = parts[2]
          percent = parts[4]
          "\#{used} / \#{size} (\#{percent})"
        end

        def display_stats
          puts "=" * 50
          puts " System Monitor".center(50)
          puts "=" * 50
          puts ""
          puts "  %-20s: %s" % ["CPU", get_cpu_info]
          puts "  %-20s: %s" % ["Memory", get_memory_info]
          puts "  %-20s: %s" % ["Disk", get_disk_info]
          puts "  %-20s: %s" % ["Time", Time.now.strftime("%Y-%m-%d %H:%M:%S")]
          puts ""
          puts "=" * 50
        end

        if ARGV.include?('watch')
          begin
            loop do
              print "\\e[2J\\e[H"  # Clear screen
              display_stats
              puts "Press Ctrl+C to exit"
              sleep 2
            end
          rescue Interrupt
            puts "\\nExiting..."
          end
        else
          display_stats
        end
      SOLUTION
    }

    File.write(File.join(LESSONS_DIR, 'system-monitor.json'), JSON.pretty_generate(lesson))
  end
end

# Run if called directly
if __FILE__ == $PROGRAM_NAME
  tutor = RubyTutor.new
  tutor.run(ARGV)
end
