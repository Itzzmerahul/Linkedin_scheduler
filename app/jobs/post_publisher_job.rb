# app/jobs/post_publisher_job.rb

class PostPublisherJob < ApplicationJob
  queue_as :default

  # The main method that gets called to run the job
  def perform(post)
    # If the post has been deleted or is no longer scheduled, do nothing.
    return unless post && post.status == 'scheduled'

    # The user's LinkedIn URN (Uniform Resource Name) is needed for the API call.
    # It looks like: 'urn:li:person:abcdefg'
    author_urn = "urn:li:person:#{post.user.uid}"
    
    # API endpoint for creating a post
    url = "https://api.linkedin.com/v2/ugcPosts"

    # The body of our request, formatted as JSON
    body = {
      author: author_urn,
      lifecycleState: "PUBLISHED",
      specificContent: {
        "com.linkedin.ugc.ShareContent": {
          shareCommentary: {
            text: post.content
          },
          shareMediaCategory: "NONE"
        }
      },
      visibility: {
        "com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"
      }
    }.to_json

    # Headers for the request, including the user's access token
    headers = {
      "Authorization" => "Bearer #{post.user.token}",
      "Content-Type" => "application/json",
      "X-Restli-Protocol-Version" => "2.0.0" # Required by LinkedIn API
    }
    
    # Make the API call using HTTParty
    response = HTTParty.post(url, body: body, headers: headers)

    # Check the response from LinkedIn
    if response.success?
      # If successful, update the post's status in our database
      post.update(status: 'published')
      puts "Successfully published post ##{post.id} to LinkedIn."
    else
      # If it failed, update status to 'failed' and log the error
      post.update(status: 'failed')
      puts "Failed to publish post ##{post.id}. Response: #{response.body}"
    end
  end
end