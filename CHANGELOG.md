# Changelog

All notable changes to this Nextflow template will be documented in this file.

## [2.0.0] - 2025-11-05

### Major Update: Nextflow 25.10 Migration

This release migrates the template to be fully compatible with **Nextflow 25.10** and strict syntax.

### Added

- ✅ **Typed params block** - Parameters now use type annotations (Path, String, Boolean, Integer)
- ✅ **nf-test integration** - Modern testing framework replacing manual test scripts
  - Process tests for `WRITE_GREETING` and `CONVERT_PANDOC`
  - Workflow-level integration tests
  - Test data in `tests/data/`
- ✅ **Tutorial workflow example** - Complete working example demonstrating best practices
  - Greeting document generator with Markdown → Pandoc conversion
  - Demonstrates params → meta → process pattern
  - Shows dynamic output format via metadata
- ✅ **Comprehensive documentation**
  - `RESOURCES.md` - Resource configuration guide with dynamic resource patterns
  - Updated `modules/process/README.md` with NF 25.10 patterns
  - `meta.args_<processname>` pattern documentation
- ✅ **Samplesheet schema** - JSON schema for input validation with nf-schema 2.6.1
- ✅ **Workflow outputs** - Out of preview, using `publish:` and `output {}` blocks
- ✅ **Workflow handlers** - `onComplete` and `onError` in entry workflow
- ✅ **Testing** - with `nf-test`

### Changed

- ⚠️ **BREAKING**: Minimum Nextflow version now **>= 25.10.0** (was 24.10.3)
- ⚠️ **BREAKING**: `manifest.author` → `manifest.contributor` (now supports structured metadata)
- ⚠️ **BREAKING**: Params must be defined in typed `params {}` block in main.nf
- ⚠️ **BREAKING**: Resource params removed from `nextflow.config`
- **Improved**: Parameters only used in entry workflow, passed to processes via `meta`
- **Improved**: Config files (`conf/ext.config`, `conf/resources.config`) are params-independent
- **Updated**: `.gitignore` for nf-test artifacts

### Deprecated

- `conf/ressources.config` - Kept for examples but points to correctly-spelled `conf/resources.config`
- Legacy params-based resource configuration patterns
- Using params directly in process definitions

### Removed

- ❌ Resource parameters from `nextflow.config` (use config files or dynamic directives instead)
- ❌ Conditional logic in config files (not compatible with strict syntax)
- ❌ Old test strategy (replaced with nf-test)

## [1.0.0] - Previous Version

Initial template version compatible with Nextflow 24.10.3.
