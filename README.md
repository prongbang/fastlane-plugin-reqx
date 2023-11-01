# reqx plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-reqx)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-reqx`, add it to your project by running:

```bash
gem "fastlane-plugin-reqx", git: "https://github.com/prongbang/fastlane-plugin-reqx", tag: "0.1.0"
```

## About reqx

HTTP Client for Fastlane

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```shell
body = reqx(
  method: "POST",
  url: "https://httpbin.org/post",
  header: { 'Api-Key': '1234' },
  body: { key1: 'value1', key2: 'value2' }
)
unless body.nil?
  json_body = JSON.parse(body)
end
```