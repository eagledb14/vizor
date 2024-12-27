module main

import toxml
import markdown

pub fn get_rss_feed(pages &Pages) string {
	mut rss := toxml.new()
	rss.prolog("xml", {
		"version": "1.0",
		"encoding": "UTF-8"
	})
	rss.open("rss", {
		"version": "2.0"
		"xmlns:atom": "http://www.w3.org/2005/Atom"
	})
	rss.open("channel", {})

	rss.open("title", {})
	rss.body("blackman.zip blog")
	rss.close()

	rss.open("link", {})
	rss.body("https://blackman.zip")
	rss.close()

	rss.open("description", {})
	rss.body("A simple blog written by a simple developer")
	rss.close()

	for post in pages.posts() {
		rss.open("item", {})

		rss.open("title", {})
		rss.body(post.name)
		rss.close()

		rss.open("link", {})
		rss.body("https://blackman.zip/post/${post.name}")
		rss.close()

		rss.open("description", {})
		rss.body(markdown.to_plain(post.content))
		rss.close()

		rss.close()
	}

	rss.finish()
	return rss.str()
}
