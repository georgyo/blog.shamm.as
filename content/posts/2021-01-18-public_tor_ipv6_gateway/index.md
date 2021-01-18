+++
layout = "post"
title = "Public TOR IPv6 Only Gateway"
tagline = ""
description = ""
categories = [""]
date = 2021-01-18
tags = ["tor"]
draft = false
featured_image = "/images/glow_plugs/header.jpg"
+++


These days, I feel like TOR is really getting pushed as only a method for anonymous internet browsing; almost entirely focused on HTTP. However TOR hidden services are really neat. They are the opposite of the client use case  of TOR and are for server anonymity. The problem with TOR hidden services is that they require the clients to run the TOR software to view at all. Worse, for connecting to any other service besides HTTP requires jumping over some significant hurdles. The client side configuration for visiting hidden services is actually _harder_ than the server side configuration.

There isn’t a great way for clients who don’t care about anonymity to access a hidden service in a similar fashion as TOR clients connecting to a public and known client. That’s not entirely true, there are public HTTP proxies like https://onion.ws or https://www.tor2web.org/ that are pretty decent. And those services go a step further by adding SSL and rewriting onion URLs so they work behind the proxy.

But what if you wanted to run a hidden SSH, IRC, or any non HTTP application but also wanted clear net visitors to be able to access your service. That is very difficult.  But what if we could give every TOR onion address an IPv6 address? Well TOR has this functionality built right into it!

## Enter onion.contact

I present to you https://onion.contact, similar to http://onion.ws, just adding .contact to the end of an onion address will forward the connection to the hidden server. Unlike onion.ws it gives each and every hidden services it’s own IPv6 address and the DNS results are secured with DNSSEC.

This enables the following use cases which were all impossible before hand without using the tor software directly.

### Examples, these require IPv6 connectivity.

Run a hidden ssh-chat server that is public on the internet
```bash
ssh huwugtmg6ae7oaogbg2uzot44ab4d6wkongdhee2fbohui372jdim5yd.onion.contact
```

Get let’s encrypt SSL certs for your hidden service:
https://4vev4mklgvmgo6ue.onion.contact

