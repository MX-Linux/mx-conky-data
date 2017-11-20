import feedparser.py
rss_url = "https://news.google.com/news/rss/headlines?gl=US&ned=us&hl=en"
feedparser.parse( rss_url )
count =  len(feed['entries'])
for i in range(0, count):
	if (i>=5):break
	print '{1}'.format(' ', feed.entries[i].title[0:100].encode('utf8'))
