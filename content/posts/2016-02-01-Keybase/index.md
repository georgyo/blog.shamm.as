+++
layout = "post"
title = "Keybase?"
tagline = ""
description = ""
categories = ["crypto"]
date = 2016-02-01
tags = ["crypto", "pgp", "keybase"]
+++

Key distribution is hard, no doubt about that. Keybase has a pretty good idea on its head, but falls on its face at the finish line.

The keybase approach of authenticating a key belongs to someone is by signing an advertisement for keybase with your private key and posting it to a social media
account. This is actually a pretty decent idea, people are generally pretty sure their facebook/twitter/etc friend is the person they think it is. The more accounts you
link to keybase, the harder it is for them to spoof being you, and ergo makes your public key’s authenticity pretty good!

The problems with keybase is that it choose to be a central and singular provider for this task, in addition of being incompatible with all other previous solutions.
Not because their methods would prevent that, but because they choose to be loners doing their own thing. It makes me unbelievably sad, that people use it and talk
about it as a good thing. Lets break down the places where it fails.

Keybase is a business. The most important thing to realize is that keybase is a startup. It’s core codebase is proprietary, there is no federation, and is incompatable
with everything that has come before it. The end game for keybase is the same as every startup. Get bought, shutdown, or work to become profitable. Two of those are
actually almost the same outcome for the user, in which the user becomes the product.

If it becomes the defacto standard, keybase becomes the authority on authority. Since a large portion of their users will be storing their private key with them, when
they get subpoenaed, they can hand over that (encrypted) private key with ease. The encrpytion on the private key is not a new problem for authorities, who have focused
much effort on brute forcing those semetric ciphers. Oh, and a sucesfull XSS attack or MITM with a bit of javascript can surender the entire key.

OpenPGP already happens to have a way to ensure a key belong to the person who they say it belongs to using a [web of trust](http://en.wikipedia.org/wiki/Web_of_trust).
The web of trust only works the more people use it, and only if they follow it religiously. You can however sign a key saying you have not done much effort to ensure
the key belongs to who you say it belongs to. These key signatures would still help non-keybase users to verify if a key is valid. When you follow (track) a user in
keybase, you use your private key to sign a message saying that you are tracking them. You do not however actually sign their key at all. This is just plain dumb, so
close but they perfer to be their own island.

Keeping on that island, when you prove that you own an social media account, that could easily be encoded in the public key directly. This would make a public key be
enough to validate itself using its own metadata. Keybase again choose to be an island, they store all the proof links in their database, and require API calls to
retrieve. If they go ofline, you cannot access the proof status, and cannot validate the the proofs yourself because they are all stored on the island of keybase.

When a normal user goes to keybase, they can choose to create a key completely in their browser. This is a pretty useful for usability, but the key created will have an
identifier of “keybase/username” instead of the user’s email address. This is because you can change your email address in keybase, but you can’t change your username.
So they instead of making the email address unchangeable, they chose to be different because it was inconvenient for them. This also means that any mail client that
uses gpg won’t be able to automagically find the correct key to encrypt to.

In the keybase island, they key’s identification is actually discarded. I can upload a key to my account that has your email and your name. People can track me, and
send messages to me using keybase and be none the wise. However if you do go into gpg and list public keys, they won’t see my name or email anywhere, only yours.
Furthering the gap for email client’s ability to choose to correct key.

The client side tools for keybase are written in node.js, which is an interpreted language, not easy for normal users to install, and is subject to dependency hell for
developers. This highly discourages the use of the the CLI except for the brave, and using raw gpg commands leaves you out in the cold since they broke away from all
the standards.

Keybase has a good premiss. It would be cool to see an open standard that uses their ideas. But their greed has made me greatly dislike their product.
