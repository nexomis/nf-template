[![Test Pipeline](https://github.com/nexomis/nf-template/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/nexomis/nf-template/actions/workflows/test.yml)

# {{pipeline name}}

## Description

{{pipeline description}}

## Quick Start

This template includes a tutorial workflow that demonstrates Nextflow 25.10 best practices.

### Tutorial Example: Greeting Document Generator

The tutorial workflow generates personalized greeting documents from a samplesheet:

```bash
# Run the tutorial workflow
nextflow run . \
    --input tests/data/samplesheet.csv \
    --out_dir results \
    --output_format pdf

# Try different output formats
nextflow run . \
    --input tests/data/samplesheet.csv \
    --out_dir results \
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

# Run all tests
nf-test test

# Run specific test
nf-test test main.nf.test
nf-test test modules/process/tuto/write_greeting/main.nf.test

# Run with verbose output
nf-test test --verbose
```

## Key Features (NF 25.10+)

### Strict Syntax Compliance
- No `if` statements in config files
- No params used directly in processes
- Type annotations for all parameters
- Workflow outputs out of preview

### Parameter Handling Pattern
```groovy
// In main.nf - params block with types
params {
    input: Path        // Required (no default)
    out_dir: Path      // Required
    output_format: String = "pdf"  // Optional with default
}

// In entry workflow - map params to meta
ch_samples.map { meta ->
    def new_meta = meta.clone()
    new_meta.output_format = params.output_format
    [new_meta]
}

// In process - read from meta
process CONVERT {
    script:
    def format = meta.output_format ?: 'pdf'
    """
    pandoc input.md -o output.${format}
    """
}
```

### Resource Management
- See [RESOURCES.md](RESOURCES.md) for comprehensive resource configuration guide
- Dynamic resources based on `task.attempt`, input size, or meta attributes
- No params-based conditional resources in strict syntax

## Project Structure

```
.
├── main.nf                          # Entry workflow with typed params
├── nextflow.config                  # Pipeline configuration (NF 25.10+)
├── RESOURCES.md                     # Resource configuration guide
├── .nf-test.config                  # nf-test configuration
├── tests/                           # Test data and nf-test files
│   └── data/
│       ├── samplesheet.csv         # Example samplesheet
│       └── test.md                  # Test markdown file
├── assets/
│   └── samplesheet_schema.json     # Samplesheet validation schema
├── conf/
│   ├── resources.config            # Resource overrides
│   ├── ext.config                  # Process ext.args (params-independent)
│   └── ressources.config           # (deprecated spelling, kept for examples)
└── modules/
    ├── config/                     # Shared configuration (git submodule)
    ├── process/                    # Reusable processes (git submodule)
    │   └── tuto/                   # Tutorial processes
    │       ├── write_greeting/
    │       │   ├── main.nf
    │       │   └── main.nf.test
    │       └── convert_pandoc/
    │           ├── main.nf
    │           └── main.nf.test
    └── subworkflows/               # Reusable subworkflows (git submodule)
```

## Documentation

- [CHANGELOG.md](CHANGELOG.md) - Version history and migration notes
- [RESOURCES.md](RESOURCES.md) - Resource configuration and dynamic resources
- [CONTRIBUTE.md](CONTRIBUTE.md) - General contribution guidelines
- [modules/process/README.md](modules/process/README.md) - Process development guidelines (NF 25.10+)

## Version

**Current version:** 2.0.0 - **Nextflow 25.10** compatible

See [CHANGELOG.md](CHANGELOG.md) for detailed version history, breaking changes, and migration guide.
