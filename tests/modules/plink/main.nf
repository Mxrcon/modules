#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PLINK } from '../../../modules/plink/main.nf' addParams( options: ['args': '--make-bed --a1-allele $name.sorted.bi.pos 5 3 --biallelic-only strict --set-missing-var-ids @:#:\$1:\$2 --vcf-half-call missing --double-id --recode ped --id-delim \'_\''] )


workflow test_plink {
    
    input = [ [ id:'test', single_end:false ], // meta map
              file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true) ]

    PLINK ( input )
}
