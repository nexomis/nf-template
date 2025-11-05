#!/usr/bin/env nextflow
include { validateParameters, samplesheetToList} from 'plugin/nf-schema'

workflow {
  validateParameters()

  params {
    
  }

  channel.fromList(samplesheetToList("path/to/samplesheet", "path/to/json/schema"))
/*
Define workflow here
To access to a parameter (default or mandatory) call param.name_param
*/

  //publish:

}
