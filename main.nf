#!/usr/bin/env nextflow
include { validateParameters ; samplesheetToList } from 'plugin/nf-schema'
include { WRITE_GREETING     } from './modules/process/tuto/write_greeting/main.nf'
include { CONVERT_PANDOC     } from './modules/process/tuto/convert_pandoc/main.nf'

nextflow.enable.strict = true

workflow {

    main:
    validateParameters()
    /*
     * Tutorial Workflow: Generate personalized greeting documents
     * 
     * This workflow demonstrates NF 25.10 best practices:
     * 1. Params only used in entry workflow
     * 2. Dynamic values passed via meta
     * 3. Workflow outputs with publish/output blocks
     */

    // Load samples from samplesheet
    // The samplesheet_schema.json maps columns to meta attributes
    def ch_samples = channel.fromList(
        samplesheetToList(params.input, "assets/samplesheet_schema.json")
    )

    // Add output_format to meta (passed down to processes)
    // This demonstrates passing workflow params dynamically via meta
    ch_samples
        .map { it ->
            def meta = it[0].clone()
            meta.output_format = params.output_format
            meta // when files associated: [meta, files]
        }
        .set { ch_samples_with_format }

    // Step 1: Write greeting markdown files
    WRITE_GREETING(ch_samples_with_format)

    // Step 2: Convert markdown to final format using Pandoc
    CONVERT_PANDOC(WRITE_GREETING.out.markdown)

    publish:
    markdown  = WRITE_GREETING.out.markdown
    documents = CONVERT_PANDOC.out.document
}

// Workflow outputs configuration (out of preview since NF 25.10)
output {
    markdown {
        path 'intermediate/markdown'
        enabled params.keep_markdown
    }
    documents {
        path 'final'
        enabled true
    }
}
