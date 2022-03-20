#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MD5SUM } from '../../../modules/md5sum/main.nf'

workflow test_md5sum {
    
    input = file(params.test_data['sarscov2']['illumina']['test_single_end_bam'], checkIfExists: true)

    MD5SUM ( input )
}
