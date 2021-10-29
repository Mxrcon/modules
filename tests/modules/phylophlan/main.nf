#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PHYLOPHLAN } from '../../../modules/phylophlan/main.nf' addParams( options: [:] )

workflow test_phylophlan {
    
    input = [ [ id:'test', single_end:false ], // meta map
              file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true) ]

    PHYLOPHLAN ( input )
}
