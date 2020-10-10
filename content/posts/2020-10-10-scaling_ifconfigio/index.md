+++
layout = "post"
title = "Running ifconfig.io for $80/month"
tagline = ""
description = ""
categories = [""]
date = 2020-10-10
tags = ["ifconfig.io", "microservices"]
draft = true
featured_image = "images/glow_plugs/header.jpg"
+++

It recently came to my attention that [Cloudflare Radar][7] exists. With that tool you can look up the global ranking of any domain. They don't seem to specify how they are tracking this data, but they have stats even for domains such as google.com which does not use cloudflare. With this tool, I discovered that my silly what is your IP address service is in the [top 500 domains][6] **in the world!** As such it is time to talk about how it runs!

I created [ifconfig.io][0] about 6 years ago, and over the years it has needed almost zero scaling. At it's peak it was getting ~980 million requests per day, and currently is about ~540 million a day. That equates to about 5-9k requests per second, with an all time peak of 14krps. That is enough requests that can make even the simplest service struggle. This service costs $80 a month to run. Running what is basically an echo service isn't that interesting, but anything at scale often is.

The tech stack is CloudFlare -> Linode VM (Archlinux) -> [Go Code][1]. This was the original as well as the current architecture, and is very [KISS][8]. There are no reverse proxies, caching layers, containers, or anything else to complicate this. Adding any of those would cause the linux tech stack to start duplicating either the network or connections and each one would be a multiplier of the requirements required. Every time I think about make changes I realize how expensive modern popular solutions are.


## Bandwidth ##
![Total Bandwidth in September into October][3]
The server running [ifconfig.io][0] pushes about 5-7TB of traffic a month. The graph above shows twice that, but that is either because Cloudflare counts both egress and ingress traffic or some other cloudflare accounting. The graph does show that traffic is pretty consistent thoughout the day, it ranges 20-40Mbit/s at any given moment. If I wanted to change cloud providers, here is how much 7TB of egress costs.

* [AWS bandwidth is $0.09/GB][awsec2pricing] or $630/month
* [GCP bandwidth is $0.11/GB][gcpnetpricing] or $770/month
* [Azure Bandwidth is $0.087][azurenetpricing] or $609/month
* [Linode bandwith is $0.01/GB][linodetransferquota] or $70/month*. 


With Linode each VM is comes some included network transfer. The [$80 linode][linodepricing] comes with 8TB of egress traffic included which is more than this service's needs. So [ifconfig.io][0] has $0 (ZERO!) excess bandwidth costs.

It completely baffles me that anyone pays the big three cloud providers for bandwidth. The price for that little bit of bandwidth could get me a full 42U rack, power, and a 1Gbit commit from [Hurricane Electric][hecolo], and still have money left over to buy some hardware to run the service. Granted it isn't a cloud provider.


## Serverless ##
![Total Requests in September into August][2]
Sometimes I debate on making this "serverless." It is indeed a good use case as it could reduce load times in other areas. [ifconfig.io][0] currently gets 16 billion requests per month. This means that in addition to the bandwidth costs above, serverless would bankrupt me very quickly.

* [AWS Lambda][awslamdbapricing] would be $6,500/month!
* [AWS Lambda Edge][awslamdbapricing] would be $20,000/month!
* [GCP Functions][gcpfunctionpricing] would be $6,500/month!
* [Azure Functions][azurefunctionpricing] would be $6,500/month!
* [Cloudflare Workers][cfworkerpricing] would be $8,000/month!

I am basing this on 16 billion requests per month that I am currently getting, however these numbers are not including bandwidth costs. These costs are in addition to the bandwidth costs above.



[0]: https://ifconfig.io
[1]: https://github.com/georgyo/ifconfig.io
[2]: TotalRequestsSept.png
[3]: BandwidthSept.png
[4]: UniqueVisitorsSept.png
[6]: https://radar.cloudflare.com/domain/ifconfig.io
[7]: https://radar.cloudflare.com/
[8]: https://en.wikipedia.org/wiki/KISS_principle

[awsec2pricing]: https://aws.amazon.com/ec2/pricing/on-demand/
[linodepricing]: https://www.linode.com/pricing/
[linodetransferquota]: https://www.linode.com/docs/platform/billing-and-support/network-transfer-quota/
[gcpnetpricing]: https://cloud.google.com/vpc/network-pricing
[azurenetpricing]: https://azure.microsoft.com/en-us/pricing/details/bandwidth/
[hecolo]: https://he.net/colocation.html

[awslamdbapricing]: https://aws.amazon.com/lambda/pricing/
[gcpfunctionpricing]: https://cloud.google.com/functions/pricing
[cfworkerpricing]: https://workers.cloudflare.com/
[azurefunctionpricing]: https://azure.microsoft.com/en-us/pricing/details/functions/