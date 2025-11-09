# Resource Configuration Guide

This guide explains how to configure computational resources (CPU, memory) for processes in this Nextflow pipeline.

## Overview

Starting with Nextflow 25.10 and strict syntax compliance, resource configuration follows these principles:

- **Pipeline-specific overrides** can still be set in `conf/resources.config`
- **Dynamic resource allocation** is avoided in strict syntax
  - No dynamic closure in config file - [docs](https://nextflow.io/docs/latest/strict-syntax.html#configuration-syntax)
  - `params` map cannot be used outside of workflow entry - [docs](https://nextflow.io/docs/latest/strict-syntax.html#using-params-outside-the-entry-workflow)

## How to Override Resources

### Option 1: Modify conf/resources.config (Pipeline Level)

Edit `conf/resources.config` to set process-specific resources:

```groovy
process {
    // Override for specific process
    withName: 'FASTQC' {
        cpus = 4
        memory = 16.GB
    }
    
    // Override for multiple processes
    withName: 'KRAKEN2|KRAKEN2_BUILD' {
        cpus = 16
        memory = 64.GB
    }
    
    // Override by label
    withLabel: 'cpu_high' {
        cpus = 32
    }
}
```

### Option 2: Custom Config File (User Level)

Create a custom config file (e.g., `my_resources.config`):

```groovy
process {
    withName: 'SPADES' {
        cpus = 32
        memory = 128.GB
        time = 48.h
    }
}
```

Then run the pipeline with:
```bash
nextflow run . -c my_resources.config -params-file params.yml
```

## Dynamic Resources in Processes

Dynamic resource allocation strategies (e.g., retry with increasing resources, file-size-based scaling) should be implemented within process definitions using Nextflow's dynamic directive syntax.

**For process developers:** See [modules/process/README.md](modules/process/README.md) section 4.2 "Dynamic Resource Allocation" for patterns and best practices on implementing dynamic resources within processes.
