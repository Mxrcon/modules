process PHYLOPHLAN_PHYLOGENY {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::phylophlan=3.0.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/phylophlan:3.0.2--py_0':
        'quay.io/biocontainers/phylophlan:3.0.2--py_0' }"

    input:
    path("fasta_genomes/*")
    tuple val(meta), path(phylophlan_database)
    tuple val(meta), path(phylophlan_configuration_file)

    output:
    tuple val(meta), path("RAxML_*.tre"), emit: raxml_tre
    tuple val(meta), path("${prefix}.aln"), emit: aln
    tuple val(meta), path("${prefix}.tre"), emit: tre
    path "versions.yml", emit: version

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def diversity = task.ext.diversity ?: "medium"
    """
    phylophlan -i fasta_genomes \\
    -d ${phylophlan_database} \\
    -f ${phylophlan_configuration_file} \\
    --nproc ${tasks.cpus} \\
    ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        phylophlan: \$(phylophlan -v | sed 's/^PhyloPhlAn\ version\ //' | sed 's/\ \(.*\)//' )
    END_VERSIONS
    """
}
