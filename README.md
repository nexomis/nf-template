[![Test Pipeline](https://github.com/nexomis/nf-template/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/nexomis/nf-template/actions/workflows/test.yml)

# Add a Title

## Description

Add a description

## Quick Start

This template includes a tutorial workflow that demonstrates Nextflow 25.10 best practices (according to me).

### Tutorial Example: Greeting Document Generator

The tutorial workflow generates personalized greeting documents from a samplesheet:

```bash
# Run the tutorial workflow
NXF_VER=25.10.0 nextflow run . \
    --input tests/data/samplesheet.csv \
    --output_format pdf

# Try different output formats
NXF_VER=25.10.0 nextflow run . \
    --input tests/data/samplesheet.csv \
    --output_format rtf
```

**What it demonstrates:**
- ✅ Typed params block (NF 25.10+)
- ✅ Parameters passed via meta, not used directly in processes
- ✅ Workflow outputs with `publish:` and `output {}` blocks
- ✅ Workflow handlers (`onComplete`, `onError`)
- ✅ Dynamic values passed through metadata
- ✅ nf-test for testing

**Samplesheet format** (`tests/data/samplesheet.csv`):

```csv
sample,title,level
Alice,Ms,intermediate
Bob,Mr,beginner
Charlie,Dr,advanced
```

## Testing

This template uses [nf-test](https://code.askimed.com/nf-test/) for testing.

```bash
# Install nf-test (if not already installed)
curl -fsSL https://get.nf-test.com | bash

# Run specific test
nf-test test main.nf.test

# Run with verbose output
nf-test test --verbose
```

## Documentation convention

- [RESOURCES.md](RESOURCES.md) - Resource configuration and dynamic resources
- [CONTRIBUTE.md](CONTRIBUTE.md) - General contribution guidelines
- [modules/process/README.md](modules/process/README.md) - Process development guidelines (NF 25.10+)
- [CHANGELOG.md](CHANGELOG.md) - Version history and migration notes
