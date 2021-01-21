---
layout: default
title: Explore OpenFn
parent: Reference Implementations
grand_parent: Go.Data Interoperability
nav_order: 8
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
  password: interoperability
  ```
  3. Check out [the demo videos](https://worldhealthorganization.github.io/godata/interoperability-examples/)

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

Mention `@openfn` in the [Go.Data Community](https://community-godata.who.int/) or post questions on the [OpenFn Community](https://community.openfn.org/). 

Also check out the OpenFn documentation [docs.openfn.org](https://docs.openfn.org) and [Github](https://github.com/OpenFn). 
