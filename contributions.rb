# frozen_string_literal: true

require 'net/http'
require 'json'

class Contributions
  def run
    organization   = ENV['INPUT_ORGANIZATION']
    project        = ENV['INPUT_PROJECT']
    platform       = ENV['INPUT_PLATFORM']
    username       = ENV['INPUT_USERNAME']
    readme_path    = ENV['INPUT_README_PATH']
    git_username   = ENV['INPUT_COMMIT_USER']
    git_email      = ENV['INPUT_COMMIT_EMAIL']
    commit_message = ENV['INPUT_COMMIT_MESSAGE'] || 'Update README.md'

    gitlab_url = "https://gitlab.com/api/v4/projects/#{organization}%2F#{project}/merge_requests?scope=all&state=merged&author_username=#{username}&per_page=1000"

    fetch_and_update_readme(organization, project, platform, username, gitlab_url, readme_path, commit_message, git_username, git_email)
  rescue StandardError => e
    puts "Error: #{e.message}"
    exit 1
  end

  private

  def fetch_and_update_readme(organization, project, platform, username, gitlab_url, readme_path, commit_message, git_username, git_email)
    uri = URI(gitlab_url)
    req = Net::HTTP::Get.new(uri)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if response.is_a?(Net::HTTPSuccess)
      merged_merge_requests = JSON.parse(response.body)
      merged_count = merged_merge_requests.count

      update_readme_content(organization, project, platform, username, readme_path, merged_count)
      update_git_repo(readme_path, commit_message, git_username, git_email)
    else
      puts "Failed to retrieve merged pull requests: #{response.code} - #{response.message}"
    end
  end

  def update_readme_content(organization, project, platform, username, readme_path, merged_count)
    readme_content = File.read(readme_path)
    start_marker = '<!-- MERGED_PULL_REQUESTS_START -->'
    end_marker = '<!-- MERGED_PULL_REQUESTS_END -->'
    contribution_link = "https://gitlab.com/#{organization}/#{project}/-/merge_requests?scope=all&state=merged&author_username=#{username}"
    updated_readme_content = readme_content.gsub(/#{start_marker}.*#{end_marker}/m, "#{start_marker}\n[![](https://badgen.net/badge/#{organization}%2F#{project}/#{merged_count}/orange?icon=#{platform})](#{contribution_link})\n#{end_marker}")
    File.write(readme_path, updated_readme_content)
  end

  def update_git_repo(readme_path, commit_message, git_username, git_email)
    `git config --global --add safe.directory /github/workspace`
    `git config user.name #{git_username}`
    `git config user.email #{git_email}`

    status = `git status`
    unless status.include?("nothing to commit")
      `git add #{readme_path}`
      `git commit -m "#{commit_message}"`
      `git push`
    end
  end
end

Contributions.new.run
