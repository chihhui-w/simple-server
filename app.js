const express = require('express');
const app = express();
const port = 9999;

console.log("aaa");

const rssXml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
    xmlns:georss="http://www.georss.org/georss"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
  <channel>
    <title>eFavormart</title>
    <atom:link href="https://www.efavormart.com/feeds/pinterest" rel="self" type="application/rss+xml"/>
    <link>https://www.efavormart.com</link>
    <description></description>
    <lastBuildDate>Fri, 16 May 2025 03:59:53 +0000</lastBuildDate>
    <language>en-US</language>
    <sy:updatePeriod>daily</sy:updatePeriod>
    <sy:updateFrequency>1</sy:updateFrequency>
    <generator>https://www.efavormart.com</generator>
    <item>
      <title>aaaa</title>
      <link>https://www.efavormart.com/pages/shop-the-look/category?id=164&amp;look=6986</link>
      <dc:creator><![CDATA[ aaaa ]]></dc:creator>
      <pubDate>Tue, 25 Feb 2025 09:44:10 +0000</pubDate>
      <guid isPermaLink="false">https://www.efavormart.com/pages/shop-the-look/category?id=164&amp;look=6986</guid>
      <description>aaaa</description>
      <content:encoded><![CDATA[<img src="https://diukz67o0uvdj.cloudfront.net/6986.png"/>]]></content:encoded>
      <post-id xmlns="efavormart:feed-look-id:6986">6986</post-id>
    </item>
  </channel>
</rss>`;

app.use(express.json());
app.get('/api/xml', (req, res) => {
//   res.set('Content-Type', 'application/rss+xml; charset=utf-8');
//   res.send(rssXml);
    res.type('application/rss+xml').send(rssXml);
});

app.listen(port, () => {
  console.log(`Express server running at http://localhost:${port}`);
});
