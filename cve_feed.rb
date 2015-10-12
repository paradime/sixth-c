require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'active_support'

rails_cve_feed = "http://www.cvedetails.com/vulnerability-feed.php?vendor_id=12043&product_id=22568&version_id=0&orderby=1&cvssscoremin=0"
ruby_cve_feed = "https://www.cvedetails.com/vulnerability-feed.php?vendor_id=7252&product_id=12215&version_id=0&orderby=3&cvssscoremin=0"
vulnerability_db = ""
def get_items(feed_url)
  rss = SimpleRSS.parse open()
  rss.items.select{ |item| DateTime.parse(item.pubDate.to_s).between?( DateTime.new(2015, 1, 1), DateTime.now)}
end

def get_vulnerable_gems
  vulnerable_gems = Dir[vulnerability_db+"*"].collect{ |dir| dir[vulnerability_db.length..-1]}
end 

def get_gems
  system('bundle show > output.txt')
  file = File.new('output.txt')
  gems = file.readlines[1..-1].collect{ |gem| gem.match(/\*(..*)\(/)[1].strip}
  file.close
  gems
end

def get_my_vulnerable_gems
  v_gems = get_vulnerable_gems
  get_gems.select{|gem| v_gems.include? gem}
end
