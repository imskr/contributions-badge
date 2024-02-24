# frozen_string_literal: true

require 'net/http'
require 'json'

class Contributions
  def run
    organization = ENV['INPUT_ORGANIZATION']
    project      = ENV['INPUT_PROJECT']
    username     = ENV['INPUT_USERNAME']
    readme_path  = ENV['INPUT_README_PATH']
    git_username = ENV['INPUT_COMMIT_USER']
    git_email    = ENV['INPUT_COMMIT_EMAIL']
    commit_message = ENV['INPUT_COMMIT_MESSAGE'] || 'Update README.md'

    gitlab_url = "https://gitlab.com/api/v4/projects/#{organization}%2F#{project}/merge_requests?scope=all&state=merged&author_username=#{username}&per_page=1000"

    uri = URI(gitlab_url)
    req = Net::HTTP::Get.new(uri)

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if res.code == '200'
      merged_merge_requests = JSON.parse(res.body)
      merged_count = merged_merge_requests.count

      # Update README.md with the count
      readme_content = File.read(readme_path)
      updated_readme_content = readme_content.gsub(/<!-- MERGED_PULL_REQUESTS_COUNT -->/, merged_count.to_s)
      File.write(readme_path, updated_readme_content)

      # git flow
      `git config --global --add safe.directory /github/workspace`
      `git config user.name #{git_username}`
      `git config user.email #{git_email}`
      status = `git status`
      if !status.include?("nothing to commit")
        `git add #{readme_path}`
        `git commit -m "#{commit_message}"`
        `git push`
      end
    else
      puts "Failed to retrieve merged pull requests: #{res.code} - #{res.message}"
    end
  end
end

Contributions.new.run
