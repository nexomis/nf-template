# Nextflow pipeline conventions at Nexomis

## Workflow file structure
```
.
└── <worflow_name>/
    ├── conf/
    │   ├── ext.conf
    │   ├── publish.conf
    │   └── resources.conf           (*)
    ├── assets/                      (*)
    │   └── input_schema.json        (*)
    ├── modules/
    │   ├-- config/
    │   │   ├── process/
    │   │   │   └── labels.config
    │   │   └── profiles.config
    │   ├-- process/
    │   │   ├── <process_name_1>/
    │   │   │   └── main.tf
    │   │   └── <process_name_2>/
    │   │       └── main.tf
    │   └-- subworflow/
    │       └── <subworflow_name_1>/
    │           └── main.tf
    ├── main.nf
    ├── nextflow.config
    ├── nextflow_schema.json
    └── Readme.md

  '--'  : submodule
  '(*)' : optional
```

## Help
The `help` will be managed by `plugin/nf-schema`:
  - Include in `main.nf`
  - Create the `nextflow_schema.json` file according to the parameter values in the `params{}` section in `nextflow.config`

## Config
`nextflow.config` will include the following config files:
  - `modules/config/process/labels.config` for managing resources assigned to processes/labels
  - `modules/config/profiles.config`
  - `conf/publish.config` to manage the publication of processes and subworkflows
**NOTE:** configuration parameters can be overridden by the `-c` option in Nextflow.

## Modules

Except in very rare cases where no existing process or subworkflow calls are made, and where no creation of processes or subworkflows is relevant, the following conventions should be followed.

### Structure of `modules/
Since `include` works only at the repository level, modules will be linked in the `modules` folder (to avoid file duplication and prevent incompatibility issues during module updates).

```sh
mkdir modules
git submodule add https://github.com/nexomis/nf-subworkflows.git modules/subworkflows
git submodule add https://github.com/nexomis/nf-config.git modules/config
git submodule add https://github.com/nexomis/nf-process.git modules/process
```
**NOTE:** submodules are linked to a repository by their hash reference. For them to be updated, they need to be pulled/pushed again.

For each modularized element (subworkflow or subprocess), place it in a folder named after the element containing a `main.nf`, which will be sourced for calls.

### Continue modularity: reusable, and easily maintainable

  - Tag processes with labels present in `modules/config/process/labels.config` and update if necessary.

  - To easily adapt (without multiplying module versions) the publication of `processes` and `subworkflows` (not the case for `workflows`) specifically to each workflow, centralize publication operations in the `conf/publish.conf` file.  
**Note:** to target a specific call of a process or subworkflow they must be imported with an unique name. In all cases a process (or subworkflow) can't be call twices with the same name.

  - Do not directly call parameters (`params`) in processes and sub-workflows: processes and sub-workflows should not directly depend on global parameters. Use channels to pass parameter values in workflows: aggregate parameters into channels at the main workflow level, then pass these channels to processes and sub-workflows as inputs.

  - In order to pass arguments to specific functions use `conf/ext.conf`, those arguments can then be access directly in the subworkflows or processes by calling `task.ext.args`. Preferably, for specific arguments named `xxx`, use `ext.args_xxx` if it's a command line argument to be included as it is in the command line, otherwise use `ext.xxx` (e.g: `ext.force="true"` will be incorporated into the command line as follows: `script.sh --force ${task.ext.force}` and `ext.args_force="--force true"` which will be incorporated into the command line as follows: `script.sh ${task.ext.args_force}`).

## Notations

  - **Reads:** in every workflow, reads will be defined as a tuple with the structure described [below](#queue-channel-for-path)

  - **Typography:** process and workflow names will be written in capital letters: `workflow MY_WF {}`, `process MY_PROCESS {}`.

## Input files/directories by sample

When input files or directories need to be associated with specific samples in a run, it is recommended to use sample sheets. If the same input file or directory is referenced by multiple samples, Nextflow typically handles this with symbolic links rather than physically duplicating the files. However, this can still lead to redundant processing of the same file in different tasks, which can slow down the workflow.

To avoid this redundancy, it is advisable to use dedicated sample sheets for managing input files/directories without repeating processing. In these dedicated sample sheets, each input file or directory will be associated with a unique ID. This ID will then be used in the main sample sheet to reference the sample, instead of specifying the file/directory path directly.

This approach ensures that input files/directories are processed only once, even when linked to multiple samples.

Note: The sample sheets should be placed in the assets/ directory.

## Conventions

### Queue channel for path

*Unless a particular case where this is not relevant,* Queue channel paths will be transmitted and retrieved in the format `tuple val(meta), path(file/dir)` where `meta` being a dictionary containing at least the element identifier in `meta.id` (essential for reordering different channels together).

### Avoid mv and copy for outputs

`mv` and `cp` are heavy operation on network/cloud storage on HPC infra, therefore prefer using the `StageAs` option: https://www.nextflow.io/docs/latest/process.html#output-type-path

### Manage memory for complex tool from args

TODO : Manage tool memory with conf/resources.conf https://github.com/nexomis/rna-preprocessing/blob/main/conf/resources.conf

### Managing tool args in wf

Manage tool args from conf (task.ext) `fastp --thread $task.cpus ${task.ext.args ?: default_args} \\` https://github.com/nexomis/nf-process/blob/fc42479b5bc0e1bc3631c3446d47b4f068df554b/fastp/main.nf

## Other Recommandation
 - Although not a strict requirement, it is preferable that a workflow has only one queue channel as input, and that it be the first argument. If necessary, queue channels should be merged into tuples.
 - To ensure that a process can be reused in other workflows, if in doubt, don't hesitate to emit more output than necessary.
 - `out_dir` ?
 - `SaveAs` on `publishDir` ?
