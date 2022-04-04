#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PHYLOPHLAN_CONFIG } from '../../../../modules/phylophlan/config/main.nf'

workflow test_phylophlan_config {

    PHYLOPHLAN_CONFIG ()
}
