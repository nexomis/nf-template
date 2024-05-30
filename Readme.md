# README
## Add modules

```
mkdir modules
git submodule add https://github.com/nexomis/nf-subworkflows.git modules/subworkflows
git submodule add https://github.com/nexomis/nf-config.git modules/config
git submodule add https://github.com/nexomis/nf-process.git modules/process
```
NOTE: Submodules are linked to a repository by their hash reference. For them to be updated, they need to be pull/push again. 


## Conventions
### Submodules structure
The minimal structure of a submodule will be : a folder that contains the `main.nf` file in which the submodule is defined.
```
submodule_folder
|___ main.nf
```

### Includes
Relative paths need to be used to include a submodule.

### Notations
#### Reads
In every workflow, reads will be defined as a tuple with the following structure : `(sample_name, [paths_to_files])`

#### Typography
Process and workflows names will be written in capital letters.
workflow MY_WF {

}

process MY_PROCESS {

}

### Code
The "main" workflow will call the submodules that could be either: subworkflows or processes.

The processes are unique operations that could be either defined in the `main.nf` file of a subworkflow OR independently as a new process in the nf-process repository (https://github.com/nexomis/nf-process.git) in case they are main to be re used by other (sub) workflows.

Only Channels will be passed between (sub)workflows and processes. For that matter, parameters CAN'T be directly passed; instead, they will be passed through `Channels.values`

### Publish the results
If the results of a module should be published, it must be explicitly stated in the `conf/publish.conf` file.
