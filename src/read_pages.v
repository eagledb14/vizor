module main

import os
import markdown
import time

struct Pages {
mut:
	home string
	links string
	posts map[string]Post
	post_list []string
}

struct Post {
pub:
	path string
	time i64
	content string
}

pub fn new_pages() &Pages {
	mut pages := &Pages{}
	spawn pages.update_concurrently()

	return pages
}

fn (mut p Pages) walk_pages() {
	p.home = os.read_file(os.join_path(".", "pages", "home.md")) or {println(err); ""}
	p.links = os.read_file(os.join_path(".", "pages", "links.md")) or {println(err); ""}

	mut posts := map[string]Post{}
	mut post_list := []string{}

	path := os.join_path(".", "pages", "posts")
	entries := os.ls(path) or { return }

	for entry in entries {
		entry_path := os.join_path(path, entry)
		if os.is_file(entry_path) {
			post_list << entry
			posts[entry] = Post{
				path: entry_path,
				time: os.file_last_mod_unix(entry_path)
				content: os.read_file(entry_path) or {""}
			}
		}
	}

	post_list.sort_with_compare(fn [posts](a &string, b &string) int {
		if posts[a].time > posts[b].time {
			return -1
		} else {
			return 1
		}
	})

	p.posts = posts.clone()
	p.post_list = post_list
}

fn (mut p Pages) update_concurrently() {
	for {
		p.walk_pages()
		time.sleep(1 * time.hour)
	}
}

pub fn (p Pages) read_home() string {
	return markdown.to_html(p.home)
}

pub fn (p Pages) read_links() string {
	return markdown.to_html(p.links)
}

pub fn (p Pages) read_post(page string) string {
	return markdown.to_html(p.posts[page].content)
}

pub fn (p Pages) posts() []string {
	return p.post_list
}
