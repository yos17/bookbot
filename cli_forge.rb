#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

# CLI Forge - AI-powered Unix CLI tool generator
class CLIForge
  VERSION = '1.0.0'
  API_URL = 'https://api.anthropic.com/v1/messages'

  def initialize
    @api_key = ENV['ANTHROPIC_API_KEY']
    @tools_dir = File.expand_path('~/.local/bin')
    ensure_tools_directory
  end

  def run(args)
    if args.empty? || args.include?('--help') || args.include?('-h')
      show_help
      return
    end

    if args[0] == '--version' || args[0] == '-v'
      puts "CLI Forge v#{VERSION}"
      return
    end

    if args[0] == 'list'
      list_generated_tools
      return
    end

    if args[0] == 'remove'
      remove_tool(args[1])
      return
    end

    # Main workflow: generate a CLI tool
    description = args.join(' ')
    generate_cli_tool(description)
  end

  private

  def ensure_tools_directory
    FileUtils.mkdir_p(@tools_dir) unless Dir.exist?(@tools_dir)
  end

  def show_help
    puts <<~HELP
      CLI Forge v#{VERSION} - AI-powered Unix CLI tool generator

      Usage:
        cli_forge <description>     Generate a CLI tool from description
        cli_forge list              List all generated tools
        cli_forge remove <name>     Remove a generated tool
        cli_forge --help, -h        Show this help message
        cli_forge --version, -v     Show version

      Examples:
        cli_forge "a tool that converts JSON to YAML"
        cli_forge "a tool that monitors system CPU usage and alerts when above 80%"
        cli_forge "a tool to batch rename files with regex patterns"

      Setup:
        Set your Anthropic API key:
        export ANTHROPIC_API_KEY='your-api-key-here'

      Generated tools are installed to: #{@tools_dir}
      Make sure this directory is in your PATH.
    HELP
  end

  def generate_cli_tool(description)
    unless @api_key
      puts "❌ Error: ANTHROPIC_API_KEY environment variable not set"
      puts "Please set it with: export ANTHROPIC_API_KEY='your-api-key-here'"
      exit 1
    end

    puts "🤖 Generating CLI tool: #{description}"
    puts "⏳ Thinking..."

    code_response = call_claude_api(build_generation_prompt(description))

    if code_response[:error]
      puts "❌ Error: #{code_response[:error]}"
      exit 1
    end

    # Extract tool name and code
    tool_data = parse_generated_response(code_response[:content])

    if tool_data[:error]
      puts "❌ Error parsing response: #{tool_data[:error]}"
      exit 1
    end

    install_tool(tool_data[:name], tool_data[:code], tool_data[:description])
  end

  def build_generation_prompt(description)
    <<~PROMPT
      You are a Unix CLI tool generator. Generate a complete, production-ready Ruby CLI tool based on this description:

      "#{description}"

      Requirements:
      1. Create a complete Ruby script with proper shebang (#!/usr/bin/env ruby)
      2. Include argument parsing with --help and --version flags
      3. Add error handling and user-friendly messages
      4. Follow Unix conventions (exit codes, stdout/stderr)
      5. Make it self-contained (minimize external dependencies)
      6. Add clear comments explaining functionality
      7. Generate a meaningful tool name (lowercase, hyphen-separated)

      Respond ONLY with a JSON object in this exact format:
      {
        "name": "tool-name",
        "description": "Brief description of what the tool does",
        "code": "complete Ruby code here"
      }

      The code should be complete and ready to run. Do not include markdown code blocks or additional explanation.
    PROMPT
  end

  def call_claude_api(prompt)
    uri = URI.parse(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 60

    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request['x-api-key'] = @api_key
    request['anthropic-version'] = '2023-06-01'

    request.body = {
      model: 'claude-sonnet-4-20250514',
      max_tokens: 4096,
      messages: [
        {
          role: 'user',
          content: prompt
        }
      ]
    }.to_json

    begin
      response = http.request(request)

      if response.code.to_i != 200
        return { error: "API request failed with status #{response.code}: #{response.body}" }
      end

      parsed = JSON.parse(response.body)
      content = parsed['content']&.first&.fetch('text', '')

      { content: content }
    rescue StandardError => e
      { error: "Request failed: #{e.message}" }
    end
  end

  def parse_generated_response(content)
    # Try to extract JSON from the response
    json_match = content.match(/\{[\s\S]*"name"[\s\S]*"code"[\s\S]*\}/)

    unless json_match
      return { error: "Could not find valid JSON in response" }
    end

    begin
      data = JSON.parse(json_match[0])

      unless data['name'] && data['code']
        return { error: "Response missing required fields (name or code)" }
      end

      {
        name: data['name'],
        code: data['code'],
        description: data['description'] || 'Generated CLI tool'
      }
    rescue JSON::ParserError => e
      { error: "Invalid JSON: #{e.message}" }
    end
  end

  def install_tool(name, code, description)
    tool_path = File.join(@tools_dir, name)

    # Check if tool already exists
    if File.exist?(tool_path)
      print "⚠️  Tool '#{name}' already exists. Overwrite? (y/N): "
      response = $stdin.gets.chomp
      unless response.downcase == 'y'
        puts "❌ Installation cancelled"
        return
      end
    end

    # Write the tool
    File.write(tool_path, code)
    File.chmod(0755, tool_path)

    # Store metadata
    store_tool_metadata(name, description)

    puts "✅ Successfully created: #{name}"
    puts "📝 Description: #{description}"
    puts "📍 Location: #{tool_path}"
    puts ""
    puts "Try it out: #{name} --help"

    # Check if directory is in PATH
    unless ENV['PATH'].split(':').include?(@tools_dir)
      puts ""
      puts "⚠️  Note: #{@tools_dir} is not in your PATH"
      puts "Add it with: echo 'export PATH=\"$PATH:#{@tools_dir}\"' >> ~/.bashrc"
    end
  end

  def store_tool_metadata(name, description)
    metadata_file = File.join(@tools_dir, '.cli_forge_tools.json')

    metadata = if File.exist?(metadata_file)
                 JSON.parse(File.read(metadata_file))
               else
                 {}
               end

    metadata[name] = {
      'description' => description,
      'created_at' => Time.now.iso8601,
      'version' => VERSION
    }

    File.write(metadata_file, JSON.pretty_generate(metadata))
  end

  def list_generated_tools
    metadata_file = File.join(@tools_dir, '.cli_forge_tools.json')

    unless File.exist?(metadata_file)
      puts "No tools have been generated yet."
      return
    end

    metadata = JSON.parse(File.read(metadata_file))

    if metadata.empty?
      puts "No tools have been generated yet."
      return
    end

    puts "Generated CLI Tools:"
    puts "=" * 60
    metadata.each do |name, info|
      puts "#{name}"
      puts "  Description: #{info['description']}"
      puts "  Created: #{info['created_at']}"
      puts ""
    end
  end

  def remove_tool(name)
    unless name
      puts "❌ Error: Please specify a tool name"
      puts "Usage: cli_forge remove <tool-name>"
      return
    end

    tool_path = File.join(@tools_dir, name)

    unless File.exist?(tool_path)
      puts "❌ Error: Tool '#{name}' not found"
      return
    end

    print "⚠️  Are you sure you want to remove '#{name}'? (y/N): "
    response = $stdin.gets.chomp

    unless response.downcase == 'y'
      puts "❌ Removal cancelled"
      return
    end

    File.delete(tool_path)

    # Update metadata
    metadata_file = File.join(@tools_dir, '.cli_forge_tools.json')
    if File.exist?(metadata_file)
      metadata = JSON.parse(File.read(metadata_file))
      metadata.delete(name)
      File.write(metadata_file, JSON.pretty_generate(metadata))
    end

    puts "✅ Successfully removed: #{name}"
  end
end

# Run the application
if __FILE__ == $0
  forge = CLIForge.new
  forge.run(ARGV)
end