You can CNAME your content as well!
- [rendezvous-direct.fu.io](http://rendezvous-direct.fu.io/)

OR Put Cloudflare in front of it (which also gives it an IPv4 Address and SSL)
- [rendezvous.fu.io](https://rendezvous.fu.io/)

/!\ WARNING: Most onion websites don’t really work well without URL rewriting like an HTTP proxy can. 

This also means you can run a hidden mail server that can receive mail from the public internet (provided your mail server has an IPv6 address).
- [tor@tormail.fu.io](mailto:tor@tormail.fu.io)
- [tor@4h7xf55h5slylp67qgnmptttbkqpatrhtgqwby2sripwdijo2lbbloyd.onion.contact](mailto:tor@4h7xf55h5slylp67qgnmptttbkqpatrhtgqwby2sripwdijo2lbbloyd.onion.contact)

## Should I use this?

No. Maybe? It's complicated.

If you're a client and you want to connect to a service, you should likely use TOR and set things up properly. However if want to run a service where you want to be anonomus but visting the site won't endager your users, then this might be a tool for you.

If you're just going to run a static website, there are plenty of free static hosting websites that are reachable over TOR and don't require any identifying information. Those are much better tools for that task. However dynamic content that can actually handle any load is much harder to find anonomus solutions.

## Fine print / Drawbacks

There are a few downsides to this method.

- This provides no client side anonymity, IE people can see your DNS requests and that you are connecting here.
- The IPv6 addresses are only gaurenteed to stick around for 60 seconds. They are much less likely to change that that, but they will change from time to time.
- Most TOR services won't have SSL (and shouldn't) but even those that do will likely have the cert for a different domain, expect errors.
- It's running on one (underpowered) VM. It will be very easy to take it down with requests if it becomes popular.
- I listed mail as an example use case. Most spam prevention is based on the source IP. You will have to figure out how to filter you're mail much more effectively.
- Myself and the server live in the USA. I will cave to any legal presure, this is a project I'm doing for fun.

## Okay, how is this implemented?

The setup is rather simple, there isn't a lot of moving parts.

- An IPv6 Block is routed to the server.
- TOR acts as a transparent proxy and DNS server
- CoreDNS rewrites the DNS queries and adds DNSSEC
- NFTables redirects the IPv6 block to TOR's transparent proxy.

That's it.

### Tor config:
```bash
# This is the default IPv4 network, it isn't possible to unset this or turn off IPv4 resolution.
VirtualAddrNetworkIPv4 10.192.0.0/10
VirtualAddrNetworkIPv6 2600:3c03:e000:03e6::/64
AutomapHostsOnResolve 1
TransPort [::]:9040 IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort
TransPort 0.0.0.0:9040 IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort
DNSPort 9053
```

### CoreDNS / Corefile:

I did make some slight changes to CoreDNS to make this work. Those changes can be found [here](https://github.com/coredns/coredns/compare/coredns:master...georgyo:onion_ist)

```bash
onion.contact {
    dnssec onion.contact {
      key file /etc/coredns/Konion.contact.+015+58313
      key file /etc/coredns/Konion.contact.+015+57085
    }
    file /etc/coredns/onion.zone.signed
    # We redirect to ourselves as it is not possible to make forward, file, rewrite, and dnssec play nice with each other.
    forward . 127.0.0.1:8053 {
      # except_type is not part of basic CoreDNS
      except_type A CAA RRSIG NSEC TXT DNSKEY DS SPF NS SOA SRV PTR CERT DNAME APL AFSDB SSHFP MX
    }
}

.:8053 {
    rewrite continue {
      name regex (.*)\.onion\.contact {1}.onion
      answer name (.*)\.onion {1}.onion.contact
    }
    forward . 127.0.0.1:9053
}
```

### NFTables

These rules could be trimmed down a bit more, however I think it's more valuable to show a more complete config.

```bash
# Verify your network interface with ip addr
define interface = eth0
# Verify tor uid with id -u tor
define uid = 43
define tor_trans_subnet = 2600:3c03:e000:03e6::/64
define tor_trans_port   = 9040

table inet nat {
        chain PREROUTING {
                type nat hook prerouting priority -100; policy accept;
                jump prerouting_output
        }

        chain OUTPUT {
                type nat hook output priority -100; policy accept;
                jump prerouting_output
        }

        chain prerouting_output {
                meta l4proto tcp ip6 daddr $tor_trans_subnet redirect to $tor_trans_port
        }
}

table inet filter {
        chain INPUT {
                type filter hook input priority 0; policy drop;
                iifname "lo" accept
                ct state invalid counter drop comment "Drop invalid connections"
                ct state established,related accept comment "Accept traffic we are responding to"
                meta l4proto ipv6-icmp icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, ind-neighbor-solicit, ind-neighbor-advert, mld2-listener-report } accept comment "Accept ICMPv6"                                                
                meta l4proto icmp icmp type { destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem } accept comment "Accept ICMP"
                ip protocol igmp accept comment "Accept IGMP"
                iifname $interface meta l4proto tcp tcp dport $tor_trans_port ct state new accept
        }
        chain FORWARD {
                type filter hook forward priority 0; policy drop;
                ct state invalid counter drop comment "Drop invalid connections"
                ct state established,related accept comment "Accept traffic we are responding to"
                ip6 daddr $tor_trans_subnet accept
        }
        chain OUTPUT {
                type filter hook output priority 0; policy drop;
                ct state invalid counter drop comment "Drop invalid connections"
                ct state established,related accept comment "Accept traffic we are responding to"
                oifname "lo" accept
                oifname $interface meta l4proto tcp ip6 saddr $tor_trans_subnet accept
                oifname $interface meta l4proto tcp skuid $uid ct state new accept comment "Accept Tor Connections"
                oifname $interface meta l4proto tcp skuid 0 ct state new accept comment "Accept root connections"
        }
}
```



