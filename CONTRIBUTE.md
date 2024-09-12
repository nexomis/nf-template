# Nextflow Pipeline Conventions

Objectives:

- Establish a standardized file structure for Nextflow projects
- Promote modularity and maintainability across workflows
- Ensure clear conventions for configuration and parameter handling

## 0. Project Structure

- Follow a standardized directory layout for organizing workflows, configuration files, and modules.

```
<workflow_name>/
├── conf/
│   ├── ext.conf
│   ├── publish.conf
│   └── resources.conf           (*)
├── assets/                      (*)
│   └── input_schema.json        (*)
├── modules/
│   ├── config/
│   │   ├── process/
│   │   │   └── labels.config
│   │   └── profiles.config
│   ├── process/
│   │   ├── <process_name_1>/
│   │   │   └── main.nf
│   │   └── <process_name_2>/
│   │       └── main.nf
│   └── subworkflow/
│       └── <subworkflow_name_1>/
│           └── main.nf
├── main.nf
├── nextflow.config
├── nextflow_schema.json
└── README.md

  '--'  : submodule
  '(*)' : optional
```

## 1. Help Documentation and Parameters

- Use `nf-validation@1.1.3` for managing help documentation:
  - Include in `main.nf` (see template).
  - Create nextflow_schema.json based on the parameters in the params{} section of nextflow.config.
Example [here](./nextflow_schema.json)

- Use `params.out_dir` to define the output directory.
- Define resource parameters in the `resources_options` section, matching `modules/config/process/labels.config`.
- Manage tool parameterization logic in `.conf/ext.conf`.
Example [here](.conf/ext.conf)

- Note that the plugin `nf-schema` is not compatible with EPI2ME because of its updated JSON schema


## 2. Configuration Files

- Include multiple configuration files in nextflow.config. Load in the following order (lowest to highest priority):
  - `modules/config/process/labels.config` - manages resources assigned to processes/labels.
  - `modules/config/profiles.config` - defines Nextflow profiles.
  - `conf/publish.conf`  manages the publication of processes and subworkflows.
  - `conf/ext.conf` - manages `ext` passed to processes and controls tool arguments.
  - `modules/config/dag.config` - manage the DAG report config
  - `modules/config/report.config` - manage the report config
  - `modules/config/timeline.config` - manage the timeline report config
  - `conf/resources.conf` - manage pipeline specific resources
  
**NOTE:** configuration parameters can be overridden by the `-c` option in Nextflow.

- Use `conf/publish.conf` for centralized management of publication settings for processes.
Example [here](./conf/publish.conf)

## 3. Modules

- Use modules to avoid duplication and maintain compatibility during updates:

  - Link modules in the modules folder:

```sh
mkdir modules
git submodule add https://github.com/nexomis/nf-subworkflows.git modules/subworkflows
git submodule add https://github.com/nexomis/nf-config.git modules/config
git submodule add https://github.com/nexomis/nf-process.git modules/process
```
**NOTE:** submodules are linked to a repository by their hash reference. For them to be updated, they need to be pulled/pushed again.

- See [here](https://github.com/nexomis/nf-process/blob/main/README.md) rules and conventions for process.
- Unique naming is required for specific calls; processes or subworkflows cannot be called multiple times with the same name.

Example:
```
include { GZ as GZ1; GZ as GZ2; GZ as GZ3 } from '../../../process/gz/main.nf'
```

## 4. Subworkflow

- Prefer a single queue channel as input for (sub)workflows; merge inputs into tuples if necessary.
- Avoid using global parameters (params) directly in processes or subworkflows. (such as `params.skip_xxxxx`)
- Use `meta` attributes to implement optional steps. 
Example 1:
```
  inputReadsFromK3
  | map {it[1]}
  | branch {
      spades: it[0].assembler == "spades"
      no_assembly: true
    }
  | set { inputForAssembly }

  SPADES(inputForAssembly.spades)

  SPADES.out.scaffolds
  | set { scaffolds }
```
Example 2:
```
  finalScaffolds
  | filter { it[0].realign == "yes" }
  | set { toRealignScaffolds }

  BOWTIE2_BUILD(toRealignScaffolds)
  BOWTIE2_BUILD.out.idx
  | map { [it[0].id, it[1]] }
  | set { bwtIdx }
```
- Use strategies like `join` followed by `concat|unique` to insert an optional processing step:
```
joinInputForK2i1 = inputReads.join(inputK2i1, by:0)
  KRAKEN2_HOST1(joinInputForK2i1.map { it[1] }, joinInputForK2i1.map { it[2] })
  KRAKEN2_HOST1.out.unclassified_reads_fastq
  | GZ1
  | map {[it[0].id, it]}
  | concat(inputReads)
  | unique { it[0] }
  | set {inputReadsFromK1}
```
## 5. Typography Conventions

- Channel Instances: `lowerCamelCase`
- Groovy Variables (Non-Channels): `snake_case`
- Groovy Functions: `lowerCamelCase`
- Processes or Sub-Workflows: `UPPER_SNAKE_CASE`
- Process Inputs and Outputs: `snake_case`
- Sub-Workflow Inputs and Outputs: `lowerCamelCase`

## 6. Input Files/Directories by Sample

- Use sample sheets to manage input files/directories associated with samples:
- Use unique IDs in dedicated sample sheets to reference input files/directories in the main sample sheet, preventing redundant processing.
- Place sample sheets in the `assets/` directory. 
Example [here](./assets/input_schema.json)

## 7. Testing

- Provide test with `nextflow run . -c data/test/test.config`
- Setup testing parameters in `data/test/test.config`
- Provide testing inputs in `data/test/inputs/`
  - Eventually add a script to dowload input test data
- Test outputs in `data/test/out_dir`
