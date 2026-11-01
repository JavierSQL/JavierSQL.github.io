# frozen_string_literal: true

# Series navigation for blog posts.
#
# Series are defined in _data/series.yml (key = post category slug).
#  - SeriesNav::Generator builds the ordered list of each series and exposes it
#    to Liquid as `site.data.series_index` (used by _pages/series.html and the
#    "Read by series" strip in _pages/blog.md).
#  - A :posts post_render hook injects, into the final HTML of each post that
#    belongs to a series, a "Part N of M" line under the post header and a
#    Previous / Next block at the end of the article. Only `output` is touched,
#    so the RSS feed and search index keep the clean post content.
#  - Any page that renders series markup gets /assets/css/series.css in <head>.
#
# This lives in _plugins/ because the starter style contract forbids local
# _layouts/_includes. Every hook is wrapped in rescue: if something breaks,
# the site builds without series navigation instead of failing the deploy.

require "cgi"

module SeriesNav
  CSS_HREF = "/assets/css/series.css"
  SERIES_PAGE = "/blog/series/"
  SUBSCRIBE_URL = "/blog/#subscribe"

  # relative_path of post => { memberships: [...] }
  @nav = {}

  class << self
    attr_reader :nav

    def reset!
      @nav = {}
    end

    def h(text)
      CGI.escapeHTML(text.to_s)
    end

    def url_for(site, path)
      return "" if path.nil? || path.to_s.empty?
      return path.to_s if path.to_s.include?("://")

      p = path.to_s.start_with?("/") ? path.to_s : "/#{path}"
      "#{site.baseurl}#{p}"
    end

    # ---- HTML builders -----------------------------------------------------

    def badge_html(site, info)
      ms = info[:memberships]
      roles = ms.map { |m| m[:entry]["role"] }
      if ms.size > 1 && roles.include?("epilogue") && roles.include?("prologue")
        from = ms.find { |m| m[:entry]["role"] == "epilogue" }
        to = ms.find { |m| m[:entry]["role"] == "prologue" }
        text = %(A bridge between #{series_link(site, from)} and #{series_link(site, to)})
      else
        m = ms.first
        e = m[:entry]
        text =
          case e["role"]
          when "prologue" then %(Prologue to #{series_link(site, m)})
          when "epilogue" then %(Epilogue to #{series_link(site, m)})
          else %(Part #{e["part"]} of #{m[:series]["total"]} &middot; #{series_link(site, m)})
          end
      end
      %(<p class="series-badge"><i class="fa-solid fa-layer-group fa-sm"></i> #{text}</p>)
    end

    def series_link(site, membership)
      s = membership[:series]
      %(<a href="#{h(url_for(site, SERIES_PAGE))}##{h(s["key"])}">#{h(s["title"])}</a>)
    end

    def card_html(site, entry, direction)
      arrow = direction == :prev ? "&larr; Previous" : "Next &rarr;"
      img = ""
      unless entry["thumbnail"].to_s.empty?
        img = %(<img class="series-card-img" src="#{h(url_for(site, entry["thumbnail"]))}" alt="" loading="lazy">)
      end
      <<~HTML
        <a class="series-card series-card-#{direction}" href="#{h(url_for(site, entry["url"]))}">
        #{img}<span class="series-card-body">
        <span class="series-card-dir">#{arrow} &middot; #{h(entry["label"])}</span>
        <span class="series-card-title">#{h(entry["title"])}</span>
        <span class="series-card-desc">#{h(entry["description"])}</span>
        </span>
        </a>
      HTML
    end

    def coming_html(site, series)
      next_part = series["published"] + 1
      <<~HTML
        <a class="series-card series-card-next series-card-coming" href="#{h(url_for(site, SUBSCRIBE_URL))}">
        <span class="series-card-body">
        <span class="series-card-dir">Coming next &middot; Part #{next_part} of #{series["total"]}</span>
        <span class="series-card-title">This series is still being written.</span>
        <span class="series-card-desc">Subscribe to get the next part by email.</span>
        </span>
        </a>
      HTML
    end

    def more_series_html(site)
      <<~HTML
        <a class="series-card series-card-next series-card-coming" href="#{h(url_for(site, SERIES_PAGE))}">
        <span class="series-card-body">
        <span class="series-card-dir">You reached the end of this series</span>
        <span class="series-card-title">Browse the other series &rarr;</span>
        </span>
        </a>
      HTML
    end

    def footer_html(site, info)
      ms = info[:memberships]
      prev_entry = nil
      next_entry = nil
      ms.each do |m|
        seq = m[:series]["entries"]
        i = m[:index]
        prev_entry ||= seq[i - 1] if i.positive?
        next_entry ||= seq[i + 1] if i < seq.size - 1
      end

      prev_html = prev_entry ? card_html(site, prev_entry, :prev) : %(<span class="series-card-empty"></span>)
      next_html =
        if next_entry
          card_html(site, next_entry, :next)
        else
          last = ms.last[:series]
          last["status"] == "ongoing" ? coming_html(site, last) : more_series_html(site)
        end

      titles = ms.map { |m| series_link(site, m) }.uniq.join(" &rarr; ")
      <<~HTML
        <nav class="series-nav" aria-label="Series navigation">
        <div class="series-nav-head">
        <span class="series-nav-title"><i class="fa-solid fa-layer-group fa-sm"></i> #{titles}</span>
        <a class="series-nav-all" href="#{h(url_for(site, SERIES_PAGE))}">All series &rarr;</a>
        </div>
        <div class="series-nav-grid">
        #{prev_html}#{next_html}
        </div>
        </nav>
      HTML
    end

    def inject_css(site, html)
      return html if html.include?(CSS_HREF)

      link = %(<link rel="stylesheet" href="#{h(url_for(site, CSS_HREF))}">)
      html.sub("</head>") { "#{link}\n</head>" }
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      SeriesNav.reset!
      defs = site.data["series"]
      return unless defs.is_a?(Hash)

      posts = site.posts.docs
      by_slug = posts.each_with_object({}) { |p, acc| acc[p.data["slug"]] = p }
      special = defs.values.flat_map { |d| [d["prologue"], d["epilogue"]] }.compact

      index = defs.map do |key, d|
        parts = posts.select do |p|
          Array(p.data["categories"]).include?(key) && !special.include?(p.data["slug"])
        end
        parts = parts.sort_by(&:date).each_with_index
                     .sort_by { |p, i| [(p.data["series_part"] || (i + 1)).to_f, i] }
                     .map(&:first)

        entries = []
        if (pro = by_slug[d["prologue"]])
          entries << entry(pro, "Prologue", "prologue", nil)
        end
        parts.each_with_index { |p, i| entries << entry(p, "Part #{i + 1}", "part", i + 1) }
        if (epi = by_slug[d["epilogue"]])
          entries << entry(epi, "Epilogue", "epilogue", nil)
        end

        {
          "key" => key,
          "title" => d["title"] || key,
          "tagline" => d["tagline"].to_s,
          "status" => d["status"] || "complete",
          "order" => d["order"] || 99,
          "published" => parts.size,
          "total" => [d["planned"].to_i, parts.size].max,
          "start_url" => entries.first && entries.first["url"],
          "entries" => entries,
          "_docs" => (pro ? [pro] : []) + parts + (epi ? [epi] : []),
        }
      end
      index = index.reject { |s| s["entries"].empty? }.sort_by { |s| s["order"] }

      index.each do |s|
        s.delete("_docs").each_with_index do |doc, i|
          info = (SeriesNav.nav[doc.relative_path] ||= { memberships: [] })
          info[:memberships] << { series: s, index: i, entry: s["entries"][i] }
        end
      end

      site.data["series_index"] = index
    rescue StandardError => e
      Jekyll.logger.warn "SeriesNav:", "generator failed, series navigation disabled (#{e.class}: #{e.message})"
      SeriesNav.reset!
    end

    private

    def entry(doc, label, role, part)
      {
        "label" => label,
        "role" => role,
        "part" => part,
        "title" => doc.data["title"].to_s,
        "url" => doc.url,
        "description" => doc.data["description"].to_s,
        "thumbnail" => doc.data["thumbnail"].to_s,
        "date" => doc.date.strftime("%B %-d, %Y"),
      }
    end
  end
end

Jekyll::Hooks.register :posts, :post_render do |doc|
  begin
    info = SeriesNav.nav[doc.relative_path]
    next unless info

    site = doc.site
    html = doc.output.to_s

    # The bridge post is a member of two series; show memberships in reading order.
    info[:memberships].sort_by! { |m| m[:entry]["role"] == "prologue" ? 1 : 0 }

    badge = SeriesNav.badge_html(site, info)
    head = html.index('<header class="post-header"')
    head_close = head && html.index("</header>", head)
    html = html[0...head_close] + badge + html[head_close..] if head_close

    start = html.index('<article class="post-content"')
    close = start && html.index("</article>", start)
    if close
      html = html[0...close] + SeriesNav.footer_html(site, info) + html[close..]
    end

    doc.output = SeriesNav.inject_css(site, html)
  rescue StandardError => e
    Jekyll.logger.warn "SeriesNav:", "skipped #{doc.relative_path} (#{e.class}: #{e.message})"
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  begin
    out = page.output.to_s
    page.output = SeriesNav.inject_css(page.site, out) if out.include?('class="series-')
  rescue StandardError => e
    Jekyll.logger.warn "SeriesNav:", "css not injected in #{page.relative_path} (#{e.class}: #{e.message})"
  end
end
