
urls = [
  "http://www.repubblica.it/rss/cronaca/rss2.0.xml", 
  "http://xml2.corriereobjects.it/rss/economia.xml", 
  "https://www.gazzetta.it/rss/serie-a.xml", 
  "http://www.repubblica.it/rss/speciali/arte/rss2.0.xml", 
  "http://www.repubblica.it/rss/homepage/rss2.0.xml"
]

urls.each do |url|
  Feed.add(url: url)
end
