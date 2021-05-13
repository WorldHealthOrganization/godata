---
layout: default
title: Explore OpenFn
parent: Real-World Examples
grand_parent: How to integrate my data with other systems
nav_order: 7
permalink: /explore-openfn/
---

# Exploring the Reference Implementations on OpenFn

## Explore the Live Reference Project on OpenFn.org
Check out a live
  [reference project](https://www.openfn.org/projects/p5amme/jobs) running on
  OpenFn.org to explore the jobs configured for the [Interoperability reference implementations](https://worldhealthorganization.github.io/godata/interoperability-examples/). 
  To log in:
  1. Go to [OpenFn.org](https://www.openfn.org/projects/p5amme/jobs) 
  2. Use the demo project's login credentials: 
  ```
  username: godata@who.int
  password: interop2021
  ```
  3. **[Watch this video](https://sprcdn-assets.sprinklr.com/1652/d3588bef-95ef-4536-98b6-a33cd6ebf293-797828951.mp4)** walkthrough of the OpenFn jobs. And check out the [other demo videos](https://community-godata.who.int/topics/interoperability/5fd8ec64f5c77e114e6c6823). 

  4. Explore the **Go.Data Demo Instance**. If you would like to try Go.Data before downloading and installing yourself then a “sandbox” environment has been made available on a WHO server.  This is a play instance of the latest version of the software and you are free to create an outbreak, populate it with data, experiment with reports, exporting data etc.  You can make any changes that you like to explore the tool and see it in practice and an outbreak with dummy data has been provided to give you a head start.
  - This environment resets every two days however, so should not be used for building demonstrations or for any work that you would like to persist.  Also bear in mind that others may be using the environment at the same time as you
  - To request your login account please complete the form below/send an email to [godata@who.int](mailto://godata@who.int) including:
  1. The name of your institution and the country where you are working
  2. Your intended use of Go.Data
  3. Your preferred duration for using the demo site

## Getting started on OpenFn.org&apos;s free forever tier
OpenFn integration platform provides a *free-forever* tier for users wanting to quickly prototype and test integration flows, or experiment with existing OpenFn jobs (or "integration scripts") implemented by other real-world organizations on the hosted platform [OpenFn.org - register here](https://www.openfn.org/signup).

- Swing by [docs.openfn.org](https://docs.openfn.org)), a one-stop show for
  detailed documentation, how-to&apos;s, and helpful guides for many different
  aspects of data integration and interoperability in the health and
  humanitarian space.
- To understand how the "job" scripts, see "Composing Job Expressions" and "Job Execution" on
  [docs.openfn.org](https://docs.openfn.org) and notice how in each job in the
  reference implementation we handle different types of source data, perform
  certain transformations, and connect to different systems.
- Grab a copy of the job scripts on
  [GitHub](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs)
  so you can create your own repo and link this to your own OpenFn project or run on open-source tools (see below). 
- And check out the [Jobs Library](https://docs.openfn.org/library) for more examples of
  how people are creating jobs and triggers to implement interoperability
  solutions across ICT4D.

Many users will prototype integration jobs on OpenFn.org to leverage the web-based "integration 
studio" and job-writing IDE before deploying the jobs via open-source tools (see below) or the hosted platform service.


## Running these jobs using only open-source tools

All of the jobs used in the [Interoperability reference implementations](https://worldhealthorganization.github.io/godata/interoperability-examples/) are built to run
with OpenFn's free and open-source core, which means they're completely portable
and can also be processed using `OpenFn/devtools`, `OpenFn/microservice`, or any
place you can run [NodeJS](https://nodejs.org/en/)—such as Linux, Windows,
MacOS, &c.

### Microservice

[OpenFn/microservice](https://openfn.github.io/microservice) makes use of
OpenFn&apos;'s open-core technology—namely OpenFn/core and the various OpenFn
adaptors—to create standalone integration servers which can be deployed on any
hardware.

### Devtools

[OpenFn/devtools](https://openfn.github.io/devtools/) is a set of free and open
source ETL tools for building, running, and debugging integrations from your
command line.

## Questions on OpenFn jobs & Go.Data API integration setup? 

Mention `@openfn` in the [Go.Data Community](https://community-godata.who.int/). 

Also check out the OpenFn documentation [docs.openfn.org](https://docs.openfn.org) and [Github](https://github.com/OpenFn). 
