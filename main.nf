#!/usr/bin/env nextflow

include { validateParameters; paramsHelp; paramsSummaryLog; samplesheetToList } from 'plugin/nf-schema'

log.info """
    |            #################################################
    |            #    _  _                             _         #
    |            #   | \\| |  ___  __ __  ___   _ __   (_)  __    #
    |            #   | .` | / -_) \\ \\ / / _ \\ | '  \\  | | (_-<   #
    |            #   |_|\\_| \\___| /_\\_\\ \\___/ |_|_|_| |_| /__/   #
    |            #                                               #
    |            #################################################
    |
    | {{pipeline name}}: {{pipeline description}}
    |
    |""".stripMargin()

if (params.help) {
  log.info paramsHelp("nextflow run nexomis/{{pipeline name}} {{typical required usage}}")
  exit 0
}
validateParameters()
log.info paramsSummaryLog(workflow)

workflow {

/*
Define workflow here
To access to a parameter (default or mandatory) call param.name_param
*/


}