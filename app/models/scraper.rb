class Scraper < ApplicationRecord
  def self.run(query)
    # require 'watir'
    browser = Watir::Browser.new :chrome, headless: true

    # p "What venue would you like to search for?"
    # venue = gets.chomp
    query.gsub(" ", "+")

    browser.goto "https://www.google.co.uk/search?q=#{query}"

    data = Hash.new

    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"].each do |day|
      data[day.to_sym] = {}
      if browser.div(aria_label: "Histogram showing popular times on #{day}s").exists?
        browser.div(aria_label: "Histogram showing popular times on #{day}s").divs(class: 'lubh-bar').each do |bar|
          time = bar.aria_label.scan(/(\d{1,2} (am|pm))/).flatten.first
          if time == "12 am"
            time = 0
          elsif time == "12 pm" || time.include?("am")
            time = time.to_i
          else
            time = time.to_i + 12
          end
          height = bar.style("height")
          data[day.to_sym][time] = height.to_i
        end
      end
    end

    if browser.div(class: ["lubh-bar", "lubh-sel"]).exists?
      data[:current] = browser.div(class: ["lubh-bar", "lubh-sel"]).style("height").to_i
    end

    browser.close

    return data

  end
end
