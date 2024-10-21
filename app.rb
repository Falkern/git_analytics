require 'httparty'
require 'json'
require 'dotenv/load'
require 'optparse'

class GitHubAnalytics
  GITHUB_API_URL = 'https://api.github.com'

  def initialize
    @username = ENV['GITHUB_USERNAME'] 
    @token = ENV['GITHUB_TOKEN'] 
  end

  def fetch_repos(page = 1, repos = [])
    response = HTTParty.get("#{GITHUB_API_URL}/users/#{@username}/repos?page=#{page}&per_page=100", headers: headers)

    if response.success?
      repos.concat(JSON.parse(response.body))
      fetch_repos(page + 1, repos) if response.headers['link'] && response.headers['link'].include?('rel="next"')
    else
      puts "Error fetching repositories: #{response.code} - #{response.message}"
      []
    end

    repos
  end

  def repo_details(repo)
    response = HTTParty.get("#{GITHUB_API_URL}/repos/#{repo['owner']['login']}/#{repo['name']}", headers: headers)

    if response.success?
      JSON.parse(response.body)
    else
      puts "Error fetching details for #{repo['name']}: #{response.code} - #{response.message}"
      {}
    end
  end

  def headers
    {
      "Authorization" => "token #{@token}",
      "User-Agent" => "Ruby"
    }
  end

  def display_analytics(show_stars: true, show_forks: true, show_issues: true)
    repos = fetch_repos
    return if repos.empty?

    total_stars = 0
    total_forks = 0

    puts "\n===== Repository Analytics for #{@username} =====\n"
    repos.each do |repo|
      details = repo_details(repo)
      next if details.empty?

      stars = details['stargazers_count']
      forks = details['forks_count']
      open_issues = details['open_issues_count']

      total_stars += stars
      total_forks += forks

      puts "Repository: #{details['name']}"
      puts "  Stars: #{stars}" if show_stars
      puts "  Forks: #{forks}" if show_forks
      puts "  Open Issues: #{open_issues}" if show_issues
      puts "-" * 40
    end

    puts "===== Summary Statistics ====="
    puts "  Total Stars: #{total_stars}" if show_stars
    puts "  Total Forks: #{total_forks}" if show_forks
    puts "=============================="
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: github_analytics.rb [options]"

  opts.on('--stars', 'Show star counts') { options[:stars] = true }
  opts.on('--forks', 'Show fork counts') { options[:forks] = true }
  opts.on('--issues', 'Show open issues count') { options[:issues] = true }
  opts.on('--help', 'Displays this help message') do
    puts opts
    exit
  end
end.parse!

options[:stars] ||= true
options[:forks] ||= true
options[:issues] ||= true

analytics = GitHubAnalytics.new
analytics.display_analytics(show_stars: options[:stars], show_forks: options[:forks], show_issues: options[:issues])
