require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url))

    students_hash = {}

    students.css('div.student-card').map do |student_card|
      students_hash = {
      :name => student_card.css('h4.student-name').text,
      :location => student_card.css('p.student-location').text,
      :profile_url => student_card.css('a').attribute('href').value
    }
    #students_hash - question, I had .each before and it didnt work, even after  also retunrng student_hash
    end
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    bio = profile.css('div.description-holder p').text
    profile_quote = profile.css('div.profile-quote').text
    twitter = nil
    blog = nil
    linkedin = nil
    github = nil
    profile.css('div.social-icon-container').children.each do |link|
      if link.attribute('href')
        if  link.attribute('href').value.include?('twitter')
          twitter = link.attribute('href').value
        elsif  link.attribute('href').value.include?('linkedin')
          linkedin = link.attribute('href').value
        elsif  link.attribute('href').value.include?('github')
          github = link.attribute('href').value
        else
          blog = link.attribute('href').value
        end
      end
    end

    profile_hash = {
      :twitter => twitter, 
      :linkedin => linkedin, 
      :github => github, 
      :blog => blog, 
      :profile_quote => profile_quote,
      :bio => bio
  }.compact
  end
end

    # student_card = students.css('div.student-card')
    # name = student_card.css('h4.student-name').text
    # location = student_card.css('p.student-location').text
    # profile_url = student_card.css('a').attribute('href').value