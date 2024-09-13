#!/usr/bin/env nextflow
nextflow.preview.output = true
include { validateParameters; paramsHelp; paramsSummaryLog } from 'plugin/nf-validation'

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
  log.info paramsHelp("nextflow run nexomis/{{pipeline name}} [args]")
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