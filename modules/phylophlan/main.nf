// Import generic module functions
include { initOptions; saveFiles; getSoftwareName; getProcessName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process PHYLOPHLAN {
    tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

    conda (params.enable_conda ? "bioconda::phylophlan=3.0.2" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/phylophlan:3.0.2--py_0"
    } else {
        container "quay.io/biocontainers/phylophlan:3.0.2--py_0"
    }

    input:
    tuple val(meta), path(fasta_genomes)
    tuple val(meta), val(phylophlan_database)
    tuple val(meta), path(phylophlan_configuration_file)

    output:
    tuple val(meta), path("RAxML_*.tre"), emit: raxml_tre
    tuple val(meta), path("${prefix}.aln"), emit: aln
    tuple val(meta), path("${prefix}.tre"), emit: tre
    path "versions.yml", emit: versions

    script:
    def prefix = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"
    """
    mkdir ${prefix}
    mv ${fasta_genomes} ${prefix}/.
    phylophlan -i ${prefix} \
    $options.args \
    -d ${phylophlan_database} \
    --diversity ${params.phylophlan_diversity} \
    -f  ${phylophlan_configuration_file} \
    --nproc ${tasks.cpus}

    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$( phylophlan -v | sed 's/^PhyloPhlAn\ version\ //' | sed 's/\ \(.*\)//' )
    END_VERSIONS
    """
}
