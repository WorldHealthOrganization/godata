---
layout: default
title: Explore OpenFn
parent: Reference Implementations
grand_parent: Go.Data Interoperability
nav_order: 7
permalink: /explore-openfn/
---

# Exploring the Reference Implementations on OpenFn

## Getting started on OpenFn.org&apos;s free forever tier

- Swing by [docs.openfn.org](https://docs.openfn.org), a one-stop show for
  detailed documentation, how-to&apos;s, and helpful guides for many different
  aspects of data integration and interoperability in the health and
  humanitarian space.
- Check out a live
  [reference project](https://www.openfn.org/projects/p5amme/jobs) running on
  OpenFn.org
- See "Composing Job Expressions" and "Job Execution" on
  [docs.openfn.org](https://docs.openfn.org) and notice how in each job in the
  reference implementation we handle different types of source data, perform
  certain transformations, and connect to different systems.
- Grab a copy of the job scripts on
  [GitHub](https://github.com/WorldHealthOrganization/godata/tree/master/interoperability-jobs)
  so you can create your own repo.
- And check out the [Jobs Library](docs.openfn.org/library) for more examples of
  how people are creating jobs and triggers to implement interoperability
  solutions across ICT4D.

## Running these jobs using only open-source tools

All of the jobs running in the OpenFn reference implementation are built to run
with OpenFn's free and open-source core, which means they're completely portable
and can also be processed using `OpenFn/devtools`, `OpenFn/microservice`, or any
place you can run [NodeJS](https://nodejs.org/en/)—such as Linux, Windows,
MacOS, &c.

### Devtools

[OpenFn/devtools](https://openfn.github.io/devtools/) is a set of free and open
source ETL tools for building, running, and debugging integrations from your
command line.

### Microservice

[OpenFn/microservice](https://openfn.github.io/microservice) makes use of
OpenFn&apos;'s open-core technology—namely OpenFn/core and the various OpenFn
adaptors—to create standalone integration servers which can be deployed on any
hardware.
