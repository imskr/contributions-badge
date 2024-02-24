# frozen_string_literal: true

require 'net/http'
require 'json'

class Contributions
  def run
    organization = ENV['INPUT_ORGANIZATION']
    project      = ENV['INPUT_PROJECT']
    username      = ENV['INPUT_USERNAME']
    gitlab_url = "https://gitlab.com/api/v4/projects/#{organization}%2F#{project}/merge_requests?scope=all&state=merged&author_username=#{username}"

    uri = URI(gitlab_url)
    req = Net::HTTP::Get.new(uri)
    # req['PRIVATE-TOKEN'] = gitlab_token

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if res.code == '200'
      merged_merge_requests = JSON.parse(res.body)
      merged_count = merged_merge_requests.count

      # Update README.md with the count
      # readme_path = File.join(__dir__, '..', '..', 'README.md')
      readme_content = File.read(INPUT_README_PATH)
      updated_readme_content = readme_content.gsub(/MERGED_PULL_REQUESTS_COUNT/, merged_count.to_s)
      File.write(readme_path, updated_readme_content)

      # git flow
      commit_message = ENV['INPUT_COMMIT_MESSAGE'] || 'Update README.md'
      `git add #{readme_content}`
      `git commit -m "#{commit_message}"`
      `git push origin HEAD`
    else
      puts "Failed to retrieve merged pull requests: #{res.code} - #{res.message}"
    end
  end
end

Contributions.new.run
