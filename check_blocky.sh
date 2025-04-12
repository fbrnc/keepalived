#!/bin/sh

dig @127.0.0.1 -p 53 healthcheck.blocky +tcp +short || exit 1