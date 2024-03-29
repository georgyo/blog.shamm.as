+++
layout = "post"
title = "SSHCRYPT"
tagline = ""
description = ""
categories = ["crypto"]
date = 2016-01-23
tags = ["SSH", "crypto"]
+++

The other day, my friend was asking how to encrypt a file public key. I assumed he meant a PGP key, but he was actually talking about ssh keys. A quick google shows
people have asked this question before, with kind of lack luster answers.

The majority of ssh keys are actually RSA keys, which is good as they are the only type of ssh keys which can also encrypt. It also happens to be the majority of PGP
keys are also RSA keys. As a result, the underlying encryption of PGP messages and authenticating to a server are usually the same.

OpenPGP is pretty fantastic. It a great standard for secure communication between to parties. However the hardest part about modern cryptography between two separate
individuals is not getting a secrete key to the other person, but ensuring the key you did receive actually belongs to individual and that individual alone, and not the
some other third party sitting in-between the separation. I have not seen a solution that is both decent and usable; including services like keybase. The key
distribution problem is hard to solve correctly, and I am not going to attempt to solve it today.

A regular use case for PGP is Alice wants to send Bob a message that no one else can see. Alice asks Bob if he uses PGP, bob says no. Alice then spends 30 minutes
convincing Bob that PGP is good, and another two days teaching Bob how to use GnuPG. After much frustration, the original encrypted message is sent and decoded
successfully. WOOT! Bob never uses PGP again, and Alice wants an easier way.

On the other hand, ssh-keys are very popular. Bob uses github, Alice can easily get all of Bob’s ssh public keys at
[https://github.com/bob.keys](https://github.com/bob.keys). Very handy for giving access to a server, but not for sending files, even though all those keys use the
exact same encryption scheme as the PGP key Bob created for Alice earlier.

For some reason, many people think that PGP is either hard or complicated. GnuPG is a pretty fantastic tool, but usability is not its strong suit. To the average user,
the PGP trust model is both confusing and complicated. Unless you are in a work environment or surrounded by people who actively care about PGP and it’s features,
people misuse it and don’t appreciate it.

Keybase’s solution is signing a keybase advertisement on various social media services. This is suppose to validate both your key and your various other accounts. Its a
noble effort, but keybase fails in a few areas, which I’ll get into another time. For the purposes of this toy, if you trusting a single website to be a key authority,
why not Github? The fact is that for many people working in tech, their code is on github, and so there is implicit trust on both github and the user’s ssh keys who
access your codebase.

Why someone hasn’t made a simple tool to use those keys to send someone is a mystery. That’s what this tool hopes to solve.
