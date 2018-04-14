---
layout: post
title: "Exchange/Outlook is pretty dreadful."
tagline: ""
description: ""
category: "productivity"
date: "2016-02-08 8:49:05"
tags: ["email", "outlook"]
---

I recently started at a company that uses exchange for email, and enforces that you use the exchange connectors. This means no IMAP or POP; only MAPI and EWS. I have 
tried giving it a fair shot that past few months, but I am fairly frustrated. It’s actually not entirely outlook’s fault, but its a large part.

**Problem number one** is a legacy problem. One email can only exist in one folder. This is great at small scale, and is far less confusing when you “delete” a message, 
however when you’re getting 500+ emails a day multiple views is a plus.

An example of where this is a problem. You are subscribed to many mailing lists for your various projects, some of which you are only some what involved in. You have 
filters to put the various mailing list in their respective folder, however you need to make sure that messages that explitily include you on the recipients list go to 
your inbox. This is fully possible and done cleanly, great. Now someone CCs you on a 20 message thread, you ONLY get the one in your inbox, and now have to hunt for the 
rest of the thread. Worse still, the thread could be pretty fairly distributed across many folders depending if other projects were CCed and their ranking in your 
filter list. You now have a very broken picture on the message you been CCed on, and if you can’t quickly gather everything, you are SOL and have to come into the 
thread crippled, missing pieces of the puzzle, and trying to help.

What you can do is preform a search over all your folders, however outlook does not index on the fly, so a message received 15 minutes ago may still be missing from the 
index. So you are actually reliant on the message thread being in that hard to read format in the body.

This includes messages you sent. They end up in your Sent folder, so they are not attached to the thread. Outlook knows you likely want to see your messages, so it 
tried to do that search for you and include it in the thread view, but it only does this if you expand the thread. The thread view by default will only show the last 
two messages, and hides the rest behind a very small down arrow to expand. This makes it easy to loose context on how much trouble and issue is causing.

You may be saying that you can tag a message multiple colors and then give those colors meaning. You can each create search views for each color to get you that more 
complete picture you are looking for. I tried this and failed. Creating the different colors is pretty hard, and outlook just shows it as a square of that color. 
Creating the filters become increasingly hard, as the wizard is the only way and nibbles at your soul while using it. In addition, it doesn’t even solve the problem. 
You create the search views for the different colors, but each message is tag individually. So the color search view only helps in situations where a message is on more 
than one mailing list, where one of the mailing lists was consistent all the way though.

**My solution** was to ditch outlook in favor of gnome’s evolution on linux. You may be thinking that evolution is an odd choice, and I would agree with you. I tried 
using Thunderbird, however it seems to have dropped support for MAPI and someone wants to charge a few hundred bucks for an EWS plugin.

Evolution also doesn’t have tags, but the search functionality is really top notch. It is both realtime and significantly faster the outlook. I can’t undersell how much 
faster the search is, and I am not talking about folder search, I am talking about all messages everywhere search.

Evolution’s search folders has two bits of magic. One, you can search for all related bits of mail. This means all messages that are part of a thread show up, including 
cross posts, and your own replies. Two, there is a automatic folder for all unmatched mail. So as you are creating your filters, you can be extremely specific, and keep 
pulling things out of the unmatched folder till you are have created a ruleset for all incoming mail.

One of my folders is called “ME”. It includes all mail I sent and received where I was explicitly entered on the TO or CC fields, and all the mail messages relating to 
that. This means, if I reply to a thread and I wasn’t on the TO or CC, the entire thread still shows up in the ME folder, and future replies are tracked! I finally have 
a method to look at all the mail that is of importance to me. I can watch ONLY that folder, and be reasonable sure that I am not missing mail that requires my immediate 
action.

Evolution is not perfect, but it is far better than both Apple Mail and Microsoft Office (both Mac and Windows versions). It’s has a leg up on the Mac version by a fair 
bit. The only limiting thing is you can’t edit the exchange server side filtering rules. But I no longer care about those.

The Windows version of office has feature sets that are missing for from all other exchange compatible clients. An example of that is team calendars. Only the windows 
version of office lets you see you entire’s teams calendar. Its not exactly a pretty view, but its better than nothing.

