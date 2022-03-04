# trame-nomad

Exploration on how to leverage nomad/consul/fabio for better scaling management.

## Pre-requisit

We assume that [__nomad__](https://learn.hashicorp.com/tutorials/nomad/get-started-install), [__consul__](https://learn.hashicorp.com/tutorials/consul/get-started-install) and [__fabio__](https://fabiolb.net/quickstart/) are installed.

We need to run __nomad__ and __consul__ agent as dev mode for now to simplify testing

__nomad__
```
sudo nomad agent -dev -bind 0.0.0.0 -log-level INFO
```

__consul__
```
consul agent -dev
```

## Starting jobs

We'll start __fabio__ as a nomad job

```
nomad job run ./jobs/fabio.nomad
```

Then we want to create "trame jobs" ideally as template job and rely on a dispatch mechanism.

```
nomad job run ./jobs/trame-demo.nomad
nomad job run ./jobs/trame-demo-secret.nomad
```

And we want to have fabio route traffic to those jobs using some kind of ids

Connect client to fabio endpoint

```
http://localhost:9999/${ALLOCATION_ID}/
```

Dispatch job with secrets

```
nomad job dispatch -meta SECRET=xyz trame-demo-secret
```

```
http://localhost:9999/${ALLOCATION_ID}/?name&secret=xyz
```

## Web UI for -dev agents

- nomad:  http://localhost:4646/
- consul: http://localhost:8500/ (Not working when not localhost?)
- fabio:  http://localhost:9998/


## Cheatsheet

- Start job: `nomad job run ./jobs/trame-demo.nomad`
- Clear job: `nomad job stop -purge trame-demo`