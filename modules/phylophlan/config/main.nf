process PHYLOPHLAN_CONFIG {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::phylophlan=3.0.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/phylophlan:3.0.2--py_0':
        'quay.io/biocontainers/phylophlan:3.0.2--py_0' }"

    output:
    path("*.cfg")  , emit: cfg
    path("versions.yml")           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    phylophlan_write_config_file \\
    -o phylophlan_config.cfg \\
    ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        phylophlan: \$(phylophlan -v | sed 's/^PhyloPhlAn\ version\ //' | sed 's/\ \(.*\)//' )
    END_VERSIONS
    """
}
