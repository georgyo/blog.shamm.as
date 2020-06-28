+++
layout = "post"
title = "Exchange/Outlook is pretty dreadful."
tagline = ""
description = ""
categories = ["productivity"]
date = 2016-02-08
tags = ["email", "outlook"]
+++

# Two factor for SSH, revisited.

There are a great many guides that are using google authentication as a two factor source for SSH, and this is fine for one off servers where you are the one and only 
admin of that server. However there are several problems for a multi-server and/or multi-user environments. Let’s review these problems, getting a better understanding 
of two factor auth, and some solutions.

**Problem 1:** The secret key is stored in your user’s home directory on the server. With it, you can generate tokens at any time. This means that if your server gets 
compromised, they can now generate your one time tokens at will. If you have 10 servers using the same token, they can generate that token for all of them.

**Problem 2:** Since we have to both create a new key for each server AND add it to every single user’s phone, there is no method to securely provision servers. Every 
time that you would want to, you would need some method of securely distributing every users key to them, and hoping that you don’t annoy them with the added burden of 
having many keys.

**Problem 3:** OpenSSH when configured to allow SSH keys, by-passes PAM entirely, meaning they are ignoring your second factor entirely. There is a solution to this 
particular problem, but as I’ll get into in a minute, SSH keys + Google Authenticator is not two factor. Something you have + something you have = 1 factor (something 
you have).

A fair counter point is that you should not have many servers with SSH exposed to the internet. I agree with this completely. However problem 2 still applies. If you 
hire a new employee who is remote, how do you securely give them their private key? If you need to re-provision that server, are you storing all this secret data in 
your puppet/chef/salt/ansible configuration? If one of your employees (who had root access) quits, can you be 100% sure they didn’t take all the authenticator keys? 
Hope you like refreshing and distributing all the secret keys periodically.

## What is two factor authentication?

Let’s take a step back. What is two factor authentication, and why does it matter? Two factor authentication is some combination of:

* Something you know (ex. password, pattern, etc)

* Something you have (ex. hardware token, google authenticator, secret keys, SMS, etc)

* Something you are (ex. finger print, face, hand geometry, retinas, etc)

Each factor has flaws by itself. If you only use passwords, and an attacker knows or guesses your password, they have access. If you only google authentication, and a 
person has your phone, they have access. If you only use your finger print, and it gets lifted off your glass, they have access.

The idea is that each of these present different challenges to the attacker. They may be able to get your password through phishing but they couldn’t use the same 
technique to read your phone. You have just doubled their problem space! This is good for you, and bad for them.

A common mistake is using two of the same types of factors and thinking this make you secure. While this might add some complexity to targeting you, history has shown 
that having two passwords are both targetable with phishing. 

TK: Give an examples.

### Are SSH Keys two factor?

Something I see a lot is that people consider SSH keys to be two factor by themselves. While you can and should put a password on your SSH key, as a server operator you 
have **no** way to enforce that a user has one. The lack of enforcement makes it pretty hard to ensure that your users are protected by two factor.

## Solutions!

There are many many many solutions to two factor when it comes to web apps, because they are centralized and they are used by billions of people. SSH on the other hand 
has much fewer user, and many users have a weak understanding of best practices. Here are three to get you thinking.

### Solution 1:

If you only have one or two servers, and have absolute trust in all the people who can log in, you can stick with google authenticator.

If you do this, be 100% sure that you disable ssh keys entirely. All users should and must log in with both their authenticator code and their password.

### Solution 2:

Configure SSH to enforce both SSH Keys and Passwords using AuthenticationMethods. This method has the benefit that it has no dependencies on external services, requires 
no trust handling of private keys on the server. In the case bastion hosts, that SSH key could be used with an agent to make easy and secure access to other servers.

TK: Create Guide

### Solution 3:

Finally, you can use an external two factor services. An example of this would be yubikey. Almost all these external services are modules for PAM. This means that SSH 
keys will by-pass them, so be sure to reach them fully, and disable SSH keys completely should they be PAM based.

## Conclusion

