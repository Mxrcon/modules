#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PLINK_BFILE } from '../../../../modules/plink/bfile/main.nf'

workflow test_plink_bfile {

    input = [
        [ id:'test.rnaseq', single_end:false ], // meta map
        file(params.test_data['homo_sapiens']['illumina']['test_plink_bed'], checkIfExists: true),
        file(params.test_data['homo_sapiens']['illumina']['test_plink_bim'], checkIfExists: true),
        file(params.test_data['homo_sapiens']['illumina']['test_plink_fam'], checkIfExists: true)
    ]

    PLINK_BFILE ( input )
}
