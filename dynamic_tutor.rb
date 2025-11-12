#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

# Dynamic Ruby Tutor - AI-powered personalized learning
class DynamicTutor
  WORKSPACE_DIR = File.join(Dir.home, '.cli_forge', 'learning')
  LESSONS_DIR = File.join(Dir.home, '.cli_forge', 'my_lessons')
  API_URL = 'https://api.anthropic.com/v1/messages'

  def initialize(api_key)
    @api_key = api_key
    setup_directories
  end

  def run(args)
    command = args[0]

    case command
    when 'build'
      # Start learning to build something
      description = args[1..-1].join(' ')
      start_learning(description)
    when 'next'
      # Move to next step
      next_step
    when 'test'
      # Test current step
      test_current_step
    when 'hint'
      # Get hint for current step
      get_hint
    when 'status'
      # Show current progress
      show_status
    when 'reset'
      # Reset current lesson
      reset_lesson
    when 'code'
      # Show AI-generated solution (for comparison)
      show_generated_code
    else
      show_help
    end
  end

  private

  def setup_directories
    FileUtils.mkdir_p(WORKSPACE_DIR)
    FileUtils.mkdir_p(LESSONS_DIR)
  end

  def show_help
    puts <<~HELP

      🎓 CLI Forge Dynamic Learning Mode

      Learn by building EXACTLY what you want!

      Commands:
        learn build "<description>"  Start learning to build a tool
        learn next                   Move to the next step
        learn test                   Test your current implementation
        learn hint                   Get a hint for the current step
        learn status                 Show your learning progress
        learn reset                  Start over with current lesson
        learn code                   Show AI-generated solution (for comparison)

      How it works:
        1. Describe what you want to build
        2. AI breaks it into learning steps
        3. Build each step with guidance
        4. Test as you go
        5. Learn by doing!

      Examples:
        cli_forge learn build "a tool that converts JSON to YAML"
        cli_forge learn build "a tool that monitors CPU usage"
        cli_forge learn build "a grep-like tool for searching files"

      💡 The AI adapts the curriculum to YOUR project!

    HELP
  end

  def start_learning(description)
    if description.empty?
      puts "❌ Please describe what you want to learn to build"
      puts 'Example: cli_forge learn build "a tool that converts JSON to YAML"'
      return
    end

    puts "\n🎓 Creating your personalized learning path..."
    puts "📝 Project: #{description}\n\n"

    # Generate curriculum with AI
    curriculum = generate_curriculum(description)

    if curriculum[:error]
      puts "❌ Error: #{curriculum[:error]}"
      return
    end

    # Save curriculum
    save_curriculum(curriculum)

    # Create workspace
    setup_workspace(curriculum)

    # Show first step
    display_step(curriculum[:steps][0], 1, curriculum[:steps].length)
  end

  def generate_curriculum(description)
    prompt = build_curriculum_prompt(description)
    response = call_claude_api(prompt)

    if response[:error]
      return { error: response[:error] }
    end

    parse_curriculum(response[:content], description)
  end

  def build_curriculum_prompt(description)
    <<~PROMPT
      You are an expert Ruby programming teacher. A student wants to learn how to build:

      "#{description}"

      Create a step-by-step learning curriculum that teaches them to build this tool.

      Requirements:
      1. Break the project into 4-6 progressive steps
      2. Each step should teach specific Ruby concepts
      3. Start with basics, build up complexity
      4. Include specific learning objectives for each step
      5. Provide clear tasks and validation criteria
      6. Include Ruby concepts they'll learn at each step

      Respond with a JSON object in this format:
      {
        "project_name": "short-tool-name",
        "description": "What they're building",
        "overview": "Brief overview of the project and what they'll learn",
        "estimated_time": "estimated time to complete",
        "concepts": ["concept1", "concept2", ...],
        "steps": [
          {
            "number": 1,
            "title": "Step title",
            "description": "What they'll build in this step",
            "concepts": ["Ruby concept1", "Ruby concept2"],
            "tasks": ["Task 1", "Task 2", ...],
            "starter_code": "Ruby code with TODOs",
            "validation": {
              "description": "What to check",
              "test_code": "Ruby code that tests the implementation"
            },
            "hints": ["Hint 1", "Hint 2", "Hint 3"]
          },
          ...
        ]
      }

      Make it educational, progressive, and practical. Focus on teaching good Ruby practices.
    PROMPT
  end

  def call_claude_api(prompt)
    uri = URI.parse(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 90

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request['x-api-key'] = @api_key
    request['anthropic-version'] = '2023-06-01'

    request.body = {
      model: 'claude-sonnet-4-20250514',
      max_tokens: 8192,
      messages: [{ role: 'user', content: prompt }]
    }.to_json

    begin
      response = http.request(request)

      if response.code.to_i != 200
        return { error: "API request failed: #{response.code}" }
      end

      parsed = JSON.parse(response.body)
      content = parsed['content']&.first&.fetch('text', '')

      { content: content }
    rescue => e
      { error: "Request failed: #{e.message}" }
    end
  end

  def parse_curriculum(content, original_description)
    # Extract JSON from response
    json_match = content.match(/\{[\s\S]*"project_name"[\s\S]*"steps"[\s\S]*\}/m)

    unless json_match
      return { error: "Could not parse curriculum from AI response" }
    end

    begin
      curriculum = JSON.parse(json_match[0], symbolize_names: true)
      curriculum[:original_description] = original_description
      curriculum[:current_step] = 0
      curriculum
    rescue JSON::ParserError => e
      { error: "Invalid curriculum JSON: #{e.message}" }
    end
  end

  def save_curriculum(curriculum)
    lesson_file = File.join(LESSONS_DIR, 'current_lesson.json')
    File.write(lesson_file, JSON.pretty_generate(curriculum))
  end

  def load_curriculum
    lesson_file = File.join(LESSONS_DIR, 'current_lesson.json')
    return nil unless File.exist?(lesson_file)

    JSON.parse(File.read(lesson_file), symbolize_names: true)
  end

  def setup_workspace(curriculum)
    # Create workspace file
    tool_file = File.join(WORKSPACE_DIR, "#{curriculum[:project_name]}.rb")

    # Start with first step's code
    first_step = curriculum[:steps][0]
    File.write(tool_file, first_step[:starter_code])

    curriculum[:workspace_file] = tool_file
    save_curriculum(curriculum)
  end

  def display_step(step, step_num, total_steps)
    puts "\n" + "=" * 70
    puts "📚 Step #{step_num}/#{total_steps}: #{step[:title]}"
    puts "=" * 70

    puts "\n📖 Overview:"
    puts "  #{step[:description]}"

    puts "\n💡 Concepts You'll Learn:"
    step[:concepts].each { |concept| puts "  • #{concept}" }

    puts "\n✅ Your Tasks:"
    step[:tasks].each_with_index { |task, idx| puts "  #{idx + 1}. #{task}" }

    curriculum = load_curriculum
    puts "\n📁 Workspace: #{curriculum[:workspace_file]}"

    puts "\n▶️  Next Steps:"
    puts "  1. Edit: #{curriculum[:workspace_file]}"
    puts "  2. Complete the tasks above"
    puts "  3. Test: cli_forge learn test"
    puts "  4. When tests pass: cli_forge learn next"
    puts "\n💭 Need help? cli_forge learn hint"
    puts ""
  end

  def next_step
    curriculum = load_curriculum

    unless curriculum
      puts "❌ No active lesson. Start one with: cli_forge learn build \"<description>\""
      return
    end

    current = curriculum[:current_step]
    total = curriculum[:steps].length

    if current >= total
      complete_lesson(curriculum)
      return
    end

    # Check if current step is done (optional - could require test pass)
    curriculum[:current_step] = current + 1
    save_curriculum(curriculum)

    if curriculum[:current_step] < total
      next_step_data = curriculum[:steps][curriculum[:current_step]]

      # Append next step's code
      File.open(curriculum[:workspace_file], 'a') do |f|
        f.puts "\n# Step #{curriculum[:current_step] + 1}: #{next_step_data[:title]}"
        f.puts next_step_data[:starter_code]
      end

      display_step(next_step_data, curriculum[:current_step] + 1, total)
    else
      complete_lesson(curriculum)
    end
  end

  def complete_lesson(curriculum)
    puts "\n" + "=" * 70
    puts "🎉 Congratulations! You've completed your lesson!"
    puts "=" * 70
    puts "\n📚 Project: #{curriculum[:description]}"
    puts "✅ Steps Completed: #{curriculum[:steps].length}"
    puts "🎓 Concepts Learned:"
    curriculum[:concepts].each { |concept| puts "  • #{concept}" }

    puts "\n💎 Your completed tool: #{curriculum[:workspace_file]}"
    puts "\n🚀 Ready for more?"
    puts "  • Try building something else: cli_forge learn build \"<new project>\""
    puts "  • Generate a similar tool with AI: cli_forge \"#{curriculum[:original_description]}\""
    puts "  • Compare your code with AI's approach: cli_forge learn code"
    puts ""
  end

  def test_current_step
    curriculum = load_curriculum

    unless curriculum
      puts "❌ No active lesson"
      return
    end

    current_step_idx = curriculum[:current_step]
    step = curriculum[:steps][current_step_idx]

    unless step
      puts "❌ No current step to test"
      return
    end

    puts "\n🧪 Testing Step #{current_step_idx + 1}: #{step[:title]}\n"

    validation = step[:validation]
    workspace_file = curriculum[:workspace_file]

    # Run the validation test
    result = run_validation(workspace_file, validation)

    if result[:passed]
      puts "✅ All tests passed!"
      puts "🎉 Great job! Ready for the next step?"
      puts "   Run: cli_forge learn next"
    else
      puts "❌ Tests failed"
      if result[:error]
        puts "Error: #{result[:error]}"
      end
      if result[:output]
        puts "Output: #{result[:output]}"
      end
      puts "\n💡 Try again or get a hint: cli_forge learn hint"
    end
  end

  def run_validation(workspace_file, validation)
    unless File.exist?(workspace_file)
      return { passed: false, error: "Workspace file not found" }
    end

    begin
      # Create test file
      test_file = File.join(WORKSPACE_DIR, 'test_runner.rb')

      test_code = <<~TEST
        require 'stringio'

        # Load student code
        load '#{workspace_file}'

        # Run validation
        begin
          #{validation[:test_code]}
          puts "PASS"
        rescue => e
          puts "FAIL: \#{e.message}"
        end
      TEST

      File.write(test_file, test_code)

      # Run test
      output = `ruby #{test_file} 2>&1`.strip

      File.delete(test_file) if File.exist?(test_file)

      if output.start_with?('PASS')
        { passed: true }
      else
        { passed: false, output: output }
      end
    rescue => e
      { passed: false, error: e.message }
    end
  end

  def get_hint
    curriculum = load_curriculum

    unless curriculum
      puts "❌ No active lesson"
      return
    end

    current_step_idx = curriculum[:current_step]
    step = curriculum[:steps][current_step_idx]

    unless step
      puts "❌ No current step"
      return
    end

    # Track which hint to show
    hint_index = curriculum[:current_hint] || 0

    if hint_index >= step[:hints].length
      puts "\n💡 You've seen all the hints for this step!"
      puts "\nWant to see the solution? Run: cli_forge learn code"
      return
    end

    puts "\n💡 Hint #{hint_index + 1}/#{step[:hints].length}:"
    puts "   #{step[:hints][hint_index]}"
    puts ""

    # Update hint index
    curriculum[:current_hint] = hint_index + 1
    save_curriculum(curriculum)

    if curriculum[:current_hint] < step[:hints].length
      puts "Need another hint? Run: cli_forge learn hint"
    end
  end

  def show_status
    curriculum = load_curriculum

    unless curriculum
      puts "\n❌ No active lesson"
      puts "Start learning: cli_forge learn build \"<description>\""
      return
    end

    puts "\n" + "=" * 70
    puts "📊 Learning Progress"
    puts "=" * 70

    puts "\n📚 Project: #{curriculum[:description]}"
    puts "⏱️  Estimated Time: #{curriculum[:estimated_time]}"

    current = curriculum[:current_step]
    total = curriculum[:steps].length

    puts "\n✅ Progress: Step #{current + 1}/#{total}"

    # Show all steps with status
    curriculum[:steps].each_with_index do |step, idx|
      if idx < current
        status = "✅"
      elsif idx == current
        status = "🔄"
      else
        status = "⭕"
      end
      puts "#{status} Step #{idx + 1}: #{step[:title]}"
    end

    if current < total
      puts "\n📁 Current workspace: #{curriculum[:workspace_file]}"
      puts "💡 Next: cli_forge learn test (then 'learn next')"
    end

    puts ""
  end

  def reset_lesson
    curriculum = load_curriculum

    unless curriculum
      puts "❌ No active lesson to reset"
      return
    end

    print "⚠️  Reset current lesson? You'll lose your progress. (yes/no): "
    response = $stdin.gets.chomp.downcase

    return unless response == 'yes'

    # Reset to step 0
    curriculum[:current_step] = 0
    curriculum[:current_hint] = 0

    # Reset workspace
    first_step = curriculum[:steps][0]
    File.write(curriculum[:workspace_file], first_step[:starter_code])

    save_curriculum(curriculum)

    puts "✅ Lesson reset to Step 1"
    display_step(first_step, 1, curriculum[:steps].length)
  end

  def show_generated_code
    curriculum = load_curriculum

    unless curriculum
      puts "❌ No active lesson"
      return
    end

    puts "\n🤖 Generating complete solution with AI for comparison..."
    puts "Building: #{curriculum[:original_description]}\n"

    # Call the main generator
    prompt = <<~PROMPT
      Generate a complete, production-ready Ruby CLI tool for:
      "#{curriculum[:original_description]}"

      Include:
      - Proper shebang
      - Error handling
      - --help and --version flags
      - Clean, commented code

      Respond with ONLY the Ruby code, no explanations.
    PROMPT

    response = call_claude_api(prompt)

    if response[:error]
      puts "❌ Error: #{response[:error]}"
      return
    end

    # Extract code
    code = response[:content]

    # Remove markdown code blocks if present
    code = code.gsub(/```ruby\n/, '').gsub(/```\n?/, '')

    puts "\n" + "=" * 70
    puts "AI-Generated Solution:"
    puts "=" * 70
    puts code
    puts "=" * 70

    puts "\n💭 Compare this with your implementation!"
    puts "   Your code: #{curriculum[:workspace_file]}"
    puts "\n   Notice the differences? That's learning in action!"
    puts ""
  end
end
