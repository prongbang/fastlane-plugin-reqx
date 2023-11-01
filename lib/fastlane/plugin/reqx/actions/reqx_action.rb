require 'fastlane/action'
require_relative '../helper/reqx_helper'

module Fastlane
  module Actions
    class ReqxAction < Action
      def self.run(params)
        UI.message("The reqx plugin is working!")

        # Prepare
        method = params[:method]
        body = params[:body].to_json
        UI.message("#{method} #{params[:url]}")
        UI.message("Payload #{body}")

        # Use method
        url = URI(params[:url])
        req = Net::HTTP::Get.new(url)
        if method == "POST"
          req = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
        elsif method == "PUT"
          req = Net::HTTP::Put.new(url, 'Content-Type' => 'application/json')
        elsif method == "PATCH"
          req = Net::HTTP::Patch.new(url, 'Content-Type' => 'application/json')
        elsif method == "DELETE"
          req = Net::HTTP::Delete.new(url)
        end

        # Set custom header
        header = params[:header]
        header.each { |key, value| req.add_field(key, value) }

        # Set body
        req.body = body

        res = Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_PEER) do |http|
          http.request(req)
        end

        # Response
        handle_response(res)
      end

      def self.handle_response(res)
        case res
        when Net::HTTPSuccess
          UI.message("#{res.body}")
          return res.body
        when Net::HTTPRedirection
          UI.important("Redirection detected. Response: #{res.body}")
          return nil
        else
          UI.user_error!("Request failed with response code: #{res.code} and message: #{res.message}")
          return nil
        end
      end

      def self.description
        "HTTP Client for Fastlane"
      end

      def self.authors
        ["prongbang"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "HTTP Client for Fastlane"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
           key: :url,
           env_name: "REQX_URL",
           description: "URL to send the request to",
           verify_block: proc do |value|
             UI.user_error!("URL is required") if value.to_s.empty?
           end
          ),
          FastlaneCore::ConfigItem.new(
           key: :method,
           env_name: "REQX_METHOD",
           description: "Method to send the request",
           verify_block: proc do |value|
             UI.user_error!("Method is required") if value.to_s.empty?
           end
          ),
          FastlaneCore::ConfigItem.new(
           key: :header,
           env_name: "REQX_HEADER",
           description: "Header of the request",
           default_value: {},
           is_string: false
          ),
          FastlaneCore::ConfigItem.new(
           key: :body,
           env_name: "REQX_BODY",
           description: "Body of the request",
           default_value: {},
           is_string: false
          )
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
